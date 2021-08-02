#' Modify the action of a unit or group of units
#' @param game The game to modify the unit(s) in
#' @param player The player who owns the unit(s)
#' @param .u Either a character vector of unit names to modify or a scalar of a
#'   map loc, in which case all units in that loc will be modified.
#' @param .a Action to assign to units
#' @param .l Location to move units to (or same as where they are if not moving)
#' @importFrom purrr walk
#' @export
modify_unit <- function(game, player, .u, .a, .l) {
  # check if a loc was passed
  if ((length(.u) == 1) && (.u %in% names(MAP))) {
    .loc_u <- read_player_map(game, player) %>%
      filter(.data$loc == .u) %>%
      pull(unit_name)

    if (length(.loc_u) == 0) {
      warning(glue("{player} has no units in {.u}"))
      return(invisible(NULL))
    } else {
      .u <- .loc_u
    }
  }


  walk(.u, ~{
    # TODO: should check if it's a legal move first. Boring...
    if(is.null(.x) || is.na(.x)) return(NULL)
    .pm <- read_player_map(game, player)

    # TODO: add translating unit_id to .u (probably here)

    if (!(.x %in% .pm$unit_name)) {
      warning(glue("{.x} is not a unit in {player}'s army"))
      return(NULL)
    }
    ####

    # edit player map
    ## TODO: this is super inefficient to read/write the player map each time. Should fix that.
    .pm <- .pm %>%
      mutate(
        loc = ifelse(unit_name == .x, .l, loc),
        action = ifelse(unit_name == .x, .a, action)
      )
    write_player_map(game, player, .pm)
  })

}

#' Kill a unit
#' @importFrom purrr walk
#' @export
kill_unit <- function(game, player, .u) {
  walk(.u, ~ modify_unit(game, player, .x, NA_character_, NA_character_))
}


#' Print the calls players make to move units
#' @importFrom purrr pwalk
#' @export
modify_unit_calls <- function(game_df, .p = NULL) {
  check_player_name(game_df, .p)

  if (!is.null(.p)) {
    game_df <- filter(game_df, .data$player == .p)
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
