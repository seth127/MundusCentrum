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
#' * `points` (optional) -- how many points to start the game with. Overriden if
#' anything is passed to `points` argument of the function.
#'
#' @param name Name of game
#' @param players List of players. See "Details" for structure of list.
#' @param points Total number of points each player starts with. If left `NULL`,
#'   will look for a `points` element in each player data element.
#'
#' @importFrom checkmate assert_string assert_list
#' @export
new_game <- function(name, players, points = NULL) {
  assert_string(name)
  assert_list(players)

  # check player names
  players <- map(players, function(.p) {
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

  game <- list()
  game[["game_root"]] <- setup_game_dir(name, players)
  list_to_json(BLANK_MAP, file.path(game[["game_root"]], glue("{name}_MAP.json")))

  return(game)
}

#' @keywords internal
setup_game_dir <- function(name, players) {
  game_root <- file.path(GAME_ROOT_DIR, sanitize_name(name))
  if (dir_exists(game_root)) abort(glue("Sorry, {name} already exists in {GAME_ROOT_DIR}. Pick another name."))
  dir_create(game_root)

  player_dirs <- map_chr(players, function(.p) {
    player_dir <- file.path(game_root, .p[["id"]])
    dir_create(player_dir)
    list_to_json(.p, file.path(player_dir, paste0(.p[["id"]], ".json")))
    player_dir
  })
  game_root
}

#' @keywords internal
sanitize_name <- function(.n) {
  tolower(str_replace_all(.n, "[^[:alnum:]]", "_"))
}
