#' Process a game turn
#'
#' Run after players have updated their maps
#' @importFrom dplyr arrange
#' @export
reconcile_player_orders <- function(game) {
  .m <- players_to_global_map(game)
  if (nrow(.m[["conflict"]]) > 0) {
    message("CONFLICT(s):")
    warn("Conflict is at hand! Please resolve territorial disputes.", "map_conflict_warning")
    return(.m[["conflict"]])
  }
  message("All units resolved.")
  return(.m[["resolved"]])
}

#' Move a unit
#' @importFrom purrr walk
#' @export
move_unit <- function(game, player, .u, .a, .l1, .l2) {
  walk(.u, ~{
    # TODO: should check if it's a legal move first. Boring...
    .pm <- read_player_map(game, player) %>%
      mutate(
        loc = ifelse(unit_name == .x, .l2, loc),
        action = ifelse(unit_name == .x, .a, action)
      )
    write_player_map(game, player, .pm)
  })

}

#' Kill a unit
#' @importFrom purrr walk
#' @export
kill_unit <- function(game, player, .u) {
  walk(.u, ~{
    .pm <- read_player_map(game, player) %>%
      filter(unit_name != .x)
    write_player_map(game, player, .pm)
  })
}
