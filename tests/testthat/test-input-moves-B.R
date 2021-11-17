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

test_that("first retreat test: back from whence you came simple", {
  .g <- temp_game(
    "retreat test",
    bpl(SFR, "F2", ERC),
    bpl(BGR, "C4", SMU)
  ) %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, 8, .a = "move", .l = "C3") %>%
    make_new_move(BGR, c(1,2,3), .a = "move", .l = "C3") %>%
    finalize_turn()


  expect_unit_move(
    test_game = .g,
    test_player = SFR,
    test_unit = 8,
    test_action = "retreat",
    test_locs = "F2",
    exp_action_opts = c('retreat', 'rout', 'superrout'),
    exp_loc_opts = list(c("F2"))
  )
})


test_that("retreat test: back from whence you came, two places", {
  .g <- temp_game(
    "retreat test",
    bpl(SFR, "F2", ERC),
    bpl(BGR, "C4", SMU)
  ) %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, 8, .a = "move", .l = "C3") %>%
    make_new_move(SFR, 9, .a = "move", .l = c("F3", "C3")) %>%
    make_new_move(BGR, c(1,2,3), .a = "move", .l = "C3") %>%
    finalize_turn()

  expect_unit_move(
    test_game = .g,
    test_player = SFR,
    test_unit = c(8, 9),
    test_action = "retreat",
    test_locs = "F2",
    exp_action_opts = c('retreat', 'rout', 'superrout'),
    exp_loc_opts = list(c("F2", "F3"))
  )
})



test_that("retreat test: regular retreat, egress blocked", {
  .g <- temp_game(
    "retreat test",
    bpl(SFR, "F2", ERC),
    bpl(BGR, "C4", SMU)
  ) %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, 8, .a = "move", .l = "C3") %>%
    make_new_move(BGR, c(1,2,3), .a = "move", .l = "C5") %>%
    finalize_turn() %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, 8, .a = "move", .l = "C5") %>%
    make_new_move(BGR, 4, .a = "move", .l = "C3") %>% # blocking his retreat ^
    finalize_turn()

  expect_unit_move(
    test_game = .g,
    test_player = SFR,
    test_unit = 8,
    test_action = "retreat",
    test_locs = "F5",
    exp_action_opts = c('retreat', 'rout', 'superrout'),
    exp_loc_opts = list(c("F5", "F7"))
  )
})
