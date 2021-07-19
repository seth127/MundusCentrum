FO <- tibble::tibble(
  force_org = c("troop", "fast", "elite", "heavy", "transport", "flyer", "hq"),
  movement = c(1, 2, 1, 1, 1, 3.5, 1),
  control = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
  soar = c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE)
)

if (length(FO$force_org) != length(unique(FO$force_org))) {
  abort(glue("Failed to load Force Org Slots. Duplicate entries in `force_org` column of FO tibble"))
}

usethis::use_data(FO, overwrite = TRUE)
