

#' Reconcile player maps with global map
#' @importFrom purrr map_dfr
#' @importFrom dplyr full_join group_by summarize filter pull
#'
#' @keywords internal
players_to_global_map <- function(game){
  .gm <- read_global_map(game)
  new_map <- map_dfr(game[["players"]], function (.p) {
    .pm <- read_player_map(game, .p)
    ### TODO: probably need to check for mismatches before we return this
    full_join(
      select(.gm, unit_uuid),
      select(.pm, unit_uuid, loc, action),
      by = "unit_uuid"
    ) %>%
      mutate(player = .p) %>%
      select(unit_uuid, player, loc, action)
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

##################
# PRIVATE HELPERS
##################

#' @export
get_global_map_path <- function(game) {
  file.path(game[["game_root"]], glue("{basename(game[['game_root']])}_MAP.csv"))
}

#' @export
get_player_map_path <- function(game, player) {
  file.path(game[["game_root"]], player, glue("{player}.csv"))
}

#' @export
read_player_map <- function(game, player) {
  read_csv(get_player_map_path(game, player), col_types = "ccccic")
}

#' @export
read_global_map <- function(game) {
  read_csv(get_global_map_path(game), col_types = "cccc")
}

#' @export
write_player_map <- function(game, player, map) {
  write_csv(map, get_player_map_path(game, player))
}

#' @export
write_global_map <- function(game, map) {
  write_csv(map, get_global_map_path(game))
}
