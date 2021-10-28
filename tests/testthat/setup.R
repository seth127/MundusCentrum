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
  "Rhino"
)

# create a temporary game
temp_game <- function(game_name, ...) {
  # Start the game fresh
  if (fs::dir_exists(game_dir_path(game_name))) fs::dir_delete(game_dir_path(game_name))

  .players <- list(...)
  walk(.players, ~checkmate::assert_class(.x, "MC_bpl"))

  new_game(
    game_name,
    .players,
    points = 50000
  )
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
