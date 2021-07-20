MAP <- list(
  A1 = list(
    name = "Forlinden",
    borders = c("A4"),
    x_ = 0.041,
    y_ = 0.82
  ),
  A2 = list(
    name = "Lune Valley",
    borders = c("A4", "A3", "B2"),
    rivers = c("A5"),
    x_ = 0.16,
    y_ = 0.815
  ),
  A3 = list(
    name = "Evendim Hills",
    borders = c("A2", "A5", "D2"),
    x_ = 0.26,
    y_ = 0.845
  ),
  A4 = list(
    name = "North Mithlond",
    borders = c("A1", "A2"),
    rivers = c("A5", "A6"),
    seaports = c("E1", "B1"),
    power = TRUE,
    x_ = 0.13,
    y_ = 0.785
  ),
  A5 = list(
    name = "Tower Hills",
    borders = c("A3", "A6", "A7"),
    rivers = c("A2", "B5", "B7"),
    x_ = 0.215,
    y_ = 0.74
  ),
  A6 = list(
    name = "South Mithlond",
    borders = c("A5", "A8"),
    rivers = c("A4"),
    x_ = 0.14,
    y_ = 0.71
  ),
  A7 = list(
    name = "The Shire",
    borders = c("A5"),
    rivers = c("B9", "B11", "E1"),
    power = TRUE,
    spaceport = TRUE,
    x_ = 0.22,
    y_ = 0.66
  ),
  A8 = list(
    name = "Marlindon",
    borders = c("A6"),
    rivers = c("E1"),
    power = TRUE,
    x_ = 0.09,
    y_ = 0.645
  ),
  B1 = list(
    name = "Forodwaith",
    borders = c("B2", "B3", "B4", "D1", "D2"),
    seaports = c("A4"),
    power = TRUE,
    x_ = 0.5,
    y_ = 0.965
  ),
  B2 = list(
    x_ = 0.33,
    y_ = 0.87
  ),
  B3 = list(
    x_ = 0.425,
    y_ = 0.85
  ),
  B4 = list(
    x_ = 0.55,
    y_ = 0.915
  ),
  B5 = list(
    x_ = 0.34,
    y_ = 0.795
  ),
  B6 = list(
    x_ = 0.505,
    y_ = 0.76
  ),
  B7 = list(
    x_ = 0.34,
    y_ = 0.745
  ),
  B8 = list(
    x_ = 0.38,
    y_ = 0.72
  ),
  B9 = list(
    x_ = 0.29,
    y_ = 0.68
  ),
  B10 = list(
    x_ = 0.35,
    y_ = 0.68
  ),
  B11 = list(
    x_ = 0.39,
    y_ = 0.65
  ),
  C1 = list(
    x_ = 0.585,
    y_ = 0.82
  ),
  C2 = list(
    x_ = 0.69,
    y_ = 0.79
  ),
  C3 = list(
    x_ = 0.61,
    y_ = 0.65
  ),
  C4 = list(
    x_ = 0.705,
    y_ = 0.65
  ),
  C5 = list(
    x_ = 0.7,
    y_ = 0.595
  ),
  D1 = list(
    x_ = 0.81,
    y_ = 0.92
  ),
  D2 = list(
    x_ = 0.95,
    y_ = 0.93
  ),
  D3 = list(
    x_ = 0.8,
    y_ = 0.795
  ),
  D4 = list(
    x_ = 0.94,
    y_ = 0.755
  ),
  E2 = list(
    x_ = 0.44,
    y_ = .59
  ),
  E5 = list(
    x_ = 0.495,
    y_ = 0.385
  ),
  E7 = list(
    x_ = 0.5,
    y_ = 0.285
  ),
  F1 = list(
    x_ = 0.5,
    y_ = 0.61
  ),
  F2 = list(
    x_ = 0.565,
    y_ = 0.6
  ),
  F3 = list(
    x_ = 0.575,
    y_ = 0.52
  ),
  F4 = list(
    x_ = 0.59,
    y_ = 0.43
  ),
  F5 = list(
    x_ = 0.85,
    y_ = 0.48
  ),
  F6 = list(
    x_ = 0.95,
    y_ = 0.4
  ),
  F7 = list(
    x_ = 0.685,
    y_ = 0.41
  ),
  F8 = list(
    x_ = 0.73,
    y_ = 0.31
  )
)

usethis::use_data(MAP, overwrite = TRUE)
