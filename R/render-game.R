#' Render the Rmd files for a game
#'
#' Takes an `.Rmd` template and a `.json` as input and renders
#' the markdown(s)
#' @export
render_game <- function(game_path, players = FALSE, html = FALSE) {
  game_name <- basename(game_path)
  rmd_template <- file.path(game_path, paste0(game_name, ".Rmd"))
  json_input <- file.path(game_path, paste0(game_name, ".json"))
  checkmate::assert_file_exists(rmd_template)
  checkmate::assert_file_exists(json_input)

  template_string <- readr::read_lines(rmd_template)

  to_render <- if (isTRUE(players)) {
    .pj <- jsonlite::fromJSON(json_input, simplifyVector = FALSE)$players
    c("GLOBAL", purrr::map_chr(.pj, ~ sanitize_name(.x[["name"]])))
  } else {
    "GLOBAL"
  }
  walk(to_render, ~ {
    data <- list(PLAYER = .x)

    player_hash <- digest::digest(paste0(game_name, .x), algo = "md5")

    #?#other_players <- str_subset(to_render, glue("(GLOBAL|{.x})"), negate = TRUE)

    #
    text <- template_string

    # trying to add back in the player's moves, but haven't gotten there yet...


    # .x_moves <- template_string %>%
    #   str_detect(paste0("(kill|modify)_unit.+", .x))
    # .x_moves_string <- template_string[.x_moves]
####


    if (.x == "GLOBAL") {
      # turn on code rendering for GLOBAL only
      text <- text %>%
        str_replace(stringr::fixed("echo = FALSE"), "echo = TRUE")
    } else {
      # trying to add back in the player's moves
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
  })

  if (isTRUE(html)) {
    walk(to_render, ~ {
      player_hash <- digest::digest(paste0(game_name, .x), algo = "md5")
      rmd_file <- file.path(game_path, paste0(player_hash, ".Rmd"))
      message(glue("  Rendering html from {rmd_file}..."))
      rmarkdown::render(
        rmd_file,
        output_format = "html_document",
        output_dir = game_path,
        quiet = TRUE
      )
    })
    message("All done rendering.")
  }
}

#' Copy game HTML files to a new dir (for publishing and hosting)
#' @export
publish_game_html <- function(game_dir, dest_dir) {
  html_files <- fs::dir_ls(game_dir, glob = "*.html")
  dest_dir <- file.path(dest_dir, basename(game_dir))
  if (!fs::dir_exists(dest_dir)) fs::dir_create(dest_dir)

  fs::file_copy(html_files, dest_dir)
}
