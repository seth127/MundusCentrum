#' Modify the action of a unit or group of units
#' @param game The game to modify the unit(s) in
#' @param .p The player who owns the unit(s)
#' @param .u Either a character vector of unit names to modify, a vector of
#'   unit_id's , or a scalar of a map loc, in which case all units in that loc
#'   will be modified.
#' @param .a Action to assign to units
#' @param .l Location to move units to (if NULL, assumed to be same as where they are)
#' @importFrom purrr walk imap_dfr
#' @importFrom dplyr bind_rows
#' @export
modify_unit <- function(game, .p, .u, .a, .l = NULL) {
  check_player_name(game, .p)

  # check if a loc was passed
  if ((length(.u) == 1) && (.u %in% names(game$map))) {
    .loc_u <- game$map_df %>%
      filter(
        .data$player == .p,
        .data$loc == .u
      ) %>%
      pull(unit_name)

    if (length(.loc_u) == 0) {
      warning(glue("{.p} has no units in {.u}"))
      return(invisible(NULL))
    } else {
      .u <- .loc_u
    }
  }
  .u <- unique(.u) # if unit in multiple battles they will be duplicated

  ## TODO: this feels like it might be super inefficient, making a lot of copies of game$map_df maybe... should look into that
  ## * should this be some kind of map instead of walk?
  new_moves <- map_dfr(.u, function(.ux) {
    # TODO: should check if it's a legal move first. Boring...
    if(is.null(.ux) || is.na(.ux)) return(NULL)

    # translate unit_id to unit_name (probably here)
    if (!is.na(suppressWarnings(as.numeric(.ux)))) {
      .ux <- game %>%
        get_player_map(.p) %>%
        filter(player == .p, unit_id == .ux) %>%
        pull(unit_name) %>%
        unique() # if unit in multiple battles they will be duplicated
    }

    if (length(.ux) > 1) warn(glue("length(.ux) > 1 :: {paste(.ux, collapse = ', ')}"), "modify_unit_warning")
    if (!(.ux %in% pull(get_player_map(game, .p), unit_name))) {
      warning(glue("{.ux} is not a unit in {.p}'s army"))
      return(NULL)
    }

    ## edit player map

    # if .l is NULL, use current location
    if (is.null(.l)) {
      # TODO: maybe refactor this and lines 41-45 into a getter helper?
      .l <- game %>%
        get_player_map(.p) %>%
        filter(player == .p, unit_name == .ux) %>%
        pull(loc) %>%
        unique() # if unit in multiple battles they will be duplicated
    } else if (is.na(.l)) {
      message(glue("Rest In Peace {.ux}, KIA"))
    }


    purrr::imap_dfr(.l, function(.lx, .i) {
      check_loc(game, .lx)
      game$map_df %>%
        filter(.data$unit_name == .ux) %>%
        mutate(
          loc = .lx,
          action = .a,
          passing_through = .i != length(.l)#ifelse(.i != length(.l), "TRUE", "")
        )
    }) %>%
      unique() # if unit in multiple battles they will be duplicated
  })

  game$map_df <- dplyr::bind_rows(
    new_moves,
    game$map_df %>% filter(!(.data$unit_name %in% new_moves$unit_name))
  ) %>%
    #unique() %>% # if unit in multiple battles they will be duplicated
    sort_map_df()

  return(game)
}

#' Kill a unit
#' @importFrom purrr walk
#' @export
kill_unit <- function(game, player, .u) {
  modify_unit(game, player, .u, NA_character_, NA_character_)
}


#' Print the calls players make to move units
#' @importFrom purrr pwalk
#' @export
modify_unit_calls <- function(game, .p = NULL) {
  check_player_name(game, .p)

  if (!is.null(.p)) {
    game_df <- filter(game$map_df, .data$player == .p)
  }

  game_df %>%
    group_by(player, loc) %>%
    count() %>%
    pwalk(print_modify_unit_call)
}


#' pwalk iterator for modify_unit_calls()
#' @keywords internal
print_modify_unit_call <- function(...) {
  .row <- list(...)
  print(
    glue('modify_unit(game, "{.row$player}",\t"{.row$loc}",\t"WHAT?",\t"WHERE?") # {.row$n} units')
  )
}

#' @keywords internal
sort_map_df <- function(map_df) {
  map_df %>%
    arrange(loc, player, action, unit_id, unit_type, unit_name) %>%
    select(player, loc, unit_id, unit_type, action, unit_name, passing_through)

}
