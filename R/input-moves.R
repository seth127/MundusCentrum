# 004B
# * big_grizz B4 bike squads
# * eric H6 has a full plane soaring

#' Input moves for one (group of) units.
#' @name input_moves
NULL

#' @describeIn input_moves Input player code to trigger move. Returns the name of the player.
#' @export
input_player_code <- function(game, player_code) {
  player_names <- get_player_names(game)
  # stop the cheaters
  if(player_code %in% player_names) {
    rlang::abort("Please specify player code, not player name", "input_moves_error")
  }

  # load the name
  winner <- names(which(game$players == player_code))
  if (length(winner) == 0) rlang::abort(glue("Invalid player code: {player_code}"), "input_moves_error")
  return(winner)
}

#' @describeIn input_moves Takes player and .u and returns legal actions.
#' @export
input_unit <- function(game, .p, .u) {

  # will this break Shiny?
  #if (!interactive()) abort("Cannot call input_unit() when NOT in interactive session", "input_moves_error")

  check_player_name(game, .p)

  # translate loc or unit_id to unit_name
  .u <- loc_to_unit(game, .p, .u)
  .u <- map_chr(.u, function(.ux) {
    if(is.null(.ux) || is.na(.ux)) return(NULL)
    unit_id_to_name(game, .p, .ux)
  })

  # get df of units we care about
  unit_df <- get_player_map(game, .p) %>%
    filter(
      .data$unit_name %in% .u,
      !.data$passing_through
    ) %>%
    left_join(UNIT, by = "unit_type")

  if (length(unique(unit_df$loc)) > 1) {
    abort(paste(
      "Must pass all units in the same loc. Got",
      paste(unique(unit_df$loc), collapse = ", ")
    ), "input_moves_error")
  }

  return(unit_df)
}


#' @describeIn input_moves Takes units (from `input_units()`) and adds the chosen action.
#'  Returns the `unit_df` with the chosen action filled in.
#' @param unit_df The tibble of units that's actin
#' @export
input_action <- function(unit_df, game, .test = NULL) {

  if (str_detect(game$turn, "A$")) {
    # moves
    actions <- c(
      "move",
      "defend",
      "reinforce"
    )

    if (any(unit_df$control))    actions <- c(actions, "control")
    if (any(unit_df$transport))  actions <- c(actions, "transport")

  } else if (str_detect(game$turn, "B$")) {
    # if dead, they can only respawn
    if (any(is.na(unit_df$loc))) {
      if (!all(is.na(unit_df$loc))) {
        abort(paste0(
          "Must pass either all dead units or no dead units.",
          "\nThe following are dead:  ",
          paste(unit_df$unit_name[is.na(unit_df$loc)], collapse = ", "),
          "\nThe following are alive: ",
          paste(unit_df$unit_name[!is.na(unit_df$loc)], collapse = ", ")
        ), "input_moves_error")
      }
      actions <- "respawn"
    }

    # retreats
    actions <- c(
      "retreat",
      "rout",
      "superrout"
    )

  } else {
    abort("Oops, we should never get to phase C if we code legal retreats right...", class = "dev_error")
  }

  ### TEST ###
  pick <- if (!is.null(.test)) {
    assert_string(.test)
    if (!(.test %in% actions)) abort(glue("{.test} not in {paste(actions, collapse = ', ')}"), "input_moves_test_error")
    .test
  } else {
    # GET INPUT FROM USER (will switch to something Shiny-ish?)
    ## need to figure out how we'll refactor this if we have to split it
    ## into two functions to get the shiny input in the middle (and serve actions...)
    actions[utils::menu(actions)]
  }

  return(list(
    df = mutate(unit_df, action = pick),
    actions = actions
  ))
}



