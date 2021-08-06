
#' Join a game_df against the unit_type keyword columns
#' @importFrom dplyr left_join
#' @export
add_keywords <- function(game, .p = NULL) {
  check_player_name(game, .p)

  if (!is.null(.p)) {
    game_df <- filter(game$map_df, .data$player == .p)
  }

  left_join(game_df, UNIT, by = "unit_type")
}

