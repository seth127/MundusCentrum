#' Print method for game object
#' @importFrom cli cli_h1 cat_bullet
#' @export
print.MC_game <- function(x, .p = NULL) {
  if (isTRUE(getOption('knitr.in.progress'))) {
    cat(glue("### {x$name} ---------------------------\n\n"))
    cat("An epic throwdown, featuring:\n\n")
    purrr::walk(get_player_names(x), ~{
      cat(glue("* **{.x}**\n\n"))
    })
    cat("\n")
    #print_map_df(x, .p = .p, .n = 3) # not printing map_df in Rmd
  } else {
    cli::cli_h1(x$name)
    cat("An epic throwdown, featuring:\n")
    cli::cat_bullet(get_player_names(x))
    cat("\n")
    print(print_map_df(x, .p = .p, .n = 3)) # I'm kinda annoyed I have to put print() here, but it doesn't seem to work without it
  }
}
