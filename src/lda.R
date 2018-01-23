require(tidytext)
require(broom)
require(purrr)
source('../src/parse_input.R')
data(stop_words)

tidy_email <- function(fn) {
  data_frame(text=parse_file_body(fn)) %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words, by="word")
}

get_tidy_emails_from_author <- function(headers,author) {
  headers %>%
    filter(author==From) %>%
    select(EmailLocation) %>%
    mutate(emails=map(EmailLocation, tidy_email)) %>%
    unnest(emails)
}

get_tidy_email_from_authors <- function(headers, authors) {
  authors %>%
    mutate(tables=map(author, ~ get_tidy_emails_from_author(headers, .x))) %>%
    unnest(tables)
}

get_dtm_from_authors <- function(email_df) {
  email_dfm <- email_df %>%
    filter(!str_detect(word, "^[0-9]+$")) %>%
    unite(document, author, EmailLocation) %>%
    count(document, word, sort=TRUE) %>%
    cast_dtm(document, word, n)
}
