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
    make_new_move(SFR, 9, .a = "move", .l = c("F3", "F7")) %>%
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
    exp_loc_opts = list(c("F7"))
  )
})


test_that("retreat test: regular retreat, egress blocked flying", {
  .g <- temp_game(
    "retreat test",
    bpl(SFR, "F2", ERC),
    bpl(BGR, "C4", SMU)
  ) %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, 8, .a = "move", .l = "C3") %>%
    make_new_move(SFR, 9, .a = "move", .l = "F3") %>% # this where we're retreating to
    make_new_move(BGR, c(1,2,3), .a = "move", .l = "C5") %>%
    finalize_turn() %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, 8, .a = "move", .l = "F7") %>% # attack
    make_new_move(BGR, c(1,2,3), .a = "move", .l = "F7") %>% # attack (winner)
    make_new_move(BGR, 7, .a = "move", .l = "C3") %>% # blocking his retreat ^
    finalize_turn()

  expect_unit_move(
    test_game = .g,
    test_player = SFR,
    test_unit = 8,
    test_action = "retreat",
    test_locs = "F5",
    # exp_action_opts = c('retreat', 'rout', 'superrout'),
    # exp_loc_opts = list(c("F3"))
    ##### currently saying
    ##### TODO: exp_loc_opts = list(c("F5", "F8"))
    ##### which is wrong because a) those are rout spots and b) "F4" should also be a rout spot
    ##### c) F3 should be a retreat spot, but we need to add flying (over rivers)
  )
})


test_that("retreat test: regular retreat, egress blocked transport", {
  .g <- temp_game(
    "retreat test",
    bpl(SFR, "F2", ERC),
    bpl(BGR, "C4", SMU)
  ) %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(SFR, c(8,9), .a = "move", .l = "F3") %>%
    make_new_move(BGR, c(1,2,3,7), .a = "transport", .l = c("C5", "F7")) %>%
    finalize_turn() %>%
    start_turn_moves(.input = FALSE) %>%
    make_new_move(BGR, 4, .a = "move", .l = "C3") %>% # covering retreat
    make_new_move(BGR, c(1,2,3,7), .a = "transport", .l = "F3") %>% # attack
    make_new_move(SFR, 8, .a = "move", .l = "F7") %>% # blocking his retreat ^
    finalize_turn()

  expect_unit_move(
    test_game = .g,
    test_player = BGR,
    test_unit = c(1,2,3,7),
    test_action = "retreat",
    test_locs = "C3",
    # exp_action_opts = c('retreat', 'rout', 'superrout'),
    # exp_loc_opts = list(c("F3"))
    ##### TODO: currently saying I can only retreat to C5 (and showing arrow from C5)
    ##### but I actually attacked from F7 :shrug:
    ##### Need to fix that, but the original point of this test was checking
    ##### that everyone could jump back in the transport and fly over the river
    ##### to C3 (which is not yet coded)
  )
})



test_that("rout test: rout", {
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
    test_action = "rout",
    test_locs = "C1",
    exp_action_opts = c('retreat', 'rout', 'superrout'),
    exp_loc_opts = list(c("F7", "C1", "C5", "F3"))
    ###### TODO: currently rout seems to give you the options for normal movement. Fix that.
  )
})
