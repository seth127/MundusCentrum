#' @importFrom jsonlite toJSON
#' @importFrom readr write_lines
#' @keywords internal
list_to_json <- function(.l, .f) {
  .l %>%
    toJSON(auto_unbox = TRUE, pretty = TRUE) %>%
    write_lines(.f)
}

#' @export
get_player_names <- function(game) {
  stringr::str_subset(names(game[["players"]]), "GLOBAL", negate = TRUE)
}

#' Check if a player name is in the game
#' @keywords internal
check_player_name <- function(game_df, .p) {
  # TODO: consider making this s3 to dispatch on either game_df or game
  # would need to make s3 classes for those both, but that's probably a good idea
  #
  # IDEA in email: these things should all take a single `game` object which _contains_ the map too
  # * and this should just use get_player_names() above ^

  valid_players <- c(unique(names(game_df$player)), "CONFLICT!") # just need to get this
  if (!is.null(.p)) {
    checkmate::assert_string(.p)
    if (!(.p %in% valid_players)) abort(glue("{.p} is not a valid player. Choose from {paste(valid_players, collapse = ', ')}"))
  }
}
