temp_game_dir <- file.path(tempdir(), "MundusCentrum-test-input-moves")
dir_create_empty(temp_game_dir)
withr::defer(fs::dir_delete(temp_game_dir))

withr::local_options(list(
  "MC.render_map" = FALSE,
  "MC.games_dir" = temp_game_dir
))

test_that("first test - two units move F2 to F3", {
  expect_unit_move(
    test_game = temp_game("first test", bpl(SFR, "F2", SMU)),
    test_player = SFR,
    test_unit = 1:2,
    test_action = "move",
    exp_action_opts = c("move", "defend", "reinforce"),
    test_locs = "F3",
    exp_loc_opts = list(c("F1", "F3"))
  )
})


test_that("second test - Storm Raven can soar", {
  expect_unit_move(
    test_game = temp_game("second test", bpl(SFR, "F2", SMU)),
    test_player = SFR,
    test_unit = 7,
    test_action = "move",
    exp_action_opts = c("move", "defend", "reinforce", "transport"),
    test_locs = c("F2S", "E3S", "E1S"),
    exp_loc_opts = list(
      c("F1", "F3", "C3", "F2S"),
      c("F1S", "F3S", "C3S", "E3S"),
      c("E4S", "B11S", "E1S", "E2S", "E5S", "F2S", "F3S")
    )
  )
})
