
##Twitter API 


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




# Binding the different tweets data together
tweets <- bind_rows(tweets.gme, tweets.amc, tweets.pltr, tweets.BB, tweets.tsla, tweets.apha, tweets.tlry, tweets.nio, tweets.rkt, tweets.aapl)


levels(tweets$day)[levels(tweets$day)=="Sun"] <- "wknd"
levels(tweets$day)[levels(tweets$day)=="Sat"] <- "wknd"



# Saving as a CSV file ready for sentiment analysis
write.csv(tweets,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter\\week10_tweets.csv", row.names = FALSE)

# OBS these tweets are shifted in terms of the day, so day and time stamp doesn't fit! 
