#This R script gets the text from the markdown files in this repo and manipulates it into
#a tidytext format from which you can do LSA, and in future hopefully other pieces of
#analysis too

library(plyr)
library(tibble)
library(Rcpp)
library(tidytext)
library(dplyr)
library(stringr)
library(SnowballC)

md_files <- list.files(path = "../", pattern = ".md") %>% #get names of .md files
  sapply(function(x) paste0("../", x))

sentences <- sapply(md_files, function(x) readLines(x)) %>% #read files
  ldply(cbind) %>% #turn files into data frame
  select(file = 1, text = 2) %>% #rename columns
  filter(text != "") %>% #remove blank lines
  filter(!str_detect(text, "#")) %>% #remove lines that are actually just section headers
  group_by(file) %>%
  mutate(fulltext = paste0(text, collapse = " ")) %>% #group each file's text as a big string
  ungroup() %>%
  select(file, fulltext) %>% #keep just file name and text
  unique() %>%
  unnest_tokens(sentence, fulltext, token = "sentences", to_lower = FALSE) %>% #break reports by sentence
  group_by(file) %>%
  mutate(sentence_ID = row_number()) %>% #tag sentences with IDs
  ungroup() %>%
  mutate(ID = paste0(file, "_", sentence_ID)) %>% 
  select(ID, sentence) #we now have a dataframe of sentences in the repo, tagged by IDs

data("stop_words")

text <- sentences %>%
  unnest_tokens(word, sentence, token = "words", to_lower = TRUE) %>% #break apart by words
  filter(word != "glossary.md") %>% #remove glossary hyperlinks
  anti_join(stop_words %>% filter(lexicon == "SMART")) %>% #remove stopwords
  mutate(word = wordStem(word)) #stem

word_counts <- text %>% count(ID, word) #count occurrences of each word in the vocab per document




