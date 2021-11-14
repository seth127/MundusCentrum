temp_game_dir <- file.path(tempdir(), "MundusCentrum-test-input-moves")
dir_create_empty(temp_game_dir)
withr::defer(fs::dir_delete(temp_game_dir))

withr::local_options(list(
  "MC.render_map" = FALSE,
  "MC.verbose" = FALSE,
  "MC.games_dir" = temp_game_dir
))


#################
# PHASE B
#################

test_that("first test - two units move F2 to F3", {
  expect_unit_move(
    test_game = temp_game("first test", bpl(SFR, "F2", SMU)),
    test_player = SFR,
    test_unit = 1:2,
    test_action = "move",
    test_locs = "F3",
    exp_action_opts = c("move", "defend", "reinforce"),
    exp_loc_opts = list(c("F1", "F3"))
  )
})


test_that("second test - Storm Raven can soar", {
  expect_unit_move(
    test_game = temp_game("second test", bpl(SFR, "F2", SMU)),
    test_player = SFR,
    test_unit = 7,
    test_action = "move",
    test_locs = c("F2S", "E3S", "E1S"),
    exp_action_opts = c("move", "defend", "reinforce", "transport"),
    exp_loc_opts = list(
      c("F1", "F3", "C3", "F2S"),
      c("F1S", "F3S", "C3S", "E3S"),
      c("E4S", "B11S", "E1S", "E2S", "E5S", "F2S", "F3S")
    )
  )
})


test_that("first multimove test", {
  .g <- temp_game(
    "first multimove test",
    bpl(SFR, "F2", ERC)
  ) %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, c(1,2,3), .a = "move", .l = "F3") %>%
    make_new_move(SFR, c(8), .a = "move", .l = c("C3", "C1")) %>%
    finalize_turn()

  expect_unit_move(
    test_game = .g,
    test_player = SFR,
    test_unit = 8,
    test_action = "move",
    test_locs = c("B4", "B1"),
    exp_action_opts = c('move', 'defend', 'reinforce'),
    exp_loc_opts = list(c("B4", "B6", "C2", "C3"), c("B1", "C1"))
  )
})


test_that("first multiplayer test", {
  .g <- temp_game(
    "first multimove test",
    bpl(SFR, "F2", ERC),
    bpl(BGR, "C4", SMU)
  ) %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, c(1,2,3), .a = "move", .l = "F3") %>%
    make_new_move(BGR, c(1,2,3), .a = "move", .l = "C3") %>%
    finalize_turn()

  expect_unit_move(
    test_game = .g,
    test_player = SFR,
    test_unit = c(1,2,3),
    test_action = "move",
    test_locs = "F4",
    exp_action_opts = c('move', 'defend', 'reinforce'),
    exp_loc_opts = list(c("E5", "F2", "F4"))
  )

  expect_unit_move(
    test_game = .g,
    test_player = BGR,
    test_unit = 1,
    test_action = "defend",
    test_locs = "C3",
    exp_action_opts = c('move', 'defend', 'reinforce'),
    exp_loc_opts = list()
  )

  expect_unit_move(
    test_game = .g,
    test_player = BGR,
    test_unit = c(2,3),
    test_action = "move",
    test_locs = "F7",
    exp_action_opts = c('move', 'defend', 'reinforce'),
    exp_loc_opts = list(c("C4", "C5", "F7", "C1", "F2"))
  )

})

#################
# PHASE B
#################

# test_that("first retreat test", {
#   .g <- temp_game(
#     "first retreat test",
#     bpl(SFR, "F2", ERC),
#     bpl(BGR, "C4", SMU)
#   ) %>%
#     start_turn_moves(.input = FALSE) %>%
#     make_new_move(SFR, c(1,2,3), .a = "move", .l = "F3") %>%
#     make_new_move(SFR, c(8), .a = "move", .l = "C3") %>%
#     finalize_turn()
#
#   expect_unit_move(
#     test_game = .g,
#     test_player = SFR,
#     test_unit = 7,
#     test_action = "move",
#     exp_action_opts = c("move", "defend", "reinforce", "transport"),
#     test_locs = c("F2S", "E3S", "E1S"),
#     exp_loc_opts = list(
#       c("F1", "F3", "C3", "F2S"),
#       c("F1S", "F3S", "C3S", "E3S"),
#       c("E4S", "B11S", "E1S", "E2S", "E5S", "F2S", "F3S")
#     )
#   )
# })
