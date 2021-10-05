devtools::load_all()
game_name <- "Sloth v Grizz"

# Start the game over
fs::dir_delete(game_dir_path(game_name))

game <- new_game(
  game_name,
  list(
    list(
      name = "Big Grizz",
      team = "Pretend Good Guys",
      units = system.file("extdata", "starting-armies", "big_grizz.csv", package = "MundusCentrum")
    ),
    list(
      name = "Slothfire",
      team = "Morally Ambiguous Guys",
      units = system.file("extdata", "starting-armies", "eric.csv", package = "MundusCentrum")
    )
  ),
  points = 50000
)

game <- game %>%
  start_turn_moves() %>%
  finalize_turn()
