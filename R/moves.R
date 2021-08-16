
#' Import moves from googlesheet
#' @export
moves_from_gsheet <- function(.p, .t, ss, sheet) {
  df <- googlesheets4::read_sheet(
    ss = ss,
    sheet = sheet,
    .name_repair = ~make.names(., unique = T),
  )

  .t <- as.character(.t)

  df %>%
    select(
      Unit.ID,
      (starts_with("Turn") &
         (ends_with(glue(".{.t}")) | ends_with(glue(".{.t}.1")))
       )
    ) %>%
    mutate(
      across(starts_with("Turn"), ~str_replace_all(.x, '[\\\\/\\"]', '')),
      player = .p
    ) %>%
    pwalk(print_modify_unit_eric_gsheet_2col)


}


print_modify_unit_eric_gsheet_2col <- function(...) {
  .row <- list(...)
  cat(glue("modify_unit('{.row[[4]]}', '{.row[[1]]}', '{.row[[2]]}', '{.row[[3]]}') %>%\n\n"))
}
