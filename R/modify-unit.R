#' Modify the action of a unit or group of units
#' @param game The game to modify the unit(s) in
#' @param .p The player who owns the unit(s)
#' @param .u Either a character vector of unit names to modify, a vector of
#'   unit_id's , or a scalar of a map loc, in which case all units in that loc
#'   will be modified.
#' @param .a Action to assign to units
#' @param .l Location to move units to (or same as where they are if not moving)
#' @importFrom purrr walk
#' @importFrom dplyr bind_rows
#' @export
modify_unit <- function(game, .p, .u, .a, .l) {
  check_player_name(game, .p)

  # check if a loc was passed
  if ((length(.u) == 1) && (.u %in% names(MAP))) {
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

  ## TODO: this feels like it might be super inefficient, making a lot of copies of game$map_df maybe... should look into that
  ## * should this be some kind of map instead of walk?
  new_moves <- map_dfr(.u, ~{
    # TODO: should check if it's a legal move first. Boring...
    if(is.null(.x) || is.na(.x)) return(NULL)

    # translate unit_id to unit_name (probably here)
    if (!is.na(suppressWarnings(as.numeric(.x)))) {
      .x <- game %>%
        get_player_map(.p) %>%
        filter(player == .p, unit_id == .x) %>%
        pull(unit_name)
    }

    if (length(.x) > 1) message(glue("length(.x) > 1 :: {paste(.x, collapse = ', ')}"))
    if (!(.x %in% pull(get_player_map(game, .p), unit_name))) {
      warning(glue("{.x} is not a unit in {.p}'s army"))
      return(NULL)
    }

    # edit player map
    game$map_df %>%
      filter(.data$unit_name == .x) %>%
      mutate(
        loc = .l,
        action = .a
      )
  })

  game$map_df <- dplyr::bind_rows(
    new_moves,
    game$map_df %>% filter(!(.data$unit_name %in% new_moves$unit_name))
  ) %>%
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
    select(player, loc, unit_id, unit_type, action, unit_name)

}
