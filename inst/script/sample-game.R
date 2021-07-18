#fs::dir_delete(file.path(GAME_ROOT_DIR, "anno_uno"))

name = "Anno Uno"
players = list(
  list(
    name = "Big Grizz",
    team = "Space Marines"
  ),
  list(
    name = "Eric",
    team = "Space Orcs"
  ),
  list(
    name = "Chris",
    team = "Tyrannids"
  )
)
points = 2000


####
GAME <- new_game(name, players, points)
