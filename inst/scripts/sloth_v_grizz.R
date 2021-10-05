devtools::load_all()
game_name <- "Sloth v Grizz"
options("MC.render_map" = FALSE)

# "GLOBAL": "93c791f11f6bf4d3871bed645fa2cee7",
# "big_grizz": "6a45c6b9c8d0f251662fabcdca52cc43",
# "slothfire": "047a45d5b4a91f1c56387070a270da4b"

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
