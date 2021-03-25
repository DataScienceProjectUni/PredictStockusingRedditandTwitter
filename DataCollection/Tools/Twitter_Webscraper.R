
##Twitter Web_Scraper


#Loading libaries
library("twitteR")
library(tidyverse)
library(dplyr)
library("tidytext")
library(rtweet)
library(lubridate)

#Keys and Tokens from Twitter
API_Key <- "OonvgKZHTrlekJstRIMVa7Sov"
API_Secret_Key <- "HeIlK8HlSI98F218za8uvwNmpIBOqQYRsn9likEcI0DuAI9vJo"
Access_Token <- "1137671692711596038-QwlMYtruJj7fpLpIxxawuFZ9yDF7jW"
Access_Token_Secret <- "u5oh6tbzFObRd7LtDlEAWlDuvO46U3x4CTxzGvfcgG1oE"
Bearer_Token <- "AAAAAAAAAAAAAAAAAAAAANT0MgEAAAAAFoNqAZU8NEhJj1nbKAU2g44dbcw%3DybuSNOy4XTJXih4PKeetVsBDu5ZmszqihoRITlr4f3dhnM9vGg"

options(httr_oauth_cache=TRUE)
setup_twitter_oauth(API_Key, API_Secret_Key, Access_Token, Access_Token_Secret)

# Setting up the token to scrape Twitter
token <- create_token(
  app = "Stockmarket_Scraper",
  consumer_key = API_Key,
  consumer_secret = API_Secret_Key,
  access_token = Access_Token,
  access_secret = Access_Token_Secret)


# Tickers with most post volume on Reddit, last 13 days
# GME - AMC - PLTR - BB - TSLA - APHA - TLRY - NIO - RE - RKT - AAPL

# Retriving the needed tweet data by the Stock Ticker for a weeks interval
# First the weekdays 
tweets.gme <- search_tweets("#$GME -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.amc <- search_tweets("#$AMC -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.pltr <- search_tweets("#$PLTR -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.BB <- search_tweets("#$BB -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.tsla <- search_tweets("#$TSLA -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.apha <- search_tweets("#$APHA -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.tlry <- search_tweets("#$TLRY -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.nio <- search_tweets("#$NIO -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.rkt <- search_tweets("#$RKT -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.aapl <- search_tweets("#$AAPL -Free -filter:retweets", n=100000, lang="en", since='2021-03-08', until='2021-03-13', retryonratelimit = TRUE)[,c(3,5,12,13,14)]




# Here the weekends
tweets.gme2 <- search_tweets("#$GME -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.amc2 <- search_tweets("#$AMC -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.pltr2 <- search_tweets("#$PLTR -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.BB2 <- search_tweets("#$BB -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.tsla2 <- search_tweets("#$TSLA -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.apha2 <- search_tweets("#$APHA -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.tlry2 <- search_tweets("#$TLRY -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.nio2 <- search_tweets("#$NIO -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.rkt2 <- search_tweets("#$RKT -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]
tweets.aapl2 <- search_tweets("#$AAPL -Free -filter:retweets", n=100000, lang="en", since='2021-03-13', until='2021-03-15', retryonratelimit = TRUE)[,c(3,5,12,13,14)]




tweets.gme <- bind_rows(tweets.gme, tweets.gme2)
tweets.amc <- bind_rows(tweets.amc, tweets.amc2)
tweets.pltr <- bind_rows(tweets.pltr, tweets.pltr2)
tweets.BB <- bind_rows(tweets.BB, tweets.BB2)
tweets.tsla <- bind_rows(tweets.tsla, tweets.tsla2)
tweets.apha <- bind_rows(tweets.apha, tweets.apha2)
tweets.tlry <- bind_rows(tweets.tlry, tweets.tlry2)
tweets.nio <- bind_rows(tweets.nio, tweets.nio2)
tweets.rkt <- bind_rows(tweets.rkt, tweets.rkt2)
tweets.aapl <- bind_rows(tweets.aapl, tweets.aapl2)




# GME preperation
tweets.gme$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.gme$ticker <- "GME" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market
#(i.e. From 09:00 Monday - 09:00 Tuesday = "Tue") as they are to predict the movement on tuesday
tweets.gme <- tweets.gme %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))



