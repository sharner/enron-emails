require(tidyverse)
require(lubridate)

load_headers <- function(fn) {
  headers <- read_csv(fn)
  headers$Date <- parse_date_time(str_sub(headers$Date, start=6), order="%d %B %Y %H")
  headers$From <- decode_emails(headers$From)
  as_tibble(headers)
}

decode_emails <- function(l) {
  emails <- unlist(str_split(l, ","))
  # Some anomalous characters in some emails
  emails <- str_replace_all(emails, "([:space:]|\\<|\\>)", "")
  # Remove any blank entries
  emails[!is.na(emails) & emails != ""]
}

collect_recipients <- function(h) {
  recipients <- c(decode_emails(h$To),
                  decode_emails(h$Cc),
                  decode_emails(h$Bcc))
  tibble(recipient=recipients)
}
