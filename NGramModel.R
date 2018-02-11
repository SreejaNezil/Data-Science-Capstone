###############################################################################
##  Coursera Data Science Capstone Project
##  Text Predictor Application  
###############################################################################
##  NGramModel.R
##  This program leverages the cleaned sample data from the sample data 
##  extracted during the creation of Milestone report.
##  The goal is to create bi-gram, tri-gram and quad-grams from the cleaned sample data.
###############################################################################


options(java.parameters = "- Xmx7168m")
library(qdap)
library(quanteda)

my_sample_data <- readLines("SampleData.txt")
my_sample_data <- replace_contraction(my_sample_data)
#my_sample_data <- replace_ordinal(my_sample_data)
#my_sample_data <- replace_number(my_sample_data)
my_sample_data <- replace_abbreviation(my_sample_data)

corpusTokens <- quanteda::tokens(my_sample_data,what="word",ngrams=1L,  
                                 remove_numbers = TRUE, remove_punct = TRUE,
                                 remove_symbols = TRUE, remove_separators = TRUE,
                                 remove_twitter = TRUE, remove_hyphens = TRUE, remove_url = TRUE,
                                 skip = 0, concatenator = "_")
badWords <- readLines(".\\badwords.txt")
corpusTokens <- tokens_remove(corpusTokens,badWords)
# stopWords <- stopwords("english")
# corpusTokens <- tokens_remove(corpusTokens,stopWords)
junk_tokens <- c('u','f0','009f')
corpusTokens <- tokens_remove(corpusTokens,junk_tokens)
remove(my_sample_data)
#saveRDS(corpusTokens,file="unigrams.Rdata")

bigrams <- quanteda::tokens_ngrams(corpusTokens,n=2L,skip=0L,concatenator="_")
trigrams <- quanteda::tokens_ngrams(corpusTokens,n=3L,skip=0L,concatenator="_")
quadgrams <- quanteda::tokens_ngrams(corpusTokens,n=4L,skip=0L,concatenator="_")
fivegrams <- quanteda::tokens_ngrams(corpusTokens,n=5L,skip=0L,concatenator="_")

rm(corpusTokens)

bigram_fm <- dfm(bigrams)
bigram_fm <- dfm_trim(bigram_fm,min_count=2)
bigram_Vec <- sort(colSums(bigram_fm),decreasing=TRUE)
saveRDS(bigram_Vec,file="bigramData.Rdata")
rm(bigrams)
rm(bigram_fm)
rm(bigram_Vec)

trigram_fm <- dfm(trigrams)
#trigram_fm <- dfm_trim(trigram_fm,min_count=2)
trigram_Vec <- sort(colSums(trigram_fm),decreasing=TRUE)
saveRDS(trigram_Vec,file="trigramData.Rdata")
rm(trigrams)
rm(trigram_fm)
rm(trigram_Vec)

quadgram_fm <- dfm(quadgrams)
#quadgram_fm <- dfm_trim(quadgram_fm,min_count=2)
quadgram_Vec <- sort(colSums(quadgram_fm),decreasing=TRUE)
saveRDS(quadgram_Vec,file="quadgramData.Rdata")

fivegram_fm <- dfm(fivegrams)
#fivegram_fm <- dfm_trim(fivegram_fm,min_count=2)
fivegram_Vec <- sort(colSums(fivegram_fm),decreasing=TRUE)
saveRDS(fivegram_Vec,file="fivegramData.Rdata")

rm(quadgrams)
rm(quadgram_fm)
rm(quadgram_Vec)

