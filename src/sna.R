require(tidyverse)
require(tidytext)
library(tidyr)
require(janeaustenr) # remove later
source('../src/parse_input.R')

text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")
text_df <- data_frame(line = 1:4, text = text)
text_df %>%
  unnest_tokens(word, text)


original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

tidy_books <- original_books %>%
  unnest_tokens(word, text)
