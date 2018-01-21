require('stringr')

# parse_file_header(file.path(dirName, "campbell-l", "nsps_for_turbines", "1."))

parse_file_header <- function(fn){
  tryCatch(
    {
      con <- file(fn,open="r")
      # Parse the Header
      header <- list()
      last <- ""
      while (TRUE) {
        l <- readLines(con,1)
        # Remove quotes - they'll mess up the CSV
        l <- str_replace_all(l, "['\"]", '')
        # This line has a new header
        if (str_detect(l, '^[:space:]*[a-zA-Z-]+:')) {
          l1 <- str_trim(str_split(l, ':')[[1]])
          last <- l1[1]
          header[last] <- l1[2]
        } else {
          header[last] <- paste(header[last], l, sep=' ')
        }
        # cat(l, '\n')
        if (l == "") break
      }
      header
    }, error=function(e){
      print(paste("Error in parse_file_header: parsing file", fn))
      print(e)
      list()
    },
    finally={
      close(con)
      #cat("closing connection")
    }
  )
}

# Extract the body from a file with an email
parse_file_body <- function(fn){
  tryCatch(
    {
      con <- file(fn,open="r")
      while (TRUE) {
        l=readLines(con,1)
        if (l == "") break
      }
      body=readLines(con,-1, ok=TRUE, warn=FALSE)
    }, error=function(e){
      print(paste("Error in parse_file_body: parsing file", fn))
      print(e)
      list()
    },
    finally={
      close(con)
    }
  )
}


# Calculate CSV File Columns
create_csv_columns <- function() {
  # paste("Message-ID",
  #       "Date",
  #       "From",
  #       "To",
  #       "Subject",
  #       "Cc",
  #       "Mime-Version",
  #       "Content-Type",
  #       "Content-Transfer-Encoding",
  #       "Bcc",
  #       "X-From",
  #       "X-To",
  #       "X-cc",
  #       "X-bcc",
  #       "X-Folder",
  #       "X-Origin",
  #       "X-FileName", 
  #       "EmailLocation", sep=",")
  paste("Date",
        "From",
        "To",
        "Subject",
        "Cc",
        "Bcc",
        "EmailLocation", sep=",")
}

unique_headers <<- c() 

# Parse Headers into a line
get_email_header <- function(fn) {
  h <- parse_file_header(fn)
  unique_headers <<- unique(c(unique_headers, names(h)))
  # Stop if a file has an unexpected number of headers
  # assert_that(length(h) == 17)
  rh <- function(h, tag) paste0('"', ifelse(is.null(h[[tag]]), NA, h[[tag]]), '"')
  # Ensure files are written in the right order in the CSV
  # paste(rh(h, "Message-ID"),
  #       rh(h, "Date"),
  #       rh(h, "From"),
  #       rh(h, "To"),
  #       rh(h, "Subject"),
  #       rh(h, "Cc"),
  #       rh(h, "Mime-Version"),
  #       rh(h, "Content-Type"),
  #       rh(h, "Content-Transfer-Encoding"),
  #       rh(h, "Bcc"),
  #       rh(h, "X-From"),
  #       rh(h, "X-To"),
  #       rh(h, "X-cc"),
  #       rh(h, "X-bcc"),
  #       rh(h, "X-Folder"),
  #       rh(h, "X-Origin"),
  #       rh(h, "X-FileName"), 
  #       paste0('"', fn, '"'),
  #       sep=",")
  paste(rh(h, "Date"),
        rh(h, "From"),
        rh(h, "To"),
        rh(h, "Subject"),
        rh(h, "Cc"),
        rh(h, "Bcc"),
        paste0('"', fn, '"'),
        sep=",")
}

# Process all files
# count <<- 0
process_all_headers <- function(fn, con) {
  if (file_test("-d", fn)) {
    #cat('Dir: ', fn, '\n')
    for (c in dir(fn)) process_all_headers(file.path(fn, c), con)
  } else {
    # cat('File: ', fn, '\n')
    l <- get_email_header(fn)
    writeLines(l, con, sep="\n")
    # if (count %% 1000 == 0) cat('.')
    # count <<- count+1
  }
  #print(paste('Done processing', count, 'files'))
}

# Toggle TRUE to run a batch import:
# R CMD BATCH ./src/parse_input.R
if (FALSE) {
  dirName <- './data/maildir'
  con <- file('headers.csv',open="w")
  header <- create_csv_columns()
  writeLines(header, con, sep="\n")
  process_all_headers(dirName, con)
  close(con)
}
