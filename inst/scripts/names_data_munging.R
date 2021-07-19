dir <- system.file("extdata", "name-files", package = "MundusCentrum")
devtools::load_all()

##### Philosophers
# https://www.famousphilosophers.org/list/

phil <- read_lines(file.path(dir, "philosophers.txt")) %>%
  str_replace("\\\t.+$", "") %>%
  unique()
write_lines(phil, file.path(dir, "philosophers.txt"))

######## Writers
# https://gist.github.com/jaidevd/23aef12e9bf56c618c41
writers <- read_csv("~/Downloads/books.csv") %>%
  tidyr::separate(
    Author,
    c("last", "first"),
    sep = ", "
  ) %>%
  filter(
    !is.na(first),
    str_detect(last, "Hitler", negate = TRUE)
  ) %>%
  mutate(name = paste(first, last)) %>%
  pull(name) %>%
  unique()

write_lines(writers, file.path(dir, "writers.txt"))

######## Grammy's
# https://www.kaggle.com/unanimad/grammy-awards?select=the_grammy_awards.csv

df <- read_csv("~/Downloads/the_grammy_awards.csv")
View(df)

artists <- unique(
  df %>%
    filter(
      str_detect(sanitize_name(category), "(album|song|record)_of_the_year"),
      !is.na(artist)
    ) %>%
    pull(artist) %>%
    str_subset("[Vv]arious|[Ww]ith", negate = T) %>%
    stringr::str_split(", ?") %>%
    unlist()
)
readr::write_lines(artists, file.path(dir, "grammy_artists.txt"))

producers <- unique(
  df %>%
    filter(
      str_detect(sanitize_name(category), "producer_of_the_year")
    ) %>%
    pull(nominee)
)
readr::write_lines(producers, file.path(dir, "grammy_producers.txt"))

######
last_names <- read_lines(file.path(dir, "us_pop_last_2010s.txt")) %>%
  stringr::str_to_title()
write_lines(last_names, file.path(dir, "us_pop_last_2010s.txt"))
