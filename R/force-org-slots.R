force_org_file_path <- system.file("extdata", "force_org_slots.csv", package = "MundusCentrum")
FO <- read_csv(
  force_org_file_path,
  col_types = "cnll"
)

if (length(FO$force_org) != length(unique(FO$force_org))) {
  abort(glue("Failed to load Force Org Slots. Duplicate entries in `force_org` column of {force_org_file_path}"))
}
