#fs::dir_delete(file.path(GAME_ROOT_DIR, "anno_uno"))

name = "Anno Uno"
players = list(
  list(
    name = "Big Grizz",
    team = "Space Marines",
    units = system.file("extdata", "unit-templates", "big_grizz.csv", package = "MundusCentrum")
  ),
  list(
    name = "Eric",
    team = "Space Orcs",
    units = system.file("extdata", "unit-templates", "eric.csv", package = "MundusCentrum")
  ),
  list(
    name = "Chris",
    team = "Tyrannids",
    units = system.file("extdata", "unit-templates", "chris.csv", package = "MundusCentrum")
  )
)
points = 2000


####
GAME <- new_game(name, players, points)