#' @describeIn input_moves Takes units with action (from `input_action()`) and
#'   adds the loc(s), and returns code-gen strings to write to
#'   [game_turnfile_path()]
#' @param unit_df The tibble of units that's acting
#' @export
input_loc <- function(unit_df, game, .test = NULL) {

  # will this break Shiny?
  if (!interactive()) abort("Cannot call input_action() when NOT in interactive session", "input_moves_error")

  .a <- unique(unit_df$action) # could just to assert_string, but this is better debugging
  if (length(.a) > 1) {
    abort(paste(
      "Must pass all units in the same action. Got",
      paste(unique(unit_df$action), collapse = ", ")
    ), "input_moves_error")
  }

  movers_df <- if(.a == "transport") {
    filter(unit_df, transport)
  } else {
    unit_df
  }

  num_moves <- if (all(movers_df$soar)) {
    3
  } else if (all(movers_df$fast) | all(movers_df$transport)) {
    2
  } else {
    1
  }

  ### TEST ###
  assert_character(.test, null.ok = TRUE)
  if (!is.null(.test) && length(.test) > num_moves) {
    abort(glue("length(.test) {length(.test)} > num_moves {num_moves}"), "input_moves_test_error")
  }
  test_opts <- list()
  ###

  loc_picks <- c()
  current_loc <- orig_loc <- unique(movers_df$loc)

  if (.a %in% c("control", "defend")) {
    loc_picks <- current_loc
  } else {
    for (.i in 1:num_moves) {
      checkmate::assert_string(current_loc) # should be no way to fail this, but just in case

      # build move options
      loc_opts <- unlist(game$map[[current_loc]][c("borders", "bridges")])

      if (all(movers_df$fly) | all(movers_df$soar)) {
        loc_opts <- c(
          loc_opts,
          unlist(game$map[[current_loc]][c("rivers")])
        )
      }


      #' Soaring Rules
      #' * you can only change altitude once per turn
      #' * when you land, you're done

      if (all(movers_df$soar)) {

        loc_opts <- c(
          loc_opts,
          unlist(game$map[[current_loc]][["sky"]])
        )

        if (!has_changed_altitude(c(orig_loc, loc_picks))) {
          loc_opts <- c(
            loc_opts,
            altitude_change_opts(current_loc)
          )
        }

      }

      loc_opts <- unique(loc_opts)

      ### TEST ###
      test_opts[[length(test_opts)+1]] <- loc_opts
      if (!is.null(.test)) {
        if (.i > length(.test)) break
        new_loc <- .test[.i]
        if (!(new_loc %in% loc_opts)) abort(glue("{new_loc} not in {paste(loc_opts, collapse = ', ')}"), "input_moves_test_error")
      } else {
        # GET INPUT FROM USER (will switch to something Shiny-ish?)
        ## need to figure out how we'll refactor this if we have to split it
        ## into two functions to get the shiny input in the middle (and serve actions...)
        new_loc <- loc_opts[utils::menu(loc_opts)]
        if (new_loc == "") break
      }

      current_loc <- new_loc
      loc_picks <- c(loc_picks, new_loc)

      # if you're on the ground after your 2nd move then you're done
      if (.i == 2 && !all_the_way_up(current_loc)) break
    }
  }

  player <- unique(unit_df$player)
  unit_ids <- paste(unit_df$unit_id, collapse = ', ')
  action <- unique(unit_df$action)
  loc_picks <- paste0("'", paste0(loc_picks, collapse = "', '"), "'")
  res <- glue("modify_unit('{player}', c({unit_ids}), '{action}', c({loc_picks})) %>%")

  return(list(
    res = res,
    locations = test_opts
  ))
}

#' @keywords internal
has_changed_altitude <- function(moves) {
  any(all_the_way_up(moves)) &&
    any(!all_the_way_up(moves))
}

#' if soaring can land, if grounded can take off
#' @keywords internal
altitude_change_opts <- function(.l) {
  ifelse(
    all_the_way_up(.l),
    str_replace(.l, "S$", ""),
    paste0(.l, "S")
  )
}

all_the_way_up <- function(.l) {
  str_detect(.l, "S$")
}

########################
