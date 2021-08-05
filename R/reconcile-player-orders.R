#' Reconcile player maps with global map
#'
#' Run after players have updated their maps. This will add all unit placements
#' on the player maps to the global map. If there are opposing units in any
#' locations, it will return a tibble of the units in conflict zones and warn
#' about that the conflict must be resolved. If there are no conflicts,
#' invisibly returns the tibble with all units on the board.
#' @importFrom dplyr arrange summarize
#' @export
reconcile_player_orders <- function(game) {

  conflicts <- game$map_df %>%
    group_by(loc) %>%
    summarize(count = length(unique(player))) %>%
    filter(count > 1) %>%
    pull(loc)

  if (length(conflicts) > 0) {
    message("CONFLICT(s):")
    warn("Conflict is at hand! Please resolve territorial disputes.", "map_conflict_warning")
    game$conflicts <- conflicts
  } else {
    message("All units resolved.")
    game$conflicts <- NULL

    # record comm relays
    locs <- game$map_df$loc
    names(locs) <- game$map_df$player
    locs <- locs[!duplicated(locs)]
    for(.i in 1:length(locs)) {
      game$map[[locs[.i]]][["comm"]] <- names(locs)[.i]
    }

    # get rid of passing_through entries
    game$map_df <- filter(game$map_df, !passing_through) # !isTRUE(as.logical(passing_through)) # wasn't working
    .dups <- duplicated(game$map_df$unit_name)
    if (sum(.dups) > 0) {
      warn(paste(
        "DEV ERROR: passing through not filtered. Duplicate units:",
        paste(game$map_df$player[.dups], game$map_df$unit_id[.dups], game$map_df$unit_name[.dups], sep = " - ", collapse = ', '),
        "reconcile_error"
      ))
    }

    # record control
    control_df <- filter(game$map_df, action == "control")
    locs <- control_df$loc
    names(locs) <- control_df$player
    locs <- locs[!duplicated(locs)]
    for(.i in 1:length(locs)) {
      game$map[[locs[.i]]][["control"]] <- names(locs)[.i]
    }
  }

  game
}
