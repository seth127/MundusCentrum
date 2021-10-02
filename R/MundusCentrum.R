#' @title Mundus Centrum
#'
#' An open source long form strategy, tactics, and logistics war game, heavily
#' inspired by Warhammer 40k and the blog of Brett Devereux.
#' @importFrom checkmate assert_string assert_list assert_numeric assert_character
#' @importFrom glue glue
#' @importFrom rlang abort warn inform
#' @importFrom purrr map map_chr map_lgl walk
#' @importFrom dplyr select filter mutate everything pull
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#' @importFrom fs file_exists dir_exists file_create dir_create file_delete dir_delete
#' @importFrom stringr str_subset str_detect str_replace str_replace_all
#' @importFrom readr read_lines write_lines read_csv write_csv
#' @importFrom digest digest
#' @importFrom here here
#' @name MundusCentrum
NULL
