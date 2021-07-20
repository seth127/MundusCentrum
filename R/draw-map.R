
#' Draw the game map
#' @importFrom ggplot2 ggplot geom_point geom_jitter theme coord_cartesian annotation_custom aes element_blank scale_size_area scale_colour_manual
#' @importFrom RColorBrewer brewer.pal
#' @importFrom grid rasterGrob unit
#' @importFrom dplyr count full_join
#' @param game_df Takes a tibble output from [reconcile_player_orders()]
#' @return Returns a ggplot object of the map
#' @export
draw_map <- function(game_df) {
  map_img <- jpeg::readJPEG(system.file("extdata", "img", "MundusCentrumAlpha.jpeg", package = "MundusCentrum"))

  map_data <- map_dfr(names(MAP), ~{
    .m <- MAP[[.x]]
    list(
      loc = .x,
      name = .m[["name"]],
      x_ = .m[["x_"]],
      y_ = .m[["y_"]]
    )
  })

  plot_data <- full_join(
    map_data,
    count(game_df, loc, player),
    by = "loc"
  ) %>%
    filter(!is.na(x_), !is.na(player)) %>%
    mutate(point_size = pmin(ifelse(n < 5, n^1.2, ifelse(n > 5, n^0.8, n)), 15))

  x_mult <- 7
  y_mult <- 10

  ###### TODO: change this to be dynamic
  myColors <- brewer.pal(3, "Spectral")
  names(myColors) <- c("big_grizz", "eric", "chris")
  custom_colors <- scale_colour_manual(name = "Species Names", values = myColors)
  #########

  ggplot(map_data, aes(x = x_*x_mult, y = y_*y_mult)) +
    coord_cartesian(xlim = c(0,1)*x_mult, ylim = c(0,1)*y_mult) +
    annotation_custom(rasterGrob(map_img,
                                       width = unit(1,"npc"),
                                       height = unit(1,"npc")),
                      0, 1*x_mult, 0, 1*y_mult) +
    geom_point(size = 3, shape = 1) +
    geom_jitter(data = plot_data, aes(size = point_size, color = player), alpha = 0.82, width = 0.15, height = 0.15) +
    ggplot2::scale_size_area(guide = "none") +
    theme(
      axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      axis.title.y=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    ) +
    custom_colors

}
