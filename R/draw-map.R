X_MULT <- 7
Y_MULT <- 10

#' Draw the game map
#' @importFrom ggplot2 ggplot geom_point geom_jitter theme coord_cartesian
#'   annotation_custom aes element_blank element_text scale_size_area
#'   scale_colour_manual scale_fill_manual ggtitle geom_line geom_segment
#' @importFrom grid rasterGrob unit arrow
#' @importFrom dplyr count full_join rename group_by
#' @param game The game object that contains the map etc
#' @return Returns a ggplot object of the map
#' @export
draw_map <- function(game, .p = NULL) {
  map_file <- if (isTRUE(getOption("MC.render_map"))) {
    system.file("extdata", "img", "MundusCentrumAlpha.jpeg", package = "MundusCentrum")
  } else {
    system.file("extdata", "img", "MundusCentrumAlpha_bare.jpeg", package = "MundusCentrum")
  }
  map_img <- jpeg::readJPEG(map_file)

  if (!is.null(.p) && .p == "GLOBAL") .p <- NULL
  check_player_name(game, .p)

  # get df of units we care about
  map_df <- get_player_map(game, .p)
  map_title <- if (!is.null(game$conflicts)) {
    "CONFLICT!"
  } else {
    if (is.null(.p)) {
      "GLOBAL"
    } else {
      .p
    }
  }

  # get static map coordinates
  map_data <- map_dfr(names(game$map), ~{
    .m <- game$map[[.x]]
    list(
      loc = .x,
      name = .m[["name"]],
      x_ = .m[["x_"]],
      y_ = .m[["y_"]]
    )
  })

  # get control and visibility
  map_data <- map_data %>%
    left_join(get_control_df(game), by = "loc") %>%
    left_join(get_comm_df(game), by = "loc") %>%
    mutate(
      visible = loc %in% player_vision(game, .p),
      loc_fill =  ifelse(!visible, "DARK", ifelse(!is.na(control), control, "FREE")),
      comm_fill =  ifelse(!visible, "DARK", ifelse(!is.na(comm), comm, "FREE"))
    )

  visible_loc <- map_data %>%
    filter(visible) %>%
    pull(loc)

  # get units
  unit_data <- full_join(
    map_data,
    count(filter(map_df, !passing_through), loc, player),
    by = "loc"
  ) %>%
    filter(
      !is.na(player),
      loc %in% visible_loc
    ) %>%
    mutate(
      soaring = ifelse(str_detect(loc, "S$"), "SOARING", "GROUND"),
      point_size = pmin(ifelse(n < 5, n^1.2, ifelse(n > 5, n^0.8, n)), 20)
      #point_size = pmax(pmin(total_folks/3, 20), 2) #### TODO: adjust this once we get real army sizes
    )

  # create df of paths for drawing arrows
  path_df <- map_df %>%
    filter(loc != prev_loc) %>%
    #mutate(unit_id_group = paste0(prev_loc, "-", loc)) %>%
    #select(player, unit_id_group, prev_loc, loc) %>%
    select(player, prev_loc, loc) %>%
    unique() %>%
    left_join(select(map_data, loc, x_, y_), by = "loc") %>%
    left_join(
      select(map_data, loc, x_, y_) %>% rename(prev_loc = loc),
      by = "prev_loc",
      suffix = c("loc", "prev"))

  ggplot(map_data, aes(x = x_*X_MULT, y = y_*Y_MULT)) +
    coord_cartesian(xlim = c(0,1)*X_MULT, ylim = c(0,1)*Y_MULT) +
    annotation_custom(rasterGrob(map_img,
                                       width = unit(1,"npc"),
                                       height = unit(1,"npc")),
                      0, 1*X_MULT, 0, 1*Y_MULT) +
    # static loc markers
    geom_point(data = filter(map_data, str_detect(loc, "S", negate = TRUE)), size = 3, shape = 21, aes(fill = factor(loc_fill))) +
    # bridges
    geom_line(data = get_bridges(game, .p), aes(x_*X_MULT, y_*Y_MULT, group = bridge_id), size = 2.3, alpha = 0.4, colour = "#AA5D06") +#, lineend = "round") +
    geom_line(data = get_bridges(game, .p), aes(x_*X_MULT, y_*Y_MULT, group = bridge_id), size = 1, alpha = 0.6, colour = "#AAAAAA") +
    # battles
    geom_point(data =filter(map_data, visible, loc %in% game$conflicts), size = 18, shape = 21, color = "red", stroke = 3, alpha = 0.38) +
    # comms
    geom_point(data = filter(map_data, !is.na(control)), size = 2, shape = 8) +
    # controls
    geom_point(data = filter(map_data, !is.na(comm)), size = 1, shape = 21, aes(fill = comm_fill)) +
    # armies
    geom_jitter(data = unit_data, aes(size = point_size, fill = player, color = soaring), alpha = 0.82, width = 0.15, height = 0.15, shape = 21) +
    # paths
    geom_segment(data = path_df, aes(x = x_loc*X_MULT,y = y_loc*Y_MULT,xend = x_prev*X_MULT,yend = y_prev*Y_MULT,color=player), arrow=grid::arrow(ends = "first", length = unit(0.35, "cm"), angle = 20), alpha = 0.55) +
    # formatting
    theme(
      axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      axis.title.y=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.title = element_text(hjust = 0.5)
    ) +
    scale_size_area(guide = "none") +
    scale_colour_manual(values = c(game$player_colors, c("SOARING" = "#87ECEC", "GROUND" = "#A9A9A9")), guide = "none") + # unit borders
    scale_fill_manual(values = c(game$player_colors, "FREE" = "#00000000", "DARK" = "#000000"), guide = "none") + # visibility and control
    ggtitle(map_title)
}

#' Get locs that player can see
#' @importFrom stringr str_replace
#' @keywords internal
player_vision <- function(game, .p) {
  if (is.null(.p) || .p == "GLOBAL") return(names(game$map))
  #if (.p == "CONFLICT!") return(unique(game$conflicts))

  controls <- get_controls(game, .p)

  occ_loc <- game$map_df %>%
    filter(player == .p) %>%
    pull(loc) %>%
    c(controls) %>%
    unique()

  borders <- map(occ_loc, ~ {
    c(
      game$map[[.x]][["borders"]],
      game$map[[.x]][["rivers"]]
    )
  }) %>%
    unlist()

  sky <- occ_loc %>%
    str_replace("S$", "") %>%
    paste0("S")

  comms <- get_comms(game, .p)

  c(occ_loc, borders, sky, comms, controls) %>%
    unique() %>%
    sort()
}


