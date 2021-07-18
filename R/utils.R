#' @importFrom jsonlite toJSON
#' @importFrom readr write_lines
#' @keywords internal
list_to_json <- function(.l, .f) {
  .l %>%
    toJSON(auto_unbox = TRUE, pretty = TRUE) %>%
    write_lines(.f)
}
