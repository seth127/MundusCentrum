#' Print method for game object
#' @importFrom cli cli_h1 cat_bullet
#' @export
print.MC_game <- function(x, .p = NULL) {
  if (isTRUE(getOption('knitr.in.progress'))) {
    cat(glue("### {game$name} ---------------------------\n\n"))
    cat("An epic throwdown, featuring:\n\n")
    purrr::walk(get_player_names(game), ~{
      cat(glue("* **{.x}**\n\n"))
    })
    cat("\n")
    print_map_df(x, .p = .p, .n = 3)
  } else {
    cli::cli_h1(game$name)
    cat("An epic throwdown, featuring:\n")
    cli::cat_bullet(get_player_names(game))
    cat("\n")
    print(print_map_df(x, .p = .p, .n = 3)) # I'm kinda annoyed I have to put print() here, but it doesn't seem to work without it
  }
}
