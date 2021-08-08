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
#' @importFrom RColorBrewer brewer.pal
#' @importFrom rlang set_names
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

  game <- list(
    # create hashes for serving html
    players = as.list(
      map_chr(paste(name, c("GLOBAL", ids)), ~digest::digest(.x, algo = "md5")) %>%
        rlang::set_names(c("GLOBAL", ids))
    ),
    player_colors = rlang::set_names(brewer.pal(length(ids), "Spectral"), ids),
    map = add_sky(MAP)
  )
  game[["map_df"]] <- setup_map_df(name, players)

  return(reconcile_player_orders(game))
}

#' @importFrom purrr map_dfr
#' @keywords internal
setup_map_df <- function(name, players) {

  clear_used_names()
  map_dfr(players, function(.p) {
    # load input units file
    if (!file_exists(.p[["units"]])) abort(glue("{.p[['name']]} passed {.p[['units']]} but that file doesn't exist."))
    .u <- read_csv(.p[["units"]], col_types = "cc")
    .u %>%
      mutate(
        player = .p[["id"]],
        unit_id = seq(nrow(.u)),
        unit_type = map_chr(unit_type, sanitize_name),
        unit_name = map_chr(unit_type, build_name),
        action = "control",
        passing_through = FALSE
      ) %>%
      sort_map_df()
  })
}

#' Add all the soaring locs to the map
#' @keywords internal
add_sky <- function(.m) {
  .s <- .m
  add_s <- function(.n) paste0(.n, "S")
  sky_names <- map_chr(names(.s), add_s)
  .s <- map(.s, ~{
    .x$name <- paste(.x$name, "- Sky")
    .x$sky <- map(c("borders", "rivers", "mountains"), function(.p) {
      .x[[.p]]
    }) %>%
      purrr::compact() %>%
      unlist() %>%
      map_chr(add_s)
    .x[c("name", "sky", "x_", "y_")]
  }) %>%
    set_names(sky_names)

  for (.n in sky_names) {
    .m[[.n]] <- .s[[.n]]
  }
  return(.m)
}

#' @keywords internal
sanitize_name <- function(.n) {
  tolower(str_replace_all(.n, "[^[:alnum:]]", "_"))
}

