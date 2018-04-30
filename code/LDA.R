source("./data_preparation.R")
library(topicmodels)
library(tm)
library(slam)
library(ggplot2)
library(tidyr)
library(LDAvis)
library(stringi)

#Helper function to be able to run LDA visualisations

# Taken from http://christophergandrud.blogspot.co.uk/2015/05/a-link-between-topicmodels-lda-and.html
# (with a few small alterations made by me)

topicmodels_json_ldavis <- function(fitted, corpus, doc_term){

  # Find required quantities
  phi <- posterior(fitted)$terms %>% as.matrix
  theta <- posterior(fitted)$topics %>% as.matrix
  vocab <- colnames(phi)
  doc_length <- vector()
  for (i in 1:length(corpus)) {
    temp <- paste(corpus[[i]]$content, collapse = ' ')
    doc_length <- c(doc_length, stri_count(temp, regex = '\\S+'))
  }
  term_freq <- doc_term %>% as.matrix() %>% colSums()
  
  # Convert to json
  json_lda <- LDAvis::createJSON(phi = phi, theta = theta,
                                 vocab = vocab,
                                 doc.length = doc_length,
                                 term.frequency = term_freq)
  
  return(json_lda)
}

#Analysis

# Make document term matrix - note that we just want raw
# word counts with no weighting or anything
DTM <- full_word_counts %>% cast_dtm(ID, word, n)

num_topics <- 4

#generate our LDA object using the LDA() command from topicmodels package
lda_object <- LDA(DTM, k = num_topics, control = list(seed = 1234))

#Problem 1

topics_per_sentence <- tidy(lda_object, matrix = "gamma")

# I'm not sure what happened with us/DfT before, but in this case the
# problem with different documents for the same sentence appears to go away!
# So maybe Problem 1 in the markdown files isn't a problem (perhaps before
# we used a different package or something?)
repeated_sentences <- sentences %>% arrange(sentence) %>%
  group_by(sentence) %>%
  mutate(count = n()) %>%
  ungroup() %>%
  filter(count > 1) %>%
  left_join(topics_per_sentence %>% rename(ID = document)) %>%
  group_by(sentence) %>%
  arrange(sentence, topic)
  

#Problem 2

#consider the four inferred topics
topics_and_words <- tidy(lda_object, matrix = "beta")

#get the top terms for each
top_terms <- topics_and_words %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

#see the top terms in each
top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

# The following is the LDAvis package that lets you use snazzy graphics
# to try to decipher what your LDA is telling you. Sadly I still can't
# make any sense of the results.

corpus <- full_text %>%
  group_by(ID) %>%
  summarise(text = paste0(word, collapse = " ")) %>%
  .$text %>%
  VectorSource() %>%
  Corpus()

inputJSON <- topicmodels_json_ldavis(fitted = lda_object,
                                     corpus = corpus,
                                     doc_term = DTM)

# This creates the output. It makes it in a directory
# called 'LDA_vis'. You have to open the 'index.html'
# file in Firefox. You can google for the details of
# what you're viewing; suffice it to say that I can't
# explain what the topics actually 'mean' in a human-
# understandable way.

serVis(inputJSON, out.dir = 'LDA_vis', open.browser = FALSE)

