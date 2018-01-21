require(rlist)
require(pipeR)
source('../src/collect_stats.R')
source('../src/parse_input.R')
# steven.kean@enron.com

get_email_stats <- function(emails) {
  stats <- apply(emails, 1, email_stats)
  emails$word.count <- unlist(list.select(stats, word.count))
  emails$avg.word.length <- unlist(list.select(stats, avg.word.length))
  emails$num.lines <- unlist(list.select(stats, num.lines))
  emails$sentiment <- unlist(list.select(stats, sentiment))
  emails$num.recipients <- unlist(list.select(stats, num.recipients))
  emails$p.punct.char <- unlist(list.select(stats, p.punct.char))
  emails$p.alpha.char <- unlist(list.select(stats, p.alpha.char))
  emails$p.numeric.char <- unlist(list.select(stats, p.numeric.char))
  emails$wday <- unlist(list.select(stats, wday))
  emails$hour <- unlist(list.select(stats, hour))
  emails
}

# Get all emails from a particular person and augment them with stats
get_emails_from <- function(corpus, email.addr) {
  emails.from <- corpus %>%
    filter(From==email.addr)
  get_email_stats(emails.from)
} 

# Get the a number of emails not from this person and augment them with stats
get_random_emails_not_from <- function(corpus, email.addr, num.emails) {
  emails.not.from <- sample_n(corpus, num.emails)
  emails.not.from <- emails.not.from %>%
    filter(From!=email.addr)
  get_email_stats(emails.not.from)
}
  
