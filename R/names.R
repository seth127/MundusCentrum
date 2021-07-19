names_dir <- system.file("extdata", "name-files", package = "MundusCentrum")
used_names_file <- file.path(names_dir, "USED.txt")
names_files <- names_dir %>%
  fs::dir_ls() %>%
  str_subset("USED", negate = TRUE)

NAMES <- map(names_files, ~ read_lines(.x))
names_keys <- tools::file_path_sans_ext(basename(names_files))
names(NAMES) <- names_keys


#########
# NAME BUILDERS FOR ORGS

#' Build a name for a new unit
#'
#' @param force_org Specify a `force_org` slot for tailored name. If not passed,
#'   will choose at random.
#' @export
build_name <- function(force_org = "any") {
  assert_string(force_org)
  force_org_opts <- c("any", pull(FO, force_org))
  if (!(force_org) %in% force_org_opts) {
    abort(glue("Invalid `force_org` arg. Use one of: {paste(force_org_opts, collapse = ', ')}"))
  }

  pick <- switch(
    force_org,
    any = {
      sample_name(names(NAMES))
    },
    troop = {
      paste(sample_name("us_pop_first_2010s"), sample_name("us_pop_last_2010s"))
    },
    fast = {
      sample_name("rich_actors")
    },
    elite = {
      paste(sample_name("wu_adj"), sample_name("wu_noun"))
    },
    heavy = {
      sample_name(c("writers", "philosophers"))
    },
    transport = {
      paste(sample_name(c("rich_actors", "writers")), sample_name("us_pop_last_2010s"))
    },
    flyer = {
      sample_name("grammy_artists")
    },
    hq = {
      sample_name("grammy_producers")
    }
  )
  pick
}

#' @describeIn build_name Pass a name to this to get a Wu adjective appended.
#' @export
wu_epithet <- function(.n) {
  paste(
    sample(NAMES[["wu_adj"]], 1),
    .n
  )
}

#' @export
clear_used_names <- function() {
  write_lines("", used_names_file, sep = "")
}

########
# PRIVATE

#' @keywords internal
sample_name <- function(keys) {
  nominees <- unlist(map(keys, ~ NAMES[[.x]]))
  pick <- sample(nominees, 1)
  tries <- 1
  while(!check_used_names(pick)) {
    pick <- sample(nominees, 1)
    tries <- tries + 1
    if (tries > 10) {
      # if you've tried too long you get a wu name
      pick <- wu_epithet(pick)
    }
  }
  write_to_used_names(pick)
  pick
}

#' @keywords internal
check_used_names <- function(.n) {
  used <- read_lines(used_names_file)
  !(.n %in% used)
}

#' @keywords internal
write_to_used_names <- function(.n) {
  write_lines(.n, used_names_file, append = TRUE)
}

