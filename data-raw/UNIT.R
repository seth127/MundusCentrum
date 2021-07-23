empty <- data.frame(
  unit_type = character(),
  control = logical(),
  transport = logical(),
  fast = logical(),
  fly = logical(),
  soar = logical(),
  deep = logical(),
  sneak = logical()
)

########################################
# ADD UNITS TO THE BOTTOM OF THIS LIST

.l <- rlang::list2(
  empty,
  create_unit_type("lt_dan", "control"),
  create_unit_type("cptn_steve_hiller_usmc", "control", "fly"),
  create_unit_type("ricky_bobby", "fast"),
  create_unit_type("keyser_soze", "sneak"),
  create_unit_type("rambo"),
  create_unit_type("steve_zissou", "deep"),
  create_unit_type("mule", "transport"),
  create_unit_type("rocketman", "fly", "fast"),
  create_unit_type("maverick", "fly", "soar"),
  create_unit_type("led_zep", "transport", "soar"),

  # RIGHT HERE ^
)

########################################

UNIT <- .l %>%
  map_dfr(~dplyr::mutate_all(.,as.character)) %>%
  tibble::as_tibble(.name_repair = "universal")

usethis::use_data(UNIT, overwrite = TRUE)
