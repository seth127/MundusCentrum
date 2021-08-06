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

#' @export
get_other_players_names <- function(game, .p) {
  stringr::str_subset(names(game[["players"]]), glue("GLOBAL|{.p}"), negate = TRUE)
}

#' Check if a player name is in the game
#' @keywords internal
check_player_name <- function(game, .p) {
  valid_players <- c(names(game$players), "CONFLICT!") # just need to get this
  if (!is.null(.p)) {
    checkmate::assert_string(.p)
    if (!(.p %in% valid_players)) abort(glue("`{.p}` is not a valid player. Choose from {paste(valid_players, collapse = ', ')}"))
  }
}

#' Check if a location is on the map
#' @keywords internal
check_loc <- function(game, .l) {
  valid_locs <- names(game$map)
  if (!is.null(.l) && !is.na(.l)) {
    checkmate::assert_string(.l)
    if (!(.l %in% valid_locs)) abort(glue("`{.l}` is not a valid loc Choose from {paste(valid_locs, collapse = ', ')}"))
  }
}
