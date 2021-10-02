#' Render a game Rmd into a game R script
#'
#' @param game_name name of the game. Will look for a dir in
#'   `file.path(getOption(MC.games_dir), sanitize_name(game_name))` containing
#'   game files
#' @importFrom stringr str_which
#' @export
game_script_from_rmd <- function(game_name, run = FALSE) {
  script_path <- game_path(game_name, ".R")
  rmd_path <- game_path(game_name, ".Rmd")

  rmd_lines <- read_lines(rmd_path)
  script_lines <- c()

  ticks <- str_which(rmd_lines, "^```")

  for (.i in seq(ticks)) {
    if (str_detect(rmd_lines[ticks[.i]], "^```\\{r")) {
      start <- ticks[.i] + 1
      stop <- ticks[.i+1] -1
      script_lines <- c(script_lines, rmd_lines[start:stop], "")
    }
  }

  script_lines <- str_replace(script_lines, "^print", "#print")

  message(glue("Writing to {script_path} ..."))
  write_lines(script_lines, script_path)

  if (isTRUE(run)) {
    message(glue("Running to {script_path} ... Writing to"))
    source(script_path)
  }
}



