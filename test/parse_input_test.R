require(testthat)
source('../src/parse_input.R')
source('../src/format_utils.R')

# An example with every parsing problem I came across
input_example1 <- c(
  "Message-ID: <10932580.1075851911656.JavaMail.evans@thyme>",
  "  Date: Wed, 2 Feb 2000 02:20:00 -0800 (PST)",
  "From: houston <.ward@enron.com>",
  "To: team.artesia@enron.com, team.monahans@enron.com, team.san-juan@enron.com,",
  "team.san-juan-laplata@enron.com, team.carlsbad@enron.com, harder'.'laura@enron.com",
  'Subject: Nitrogen and Sulfur reporting and Recordkeeping for "Turbines"',
  "Cc: butch.russell@enron.com, rich.jolly@enron.com, credit <.williams@enron.com>, william.kendrick@enron.com",
  "Mime-Version: 1.0",
  "Content-Type: text/plain; charset=us-ascii",
  "Content-Transfer-Encoding: 7bit",
  "Bcc: butch.russell@enron.com, rich.jolly@enron.com, william.kendrick@enron.com",
  "X-From: Larry Campbell",
  "X-To: Team Artesia, Team Monahans, Team San-Juan, Team San-Juan-LaPlata, Team Carlsbad, Team Andrews@Enron",
  "X-cc: Butch Russell, Rich Jolly, William Kendrick",
  "X-bcc:",
  "  X-Folder: \\Larry_Campbell_Nov2001_1\\Notes Folders\\Nsps for turbines",
  "X-Origin: CAMPBELL-L",
  "X-FileName: lcampbe.nsf",
  "",
  "begin body",
  "blah blah",
  "end body"
)

test_that("parse_file_header: can parse typical header", {
  fn <- file.path( getwd(),"test_email")
  con <- file(fn,open="w")
  writeLines(input_example1, con)
  close(con)
  header <- parse_file_header(fn)
  unlink(fn)
  expect_true(!is.null(header$Date))
  from_email <- decode_emails(header$From)
  expect_true(from_email == "houston.ward@enron.com")
  to_emails <- decode_emails(header$To)
  expect_length(to_emails, 6)
  expect_equal(any(str_detect(to_emails, "'")), FALSE)
  cc_emails <- decode_emails(header$Cc)
  expect_equal(any(str_detect(cc_emails, "([:space:]|\\<|\\>)")), FALSE)
  expect_equal(str_detect(header$Subject, '"'), FALSE)
})
