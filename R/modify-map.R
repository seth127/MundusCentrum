#' @export
add_bridge <- function(game, .l1, .l2) {
  if (!(.l2 %in% game$map[[.l1]][["rivers"]])) abort(glue("Cannot build bridge because no river connects {.l1} and {.l2}"), "bridge_error")
  game$map[[.l1]][["bridges"]] <- c(game$map[[.l1]][["bridges"]], .l2)
  game$map[[.l2]][["bridges"]] <- c(game$map[[.l2]][["bridges"]], .l1)
  return(game)
}

#' Destroy a bridge
#' @export
destroy_bridge <- function(game, .l1, .l2) {
  game$map[[.l1]][["bridges"]] <- stringr::str_subset(game$map[[.l1]][["bridges"]], .l2, negate = TRUE)
  game$map[[.l2]][["bridges"]] <- stringr::str_subset(game$map[[.l2]][["bridges"]], .l1, negate = TRUE)
  return(game)
}


#' @export
add_trap <- function(game, .p, .l) {
  check_player_name(game, .p)
  checkmate::assert_string(.l)

  game$map_df <- game$map_df %>%
    bind_rows(data.frame(
      player = .p,
      loc = .l,
      unit_id = (game$map_df %>% filter(player == .p) %>% pull(unit_id) %>% max) + 1,
      unit_type = "trap",
      action = "sneak",
      unit_name = build_name("trap"),
      passing_through = FALSE
    ))
  return(game)
}

#' @export
destroy_trap <- function(game, .p, .l) {
  check_player_name(game, .p)
  checkmate::assert_string(.l)

  game$map_df <- game$map_df %>%
    filter(
      !(player == .p &
        unit_type == "trap" &
        loc == .l
      )
    )
  return(game)
}

#' @export
local_uprising <- function(game, .l) {
  checkmate::assert_string(.l)
  checkmate::assert_true(.l %in% names(game$map))
  game$map[[.l]][["control"]] <- NULL
  game
}
