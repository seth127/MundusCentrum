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
#' * `units` -- Path to a units.csv file to load, or a tibble of units (if
#' players is an `MC_bpl` object created by [bpl()]).
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

  player_colors <- if (length(ids) >= 3) {
    brewer.pal(length(ids), "Dark2")
  } else {
    brewer.pal(3, "Dark2")[1:length(ids)]
  }

  player_colors <- player_colors %>%
    as.list() %>%
    rlang::set_names(ids)

  game <- list(
    name = name,
    turn = "000A",
    # create hashes for serving html
    players = as.list(
      map_chr(c("GLOBAL", ids), ~ player_hash(name, .x)) %>%
        rlang::set_names(c("GLOBAL", ids))
    ),
    player_colors = player_colors,
    map = add_sky(MAP)
  )

  setup_game_dirs(name)

  game[["map_df"]] <- setup_map_df(name, players)

  # assign class
  class(game) <- c(GAME_CLASS, class(game))

  game_json_to_disk(game)
  return(reconcile_player_orders(game))
}

#' @importFrom purrr map_dfr
#' @keywords internal
setup_map_df <- function(name, players) {

  clear_used_names()
  map_dfr(players, function(.p) {
    # load input units
    if (inherits(.p, "MC_bpl")) {
      .u <- .p[['units']]
    } else {
      assert_string(.p[['units']])
      if (!file_exists(.p[['units']])) abort(glue("{.p[['name']]} passed {.p[['units']]} but that file doesn't exist from {getwd()}"))
      unit_file <- game_starting_armies_path(name, .p[['name']])
      if(file_exists(unit_file)) file_delete(unit_file)
      fs::file_copy(.p[['units']], unit_file)
      .u <- read_csv(unit_file, col_types = "cc")
    }

    .u %>%
      mutate(
        player = .p[["id"]],
        unit_id = seq(nrow(.u)),
        unit_type = map_chr(unit_type, sanitize_name),
        unit_name = map_chr(unit_type, build_name),
        action = "control",
        prev_loc = loc,
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

player_hash <- function(game_name, player_name) {
  digest::digest(
    paste(
      game_name,
      sanitize_name(player_name)
    ),
    algo = "md5"
  )
}

#' Build Player List
#'
#' Build the list that can be passed in (as part of a list)
#' to [new_game()] `players` argument.
bpl <- function(.name, .starting_loc, .units) {
  assert_string(.name)
  assert_string(.starting_loc)
  assert_character(.units)
  .bpl <- list(
    name = .name,
    team = glue("Team {.name}"),
    units = tibble::tibble(
      unit_type = .units,
      loc = .starting_loc
    )
  )

  class(.bpl) <- c("MC_bpl", class(.bpl))
  return(.bpl)
}

