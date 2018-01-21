require(tidyverse)
require(tidytext)
source('../src/format_utils.R')

# A good reference: https://www.tidytextmining.com/

testfile <- '../data/maildir/fischer-m/sent/21.'

email_stats <- function(row) {
  
  row <- as.list(row)
  # Convert into a tidy dataframe with stopwords
  email.file <- row$EmailLocation
  email.body <- data_frame(email.body=parse_file_body(email.file))
  
  # collect some document statistics
  num.lines <- nrow(email.body)
  one.string <- paste(email.body$email.body, collapse=" ")
  num.char <- str_length(one.string)
  # Ratio of punctuation to characters
  count_char <- function(regex) length(unlist(str_match_all(one.string, regex)))/num.char
  p.punct.char <- count_char('[:punct:]{1}')
  # Ratio of alpha
  p.alpha.char <- count_char('[a-zA-Z]{1}')
  # Ratio of numeric to characters
  p.numeric.char <- count_char('[0-9]{1}')

  # number of recipients
  num.recipients <- nrow(collect_recipients(row))
  
  # Put in tidy form and remove stopwords
  body.df <- email.body %>%
    mutate(linenumber = row_number()) %>%
    ungroup() %>%
    unnest_tokens(word, email.body) %>%
    anti_join(stop_words, by='word')
  
  # Get basic count stats after stopword removal
  avg.word.length <- mean(str_length(body.df$word))
  if (is.na(avg.word.length)) avg.word.length <- 0
  
  word.count <- nrow(body.df)
  
  # Get a sentiment score for the email
  bing <- get_sentiments("bing")
  body.sentiment <- body.df %>%
    inner_join(bing, by='word') %>%
    group_by(sentiment) %>%
    summarise(count=n())
  sentiment <- sum(filter(body.sentiment, sentiment=='negative')$count)
  neg.sentiment <- sum(filter(body.sentiment, sentiment=='negative')$count)/
    sum(body.sentiment$count)
  if (is.nan(neg.sentiment)) neg.sentiment <- 0.5 # Neutral
  
  # Get time of day and day of week (should these be factors?)
  # return stats as an attribute list  
  list(
    word.count=word.count,
    avg.word.length=avg.word.length,
    num.lines=num.lines,
    sentiment=neg.sentiment,
    num.recipients=num.recipients,
    p.punct.char=p.punct.char,
    p.alpha.char=p.alpha.char,
    p.numeric.char=p.numeric.char,
    wday=wday(row$Date),
    hour=hour(row$Date)
  )
}

author_stats <- function(emails) {
  for (e in emails) {
    
  }
  # average non-stopwords per email
  # overall sentiment
  # word frequencies
  # average word length
  # average emails sent per day
}
