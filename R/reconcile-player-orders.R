#' Reconcile player maps with global map
#'
#' Run after players have updated their maps. This will add all unit placements
#' on the player maps to the global map. If there are opposing units in any
#' locations, it will return a tibble of the units in conflict zones and warn
#' about that the conflict must be resolved. If there are no conflicts,
#' invisibly returns the tibble with all units on the board.
#' @importFrom dplyr arrange
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
  }

  game
}

#' Update global map from player maps
#'
#' Modifies the global map by
#' @importFrom purrr map_dfr
#' @importFrom dplyr full_join left_join group_by summarize filter pull
#'
#' @keywords internal
players_to_global_map <- function(game){

  #### DEPRECATED???


  .gm <- read_global_map(game)
  new_map <- map_dfr(get_player_names(game), function (.p) {
    .pm <- get_player_map(game, .p)
    ### TODO: probably need to check for mismatches before we return this
      full_join(
        select(.gm, unit_name),
        .pm,
        by = "unit_name"
      ) %>%
      mutate(player = .p) %>%
      select(player, loc, unit_id, unit_type, action, unit_name) %>%
      arrange(loc, player, action, unit_id, unit_type, unit_name)
  })

  # return any disputed lands
  fights <- new_map %>%
    group_by(loc) %>%
    summarize(count = length(unique(player))) %>%
    filter(count > 1) %>%
    pull(loc)

  list(
    resolved = new_map %>% filter(!(loc %in% fights)) %>% arrange(loc, player),
    conflict = new_map %>% filter( (loc %in% fights)) %>% arrange(loc, player)
  )
}

