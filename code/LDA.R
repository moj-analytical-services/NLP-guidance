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
  phi <- topicmodels::posterior(fitted)$terms %>% as.matrix
  theta <- topicmodels::posterior(fitted)$topics %>% as.matrix
  vocab <- colnames(phi)
  doc_length <- vector()
  for (i in 1:length(corpus)) {
    temp <- paste(corpus[[i]]$content, collapse = " ")
    doc_length <- c(doc_length, stringi::stri_count(temp, regex = "\\S+"))
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
DTM <- full_word_counts %>% tidytext::cast_dtm(ID, word, n)

num_topics <- 3 #arbitarily chosen - I tried 4 and LDAvis showed two of them
# pretty much overlapping. So I've changed to three

#generate our LDA object using the LDA() command from topicmodels package
lda_object <- topicmodels::LDA(DTM, k = num_topics, control = list(seed = 1234))

#Problem 1

topics_per_sentence <- broom::tidy(lda_object, matrix = "gamma")

# I'm not sure what happened with us/DfT before, but in this case the
# problem with different documents for the same sentence appears to go away!
# So maybe Problem 1 in the markdown files isn't a problem (perhaps before
# we used a different package or something?)
repeated_sentences <- sentences %>%
  dplyr::arrange(sentence) %>%
  dplyr::group_by(sentence) %>%
  dplyr::mutate(count = n()) %>%
  dplyr::ungroup() %>%
  dplyr::filter(count > 1) %>%
  dplyr::left_join(topics_per_sentence %>% rename(ID = document)) %>%
  dplyr::group_by(sentence) %>%
  dplyr::arrange(sentence, topic)
  

#Problem 2

#consider the four inferred topics
topics_and_words <- broom::tidy(lda_object, matrix = "beta")

#get the top terms for each
top_terms <- topics_and_words %>%
  dplyr::group_by(topic) %>%
  top_n(10, beta) %>%
  dplyr::ungroup() %>%
  dplyr::arrange(topic, -beta)

#see the top terms in each
top_terms %>%
  dplyr::mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

# The following is the LDAvis package that lets you use snazzy graphics
# to try to decipher what your LDA is telling you. Sadly I still can't
# make any sense of the results.

corpus <- full_text %>%
  dplyr::group_by(ID) %>%
  dplyr::summarise(text = paste0(word, collapse = " ")) %>%
  .$text %>%
  tm::VectorSource() %>%
  tm::Corpus()

inputJSON <- topicmodels_json_ldavis(fitted = lda_object,
                                     corpus = corpus,
                                     doc_term = DTM)

# This creates the output. It makes it in a directory
# called 'LDA_vis'. You have to open the 'index.html'
# file in Firefox. You can google for the details of
# what you're viewing; suffice it to say that I can't
# explain what the topics actually 'mean' in a human-
# understandable way.

LDAvis::serVis(inputJSON, out.dir = "LDA_vis", open.browser = FALSE)
