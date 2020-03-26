
<!-- README.md is generated from README.Rmd. Please edit that file -->

# covid.word.embedding

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of this project is to provide a demo Shiny app that can be run
on a user’s local environment to explore a GloVe model trained on the
[CORD19
dataset](https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge).

## Running the application locally

A user can run this developmental Shiny application by pulling the
repository to their local machine and opening the project in RStudio.
This prototype was built using
[Golem](https://thinkr-open.github.io/golem/). To run from RStudio,
follow the
[directions](https://thinkr-open.github.io/golem/articles/z_golem_cheatsheet.html)
as specified under 3. Day-to-day dev with golem part A. The code to be
run is also shown in R code block below which can be found in
covid.word.embedding/dev/run\_dev.R file.

``` r
# Set options here
options(golem.app.prod = FALSE)

# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
golem::document_and_reload()

# Run the application
covid.word.embedding::run_app()
```

## How to use the application locally

After running the application locally, a user can interactivley add or
subtract word vectors produced by [GloVe
algorithm](https://nlp.stanford.edu/projects/glove/) from the CORD19
dataset, which can then identify the closest related words to the
calculated word vector by cosine similarity. This
[article](https://medium.com/swlh/playing-with-word-vectors-308ab2faa519)
provides some background on adding and subtracting word vectors and the
interesting relationships that can be uncovered. The purpose of this
demo application is help users explore potentially related
words/features fromt the CORD19 dataset.

## Background on the GloVe model training

The model was trainined using [text2vec](http://text2vec.org/). An
independent R project was set up and the CORD19 dataset downloaded into
the following project folder PROJ\_ROOT/rawdata/. The purpose of the
code chunk below is to provide interested users an opportunity to
explore creating their own GloVe models from the CORD19 dataset and to
understand how the GloVe model in the prototype app was generated. Given
the large size of the dataset, this should be done independently.

``` r
## libraries --------
library(tidyverse)
library(magrittr)
library(DBI)
library(jsonlite)
library(text2vec)
library(tm)
library(SnowballC)

## set up --------
.PROJ_ROOT <- here::here()
.R_DIR <- file.path(.PROJ_ROOT, "R")
.RAW_DATA <- file.path(.PROJ_ROOT, "rawdata")
.RAW_PATH <- list.files(.RAW_DATA, recursive = T, full.names = T, pattern = ".json")

.STR_REMOVE <- paste0(c("The copyright holder.*preprint", "author.*permission", "The copyright holder.*funder", "CC-BY.*perpetuity","CC-BY.*funder", "All rights.*permission", "\\[[1-9]*\\]", "\\[[1-9]*"), collapse = "|")

metadata <- read_csv(file = file.path(.RAW_DATA, "metadata.csv"))

#Preprocessing functions-------------
prep_fun <- function(x){
  x <- tolower(x)
  x <- gsub(" +", " ", str_trim(x))
  x <- gsub("[0-9]", "", x)
  x <- gsub("\\(fig.* \\)", "", x)
  x <- gsub("\\.|,|!", "", x)
  x <- gsub(paste("\\b", stopwords(), "\\b", sep = "", collapse = "|"), "", x)
  x <- wordStem(x)
  x <- gsub(" +", " ", str_trim(x))
  return(x)
}

tmp <- list()

for(i in 1:length(.RAW_PATH)){
  print(i)
  tmp[[i]] <- try(fromJSON(txt = .RAW_PATH[[i]]))
}

tmp2 <- list()

for(i in 1:length(tmp)){
  print(i)
  tmp2[[i]] <- try(paste(gsub(pattern = .STR_REMOVE, replacement = "", tmp[[i]]$body_text$text), collapse = " "))
}

tmp3 <- list()

for(i in 1:length(tmp2)){
  print(i)
  tmp3[[i]] <- try(prep_fun(tmp2[[i]]))
}

tokens <- space_tokenizer(tmp3)
it = itoken(tokens, 
            ids = tmp$paper_id, 
            progressbar = TRUE)
vocab = create_vocabulary(it)
vocab = prune_vocabulary(vocab, term_count_min = 10L)
vectorizer = vocab_vectorizer(vocab)
tcm = create_tcm(it, vectorizer, skip_grams_window = 7L)
glove = GlobalVectors$new(word_vectors_size = 50, vocabulary = vocab, x_max = 50)
wv_main = glove$fit_transform(tcm, n_iter = 100, convergence_tol = 0.01, n_threads = 4)
```
