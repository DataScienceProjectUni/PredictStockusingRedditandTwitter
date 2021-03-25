
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
gme <- read.delim('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning/gme_clean.csv', sep= ",")
gme$body <-as.factor(gme$body) # change text to factor



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
gme <- gme[,-2]
gme[2:7] <- sapply(gme[,2:7],as.numeric)
#str(gme) 

# sum sentiment counts and group by day and hour of the day
test <- gme %>%
  mutate(Time = as.POSIXct(created_utc)) %>%
  dplyr::group_by(year =lubridate::year(Time)) %>%
  dplyr::group_by(month = lubridate::month(Time), .add=TRUE) %>%
  dplyr::group_by(day =lubridate::day(Time), .add=TRUE) %>%
  dplyr::group_by(hour =lubridate::hour(Time), .add=TRUE)%>% 
  dplyr::summarise(across(where(is.numeric), ~ sum(.x)))

# JUST ONCE we need to sum up the first hours 00:00 to 15:00 as just one hour i.e. 15:00
# then we need to sum up every 21:00 to 15:00 as just one hour as 21:00

## sum first 16 hours (once)
# slice to get only first 16 hours
test3 <- test %>% 
  "["(.,1:16,)

#sum first 16 hours as 1 hour
test4 <- test3 %>% 
  group_by(year,month,day) %>% 
  summarize(across(positive:uncertainty, ~ sum(.x, na.rm = TRUE)))

test4$day <- 8
test4$hour <- "15" %>% as.numeric()
test4 <- test4[,c(1:3,10,4:9)]



## Now do it for the rest of the observations  

# remove first 16 observations
test10 <- test %>% 
  "["(.,17:nrow(test2),)

#slice to get hours outside of stock opening
test10 <- test10 %>% 
  filter(!hour %in% 15:20)

#group by every 18th row which is from 21:00 to 15:00
test11 <- test10 %>% 
  group_by(year,month,day=rep(row_number(), length.out = n(), each = 18)) %>% 
  summarize(across(positive:uncertainty, ~ sum(.x, na.rm = TRUE)))

test11$day <- (9:15)
test11$hour <- "21" %>% as.numeric()
test11 <- test11[,c(1:3,10,4:9)]

#slice to get hours outside of stock opening
test20 <- test %>% 
  filter(hour %in% 15:20) 


#combine the two dataframes to have all 21:00 
test30 <- rbind(test4,test20,test11)
test30 <- test30[with(test30, order(test30$day)), ]
test30 <- head(test30,-2) #remove last 2 rows 


#sum up hours that are not within time of open stock market
## NEEDS TO BE DONE 




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


write.csv(gme_final, "\\GME_Sentiment.csv", row.names = FALSE)
getwd()