# AMC preperation
tweets.amc$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.amc$ticker <- "AMC" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.amc <- tweets.amc %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252")) 



# PLTR preperation
tweets.pltr$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.pltr$ticker <- "PLTR" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.pltr <- tweets.pltr %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))



# BB preperation
tweets.BB$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.BB$ticker <- "BB" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.BB <- tweets.BB %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))



# TSLA preperation
tweets.tsla$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.tsla$ticker <- "TSLA" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.tsla <- tweets.tsla %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))



# APHA preperation
tweets.apha$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.apha$ticker <- "APHA" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market
#(i.e. From 09:00 Monday - 09:00 Tuesday = "Tue") as they are to predict the movement on tuesday
tweets.apha <- tweets.apha %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))



# TLRY preperation
tweets.tlry$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.tlry$ticker <- "TLRY" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.tlry <- tweets.tlry %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252")) 



# NIO preperation
tweets.nio$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.nio$ticker <- "NIO" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.nio <- tweets.nio %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))



# RKT preperation
tweets.rkt$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.rkt$ticker <- "RKT" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.rkt <- tweets.rkt %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))



# AAPL preperation
tweets.aapl$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.aapl$ticker <- "AAPL" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.aapl <- tweets.aapl %>%
  mutate(day = wday(created_at + hours(15), label = TRUE, locale = "English_United States.1252"))





# Binding the different tweets data together
tweets <- bind_rows(tweets.gme, tweets.amc, tweets.pltr, tweets.BB, tweets.tsla, tweets.apha, tweets.tlry, tweets.nio, tweets.rkt, tweets.aapl)


levels(tweets$day)[levels(tweets$day)=="Sun"] <- "wknd"
levels(tweets$day)[levels(tweets$day)=="Sat"] <- "wknd"

###############################################################
  
# getting the opening and closing prices of the stocks
library(BatchGetSymbols)


# set dates
first.date <- Sys.Date() - 7 # Starting a week ago !OBS! should be monday
last.date <- Sys.Date() - 1
freq.data <- 'daily' # Making sure it is daily opening and closing prices
# set tickers
tickers <- c('GME', 'AMC', 'PLTR', 'BB', 'TSLA', 'APHA', 'TLRY', 'NIO', 'RKT', 'AAPL') # Same Tickers as retrieved tweets from

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,
                         last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache') ) # cache in tempdir()



# Calculating the stock movement per day 

price.list <- l.out[["df.tickers"]] # Extracting the list of prices
price.list$change <- price.list$price.close - price.list$price.open # Calculating the price change variable
price.list$movement <- ifelse(price.list$change>0, 1, 0) # Binary variable 1 stock went up, 0 stock didn't move or wen down
price.list <- price.list %>%
  mutate(day = wday(ref.date, label = TRUE, locale = "English_United States.1252"))
# Making sure that the tweets until the stock market opens will be used to predict the movement of the stocks for that day. 



# Adding the interesting variables from price.list to the tweet stock list: Volume, change and movement
# Joining the tables on date and ticker condition
week10.tweets = merge(x=tweets, y=price.list[,c(5,8,11,12,13)], by.x=c("day", "ticker"), by.y=c("day", "ticker"), all.x = TRUE, all.y=FALSE, sort = TRUE)  


# Saving as a CSV file ready for sentiment analysis
write.csv(week10.tweets,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter\\week10_tweets_day_shifted.csv", row.names = FALSE)

# OBS these tweets are shifted in terms of the day, so day and time stamp doesn't fit! 
