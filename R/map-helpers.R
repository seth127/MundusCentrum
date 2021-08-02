#' @export
get_global_map_path <- function(game) {
  file.path(game[["game_root"]], glue("{basename(game[['game_root']])}.csv"))
}

#' @export
get_global_json_path <- function(game) {
  file.path(game[["game_root"]], glue("{basename(game[['game_root']])}.json"))
}

#' @export
get_global_rmd_path <- function(game) {
  glue("{game[['game_root']]}.Rmd")
}

#' @export
get_player_rmd_path <- function(game, player) {
  file.path(game$game_root, paste0(game$players[[player]], ".Rmd"))
}

#' @export
get_player_map_path <- function(game, player) {
  file.path(game[["game_root"]], player, glue("{player}.csv"))
}

#' @export
get_player_map <- function(game, .p) {
  #suppressWarnings(read_csv(get_player_map_path(game, player), col_types = "cccic")) # need to fix this
  check_player_name(game, .p)
  res <- if (!is.null(.p) && .p != "GLOBAL") {
    filter(game$map_df, .data$loc %in% player_vision(game$map_df, .p))
  } else {
    game$map_df
  }
  return(res)
}

#' @export
read_global_map <- function(game) {
  suppressWarnings(read_csv(get_global_map_path(game), col_types = "cccic")) # need to fix this
}

#' @export
write_player_map <- function(game, player, map) {
  write_csv(map, get_player_map_path(game, player))
}

#' @export
write_global_map <- function(game, map) {
  write_csv(map, get_global_map_path(game))
}
