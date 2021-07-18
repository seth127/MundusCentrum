#' Process a game turn
#'
#' Run after players have updated their maps
#' @importFrom dplyr arrange
#' @export
reconcile_player_orders <- function(game) {
  .m <- players_to_global_map(game)
  if (nrow(.m[["conflict"]]) > 0) {
    message("CONFLICT(s):")
    warn("Conflict in game setup. Please resolve territorial disputes.")
    return(.m[["conflict"]])
  }
  message("All units resolved.")
  return(.m[["resolved"]])
}

#' Move a unit
#' @export
move_unit <- function(game, player, .u, .l1, .l2) {
  # TODO: should check if it's a legal move first. Boring...
  .pm <- read_player_map(game, player) %>%
    mutate(loc = ifelse(unit_uuid == .u, .l2, loc))
   write_player_map(game, player, .pm)
}
