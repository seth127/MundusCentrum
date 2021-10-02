#' Create csv needed to start game from an input csv
#' @param in_path Path to input CSV
#' @param out_path Path to write army CSV to
#' @param starting_loc Map location to start units in
#' @param player_name Optional string, if passed with filter input df with `filter(.data$player == player_name)`
#' @export
add_army_from_csv <- function(in_path, game_name, player_name, starting_loc) {
  checkmate::assert_string(starting_loc)

  raw_df <- read_csv(in_path) %>%
    mutate(unit_type = stringr::str_replace(.data$unit_type, " ?[0-9]+[A-Za-z]*$", "")) %>%
    filter(.data$player == player_name) %>%
    select(unit_type) %>%
    mutate(loc = starting_loc)

  if (nrow(raw_df) == 0) {
    rlang::abort(paste(
      glue("There are no rows in in {in_path} with player == '{player_name}'"),
      paste("Choose one of:", paste(unique(read_csv(in_path)$player), collapse = ", ")),
      sep = "\n"
    ))
  }

  out_path <- file.path(
    dirname(game_path(game_name)),
    "starting-armies",
    fs::path_ext_set(sanitize_name(player_name), "csv")
  )
  write_csv(raw_df, out_path)
}

# anno_duo_armies_file <- "~/Downloads/MundusCentrumUnitAttributes210729.csv"
# add_army_from_csv(anno_duo_armies_file, "Anno Duo", "Big Grizz", "D4")
# add_army_from_csv(anno_duo_armies_file, "Anno Duo", "Eric", "G7")
# add_army_from_csv(anno_duo_armies_file, "Anno Duo", "Chris", "A5")
