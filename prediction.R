# Libraries and options ####
library(dplyr)
library(quanteda)
library(wordcloud)
library(RColorBrewer)

dfTrain1 =  readRDS("dfTrain1.rds")
dfTrain2 =  readRDS("dfTrain2.rds")
dfTrain3 =  readRDS("dfTrain3.rds")

# Transfer to quanteda corpus format and segment into sentences
fun.corpus = function(x) {
  #corpus(unlist(segment(x, 'sentences')))
  corpus(unlist(corpus_reshape(corpus(x), 'sentences')))
}

# Tokenize ####
fun.tokenize = function(x, ngramSize = 1, simplify = T) {
  
  # Do some regex magic with quanteda
  #toLower(
  tokens_ngrams(tokens_tolower(
    quanteda::tokens(x,
                     remove_number = TRUE,
                     remove_punct = TRUE,
                     remove_separators = TRUE,
                     remove_twitter = TRUE
                     # ngrams = 2
                     #concatenator = " "
    )
  ), n=ngramSize, 
  concatenator = " "
  )
}

# Parse tokens from input text ####

fun.input = function(x){
  xDf = data_frame(word = as.character(fun.tokenize(corpus(x))))
  xLength = nrow(xDf)
  
  if(xLength == 0){
    input1 = data_frame(word = "")
    input2 = data_frame(word = "")
  } else if (xLength == 1){
    input1 = data_frame(word = "")
    input2 = data_frame(word = as.character(fun.tokenize(corpus(x))))
  } else {
    input1 = tail(xDf, 2)[1, ]
    input2 = tail(xDf, 1)
  }
  
  inputs = data_frame(words = unlist(rbind(input1,input2)))
  return(inputs)
}

# Predict using stupid backoff algorithm ####

fun.predict = function(x, y, n = nSuggestions) {
  print(">>>")
  print(x)
  print("<<<")
  print(y)
  # Predict giving just the top 1-gram words, if no input given
  if(x == "" & y == "") {
    prediction = dfTrain1 %>%
      select(NextWord, freq)
    print("con1")
    # Predict using 3-gram model
  }   else if( (x != "" & x %in% dfTrain3$word1) & y %in% dfTrain3$word2) {
    prediction = dfTrain3 %>%
      filter(word1 %in% x & word2 %in% y) %>%
      select(NextWord, freq)
      print("con2")
    # Predict using 2-gram model
  }   else if(y %in% dfTrain2$word1) {
    prediction = dfTrain2 %>%
      filter(word1 %in% y) %>%
      select(NextWord, freq)
      print("con3")
    # If no prediction found before, predict giving just the top 1-gram words
  }   else{
    prediction = dfTrain1 %>%
      select(NextWord, freq)
	  print("con4")
  }
  
  # Return predicted word in a data frame
  return(prediction[1:n, ])
}