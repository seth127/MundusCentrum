#' @export
get_player_map <- function(game, .p) {
  check_player_name(game, .p)
  res <- if (!is.null(.p) && .p != "GLOBAL") {
    filter(game$map_df, .data$loc %in% player_vision(game$map_df, .p))
  } else {
    game$map_df
  }
  return(res)
}
