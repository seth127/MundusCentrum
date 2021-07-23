names_dir <- system.file("extdata", "name-files", package = "MundusCentrum")
used_names_file <- file.path(names_dir, "USED.txt")
names_files <- names_dir %>%
  fs::dir_ls() %>%
  str_subset("USED", negate = TRUE)

NAMES <- map(names_files, ~ read_lines(.x))
names_keys <- tools::file_path_sans_ext(basename(names_files))
names(NAMES) <- names_keys

#' Build a name for a new unit
#'
#' @param .u Specify a `unit_type` for tailored name. If not passed,
#'   will choose at random.
#' @export
build_name <- function(.u = NULL) {
  assert_string(.u, null.ok = TRUE)
  .u_opts <- UNIT$unit_type
  if (is.null(.u)) .u <- sample(.u_opts, 1L)
  if (!(.u) %in% .u_opts) {
    abort(glue("Invalid `.u` arg: {.u} -- Use one of: {paste(.u_opts, collapse = ', ')}"))
  }

  # pick a keyword from this unit type
  keyword_picks <- UNIT %>%
    filter(unit_type == .u) %>%
    unlist() %>%
    map_lgl(~isTRUE(as.logical(.x))) %>%
    which() %>%
    names()

  keyword <- ifelse(
    length(keyword_picks) > 0,
    sample(keyword_picks, 1L),
    "control"
  )

  pick <- switch(
    keyword,
    control = {
      paste(sample_name("us_pop_first_2010s"), sample_name("us_pop_last_2010s"))
    },
    transport = {
      paste(sample_name(c("rich_actors", "writers")), sample_name("us_pop_last_2010s"))
    },
    fast = {
      sample_name("rich_actors")
    },
    fly = {
      paste(sample_name("wu_adj"), sample_name("wu_noun"))
    },
    soar = {
      sample_name("grammy_artists")
    },
    deep = {
      sample_name(c("writers", "philosophers"))
    },
    sneak = {
      sample_name("grammy_producers")
    }
  )
  pick
}

#' @describeIn build_name Show some sample names you could build.
#' @importFrom purrr walk
#' @param .n How many names you wanna see?
#' @export
show_me_names <- function(.n = 8) {
  picks <- sample(UNIT$unit_type, .n, replace = TRUE)
  walk(picks, ~ print(glue("Hi, I'm {build_name(.x)} and I'm a {.x}")))
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

