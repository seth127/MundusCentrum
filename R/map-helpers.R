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
#' @importFrom dplyr slice_head
#' @export
print_map_df <- function(game, .p = NULL, .n = NULL) {
  checkmate::assert_character(.p, null.ok = TRUE)
  checkmate::assert_integerish(.n, null.ok = TRUE)

  .m <- get_player_map(game, .p)
  # get df of units we care about
  if (!is.null(game$conflicts)) {
    cat("\n\n#### CONFLICT! Combatants:\n")
    .m <- .m %>%
      mutate(
        `CONFLICT!` = ifelse(loc %in% game$conflicts, "TRUE", ""),
        passing_through = str_replace(as.character(passing_through), "FALSE", "")
      )

    if (!is.null(.n)) {
      cat(glue("(Top {.n} units from each player)\n\n"))
      .m <- map_dfr(get_player_names(game), ~ {
        .m %>%
          filter(player == .x, isTRUE(`CONFLICT!`)) %>%
          arrange(unit_id) %>%
          dplyr::slice_head(n = .n)
      })

    }
  } else {
    cat("\n\n#### Visible units:\n")
    .m <- .m %>%
      select(-passing_through)

    if (!is.null(.n)) {
      cat(glue("(Top {.n} visible units from each player)\n\n"))
      .m <- map_dfr(get_player_names(game), ~ {
        .m %>%
          filter(player == .x) %>%
          arrange(unit_id) %>%
          dplyr::slice_head(n = .n)
      })

    }
  }

  if (isTRUE(getOption('knitr.in.progress'))) {
    return(knitr::kable(.m))
  } else {
    return(.m)
  }
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

#' @export
get_bridges <- function(game, .p = NULL) {
  check_player_name(game, .p)
  imap_dfr(game$map, function(.l1, .n) {
    if(is.null(.l1[["bridges"]])) return(data.frame())
    imap_dfr(.l1[["bridges"]], function(.l2, .i) {
      .x1 = .l1$x_
      .x2 = game$map[[.l2]]$x_
      .y1 = .l1$y_
      .y2 = game$map[[.l2]]$y_


      data.frame(
        loc = c(.n, .l2),
        bridge_id = rep(paste(.n, .l2, sep = "-"), 2),
        bridge_name = c(
          paste(sort(c(.l1$name, game$map[[.l2]]$name)), collapse = "--"),
          paste(sort(c(.l1$name, game$map[[.l2]]$name), decreasing = TRUE), collapse = "--")
        ),
        x_ = c(
          mean(c(.x1, .x1, .x2)),
          mean(c(.x1, .x2, .x2))
        ),
        y_ = c(
          mean(c(.y1, .y1, .y2)),
          mean(c(.y1, .y2, .y2))
        )
      )
    })
  }) %>%
    filter(
      !duplicated(.data$bridge_name),
      loc %in% player_vision(game, .p)
    )

}
