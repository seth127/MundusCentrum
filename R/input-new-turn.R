#' Enter new turn moves
#' @export
input_new_move <- function(game, player_code) {
  .p <- input_player_code(game, player_code)
  message(glue("Hello {.p}"))
  .u <- readline("Please enter units: ") %>%
    stringr::str_split("[, ]+") %>%
    unlist()

  make_new_move(game, .p, .u)
}

#' Actually make the move
#' @param game `MC_game` object to modify
#' @param .p String; player name
#' @param .u units; passed to input_units()
#' @param .a action to take. If `NULL`, the default, ask the user.
#' @param .l location to act. If `NULL`, the default, ask the user.
#' @return The modified `MC_game` object passed to `game`
#' @export
make_new_move <- function(game, .p, .u, .a = NULL, .l = NULL) {
  unit_df <- input_unit(game, .p, .u)
  action_res <- input_action(unit_df, game, .test = .a)
  loc_res <- input_loc(action_res$df, game, .test = .l)

  # write out
  write_lines(loc_res$res, game_turnfile_path(game), append = TRUE)
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
