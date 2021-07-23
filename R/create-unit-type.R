#' Create unit type
#' @export
create_unit_type <- function(unit_type, ...) {
  assert_string(unit_type)
  .u <- list("unit_type" = sanitize_name(unit_type))
  .keys <- c(...)
  assert_character(.keys, null.ok = TRUE)
  for (.k in .keys) {
    .u[[.k]] <- TRUE
  }
  data.frame(.u)
}
