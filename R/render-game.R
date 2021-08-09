#' Render the Rmd files for a game
#'
#' Takes an `.Rmd` template and a `.json` as input and renders
#' the markdown(s).
#' **This is basically how you "play" the game.**
#' @export
render_game <- function(game_path, players = FALSE, html = FALSE) {
  game_name <- basename(game_path)
  rmd_template <- file.path(game_path, paste0(game_name, ".Rmd"))
  json_input <- file.path(game_path, paste0(game_name, ".json"))
  checkmate::assert_file_exists(rmd_template)
  checkmate::assert_file_exists(json_input)

  write_lines(glue('
!{game_name}.Rmd
!{game_name}.json
*.Rmd
*.html'),
    file.path(game_path, ".gitignore")
  )

  template_string <- readr::read_lines(rmd_template)
  .md5 <- digest::digest(template_string)

  to_render <- if (isTRUE(players)) {
    .pj <- jsonlite::fromJSON(json_input, simplifyVector = FALSE)$players
    c("GLOBAL", purrr::map_chr(.pj, ~ sanitize_name(.x[["name"]])))
  } else if (isFALSE(players)) {
    "GLOBAL"
  } else {
    to_render <- players
  }
  walk(to_render, ~ {
    data <- list(
      PLAYER = .x,
      RMD_MD5 = .md5
    )

    player_hash <- digest::digest(paste(game_name, .x), algo = "md5")
    message(glue("{paste(game_name, .x)} -- {player_hash}"))

    # build Rmd string
    text <- template_string

    if (.x == "GLOBAL") {
      # turn on code rendering for GLOBAL only
      text <- text %>%
        str_replace(stringr::fixed("echo = FALSE"), "echo = TRUE")
    } else {
      # add in the player's moves for printing only (because real code is echo = FALSE)
      moves <- text %>%
        str_detect("^### moves") %>%
        which() %>%
        c(length(text))

      for (.i in 1:(length(moves)-1)) {
        this_move <- text[moves[.i]:moves[.i+1]] %>%
          str_subset(paste0("(kill|modify)_unit.+", .x)) %>%
          str_replace_all(" ?\\%\\>\\% ?", "") %>%
          paste(collapse = "\n")

        text[moves[.i]] <- paste0("### moves\n\n```{r, eval = FALSE, echo = TRUE}\n", this_move, "\n```\n\n")
      }
    }

    text <- whisker::whisker.render(text, data)

    write_lines(text, file.path(game_path, paste0(player_hash, ".Rmd")))

    if (isTRUE(html)) {
      rmd_file <- file.path(game_path, paste0(player_hash, ".Rmd"))
      message(glue("  Rendering html from {rmd_file}..."))
      rmarkdown::render(
        rmd_file,
        output_format = "html_document",
        output_dir = game_path,
        quiet = TRUE
      )
    }
  })
  message("All done rendering.")
}

#' Copy game HTML files to a new dir (for publishing and hosting)
#' @export
publish_game_html <- function(game_dir, dest_dir, overwrite = FALSE) {
  html_files <- fs::dir_ls(game_dir, glob = "*.html")
  dest_dir <- file.path(dest_dir, basename(game_dir))
  if (isTRUE(overwrite) && fs::dir_exists(dest_dir)) fs::dir_delete(dest_dir)
  if (!fs::dir_exists(dest_dir)) fs::dir_create(dest_dir)

  fs::file_copy(html_files, dest_dir)
}
