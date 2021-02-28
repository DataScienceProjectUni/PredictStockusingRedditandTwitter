
##Twitter Web_Scraper

#install.packages("twitteR")
library("twitteR")
library(tidyverse)
library(dplyr)
library("tidytext")

#Keys and Tokens
API_Key <- "OonvgKZHTrlekJstRIMVa7Sov"
API_Secret_Key <- "HeIlK8HlSI98F218za8uvwNmpIBOqQYRsn9likEcI0DuAI9vJo"
Access_Token <- "1137671692711596038-QwlMYtruJj7fpLpIxxawuFZ9yDF7jW"
Access_Token_Secret <- "u5oh6tbzFObRd7LtDlEAWlDuvO46U3x4CTxzGvfcgG1oE"
Bearer_Token <- "AAAAAAAAAAAAAAAAAAAAANT0MgEAAAAAFoNqAZU8NEhJj1nbKAU2g44dbcw%3DybuSNOy4XTJXih4PKeetVsBDu5ZmszqihoRITlr4f3dhnM9vGg"

options(httr_oauth_cache=TRUE)
setup_twitter_oauth(API_Key, API_Secret_Key, Access_Token, Access_Token_Secret)



tweets.aapl <-searchTwitter("#AAPL -Free -filter:retweets", n=1000, lang="en") #Searching twitter for specific tags
tweets.nvda <-searchTwitter("#NVDA + #Stocks", n=100, lang="en")
tweets.jnj <-searchTwitter("#JNJ + #Stocks", n=100, lang="en")
tweets4 <-searchTwitter("#stock1", n=1000, lang="en")
tweets5 <-searchTwitter("#stock1", n=1000, lang="en")


tweets.df <- as.data.frame(twListToDF(rbind(tweets.aapl))) #Creates df with one row per tweet

head(tweets.df)


# 
# #Finding the most tweeted words in combination with apple
# tweet_words <- tweets.df %>% select(id, text) %>% unnest_tokens(word,text) #Selects 2 columns, id and text and unnest the text
# 
# tweet_words %>% count(word,sort=T) %>% slice(1:20) %>%
#   ggplot(aes(x = reorder(word, n, function(n) -n), y = n)) +
#   geom_bar(stat = "identity") +
#   theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
#   xlab("")
# 
# 
# 
# # Create a list of stop words: a list of words that are not worth including
# 
# my_stop_words <- stop_words %>% select(-lexicon) %>%
#   bind_rows(data.frame(word = c("https", "t.co", "rt", "amp","to","of","and","link", "bio")))
# 
# tweet_words_interesting <- tweet_words %>% anti_join(my_stop_words)
# 
# tweet_words_interesting %>% group_by(word) %>% tally(sort=TRUE) %>% slice(1:25) %>%
#   ggplot(aes(x = reorder(word, n, function(n) -n), y = n)) +
#     geom_bar(stat = "identity") +
#     theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
#     xlab("")
# 
# 
# bing_lex <- get_sentiments("nrc")
# 
# fn_sentiment <- tweet_words_interesting %>% left_join(bing_lex)
# 
# fn_sentiment %>% filter(!is.na(sentiment)) %>% group_by(sentiment) %>% summarise(n=n())
