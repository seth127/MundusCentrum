X_MULT <- 7
Y_MULT <- 10

#' Draw the game map
#' @importFrom ggplot2 ggplot geom_point geom_jitter theme coord_cartesian
#'   annotation_custom aes element_blank element_text scale_size_area
#'   scale_colour_manual scale_fill_manual ggtitle
#' @importFrom RColorBrewer brewer.pal
#' @importFrom grid rasterGrob unit
#' @importFrom dplyr count full_join rename summarise group_by
#' @param game The game object that contains the map etc
#' @return Returns a ggplot object of the map
#' @export
draw_map <- function(game, .p = NULL) {
  map_img <- jpeg::readJPEG(system.file("extdata", "img", "MundusCentrumAlpha.jpeg", package = "MundusCentrum"))

  if (!is.null(.p) && .p == "GLOBAL") .p <- NULL
  check_player_name(game, .p)

  # get df of units we care about
  map_df <- get_map_df(game, .p)
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
  map_data <- map_dfr(names(MAP), ~{
    .m <- MAP[[.x]]
    list(
      loc = .x,
      name = .m[["name"]],
      x_ = .m[["x_"]],
      y_ = .m[["y_"]]
    )
  })

  # get control and visibility
  map_data <- left_join(
      map_data,
      map_df %>% filter(action == "control") %>% select(player, loc) %>% unique() %>% rename(control = player),
      by = "loc"
    ) %>%
    mutate(
      visible = loc %in% player_vision(map_df, .p),
      loc_fill =  ifelse(!visible, "DARK", ifelse(!is.na(control), control, "FREE"))
    )

  visible_loc <- map_data %>%
    filter(visible) %>%
    pull(loc)

  # get units
  unit_data <- full_join(
    map_data,
    count(map_df, loc, player),
    #map_df %>% group_by(loc, player) %>% summarise(total_folks = sum(size)),
    by = "loc"
  ) %>%
    filter(!is.na(player), loc %in% visible_loc) %>%
    mutate(
      point_size = pmin(ifelse(n < 5, n^1.2, ifelse(n > 5, n^0.8, n)), 20)
      #point_size = pmax(pmin(total_folks/3, 20), 2) #### TODO: adjust this once we get real army sizes
    )

  ###### TODO: change this to be dynamic (or just set to a flat file at beginning of game, and loaded here)
  player_colors <- brewer.pal(3, "Spectral")
  names(player_colors) <- c("big_grizz", "eric", "chris")
  #########

  ggplot(map_data, aes(x = x_*X_MULT, y = y_*Y_MULT)) +
    coord_cartesian(xlim = c(0,1)*X_MULT, ylim = c(0,1)*Y_MULT) +
    annotation_custom(rasterGrob(map_img,
                                       width = unit(1,"npc"),
                                       height = unit(1,"npc")),
                      0, 1*X_MULT, 0, 1*Y_MULT) +
    geom_point(size = 3, shape = 21, aes(fill = loc_fill)) +
    geom_point(data = filter(map_data, !is.na(control)), size = 2, shape = 8) +
    geom_jitter(data = unit_data, aes(size = point_size, color = player), alpha = 0.82, width = 0.15, height = 0.15) +
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
    scale_colour_manual(values = player_colors) +
    scale_fill_manual(values = c(player_colors, "FREE" = "#00000000", "DARK" = "#000000"), guide = "none") + # visibility and control
    ggtitle(map_title)

}


player_vision <- function(map_df, .p) {
  if (is.null(.p)) return(names(MAP))
  if (.p == "CONFLICT!") return(unique(map_df$loc))

  occ_loc <- map_df %>%
    filter(player == .p) %>%
    pull(loc) %>%
    unique()

  borders <- map(occ_loc, ~ {
    c(
      MAP[[.x]][["borders"]],
      MAP[[.x]][["rivers"]]
    )
  }) %>%
    unlist() %>%
    unique() %>%
    sort()

  ### TODO: add territories moved through by flyers and fast ones?

  c(occ_loc, borders)
}
