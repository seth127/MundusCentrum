
#' inputs unit(s) and returns legal actions
#' @export
input_unit <- function(game, .p, .u) {

  # will this break Shiny?
  if (!interactive()) abort("Cannot call input_unit() when NOT in interactive session", "input_moves_error")

  check_player_name(game, .p)

  # translate loc or unit_id to unit_name
  .u <- loc_to_unit(game, .p, .u)
  .u <- map_chr(.u, function(.ux) {
    if(is.null(.ux) || is.na(.ux)) return(NULL)
    unit_id_to_name(game, .p, .ux)
  })

  # get df of units we care about
  unit_df <- get_player_map(game, .p) %>%
    filter(unit_name %in% .u) %>%
    left_join(UNIT, by = "unit_type")

  if (length(unique(unit_df$loc)) > 1) {
    abort(paste(
      "Must pass all units in the same loc. Got",
      paste(unique(unit_df$loc), collapse = ", ")
    ), "input_moves_error")
  }

  actions <- c(
    "move",
    "defend",
    "reinforce"
  )

  if (any(unit_df$control))    actions <- c(actions, "control")
  if (any(unit_df$transport))  actions <- c(actions, "transport")
  if (all(unit_df$deep))       actions <- c(actions, "deep") # do we need this here?

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

  # GET INPUT FROM USER (will switch to something Shiny-ish?)
  ## need to figure out how we'll refactor this if we have to split it
  ## into two functions to get the shiny input in the middle (and serve actions...)
  pick <- actions[utils::menu(actions)]

  unit_df %>%
    mutate(action = pick)
}
