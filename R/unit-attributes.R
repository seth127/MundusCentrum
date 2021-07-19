unit_file_path <- system.file("extdata", "unit_attributes.csv", package = "MundusCentrum")
UA <- read_csv(
  unit_file_path,
  col_types = "ccilll"
)

if (length(UA$unit_type) != length(unique(UA$unit_type))) {
  abort(glue("Failed to load Unit Attributes. Duplicate entries in `unit_type` column of {unit_file_path}"))
}
