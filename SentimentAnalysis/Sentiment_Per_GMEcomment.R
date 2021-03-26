
#install.packages(c("tibbletime"), dependencies = T)

#load libs
library(plyr)
library(stringr)
library(readr)
library(dplyr)
library(lubridate)
library(tibbletime)


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
gme <- read.delim('~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning/gme_clean_full_day_17.csv', sep= ",")
gme$body <-as.factor(gme$body) # change text to factor
gme$created_utc <- as.POSIXct(gme$created_utc)

# only need data until 2021-03-17 21:00:00
gme <- gme %>% 
  filter(created_utc < as.POSIXct("2021-03-17 20:00:00"))



#calculating scores
scores <- score_sentiment(gme$body, positive_words, negative_words, litigious_words, superfluous_words,constraining_words, uncertainty_words, .progress='text')

# adding scored to dataset
gme$positive <- scores[,1]
gme$negative <- scores[,2]
gme$litigious <- scores[,3]
gme$superfluous <- scores[,4]
gme$constraining <- scores[,5]
gme$uncertainty <- scores[,6]

# drop body from dataset
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


#'************************THIS IS ALL TO ADJUST TO THE STOCK MARKET OPENING HOURS****************************#
# JUST ONCE we need to sum up the first hours 00:00 to 15:00 as just one hour i.e. 15:00
# then we need to sum up every 21:00 to 15:00 as just one hour as 21:00

# FIRST HALF DAY
## sum first 16 hours (once) i.e. until 15:59:59
# slice to get only first 15 hours
test3 <- test %>% 
  "["(.,1:16,) 

#sum first 15 hours as 1 hour
test4 <- test3 %>% 
  dplyr::group_by(year,month,day) %>% 
  dplyr::summarise(across(positive:uncertainty, ~ sum(.x, na.rm = TRUE)))

test4$day <- 8
test4$hour <- "15" %>% as.numeric()
test4 <- test4[,c(1:3,10,4:9)]



# FIRST WEEK INSIDE STOCK MARKET OPEN
#Now do it for the rest of the observations when stock market is closed i.e. 8.3.2021 21:00:00 until 21.03.2021 15:59:59

# remove first 16 observations and limit to before weekend
testW1 <- test %>% 
  "["(.,17:117,) %>% 
  filter(!hour %in% 16:20) #slice to get hours outside of stock opening


#group by every 19th row which is from 21:00 to 16:00
testW1 <- testW1 %>% 
  dplyr::group_by(year,month,day=rep(row_number(), length.out = n(), each = 19)) %>% 
  dplyr::summarize(across(positive:uncertainty, ~ sum(.x, na.rm = TRUE)))

testW1$day <- (9:12)
testW1$hour <- "15" %>% as.numeric()
testW1 <- testW1[,c(1:3,10,4:9)]


# WEEKEND
#Now we do it for the WEEKEND 12.3 21:00 - 15.3. 14:59:59
# get only weekend values
testWE <- test %>% 
  "["(.,118:183,)

#group by every 19th row which is from 21:00 to 16:00
testWE <- testWE %>% 
  dplyr::group_by(year,month) %>% 
  dplyr::summarize(across(positive:uncertainty, ~ sum(.x, na.rm = TRUE)))

testWE$day <- (15)
testWE$hour <- (14)
testWE <- testWE[,c(1:2,9:10,3:8)]



# SECOND WEEK OUTSIDE STOCK MARKET OPEN
# remove first week observations and limit to before weekend
testW2 <- test %>% 
  "["(.,184:nrow(test),) %>% 
  filter(!hour %in% 15:19) #slice to get hours outside of stock opening


#group by every 19th row which is from 20:00 to 15:00
testW2 <- testW2 %>% 
  dplyr::group_by(year,month,day=rep(row_number(), length.out = n(), each = 19)) %>% 
  dplyr::summarize(across(positive:uncertainty, ~ sum(.x, na.rm = TRUE)))

testW2$day <- (16:17)
testW2$hour <- "14" %>% as.numeric()
testW2 <- testW2[,c(1:3,10,4:9)]



# INSIDE STOCK MARKET OPEN FIRST WEEK
#slice to get hours inside of stock opening
testOP1 <- test %>% 
  "["(.,17:117,) %>% 
  filter(hour %in% 16:20)

# INSIDE STOCK MARKET OPEN SECOND WEEK
#slice to get hours inside of stock opening
testOP2 <- test %>% 
  "["(.,184:nrow(test),) %>% 
  filter(hour %in% 15:19)


#COMBINE ALL DF 
test_final <- rbind(test4,testW1, testOP1,testWE, testOP2, testW2)
test_final <- test_final[with(test_final, order(test_final$day, test_final$hour)), ]

#'************************END**************************************+*******#



#'************************CREATE % FOR EACH SENTIMENT CATEGORY*********************************************#
# create % sentiment for each category
sum <- (test_final$positive+test_final$negative+test_final$litigious+test_final$superfluous+test_final$constraining+test_final$uncertainty)
gme_final <- cbind(test_final, test_final$positive/sum, test_final$negative/sum, test_final$litigious/sum, test_final$superfluous/sum,test_final$constraining/sum,test_final$uncertainty/sum )

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
gme_final$created_utc <- paste(gme_final$year, gme_final$month, gme_final$day, sep="-")
gme_final$hour_min_s <- paste(gme_final$hour, "00","00", sep=":")
gme_final$created_utc <- paste(gme_final$created_utc, gme_final$hour_min_s, sep=" ")
gme_final$created_utc <- as.POSIXct(gme_final$created_utc)

#remove superfluous variables 
gme_final <- gme_final[-c(1:4,18)]
#'************************END**************************************+*******#



#'************************Get AND MERGE WITH STOCK DATA*********************************************#
# get the stock data 
library(tidyverse)
library(tidyquant)

av_api_key("JS6L6NH86R1R2V9F")
tiingo_api_key('f2a7cc9f497139d18f1056bf911eac4b763ff621')

# pick the stock
gme_stock_data <- c("GME", "AMC","PLTR","BB","TSLA","APHA","TLRY","NIO","RE","RKT","AAPL") %>%
  tq_get(get = "tiingo.iex",from = '2021-03-08', to = '2021-03-17', resample_frequency = "60min")


#remove 21:00:00 hour
gme_stock_data <- subset(gme_stock_data, symbol == "GME" & volume !=0)

#rename date to created_utc to merge easily
colnames(gme_stock_data)[2] <- "created_utc"
gme_stock_data$created_utc <- as.POSIXct(gme_stock_data$created_utc)
gme_final$created_utc <- as.POSIXct(gme_final$created_utc)

#merge dataset #DOESNT MERGE ALL
gme_merge <- left_join(gme_stock_data,gme_final, by="created_utc", all.x=TRUE)

gme_merge <- merge(gme_stock_data,gme_final)

#'************************END*********************************************#

#merge with stock data 
write.csv(gme_final, "GME_FinalData.csv", row.names = FALSE)
getwd()
