require(tidyverse)
require(tidytext)
library(tidyr)
source('../src/parse_input.R')

create_recipient_pairs <- function(headers) {
  sender.pairs <- unlist(apply(headers, 1, function(r) {
    r <- as.list(r)
    sender <- r$From
    recipients <- collect_recipients(r)
    # cat('.')
    unlist(apply(recipients, 1, function(r) list(sender, r)))
  }))
  sender.pairs <- as.tibble(matrix(sender.pairs, ncol=2, byrow=TRUE))
  names(sender.pairs) <- c('Sender', 'Recipient')
  sender.pairs %>%
    filter(Sender != Recipient) %>%
    count(Sender, Recipient, sort=TRUE)
}


# for laying out graphs http://kateto.net/networks-r-igraph

recipient_graph <- function(g) {
  set.seed(2016)
  a <- grid::arrow(type = "closed", length = unit(.15, "inches"))
  ggraph(g, layout = "fr") +
    geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                   arrow = a, end_cap = circle(.07, 'inches')) +
    geom_node_point(color = "lightblue", size = 5) +
    geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
    theme_void()
}
