#' Enter new turn moves
#' @export
input_new_move <- function(game, player_code) {
  .p <- input_player_code(game, player_code)
  message(glue("Hello {.p}"))
  .u <- readline("Please enter units: ") %>%
    stringr::str_split("[, ]+") %>%
    unlist()

  move <- game %>%
    input_unit(.p, .u) %>%
    input_action(game) %>%
    input_loc(game)

  # write out
  write_lines(move, game_turnfile_path(game), append = TRUE)
  return(move)
}

# Start new turn
#' @export
start_turn_moves <- function(game) {

  .tf <- game_turnfile_path(game)
  if (fs::file_exists(.tf)) fs::file_delete(.tf)

  write_lines(c(
    "library(MundusCentrum)",
    glue("game <- load_game('{game$name}') %>%")
  ), .tf)

  player_code <- enter_player_code(game)
  while(player_code != "") {
    this_move <- input_new_move(game, player_code)
    message(glue("Processed move:\n  {this_move}\nNext move... (press ENTER to end moves)\n"))
    player_code <- enter_player_code(game)
  }

  return(game)
}

#' End the turn and process the moves
#'
#' This is what actually executes the code we've been building
#' @export
finalize_turn <- function(game) {
  .tf <- game_turnfile_path(game)
  write_lines("reconcile_player_orders()\n", .tf, append = TRUE)
  source(.tf)
  if (fs::file_exists(.tf)) fs::file_delete(.tf)
  load_game(game$name)
}

#' @keywords internal
enter_player_code <- function(game) {
  player_code <- readline("Enter Player Code: ")
  while(!(player_code %in% c("", game$players))) {
    message(glue("{player_code} is _not_ a valid player code. Try Again."))
    player_code <- readline("Enter Player Code: ")
  }
  player_code
}
