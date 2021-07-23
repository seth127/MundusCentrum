#' Start a new Mundus Centrum game
#'
#' @details
#' **Player data format** -- Each element of the list passed to `players` must
#' have the following elements:
#'
#' * `name` -- Player name. Must be unique amongst players.
#'
#' * `team` -- One of the legal teams. See list with `teams()`.
#'
#' * `units` -- Path to a units.csv file to load.
#'
#' * `points` (optional) -- how many points to start the game with. Overriden if
#' anything is passed to `points` argument of the function.
#'
#' @param name Name of game
#' @param players List of players. See "Details" for structure of list.
#' @param points Total number of points each player starts with. If left `NULL`,
#'   will look for a `points` element in each player data element.
#'
#' @importFrom checkmate assert_string assert_list
#' @importFrom dplyr left_join
#' @export
new_game <- function(name, players, points = NULL) {
  assert_string(name)
  assert_list(players)

  # check player names and necessary fields
  players <- map(players, function(.p) {
    assert_string(.p[["name"]])
    assert_string(.p[["team"]])
    assert_string(.p[["units"]])
    .p[["id"]] <- sanitize_name(.p[["name"]])
    .p
  })
  ids <- map_chr(players, ~.x[["id"]])
  if (length(unique(ids)) != length(players)) abort(glue("Name collision. Got: {paste(ids, collapse ', ')}"))

  # check points
  if (!is.null(points)) {
    assert_numeric(points)
    players <- map(players, function(.p) {
      .p[["points"]] <- points
      .p
    })
  } else {
    if (any(map_lgl(players, ~ is.null(.x[["points"]])))) abort("Must either pass new_game(points) or specify points for each player")
  }

  game <- list(players = ids)
  game[["game_root"]] <- setup_game_dir(name, players)
  write_csv(BLANK_MAP, get_global_map_path(game))
  reconcile_player_orders(game)
  return(game)
}

#' @importFrom uuid UUIDgenerate
#' @keywords internal
setup_game_dir <- function(name, players) {
  game_root <- file.path(GAME_ROOT_DIR, sanitize_name(name))
  if (dir_exists(game_root)) abort(glue("Sorry, {name} already exists in {GAME_ROOT_DIR}. Pick another name."))
  dir_create(game_root)

  clear_used_names()
  player_dirs <- map_chr(players, function(.p) {
    player_dir <- file.path(game_root, .p[["id"]])
    dir_create(player_dir)
    list_to_json(.p, file.path(player_dir, paste0(.p[["id"]], ".json")))

    # load input units file
    if (!file_exists(.p[["units"]])) abort(glue("{.p[['name']]} passed {.p[['units']]} but that file doesn't exist."))
    .u <- read_csv(.p[["units"]], col_types = "cicc")
    .u %>%
      mutate(unit_name = map_chr(unit_type, ~ build_name(.x))) %>%
      select(unit_name, everything()) %>%
      write_csv(file.path(player_dir, paste0(.p[["id"]], ".csv")))

    return(player_dir)
  })
  game_root
}

#' @keywords internal
sanitize_name <- function(.n) {
  tolower(str_replace_all(.n, "[^[:alnum:]]", "_"))
}


