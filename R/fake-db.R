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
  game_db_path(game, create = TRUE)
  readr::write_lines(
    jsonlite::toJSON(game, auto_unbox = TRUE, pretty = TRUE),
    game_json_path(game$name)
  )
}

#' Save game state to disk
#'
#' Called internally by reconcile_player_moves()
#' @export
save_game <- function(game) {
  verbose_message("Saving game to disk...")
  game_map_to_disk(game)
  game_df_to_disk(game)
  game_img_to_disk(game)
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

#' @describeIn save_game Draw the map and save as a png
#' @importFrom ggplot2 ggsave
#' @export
game_img_to_disk <- function(game) {
  for (.p in c("GLOBAL", get_player_names(game))) {
    .m <- draw_map(game, .p)
    ggsave(
      filename = basename(game_img_path(game, .p)),
      plot = .m,
      path = dirname(game_img_path(game, .p)) ,
      width = 7.5,
      height = 8,
      units = "in",
      device = "png",
      dpi = 300
    )
  }
}


#' Load game state from disk
#'
#' @param turn String for turn to load. If NULL, loads most recent turn.
#' @export
load_game <- function(game_name, turn = NULL) {

  if (is.null(turn)) {
    all_turns <- list_turns(game_name)
    turn <- all_turns[length(all_turns)]
  }

  game_json <- game_json_path(game_name)
  checkmate::assert_file_exists(game_json)

  game <- jsonlite::fromJSON(game_json)

  turns <- game %>%
    game_db_path() %>%
    fs::dir_ls() %>%
    str_subset(glue("^{game_json}$"), negate = TRUE) %>%
    str_replace_all("\\..+$", "") %>%
    basename %>%
    unique

  if (!(turn %in% turns)) abort(glue("{turn} is not a valid turn. Try one of {paste(turns, collapse = ', ')}"))


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
  game$turn <- get_next_turn(game)
  return(game)
}

#' @export
get_next_turn <- function(game) {
  .t <- str_replace_all(game$turn, "[^0-9]", "")
  .p <- str_replace_all(game$turn, "[^A-Z]", "")
  next_turn <- if (is.null(game$conflicts)) {
    paste0(
      str_pad(as.numeric(.t)+1, 3, pad = "0"),
      "A"
    )
  } else {
    paste0(
      .t,
      LETTERS[which(LETTERS == .p)+1]
    )
  }
  next_turn
}


##################
# PRIVATE HELPERS
##################


#' Takes a game name and returns the path to a relevant file
#' @keywords internal
game_path <- function(game_name, ext = "") {
  checkmate::assert_string(game_name)
  game_name <- sanitize_name(game_name)
  file.path(
    getOption("MC.games_dir"),
    game_name,
    fs::path_ext_set(game_name, ext)
  )
}

#' @describeIn game_path Path to the game directory
#' @keywords internal
game_dir_path <- function(game_name) {
  checkmate::assert_string(game_name)
  dirname(game_path(game_name))
}

#' @describeIn game_path Path to the player's starting army .csv file
#' @keywords internal
game_starting_armies_path <- function(game_name, player_name) {
  file.path(
    game_dir_path(game_name),
    "starting_armies",
    fs::path_ext_set(sanitize_name(player_name), "csv")
  )
}

#' @describeIn game_path Path to temp file for executing turns
#' @keywords internal
game_turnfile_path <- function(game) {
  file.path(game_dir_path(game$name), TURN_TEMP_FILE)
}



#' Get path to game db files on disk
#' @param game game object
#' @param ext extension, if NULL returns dir
#' @param create if TRUE, create it. Only works for dir.
#' @keywords internal
game_db_path <- function(game, ext = NULL, create = FALSE) {

  game_name <- sanitize_name(game$name)

  .g <- file.path(
    getOption("MC.games_dir"),
    game_name,
    glue("{game_name}_db")
  )

  if (isTRUE(create)) fs::dir_create(.g) # add if_exists checking and overwrite?

  if (!is.null(ext)) {
    .g <- file.path(.g, glue("{game$turn}.{ext}"))
  }
  return(.g)
}

#' @describeIn game_db_path Path to general game info json
#' @keywords internal
game_json_path <- function(game_name) {
  file.path(
    paste0(game_path(game_name), "_db"),
    "game.json"
  )
}

#' @describeIn game_db_path Path to map_df csv
#' @keywords internal
game_csv_path <- function(game) {
  game_db_path(game, ext = "csv")
}

#' @describeIn game_db_path Path to map json
#' @keywords internal
game_map_path <- function(game) {
  game_db_path(game, ext = "map.json")
}

#' @describeIn game_db_path Path to map json
#' @keywords internal
game_img_path <- function(game, .p) {
  check_player_name(game, .p)
  game_db_path(game, ext = glue("map.{game$players[[.p]]}.png"))
}
