#' Print the calls to add to data-raw/UNIT.R
#' @export
add_units_from_csv <- function(path) {
  raw_df <- read_csv(path) %>%
    mutate(unit_type = stringr::str_replace(.data$unit_type, " ?[0-9]+[A-Za-z]*$", "")) %>%
    filter(!duplicated(.data$unit_type))

  purrr::pwalk(raw_df, print_unit_call)
}

#' @keywords internal
print_unit_call <- function(...) {
  .row <- list(...)

  unit_type <- .row$unit_type

  row_keywords <- UNIT_KEYWORDS[which(as.logical(.row[UNIT_KEYWORDS]))]
  if (length(row_keywords) > 0) {
    keyword_string <- paste(row_keywords, collapse = '", "')
    keyword_string <- glue(', "{keyword_string}"')
  } else {
    keyword_string <- ""
  }

  print(glue('create_unit_type("{.row$unit_type}"{keyword_string}),'))
}


