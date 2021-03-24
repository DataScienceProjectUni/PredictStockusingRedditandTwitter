
# install.packages(c("plyr","stringr"), dependencies = T)

library(plyr)
library(stringr)

# calculating sentiment score

score_sentiment = function(sentences, positive_words, negative_words,
                           litigious_words, superfluous_words,
                           constraining_words, uncertainty_words, .progress='none')
{
  require(plyr)
  require(stringr)
  
  scores = laply(sentences, function(sentence, positive_words, negative_words,
                                     litigious_words, superfluous_words,
                                     constraining_words, uncertainty_words)
  {
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    
    sentence = tolower(sentence)
    word.list = str_split(sentence, '\\s+')
    words = unlist(word.list)
    
    positive_matches = match(words, positive_words)
    negative_matches = match(words, negative_words)
    litigious_matches = match(words, litigious_words)
    superfluous_matches = match(words, superfluous_words)
    constraining_matches = match(words, constraining_words)
    uncertainty_matches = match(words, uncertainty_words)
    
    positive_matches = !is.na(positive_matches)
    negative_matches = !is.na(negative_matches)
    litigious_matches = !is.na(litigious_matches)
    superfluous_matches = !is.na(superfluous_matches)
    constraining_matches = !is.na(constraining_matches)
    uncertainty_matches = !is.na(uncertainty_matches)
    
    score = data.frame(positive = sum(positive_matches), negative = sum(negative_matches),
                       litigious = sum(litigious_matches), superfluous = sum(superfluous_matches),
                       constraining = sum(constraining_matches), uncertainty = sum(uncertainty_matches))
    return(score)    
  }, positive_words, negative_words, litigious_words, superfluous_words, constraining_words, uncertainty_words,  .progress=.progress)
  scores.df = data.frame(score = scores, text = sentences)
  return(scores.df)
}


#load word lists
positive_words = scan ('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/positive_words.csv', what = 'character', comment.char =';')
negative_words = scan ('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/negative_words.csv', what = 'character', comment.char =';')
litigious_words = scan ('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/litigious_words.csv', what = 'character', comment.char =';')
superfluous_words = scan ('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/constraining_words.csv', what = 'character', comment.char =';')
constraining_words = scan ('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/superfluous_words.csv', what = 'character', comment.char =';')
uncertainty_words = scan ('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/uncertainty_words.csv', what = 'character', comment.char =';')


#import csv file
gme <- read.delim('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/DataCollection/RawData/AMCComments.csv', sep= ";")[,4:6]
gme$body <-as.factor(gme$body) 



#calculating scores
scores = score_sentiment(gme$body, positive_words, negative_words, litigious_words, superfluous_words,constraining_words, uncertainty_words, .progress='text')

gme$scores <- scores[,]





library(readr)
library(dplyr)
library(lubridate)



test <- gme %>%
  mutate(Time = as.POSIXct(created_utc)) %>%
  dplyr::group_by(lubridate::day(Time)) %>%
  dplyr::group_by(lubridate::hour(Time), .add=TRUE) %>% 
  dplyr::summarise(n=sum(scores))


?group_by





