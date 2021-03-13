
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


#Retriving the needed tweet data by the Stock Ticker for a weeks interval
tweets.gme <- search_tweets("#$GME -Free -filter:retweets", n=1000, lang="en", since='2021-03-08', until='2021-03-14')[,c(3,5,11,12,13,14)]
tweets.amc <- search_tweets("#$AMC -Free -filter:retweets", n=1000, lang="en", since='2021-03-08', until='2021-03-14')[,c(3,5,11,12,13,14)]
tweets.tsla <- search_tweets("#$TSLA -Free -filter:retweets", n=1000, lang="en", since='2021-03-08', until='2021-03-14')[,c(3,5,11,12,13,14)]
tweets.altr <- search_tweets("#$ALTR -Free -filter:retweets", n=1000, lang="en", since='2021-03-08', until='2021-03-14')[,c(3,5,11,12,13,14)]
tweets.aapl <- search_tweets("#$AAPL -Free -filter:retweets", n=1000, lang="en", since='2021-03-08', until='2021-03-14')[,c(3,5,11,12,13,14)]

view(tweets.gme)


# GME preperation
tweets.gme$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.gme$ticker <- "GME" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.gme <- tweets.gme %>%
  mutate(day = wday(created_at - hours(9), label = TRUE, locale = "English_United States.1252"))



# AMC preperation
tweets.amc$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.amc$ticker <- "AMC" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.amc <- tweets.amc %>%
  mutate(day = wday(created_at - hours(9), label = TRUE, locale = "English_United States.1252")) 



# TSLA preperation
tweets.tsla$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.tsla$ticker <- "TSLA" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.tsla <- tweets.tsla %>%
  mutate(day = wday(created_at - hours(9), label = TRUE, locale = "English_United States.1252"))



# ALTR preperation
tweets.altr$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.altr$ticker <- "ALTR" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.altr <- tweets.altr %>%
  mutate(day = wday(created_at - hours(9), label = TRUE, locale = "English_United States.1252"))



# AAPL preperation
tweets.aapl$twitter <- 1 # adding a twitter 1 watermark on the data for identifications later vs Reddit
tweets.aapl$ticker <- "AAPL" # adding a ticker to the data for identifications later
# Adding day of the week adjusted for the financial opening hours of the stock market (i.e. From 09:00 Monday - 09:00 Tuesday = "Mon")
tweets.aapl <- tweets.aapl %>%
  mutate(day = wday(created_at - hours(9), label = TRUE, locale = "English_United States.1252"))



# Binding the different tweets data together
tweets <- rbind(tweets.gme, tweets.amc, tweets.altr, tweets.tsla, tweets.aapl)


###############################################################
  
# getting the opening and closing prices of the stocks
library(BatchGetSymbols)

# set dates
first.date <- Sys.Date() - 7 # Starting a week ago !OBS! should be monday
last.date <- Sys.Date()
freq.data <- 'daily' # Making sure it is daily opening and closing prices
# set tickers
tickers <- c('GME', 'AMC', 'TSLA','ALTR','AAPL') # SAme Tickers as retrieved tweets from

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,
                         last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache') ) # cache in tempdir()

View(l.out)


# Calculating the stock movement per day 

price.list <- l.out[["df.tickers"]] # Extracting the list of prices
price.list$change <- price.list$price.close - price.list$price.open # Calculating the price change variable
price.list$movement <- ifelse(price.list$change>0, 1, 0) # Binary variable 1 stock went up, 0 stock didn't move or wen down
price.list <- price.list %>%
  mutate(day = wday(ref.date, label = TRUE, locale = "English_United States.1252"))




# Adding the interesting variables from price.list to the tweet stock list: Volume, change and movement
# Joining the tables on date and ticker condition
week10.tweets = merge(x=tweets, y=price.list[,c(5,8,11,12,13)], by.x=c("day", "ticker"), by.y=c("day", "ticker"), all.x = TRUE, all.y=FALSE, sort = TRUE)  


# Saving as a CSV file ready for sentiment analysis
write.csv(week10.tweets,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter\\week10_tweets.csv", row.names = FALSE)

