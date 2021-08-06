#' @export
get_player_map <- function(game, .p) {
  check_player_name(game, .p)
  res <- if (!is.null(.p) && .p != "GLOBAL") {
    filter(game$map_df, .data$loc %in% player_vision(game, .p))
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


#' Filter out sneakers
#' @keywords internal
filter_out_sneakers <- function(map_df, .p) {
  #map
}
