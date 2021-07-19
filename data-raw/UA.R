UA <- tibble::tibble(
  unit_type = c("lt_dan", "cptn_steve_hiller_usmc", "ricky_bobby", "rocketman", "steve_zissou", "keyser_soze", "rambo","charlie_kaufman", "mule", "maverick", "boss"),
  force_org = c("troop", "troop", "fast", "elite", "elite", "elite", "heavy", "heavy", "transport", "flyer", "hq"),
  points = c(25L, 50L, 35L, 100L, 75L, 85L, 80L, 85L, 55L, 60L, 125L),
  sneaky = c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),
  deep = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE),
  strafe = c(FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE)
)

if (length(UA$unit_type) != length(unique(UA$unit_type))) {
  abort(glue("Failed to load Unit Attributes. Duplicate entries in `unit_type` column of UA tibble"))
}

usethis::use_data(UA, overwrite = TRUE)
