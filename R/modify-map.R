#' @export
add_bridge <- function(game, .l1, .l2) {
  if (!(.l2 %in% game$map[[.l1]][["rivers"]])) abort(glue("Cannot build bridge because no river connects {.l1} and {.l2}"), "bridge_error")
  game$map[[.l1]][["bridges"]] <- c(game$map[[.l1]][["bridges"]], .l2)
  game$map[[.l2]][["bridges"]] <- c(game$map[[.l2]][["bridges"]], .l1)
  return(game)
}
