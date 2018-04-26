source("./data_preparation.R")
library(tm)
library(slam)

#Helper functions

#This normalises the lengths of a matrix to length 1
normalize <- function(mat){
  col.lengths <- sapply(1:ncol(mat), function(x) sqrt(sum(mat[, x]^2)))
  return(sweep(mat, 2, col.lengths, "/"))
}

#This gives the positions of documents under a rank-k approximation
#further projected onto a rank k-1 unit hypersphere.
#The positions are given relevant to the original vector space.
posns_k <- function(TDM, k){
  svdecomp <- svd(TDM)
  posns <- svdecomp$u[,1:k] %*% diag(svdecomp$d[1:k]) %*% t(svdecomp$v[,1:k]) %>%
    normalize()
  dimnames(posns) <- dimnames(TDM)
  return(posns)
}

#This gives similarity scores
sim_scores <- function(search_text, posns){
  search_words <- search_text %>% tolower() %>%
    strsplit(search_text, split = " ") %>%
    unlist()
  search_words <- search_words[which(search_words %in% dimnames(posns)$Terms)]
  results <- colSums(posns[search_words,])
  return(results)
}

TDM <- word_counts %>% cast_tdm(word, ID, n) %>%
  weightSMART(spec = "btn") %>%
  as.matrix() %>%
  normalize() %>%
  as.simple_triplet_matrix()

SVD <- svd(TDM)

#Let's say we want to find a rank-100 approximation to our rank-450 space

k <- 100

new_posns <- posns_k(TDM, k)

some_scores <- sort(sim_scores("latent dirichlet allocation has problems", new_posns), decreasing = TRUE)[1:10] %>%
  as_tibble(rownames = NA) %>%
  rownames_to_column(var = "ID") %>%
  rename(sim_score = value)

full_sentences <- sentences %>%
  filter(ID %in% some_scores$ID) %>%
  join(some_scores) %>%
  arrange(desc(sim_score))

