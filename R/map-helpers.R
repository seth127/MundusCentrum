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

#' Print list of units on the map
#'
#' Calls [get_player_map()] and formats for printing
#' @export
print_map_df <- function(game, .p = NULL) {
  .m <- get_player_map(game, .p)
  # get df of units we care about
  .m <- if (!is.null(game$conflicts)) {
    .m %>%
      mutate(
        `CONFLICT!` = ifelse(loc %in% game$conflicts, "TRUE", ""),
        passing_through = str_replace(as.character(passing_through), "FALSE", "")
      )
  } else {
    .m %>%
      select(-passing_through)
  }
  return(knitr::kable(.m))
}

#' @export
get_comm_df <- function(game) {
  map_dfr(names(game$map), ~ {
    .l <- game$map[[.x]]
    if (!is.null(.l$comm)) {
      return(data.frame(comm = .l$comm, loc = .x))
    } else {
      return(data.frame(comm = character(), loc = character()))
    }
  })
}


#' @export
get_control_df <- function(game) {
  map_dfr(names(game$map), ~ {
    .l <- game$map[[.x]]
    if (!is.null(.l$control)) {
      return(data.frame(control = .l$control, loc = .x))
    } else {
      return(data.frame(control = character(), loc = character()))
    }
  })
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
