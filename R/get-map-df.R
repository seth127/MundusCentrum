#' Get the tibble of units and their loc on map
#' @export
get_map_df <- function(game, .p = NULL) {
  # get df of units we care about
  res <- if (!is.null(game$conflicts)) {
    filter(game$map_df, .data$loc %in% game$conflicts)
  } else {
    get_player_map(game, .p)
  }
  return(res)
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
