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
    #if (!(.p %in% valid_players)) abort(glue("`{.p}` is not a valid player. Choose from {paste(valid_players, collapse = ', ')}"))
    if (!(.p %in% valid_players)) abort(glue("`{.p}` is not a valid player"))
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

#' Suppress a warning that matches `regexpr`
#' @importFrom stringr str_detect
#' @param expr Expression to run
#' @param regexpr Regex to match against any generated warning. Warning will be suppressed if this matches the warning message.
#' @export
suppressSpecificWarning <- function(expr, regexpr) {
  withCallingHandlers({
    expr
  }, warning=function(w) {
    if (stringr::str_detect(w$message, regexpr))
      invokeRestart("muffleWarning")
  })
}

#' Create an empty copy of a directory, deleting one that's there if necessary
#' @importFrom fs dir_exists dir_delete dir_create
#' @keywords internal
dir_create_empty <- function(.path) {
  if (dir_exists(.path)) dir_delete(.path)
  dir_create(.path)
}

#' See tibble of unit attributes
#' @param .u Character vector of unit types
#' @keywords internal
get_unit_attrs <- function(.u) {
  assert_character(.u)
  UNIT %>% filter(unit_type %in% map_chr(.u, sanitize_name))
}
