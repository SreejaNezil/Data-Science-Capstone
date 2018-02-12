###############################################################################
##  Coursera Data Science Capstone Project
##  Text Predictor Application  
###############################################################################
##  predict.R
##  This program leverages the Ngram frequency models created from the sample data.
##  The next word predction is done using the simple backoff model
###############################################################################

suppressMessages(library(qdap,verbose=FALSE))
suppressMessages(library(quanteda, verbose = FALSE))
suppressMessages(library(stringi, verbose=FALSE))
suppressMessages(library(data.table, verbose=FALSE))


bigrams <- readRDS("bigramData.Rdata")
bigram_table <- data.table(bigram=names(bigrams),freq=bigrams,keep.rownames = FALSE)
rm(bigrams)
bigram_table <- bigram_table[, c("BW1", "BW2") := tstrsplit(bigram, "_", fixed=TRUE)]

pattern <- "(.*)_(.*)"
trigrams <- readRDS("./trigramData.Rdata")
trigram_table <- data.table(trigram=names(trigrams),freq=trigrams,keep.rownames = FALSE)
rm(trigrams)
trigram_table <- transform(trigram_table, TW2 = sub(pattern, "\\1", trigram), TW3 = sub(pattern, "\\2", trigram))

quadgrams <- readRDS("./quadgramData.Rdata")
quadgram_table <- data.table(quadgram=names(quadgrams),freq=quadgrams,keep.rownames = FALSE)
rm(quadgrams)
quadgram_table <- transform(quadgram_table, QW3 = sub(pattern, "\\1", quadgram), QW4 = sub(pattern, "\\2", quadgram))

fivegrams <- readRDS("./fivegramData.Rdata")
fivegram_table <- data.table(fivegram=names(fivegrams),freq=fivegrams,keep.rownames = FALSE)
rm(fivegrams)
fivegram_table <- transform(fivegram_table, FW4 = sub(pattern, "\\1", fivegram), FW5 = sub(pattern, "\\2", fivegram))


cleanInputText <- function(inputText) {
  finalInput <- tolower(as.character(inputText))
  finalInput <- replace_contraction(finalInput)
  finalInput <- replace_abbreviation(finalInput)
  #finalInput <- replace_ordinal(finalInput)
  #finalInput <- replace_number(finalInput)
  #finalInput <- removePunctuation((finalInput))
  # finalInput <- stri_replace_all(finalInput, regex="[^[:alnum:]]", replacement=" ")
  
  wordList_con <- file("badwords.txt", "r")
  badWords <- (readLines(wordList_con,skipNul = TRUE))
  close.connection(wordList_con)
  
  input_tokens <- quanteda::tokens(finalInput,what="word",ngrams=1L, remove_numbers = TRUE,
                                   remove_punct=TRUE, remove_twitter = TRUE, remove_hyphens = TRUE, remove_url = TRUE)
  input_tokens <- tokens_remove(input_tokens,badWords)
  # stopWords <- stopwords("english")
  # input_tokens <- tokens_remove(input_tokens,stopWords)
  finalInput <- as.character(input_tokens)
 # finalInput <- stripWhitespace(finalInput)
  return(finalInput)
}
predictfromBigrams <- function(inputText){
  next_word_list <- ""
  next_word_list <- subset(bigram_table, BW1==tolower(inputText),select=BW2)
  names(next_word_list) <- "Predicting from Bigrams table"
  n<-nrow(next_word_list)
  
  if(n==0) {
    return("Unable to find any relevant matched in the corpus")
  }
  if(n>3){n<-3}
  return(next_word_list[1:n])
}

predictfromTrigrams <- function(inputText){
  final_inputText <- paste(inputText,sep="_",collapse = "_")
  final_inputText <- tolower(final_inputText)
  
  next_word_list <- subset(trigram_table, TW2==final_inputText,select=TW3)
  names(next_word_list) <- "Predicting from Trigrams table"
  
  n<-nrow(next_word_list)
   if(n==0){
      next_word_list <- predictfromBigrams(inputText[2])
   }
  if(n>3){n<-3}
 return((next_word_list[1:n]))
}

predictfromQuadgrams <- function(inputText){
  final_inputText <- paste(inputText,sep="_",collapse = "_")
  final_inputText <- tolower(final_inputText)
  
  next_word_list <- subset(quadgram_table, QW3==final_inputText,select=QW4)
  names(next_word_list) <- "Predicting from Quadgrams table"
  
  n<-nrow(next_word_list)
  if(n==0){
    next_word_list <- predictfromTrigrams(inputText[2:3])
  }
  if(n>3){n<-3}
  return(next_word_list[1:n])
}

predictfromFivegrams <- function(inputText){
  final_inputText <- paste(inputText,sep="_",collapse = "_")
  final_inputText <- tolower(final_inputText)
  
  next_word_list <- subset(fivegram_table, FW4==final_inputText,select=FW5)
  names(next_word_list) <- "Predicting from Fivegrams table"
  
  n<-nrow(next_word_list)
  if(n==0){
    next_word_list <- predictfromQuadgrams(inputText[2:4])
  }
  if(n>3){n<-3}
  return(next_word_list[1:n])
}

predictNextWord <- function(inputText){
  userInput <- cleanInputText(inputText)
  next_word <- "Predicting from Quadgrams table"
  input_length <- length(userInput)
  if(input_length == 1){
    next_word <- predictfromBigrams(userInput)
  return(next_word)
  }
  else if(input_length == 2){
    next_word <- predictfromTrigrams(userInput)
    return(next_word)
  }
  else if(input_length == 3){
    next_word <- predictfromQuadgrams(userInput)
    return(next_word)
  }
  else if(input_length == 4){
    next_word <- predictfromFivegrams(userInput)
    return(next_word)
  }
  else if(input_length > 4){
    #Extract last 3 words from the input phrase
    last_4_words <- tail(userInput,4)
    next_word <- predictfromFivegrams(last_4_words)
    return(next_word)
  }
}

