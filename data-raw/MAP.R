MAP <- list(
  A1 = list(
    name = "Forlinden",
    borders = c("A4"),
    mountains = c("A2"),
    x_ = 0.041,
    y_ = 0.82
  ),
  A2 = list(
    name = "Lune Valley",
    borders = c("A4", "A3", "B2"),
    rivers = c("A5"),
    bridges = c("A5"),
    mountains = c("A1"),
    x_ = 0.16,
    y_ = 0.815
  ),
  A3 = list(
    name = "Evendim Hills",
    borders = c("A2", "A5", "B2"),
    x_ = 0.26,
    y_ = 0.845
  ),
  A4 = list(
    name = "North Mithlond",
    borders = c("A1", "A2"),
    rivers = c("A5", "A6"),
    power = TRUE,
    x_ = 0.13,
    y_ = 0.785
  ),
  A5 = list(
    name = "Tower Hills",
    borders = c("A3", "A6", "A7"),
    rivers = c("A2", "B5", "B7"),
    x_ = 0.196,
    y_ = 0.765
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
    bridges = c("B9"),
    mountains = c("A8"),
    power = TRUE,
    x_ = 0.22,
    y_ = 0.66
  ),
  A8 = list(
    name = "Harlindon",
    borders = c("A6"),
    rivers = c("E1"),
    mountains = c("A5", "A7"),
    power = TRUE,
    x_ = 0.09,
    y_ = 0.645
  ),
  B1 = list(
    name = "Forodwaith",
    borders = c("B2", "B3", "B4", "D1", "D2"),
    mountains = c("C2"),
    power = TRUE,
    x_ = 0.5,
    y_ = 0.965
  ),
  B2 = list(
    name = "Borderlands",
    borders = c("A2", "A3", "B1", "B3", "B5", "B7", "B8"),
    rivers = c("B6"),
    # x_ = 0.33,
    # y_ = 0.87
    x_ = 0.375,
    y_ = 0.825
  ),
  B3 = list(
    name = "Angmar",
    borders = c("B1", "B2"),
    mountains = c("B4", "B6", "C1"),
    x_ = 0.425,
    y_ = 0.85
  ),
  B4 = list(
    name = "Eastern Angmar",
    borders = c("B1", "C1"),
    mountains = c("B3", "C2"),
    x_ = 0.55,
    y_ = 0.915
  ),
  B5 = list(
    name = "North Downs",
    borders = c("B2", "B7"),
    rivers = c("A5"),
    x_ = 0.34,
    y_ = 0.795
  ),
  B6 = list(
    name = "Rhudaur",
    borders = c("C1"),
    rivers = c("B2", "B8", "B11", "C3", "E2"),
    bridges = "E2",
    mountains = c("B3", "C3"),
    x_ = 0.505,
    y_ = 0.76
  ),
  B7 = list(
    name = "Fornost",
    borders = c("B2", "B5", "B8", "B9", "B10"),
    rivers = c("A5"),
    power = TRUE,
    x_ = 0.34,
    y_ = 0.745
  ),
  B8 = list(
    name = "Weather Hills",
    borders = c("B2", "B7", "B10", "B11"),
    rivers = c("B6"),
    bridges = c("B6"),
    power = TRUE,
    x_ = 0.38,
    y_ = 0.72
  ),
  B9 = list(
    name = "Buckland",
    borders = c("B7", "B10", "B11"),
    rivers = c("A7"),
    x_ = 0.29,
    y_ = 0.68
  ),
  B10 = list(
    name = "Old Forest",
    borders = c("B7", "B8", "B9", "B11"),
    x_ = 0.35,
    y_ = 0.68
  ),
  B11 = list(
    name = "South Downs",
    borders = c("B8", "B9", "B10", "E1"),
    rivers = c("A7", "B6", "E2", "E3"),
    x_ = 0.34,
    y_ = 0.615
  ),
  C1 = list(
    name = "Carrock",
    borders = c("B4", "B6", "C2"),
    rivers = c("C3"),
    bridges = c("C3"),
    mountains = c("B3"),
    x_ = 0.585,
    y_ = 0.82
  ),
  C2 = list(
    name = "North Mirkwood",
    borders = c("C1"),
    rivers = c("C4", "D3"),
    bridges = c("C4", "D3"),
    mountains = c("B1", "D1"),
    power = TRUE,
    x_ = 0.69,
    y_ = 0.79
  ),
  C3 = list(
    name = "Anduin Valley",
    borders = c("C4", "C5", "F7"),
    rivers = c("B6", "C1", "F2", "F3"),
    bridges = c("C1", "F2"),
    mountains = c("B6", "E2"),
    x_ = 0.61,
    y_ = 0.65
  ),
  C4 = list(
    name = "Eastern Mirkwood",
    borders = c("C3", "C5", "F5"),
    rivers = c("C2", "D3"),
    x_ = 0.705,
    y_ = 0.65
  ),
  C5 = list(
    name = "South Mirkwood",
    borders = c("C3", "C4", "F5", "F7"),
    x_ = 0.7,
    y_ = 0.595
  ),
  D1 = list(
    name = "Weathered Heath",
    borders = c("B1", "D2", "D3"),
    mountains = c("C2", "D4"),
    x_ = 0.81,
    y_ = 0.92
  ),
  D2 = list(
    name = "North Rhun",
    borders = c("B1", "D1", "D4"),
    mountains = c("D3"),
    x_ = 0.95,
    y_ = 0.93
  ),
  D3 = list(
    name = "Esgaroth",
    borders = c("D1"),
    rivers = c("C2", "C4", "D4"),
    mountains = c("B1", "D2"),
    power = TRUE,
    x_ = 0.8,
    y_ = 0.795
  ),
  D4 = list(
    name = "South Rhun",
    borders = c("D2"),
    rivers = c("D3", "F5"),
    bridges = c("F5"),
    mountains = c("D1"),
    x_ = 0.94,
    y_ = 0.755
  ),
  E1 = list(
    name = "Minhiriath",
    borders = c("B11"),
    rivers = c("A7", "A8", "E3", "E4"),
    bridges = c("E3", "E4"),
    power = TRUE,
    x_ = 0.240,
    y_ = 0.555
  ),
  E2 = list(
    name = "Eregion",
    borders = c("F1"),
    rivers = c("B6", "B11", "E3"),
    bridges = c("E3"),
    mountains = c("F2", "F3"),
    power = TRUE,
    x_ = 0.45,
    y_ = .59
  ),
  E3 = list(
    name = "Dunland",
    borders = c("E4"),
    rivers = c("B11", "E1", "E2"),
    mountains = c("E5", "F2", "F3"),
    x_ = 0.395,
    y_ = 0.52
  ),
  E4 = list(
    name = "Enedwaith",
    borders = c("E3"),
    rivers = c("E1", "E5", "E6", "E7"),
    bridges = c("E7"),
    x_ = 0.35,
    y_ = 0.435
  ),
  E5 = list(
    name = "Fangorn",
    borders = c("E7", "F3", "F4"),
    rivers = c("E4"),
    mountains = c("E3"),
    x_ = 0.495,
    y_ = 0.385
  ),
  E6 = list(
    name = "West Rohan",
    borders = c("E7", "G1"),
    rivers = c("E4"),
    mountains = c("G3", "G4"),
    x_ = 0.295,
    y_ = 0.30
  ),
  E7 = list(
    name = "Gap of Rohan",
    borders = c("E5", "E6", "G7"),
    rivers = c("E4", "F4", "F8"),
    bridges = c("F4"),
    mountains = c("G4", "G5", "G6"),
    power = TRUE,
    x_ = 0.5,
    y_ = 0.285
  ),
  F1 = list(
    name = "Moria",
    borders = c("E2", "F2"),
    x_ = 0.5,
    y_ = 0.61
  ),
  F2 = list(
    name = "Gladden Fields",
    borders = c("F1", "F3"),
    rivers = c("C3"),
    mountains = c("E3"),
    x_ = 0.565,
    y_ = 0.6
  ),
  F3 = list(
    name = "Lorien",
    borders = c("E5", "F2", "F4"),
    rivers = c("C3", "F7"),
    mountains = c("E2", "E3"),
    power = TRUE,
    x_ = 0.575,
    y_ = 0.52
  ),
  F4 = list(
    name = "The Wold",
    borders = c("E5", "F3"),
    rivers = c("E7", "F7", "F8"),
    bridges = c("F7"),
    power = TRUE,
    x_ = 0.59,
    y_ = 0.43
  ),
  F5 = list(
    name = "Brown Lands",
    borders = c("C4", "C5", "F6", "F7", "F8"),
    rivers = c("D3", "D4"),
    mountains = c("H2", "H3"),
    power = TRUE,
    x_ = 0.85,
    y_ = 0.48
  ),
  F6 = list(
    name = "Rhun Hills",
    borders = c("F5"),
    x_ = 0.95,
    y_ = 0.4
  ),
  F7 = list(
    name = "Emen Muil",
    borders = c("C3", "C5", "F5", "F8"),
    rivers = c("F3", "F4"),
    x_ = 0.685,
    y_ = 0.41
  ),
  F8 = list(
    name = "Dead Marshes",
    borders = c("F5", "F7", "G8", "H1"),
    rivers = c("E7", "F4"),
    mountains = c("H2", "H3"),
    power = TRUE,
    x_ = 0.73,
    y_ = 0.31
  ),
  G1 = list(
    name = "Druwaith Iaur",
    borders = c("E6", "G3"),
    mountains = c("G2", "G4"),
    x_ = 0.18,
    y_ = 0.225
  ),
  G2 = list(
    name = "Andrast",
    borders = c("G3"),
    mountains = c("G1"),
    x_ = 0.175,
    y_ = 0.175
  ),
  G3 = list(
    name = "Anfalas",
    borders = c("G1", "G2", "G4"),
    mountains = c("E6"),
    x_ = 0.265,
    y_ = 0.19
  ),
  G4 = list(
    name = "Vale of Erech",
    borders = c("G3", "G5"),
    mountains = c("E6", "E7", "G1"),
    power = TRUE,
    x_ = 0.330,
    y_ = 0.205
  ),
  G5 = list(
    name = "Lamedon",
    borders = c("G4", "G6", "G9"),
    mountains = c("E7", "G4"),
    x_ = 0.395,
    y_ = 0.21
  ),
  G6 = list(
    name = "Lebennin",
    borders = c("G5", "G7", "G9"),
    rivers = c("G8"),
    mountains = c("E7"),
    power = TRUE,
    x_ = 0.48,
    y_ = 0.16
  ),
  G7 = list(
    name = "Minas Tirith",
    borders = c("E7", "G5"),
    rivers = c("G8"),
    bridges = c("G8"),
    x_ = 0.54,
    y_ = 0.195
  ),
  G8 = list(
    name = "Ithilien",
    borders = c("F8", "G10", "H4"),
    rivers = c("G6", "G7"),
    mountains = c("H1", "H3"),
    power = TRUE,
    x_ = 0.605,
    y_ = 0.15
  ),
  G9 = list(
    name = "Belfalas",
    borders = c("G5", "G6"),
    power = TRUE,
    x_ = 0.43,
    y_ = 0.11
  ),
  G10 = list(
    name = "South Ithilien",
    borders = c("G8", "I1"),
    mountains = c("H4", "H5", "H6"),
    x_ = 0.585,
    y_ = 0.1
  ),
  H1 = list(
    name = "Udun Vale",
    borders = c("F8", "H3"),
    mountains = c("G8", "H2"),
    x_ = 0.745,
    y_ = 0.2
  ),
  H2 = list(
    name = "Barad Dur",
    borders = c("H3", "H5"),
    mountains = c("F5", "F8", "H1"),
    x_ = 0.92,
    y_ = 0.21
  ),
  H3 = list(
    name = "Mount Doom",
    borders = c("H1", "H2", "H5"),
    mountains = c("F5", "F8", "G8"),
    power = TRUE,
    x_ = 0.8,
    y_ = 0.175
  ),
  H4 = list(
    name = "Minas Morgul",
    borders = c("G8", "H5"),
    mountains = c("G10", "H3", "H6"),
    x_ = 0.695,
    y_ = 0.14
  ),
  H5 = list(
    name = "Gorgoroth",
    borders = c("H2", "H3", "H4", "H6"),
    mountains = c("G10", "I5"),
    x_ = 0.92,
    y_ = 0.135
  ),
  H6 = list(
    name = "Nurn",
    borders = c("H5"),
    mountains = c("G10", "H4", "I1", "I3", "I4", "I5"),
    x_ = 0.775,
    y_ = 0.09
  ),
  I1 = list(
    name = "Harondor",
    borders = c("G10"),
    rivers = c("I2", "I3"),
    bridges = c("I3"),
    mountains = c("H6"),
    x_ = 0.52,
    y_ = 0.05
  ),
  I2 = list(
    name = "Umbar",
    borders = c("I3"),
    rivers = c("I1"),
    x_ = 0.425,
    y_ = 0.015
  ),
  I3 = list(
    name = "Harad",
    borders = c("I2", "I4"),
    rivers = c("I1"),
    mountains = c("H6"),
    x_ = 0.645,
    y_ = 0.03
  ),
  I4 = list(
    name = "Near Harad",
    borders = c("I3", "I4"),
    mountains = c("H6"),
    x_ = 0.81,
    y_ = 0.035
  ),
  I5 = list(
    name = "Khand",
    borders = c("I4"),
    mountains = c("H5", "H6"),
    power = TRUE,
    x_ = 0.9,
    y_ = 0.05
  )
)

usethis::use_data(MAP, overwrite = TRUE)
