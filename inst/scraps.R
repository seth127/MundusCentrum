devtools::load_all()

##################
# params to start the game

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
points = 3000



##################
# join against keywords
View(
  "big_grizz.csv" %>%
  system.file("extdata", "unit-templates", ., package = "MundusCentrum") %>%
  read_csv()%>%
    mutate(unit_type = map_chr(unit_type, sanitize_name)) %>%
    left_join(UNIT, by = "unit_type")
)

View(
  "eric.csv" %>%
    system.file("extdata", "unit-templates", ., package = "MundusCentrum") %>%
    read_csv()%>%
    mutate(unit_type = map_chr(unit_type, sanitize_name)) %>%
    left_join(UNIT, by = "unit_type")
)

View(
  "chris.csv" %>%
    system.file("extdata", "unit-templates", ., package = "MundusCentrum") %>%
    read_csv()%>%
    mutate(unit_type = map_chr(unit_type, sanitize_name)) %>%
    left_join(UNIT, by = "unit_type")
)


# get keywords joined against state of game map
# add_keywords(game)

render_game("inst/games/anno_duo", players = TRUE, html = TRUE)
publish_game_html("inst/games/anno_duo", "~/seth127.github.io/MundusCentrum/games", overwrite = TRUE)


# Eric's moves

moves_from_gsheet(
  "eric",
  5,
  ss = "https://docs.google.com/spreadsheets/d/1nixuwA_qX0XTXg2LQKyC2nZijZ_LcEuZUhDL7ksXiCc/",
  sheet = "Moves Only"
)
