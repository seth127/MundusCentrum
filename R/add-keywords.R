
#' Join a game_df against the unit_type keyword columns
#' @importFrom dplyr left_join
#' @export
add_keywords <- function(game_df, .p = NULL) {
  check_player_name(game_df, .p)

  if (!is.null(.p)) {
    game_df <- filter(game_df, .data$player == .p)
  }

  left_join(game_df, UNIT, by = "unit_type")
}

