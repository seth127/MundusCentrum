#' Move a unit
#' @importFrom purrr walk
#' @export
move_unit <- function(game, player, .u, .a, .l) {
  walk(.u, ~{
    # TODO: should check if it's a legal move first. Boring...
    .pm <- read_player_map(game, player) %>%
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
  walk(.u, ~{
    .pm <- read_player_map(game, player) %>%
      filter(unit_name != .x)
    write_player_map(game, player, .pm)
  })
}
