#' @export
get_player_map <- function(game, .p) {
  check_player_name(game, .p)
  res <- if (!is.null(.p) && .p != "GLOBAL") {
    .op <- get_other_players_names(game, .p)
    game$map_df %>%
      filter(.data$loc %in% c(player_vision(game, .p), NA)) %>%
      filter(!(.data$player %in% .op & .data$action == "sneak"))
  } else {
    game$map_df
  }
  return(res)
}


#' Get loc of all player comms
#' @importFrom purrr map_lgl
#' @keywords internal
get_comms <- function(game, .p) {
  map_lgl(game$map, ~ {
    if (is.null(.x$comm)) {
      FALSE
    } else {
      .x$comm == .p
    }
  }) %>%
    which() %>%
    names() %>%
    na.omit() %>%
    as.character()

}

#' Get loc of all player comms
#' @importFrom purrr map_lgl
#' @keywords internal
get_controls <- function(game, .p) {
  map_lgl(game$map, ~ {
    if (is.null(.x$control)) {
      FALSE
    } else {
      .x$control == .p
    }
  }) %>%
    which() %>%
    names() %>%
    na.omit() %>%
    as.character()

}
