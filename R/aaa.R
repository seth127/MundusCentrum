GAME_ROOT_DIR <- system.file("games", package = "MundusCentrum")

GAME_CLASS <- "MC_game"

BLANK_MAP <- data.frame(
  unit_name = character(),
  player = character(),
  loc = character(),
  action = character()
)

UNIT_KEYWORDS <- c(
  "control",
  "transport",
  "fast",
  "fly",
  "soar",
  "deep",
  "sneak"
)
