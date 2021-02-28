#install.packages("twitteR")

#using the twitteR package ####
library(twitteR)
library(tidyverse)
library(tidytext)
library(ggplot2)

#From the twitter app (Keys and tokens)
api_key <- "AxFW62RAfgBjjQcBFH3f0r6N3" # API key 
api_secret <- "MgvjDF0zr2OHP2kNy2Aix3YrpCGhjN3LVQ5bZJLT8anBt9djXz" #API secret key 
token <- "1359545003656232961-SLFEIY1sj5D5tJbvsvXM6ouNP1FOnI" #token 
token_secret <- "2IINsWj5KjyvTxUcMeEPF4vdWLkccROoO8k3NszMcTAE7" #token secret


setup_twitter_oauth(api_key, api_secret, token, token_secret) # setup for accessing twitter using the information above

tweets <- searchTwitter('#GME + #GameStop', n=1000, lang = "en") # the function searchTwitter search 
# for tweets based on the specified parameters

tweets.df <-twListToDF(tweets) # creates a data frame with one row per tweet
tweetDF <- as.data.frame(tweets.df)
View(tweetDF)


tweet_words <- tweetDF %>% select(id, text) %>% unnest_tokens(word,text)
tweet_words %>% count(word,sort=T) %>% slice(1:20) %>% 
  ggplot(aes(x = reorder(word, 
                         n, function(n) -n), y = n)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, 
                                                                                                                      hjust = 1)) + xlab("")

# Create a list of stop words: a list of words that are not worth including

#####################################
#library(stopwords)
#stopwords <- stopwords(language = "en", source = "snowball", simplify = TRUE) # Using stopwords package for list of stopwords
#####################################


my_stop_words <- stop_words %>% select(-lexicon) %>% 
  bind_rows(data.frame(word = c("https", "t.co", "rt")))

tweet_words_interesting <- tweet_words %>% anti_join(my_stop_words)

tweet_words_interesting %>% group_by(word) %>% tally(sort=TRUE) %>% slice(1:25) %>% ggplot(aes(x = reorder(word, 
                                                                                                           n, function(n) -n), y = n)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, 
                                                                                                                                                                                                        hjust = 1)) + xlab("")


