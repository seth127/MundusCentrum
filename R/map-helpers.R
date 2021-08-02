#' @export
get_global_map_path <- function(game) {
  file.path(game[["game_root"]], glue("{basename(game[['game_root']])}.csv"))
}

#' @export
get_global_json_path <- function(game) {
  file.path(game[["game_root"]], glue("{basename(game[['game_root']])}.json"))
}

#' @export
get_player_map_path <- function(game, player) {
  file.path(game[["game_root"]], player, glue("{player}.csv"))
}

#' @export
read_player_map <- function(game, player) {
  read_csv(get_player_map_path(game, player), col_types = "cccic") #%>%mutate(unit_id = as.integer(unit_id))
}

#' @export
read_global_map <- function(game) {
  read_csv(get_global_map_path(game), col_types = "cccic") #%>%mutate(unit_id = as.integer(unit_id))
}

#' @export
write_player_map <- function(game, player, map) {
  write_csv(map, get_player_map_path(game, player))
}

#' @export
write_global_map <- function(game, map) {
  write_csv(map, get_global_map_path(game))
}
