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
  create_unit_type("Trazyn The Infinite"),
  create_unit_type("Illuminor Szeras"),
  create_unit_type("Technomancer", "deep"),
  create_unit_type("Lychgaurd"),
  create_unit_type("Skorpekh Destroyers"),
  create_unit_type("Canoptek Plasmacyte", "fly"),
  create_unit_type("Immortals", "control"),
  create_unit_type("Canoptek Spyders", "fly"),
  create_unit_type("Cryptothralls"),
  create_unit_type("Canoptek Scarab Swarms", "fast", "fly"),
  create_unit_type("Canoptek Wraiths", "fast"),
  create_unit_type("Deathmarks", "deep", "sneak"),
  create_unit_type("Night Scythe", "transport", "fly", "soar"),
  create_unit_type("Overlord"),
  create_unit_type("Royal Warden"),
  create_unit_type("Necron Warriors", "control"),
  create_unit_type("Ravenwing Talonmaster", "fast", "fly"),
  create_unit_type("Deathwing Captain", "deep"),
  create_unit_type("Techmarine"),
  create_unit_type("Phobos Librarian", "sneak"),
  create_unit_type("Tactical Squad", "control"),
  create_unit_type("Infiltrators", "control", "sneak"),
  create_unit_type("Ravenwing Bike Squad", "fast"),
  create_unit_type("Ravenwing Attack Bike", "fast"),
  create_unit_type("Dreadnought"),
  create_unit_type("Redemptor Dreadnought"),
  create_unit_type("Invictor Tactical Warsuit", "sneak"),
  create_unit_type("Ravenwing Apothecary", "fast"),
  create_unit_type("Deathwing Terminators", "deep"),
  create_unit_type("Deathwing Knights", "deep"),
  create_unit_type("Vindicare Assassin", "sneak"),
  create_unit_type("Eliminators", "sneak"),
  create_unit_type("Eradicators"),
  create_unit_type("Storm Raven", "transport", "fast", "fly", "soar"),
  create_unit_type("Rhino", "transport", "fast"),
  create_unit_type("Flying Hive Tryant", "fast", "fly", "soar"),
  create_unit_type("Broodlord", "sneak"),
  create_unit_type("Genestealers", "control", "sneak"),
  create_unit_type("Tyranid Warriors", "control"),
  create_unit_type("Hive Crone", "fast", "fly", "soar"),
  create_unit_type("Termagants", "control"),
  create_unit_type("Hormagaunts", "control"),
  create_unit_type("Hive Guard"),
  create_unit_type("Biovores"),
  create_unit_type("Ripper Swarms", "control", "deep"),
  create_unit_type("Zoathropes", "fly"),
  create_unit_type("Lictor", "deep", "sneak"),
  create_unit_type("Raveners", "fast", "deep"),

  # RIGHT HERE ^
)

########################################

UNIT <- .l %>%
  dplyr::bind_rows() %>%
  replace(is.na(.), FALSE)

dup_units <- duplicated(UNIT$unit_type)
if (any(dup_units)) {
  message("DUPLICATED ROWS!!!\n")
  print(filter(UNIT, dup_units))
  abort("Duplicated rows in UNIT")
}

usethis::use_data(UNIT, overwrite = TRUE)
