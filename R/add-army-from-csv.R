#' Create csv needed to start game from an input csv
#' @param in_path Path to input CSV
#' @param out_path Path to write army CSV to
#' @param starting_loc Map location to start units in
#' @param player_name Optional string, if passed with filter input df with `filter(.data$player == player_name)`
#' @export
add_army_from_csv <- function(in_path, out_path, starting_loc, player_name = NULL) {
  checkmate::assert_string(starting_loc)

  raw_df <- read_csv(path) %>%
    mutate(unit_type = stringr::str_replace(.data$unit_type, " ?[0-9]+[A-Za-z]*$", "")) %>%
    filter(.data$player == player_name) %>%
    select(unit_type) %>%
    mutate(loc = starting_loc)

  write_csv(raw_df, out_path)
}

# add_army_from_csv(
#   "~/Downloads/MundusCentrumUnitAttributes210729.csv",
#   system.file("extdata", "unit-templates", "big_grizz.csv", package = "MundusCentrum"),
#   "B10",
#   "Moby"
# )
#
# add_army_from_csv(
#   "~/Downloads/MundusCentrumUnitAttributes210729.csv",
#   system.file("extdata", "unit-templates", "eric.csv", package = "MundusCentrum"),
#   "C4",
#   "Eric"
# )
#
# add_army_from_csv(
#   "~/Downloads/MundusCentrumUnitAttributes210729.csv",
#   system.file("extdata", "unit-templates", "chris.csv", package = "MundusCentrum"),
#   "F2",
#   "Chris"
# )
