#
# GAME_NAME <- "Sloth v Grizz"
# GAME_DIR <- file.path(tempdir(), "MC_games")
# if (!fs::dir_exists(GAME_DIR)) fs::dir_create(GAME_DIR)
# options("MC.games_dir" = GAME_DIR)
# options("MC.render_map" = FALSE)
#
# PC_GLOBAL <- "93c791f11f6bf4d3871bed645fa2cee7"
# PC_big_grizz <- "6a45c6b9c8d0f251662fabcdca52cc43"
# PC_slothfire <- "047a45d5b4a91f1c56387070a270da4b"

SFR <- sanitize_name("Slothfire")
BGR <- sanitize_name("Big Grizz")

SMU <- c(
  "Ravenwing Talonmaster",
  "Deathwing Captain",
  "Techmarine",
  "Phobos Librarian",
  "Infiltrators",
  "Ravenwing Attack Bike",
  "Storm Raven"
)

#' create a temporary game
#' @param game_name String to name the game
#' @param ... `MC_bpl` objects, created by `MundusCentrum::bpl()`. One for each
#'   player in the game.
temp_game <- function(game_name, ...) {
  # Start the game fresh
  if (fs::dir_exists(game_dir_path(game_name))) fs::dir_delete(game_dir_path(game_name))

  .players <- list(...)
  walk(.players, ~checkmate::assert_class(.x, "MC_bpl"))

  suppressMessages({
    new_game(
      game_name,
      .players,
      points = 50000
    )
  })
}

delete_game <- function(.g) {
  UseMethod("delete_game")
}

delete_game.character <- function(.g) {
  checkmate::assert_string(.g)
  game_dir <- game_dir_path(.g)
  if (fs::dir_exists(game_dir)) {
    fs::dir_delete(game_dir_path(game_dir))
  } else {
    warn(glue("No game exists at {game_dir}"), "MC_test_error")
  }
}

delete_game.MC_game <- function(.g) {
  delete_game(.g$name)
}


#' Test a unit move
#' @param test_game The game to test
#' @param test_player String; the player who will move
#' @param test_unit Integer vector; the unit(s) who will move
#' @param test_action String; the intended action
#' @param exp_action_opts Character vector; the expected action options given
#' @param test_locs Character vector; the intended locations to move to
#' @param exp_loc_opts List of character vectors; the expected loc options for each move
expect_unit_move <- function(
  test_game,
  test_player,
  test_unit,
  test_action,
  exp_action_opts,
  test_locs,
  exp_loc_opts
) {

  # check units
  udf <- input_unit(test_game, test_player, test_unit)
  expect_equal(udf$unit_id, test_unit)

  # check actions
  action_res <- input_action(udf, test_game, .test = test_action)
  expect_equal(action_res$actions, exp_action_opts)

  # check locations
  loc_res <- input_loc(action_res$df, test_game, .test = test_locs)
  expect_equal(
    loc_res$locations,
    exp_loc_opts
  )

  # check final move
  test_unit_ids <- paste(test_unit, collapse = ', ')
  test_loc_picks <- paste0("'", paste0(test_locs, collapse = "', '"), "'")
  expect_equal(
    loc_res$res,
    glue("modify_unit('{test_player}', c({test_unit_ids}), '{test_action}', c({test_loc_picks})) %>%")
  )
}


#' Not yet used 2021.10.21
expect_unit_loc <- function(game, .p, .u, loc) {
  # check player is in game
  unit_df <- game$map_df %>%
    filter(player == .p)
  expect_true(nrow(unit_df) > 0, label = glue("{.p} in {game$name}"))

  # check player has units
  expect_true(all(!!.u %in% !!unit_df$unit_id))

  # check units are in loc
  units_loc <- unit_df %>%
    filter(unit_id %in% .u)%>%
    pull(loc) %>%
    unique()
  expect_equal(!!units_loc, !!loc)
}


