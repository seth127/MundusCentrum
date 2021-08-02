#' Get the tibble of units and their loc on map
#' @export
get_map_df <- function(game, .p = NULL) {
  # get df of units we care about
  res <- if (!is.null(game$conflicts)) {
    filter(game$map_df, .data$loc %in% game$conflicts)
  } else {
    get_player_map(game, .p)
  }
  return(res)
}
