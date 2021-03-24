
# install.packages(c("plyr","stringr"), dependencies = T)

#load libs
library(plyr)
library(stringr)
library(readr)
library(dplyr)
library(lubridate)

# calculating sentiment score using custom function 
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
gme$body <-as.factor(gme$body) # change text to factor


# Changeing to date time format and CET time
gme$created_utc <- as.POSIXct(gme$created_utc) 
gme$created_utc <- gme$created_utc + hours(1) # Changeing to CET time



#calculating scores
scores <- score_sentiment(gme$body, positive_words, negative_words, litigious_words, superfluous_words,constraining_words, uncertainty_words, .progress='text')

# adding scored to dataset
gme$positive <- scores[,1]
gme$negative <- scores[,2]
gme$litigious <- scores[,3]
gme$superfluous <- scores[,4]
gme$constraining <- scores[,5]
gme$uncertainty <- scores[,6]

# drop body, subreddit from dataset
gme <- gme[,3:9]
gme[2:7] <- sapply(gme[,2:7],as.numeric)
#str(gme) 

# sum sentiment counts and group by day and hour of the day
test <- gme %>%
  mutate(Time = as.POSIXct(created_utc)) %>%
  dplyr::group_by(lubridate::year(Time)) %>%
  dplyr::group_by(lubridate::month(Time), .add=TRUE) %>%
  dplyr::group_by(lubridate::day(Time), .add=TRUE) %>%
  dplyr::group_by(lubridate::hour(Time), .add=TRUE)%>% 
  dplyr::summarise(across(where(is.numeric), ~ sum(.x)))


# create % sentiment for each category
sum <- (test$positive+test$negative+test$litigious+test$superfluous+test$constraining+test$uncertainty)
gme_final <- cbind(test, test$positive/sum, test$negative/sum, test$litigious/sum, test$superfluous/sum,test$constraining/sum,test$uncertainty/sum )

# rename comments
colnames(gme_final)[1] <- "year"
colnames(gme_final)[2] <- "month"
colnames(gme_final)[3] <- "day"
colnames(gme_final)[4] <- "hour"
gme_final[1:4] <- sapply(gme_final[,1:4],as.factor)


colnames(gme_final)[11] <- "positive_percent"
colnames(gme_final)[12] <- "negative_percent"
colnames(gme_final)[13] <- "litigious_percent"
colnames(gme_final)[14] <- "superfluous_percent"
colnames(gme_final)[15] <- "constraining_percent"
colnames(gme_final)[16] <- "uncertainty_percent"

# get timestamp back
gme_final$timestamp_etc <- paste(gme_final$year, gme_final$month, gme_final$day, sep="-")
gme_final$hour_min_s <- paste(gme_final$hour, "00","00", sep=":")
gme_final$timestamp_etc <- paste(gme_final$timestamp_etc, gme_final$hour_min_s, sep=" ")
gme_final$timestamp_etc <- as.POSIXct(gme_final$timestamp_etc)

#remove superfluous variables 
gme_final <- gme_final[-c(1:4,18)]


