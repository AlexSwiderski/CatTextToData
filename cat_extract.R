library(tidyverse)

input <- read_lines('Example_data')

# do the match and keep only the second column
header <- as_tibble(str_match(input, "^(.*?)\\s+Score.*")[, 2, drop = FALSE])
colnames(header) <- 'title'

# add index to the list so we can match the scores that come after
header <- header %>%
  mutate(row = row_number()) %>%
  fill(title)  # copy title down

# pull off the scores on the numbered rows
scores <- str_match(input, "^([0-9]+[. ]+)(.*?)\\s+([0-9]+)\\s+([0-9*]+)$")
scores <- as_tibble(scores) %>%
  mutate(row = row_number())

# keep only rows that are numbered and delete first column
scores <- scores[!is.na(scores[,1]), -1]

# merge the header with the scores to give each section
table <- left_join(scores,
                   header,
                   by = 'row'
)
colnames(table) <- c('index', 'type', 'Score', 'T-Score', 'row', 'title')



###############Attempting to automate with multiple files##################
temp = list.files(pattern = "*Example")
myfiles = lapply(temp, readLines)
myfiles2 <-map(myfiles[1:3], as_tibble(str_match(myfiles[1:3], "^(.*?)\\s+Score.*")[, 2, drop = FALSE]))

myfiles2 <-map(myfiles[1:3], as_tibble)
myfiles3 <- map(myfiles2[[1:3]], str_match(pattern =  "^(.*?)\\s+Score.*"))

myfiles2[[c(1:2)]]
