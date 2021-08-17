#' Write general game info json to disk
#'
#' Idea is this is immutable stuff created at new_game().
#' Is that right, or do we write this every turn (if it can change)?
#' @export
game_json_to_disk <- function(game) {

  # toss map and csv
  game$map <- NULL
  game$map_df <- NULL

  # write to disk
  game_path(game, create = TRUE)
  readr::write_lines(
    jsonlite::toJSON(game, auto_unbox = TRUE, pretty = TRUE),
    game_json_path(game)
  )
}

#' Save game state to disk
#'
#' Called internally by reconcile_player_moves()
#' @export
save_game <- function(game) {
  game_map_to_disk(game)
  game_df_to_disk(game)
}

#' @describeIn save_game Write map json to disk
#' @export
game_map_to_disk <- function(game) {
  readr::write_lines(
    jsonlite::toJSON(game$map, auto_unbox = TRUE, pretty = TRUE),
    game_map_path(game)
  )
}

#' @describeIn save_game Write df csv to disk
#' @export
game_df_to_disk <- function(game) {
  readr::write_csv(
    game$map_df,
    game_csv_path(game)
  )
}


#' Load game state from disk
#' @export
load_game <- function(path, turn) {
  game_json <- file.path(path, 'game.json')
  checkmate::assert_file_exists(game_json)

  turns <- path %>%
    fs::dir_ls() %>%
    str_subset(glue("^{game_json}$"), negate = TRUE) %>%
    str_replace_all("\\..+$", "") %>%
    basename %>%
    unique

  if (!(turn %in% turns)) abort(glue("{turn} is not a valid turn. Try one of {paste(turns, collapse = ', ')}"))

  game <- jsonlite::fromJSON(game_json)
  class(game) <- c(GAME_CLASS, class(game)) ### do I need this?
  game$turn <- turn
  game$map <- jsonlite::fromJSON(game_map_path(game))
  game$map_df <- readr::read_csv(game_csv_path(game), col_types = readr::cols()) # make this real
  return(game)
}

#' Increment the game turn/phase
#'
#' If no conflicts, increment to new turn.
#' If conflicts, increment phase.
#' @importFrom stringr str_replace_all str_pad
#' @keywords internal
increment_turn_phase <- function(game) {
  .t <- str_replace_all(game$turn, "[^0-9]", "")
  .p <- str_replace_all(game$turn, "[^A-Z]", "")
  if (is.null(game$conflicts)) {
    game$turn <- paste0(
      str_pad(as.numeric(.t)+1, 3, pad = "0"),
      "A"
    )
  } else {
    game$turn <- paste0(
      .t,
      LETTERS[which(LETTERS == .p)+1]
    )
  }
  return(game)
}


##################
# PRIVATE HELPERS
##################

#' Get path to game files on disk
#' @param game game object
#' @param ext extension, if NULL returns dir
#' @param create if TRUE, create it. Only works for dir.
#' @keywords internal
game_path <- function(game, ext = NULL, create = FALSE) {
  .g <- file.path(getwd(), glue("{sanitize_name(game$name)}_db"))
  if (isTRUE(create)) fs::dir_create(.g) # add if_exists checking and overwrite?

  if (!is.null(ext)) {
    .g <- file.path(.g, glue("{game$turn}.{ext}"))
  }
  return(.g)
}

#' @describeIn game_path Path to general game info json
#' @keywords internal
game_json_path <- function(game) {

  file.path(game_path(game), glue("game.json"))
}

#' @describeIn game_path Path to map_df csv
#' @keywords internal
game_csv_path <- function(game) {
  game_path(game, ext = "csv")
}

#' @describeIn game_path Path to map json
#' @keywords internal
game_map_path <- function(game) {
  game_path(game, ext = "map.json")
}
