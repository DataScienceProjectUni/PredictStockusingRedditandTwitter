
library(readr)
library(lubridate)

# Loading the twitter data that has to be appended
twitter10 <- read.delim("DataCollection/RawData/week10_tweets.csv", sep=",")[,c(2,3,4)]
twitter11 <- read.delim("DataCollection/RawData/week11_tweets.csv", sep=",")[,c(2,3,4)]


# Appending the 2 data frames
full_twitter1 <- rbind(twitter10, twitter11) 

# Changeing the Twitter time from cet to utc to fir with the stock data and reddit data
full_twitter1$created_at <- as.POSIXct(full_twitter1$created_at) 
full_twitter1$created_at <- full_twitter1$created_at - hours(1) # Changeing to UTC time


# Cutting the timeframe of week 11 Twitter data to fit with Reddit data timframe
full_twitter <- full_twitter1[full_twitter1$created_at < "2021-03-17 18:00:00" & full_twitter1$created_at > "2021-03-07 23:59:59" ,]

rm("twitter10","twitter11","full_twitter1", "full_twitter2")




# Renaming columns to fit with Reddit data
colnames(full_twitter)[2] <- "created_utc"
colnames(full_twitter)[3] <- "body"





# loading the raw Reddit data
amc <- read.delim("DataCollection/RawData/AMCComments.csv", sep=";")[,c(6,4)]
apha <- read.delim("DataCollection/RawData/APHAComments.csv", sep=";")[,c(6,4)]
aapl <- read.delim("DataCollection/RawData/APPLComments.csv", sep=";")[,c(6,4)]
bb <- read.delim("DataCollection/RawData/BBComments.csv", sep=";")[,c(6,4)]
gme <- read.delim("DataCollection/RawData/GMEComments.csv", sep=";")[,c(6,4)]
nio <- read.delim("DataCollection/RawData/NIOComments.csv", sep=";")[,c(6,4)]
pltr <- read.delim("DataCollection/RawData/PLTRComments.csv", sep=";")[,c(6,4)]
rkt <- read.delim("DataCollection/RawData/RKTComments.csv", sep=";")[,c(6,4)]
tlry <- read.delim("DataCollection/RawData/TLRYComments.csv", sep=";")[,c(6,4)]
tsla <- read.delim("DataCollection/RawData/TSLAComments.csv", sep=";")[,c(6,4)]


# Changeing to a time variable
amc$created_utc <- as.POSIXct(amc$created_utc) 


apha$created_utc <- as.POSIXct(apha$created_utc) 


aapl$created_utc <- as.POSIXct(aapl$created_utc) 


bb$created_utc <- as.POSIXct(bb$created_utc) 


gme$created_utc <- as.POSIXct(gme$created_utc) 


nio$created_utc <- as.POSIXct(nio$created_utc) 


pltr$created_utc <- as.POSIXct(pltr$created_utc) 


rkt$created_utc <- as.POSIXct(rkt$created_utc) 


tlry$created_utc <- as.POSIXct(tlry$created_utc) 


tsla$created_utc <- as.POSIXct(tsla$created_utc) 




# Looping over the data frames to rename col 1 to creates_cet
ticker <- c('gme', 'amc', 'pltr', 'bb', 'tsla', 'apha', 'tlry', 'nio', 'rkt', 'aapl')



for (i in ticker){ 
  x <- get(i)
  colnames(x)[1] <- "created_utc"
  assign(i, x)
}





# Appending Reddit and Twitter for the specific ticker
amc_final <- rbind(amc, full_twitter[full_twitter$ticker == "AMC",][,c(2,3)])
apha_final <- rbind(apha, full_twitter[full_twitter$ticker == "APHA",][,c(2,3)])
aapl_final <- rbind(aapl, full_twitter[full_twitter$ticker == "AAPL",][,c(2,3)])
bb_final <- rbind(bb, full_twitter[full_twitter$ticker == "BB",][,c(2,3)])
gme_final <- rbind(gme, full_twitter[full_twitter$ticker == "GME",][,c(2,3)])
nio_final <- rbind(nio, full_twitter[full_twitter$ticker == "NIO",][,c(2,3)])
pltr_final <- rbind(pltr, full_twitter[full_twitter$ticker == "PLTR",][,c(2,3)])
rkt_final <- rbind(rkt, full_twitter[full_twitter$ticker == "RKT",][,c(2,3)])
tlry_final <- rbind(tlry, full_twitter[full_twitter$ticker == "TLRY",][,c(2,3)])
tsla_final <- rbind(tsla, full_twitter[full_twitter$ticker == "TSLA",][,c(2,3)])






# Saving as CSV file ready for sentiment analysis
write.csv(amc_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\amc_clean.csv", row.names = FALSE)
write.csv(apha_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\apha_clean.csv", row.names = FALSE)
write.csv(aapl_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\aapl_clean.csv", row.names = FALSE)
write.csv(bb_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\bb_clean.csv", row.names = FALSE)
write.csv(gme_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\gme_clean.csv", row.names = FALSE)
write.csv(nio_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\nio_clean.csv", row.names = FALSE)
write.csv(pltr_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\pltr_clean.csv", row.names = FALSE)
write.csv(rkt_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\rkt_clean.csv", row.names = FALSE)
write.csv(tlry_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\tlry_clean.csv", row.names = FALSE)
write.csv(tsla_final,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter/DataCleaning\\tsla_clean.csv", row.names = FALSE)




