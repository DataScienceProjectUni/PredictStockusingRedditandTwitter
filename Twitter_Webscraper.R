
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



tweets.1 <-searchTwitter("#$GME -Free -filter:retweets", n=10000, lang="en", since='2021-03-01', until='2021-03-04') #Searching twitter for specific tags with filter
tweets.2 <-searchTwitter("Apple + #Stock -Free", n=10000, lang="en", since='2021-03-01', until='2021-03-04')
tweets.jnj <-searchTwitter("#JNJ + #Stocks", n=100, lang="en")
tweets4 <-searchTwitter("#stock1", n=1000, lang="en")
tweets5 <-searchTwitter("#stock1", n=1000, lang="en")
head(tweets.df1$text)


tweets.df1 <- as.data.frame(twListToDF(tweets.1)) #Creates df with one row per tweet
tweets.df2 <- as.data.frame(twListToDF(tweets.2)) #Creates df with one row per tweet
tweets.df3 <- as.data.frame(twListToDF(tweets.aapl)) #Creates df with one row per tweet
tweets.df4 <- as.data.frame(twListToDF(tweets.aapl)) #Creates df with one row per tweet
tweets.df5 <- as.data.frame(twListToDF(tweets.aapl)) #Creates df with one row per tweet

tweets.df1$Twitter <- 1 # adding a twitter 1 watermark on the data

# tweets.df1$text <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", " ", tweets.df1$text) # Remove retweet entities
# tweets.df1$text <- gsub("(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", " ", tweets.df1$text) # Remove HTML links
# tweets.df1$text <- gsub("@\\w+", " ", tweets.df1$text) # Remove people
# tweets.df1$text <-  gsub("[[:punct:]]", " ", tweets.df1$text) # Remove punctioations

write.csv(tweets.df1,"~/R-data/Data Science Project/PredictStockusingRedditandTwitter\\tweets1.csv", row.names = FALSE)


test <- split(tweets.df1, cut(tweets.df1$created, breaks="day")) # Internally Splitting the data for each hour for 1 stock

test1 <- rbind(test[[1]],test[[2]],test[[3]],test[[4]],test[[5]],test[[6]],test[[7]],test[[8]],test[[9]]) # Making a data frame for the specific day
test2 <- rbind(test[[10]]) # For each hour
test3 <- rbind(test[[11]]) # For each hour
test4 <- rbind(test[[12]]) # For each hour
test5 <- rbind(test[[13]]) # For each hour
test6 <- rbind(test[[14]]) # For each hour
test7 <- rbind(test[[15]]) # For each hour
test8 <- rbind(test[[16]]) # For each hour
test9 <- rbind(test[[17]]) # For each hour




# Using rtweet package instead

## install newest version of rtweet
# if (!requireNamespace("devtools", quietly = TRUE)) {
#   install.packages("devtools")
# }
# devtools::install_github("mkearney/rtweet")
# 
# install.packages("rtweet")

# Install devtools from CRAN
#install.packages("devtools")

# Or the development version from GitHub:
# install.packages("devtools")
#devtools::install_github("r-lib/devtools")


library(rtweet)


token <- create_token(
  app = "Stockmarket_Scraper",
  consumer_key = API_Key,
  consumer_secret = API_Secret_Key,
  access_token = Access_Token,
  access_secret = Access_Token_Secret)


rt <- search_tweets("#AAPL -Free -filter:retweets", n=1000, lang="en", since='2021-03-01', until='2021-03-02')

head(rt$text)








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



library(tidyverse)
library(tidytext)
library(ggplot2)

tweet_words <- tweets.df1 %>% select(id, text) %>% unnest_tokens(word,text) # unnest_tokens will plit a column into tokens, flattening the table into one-token-per-row
tweet_words %>% count(word,sort=T) %>% slice(1:20) %>% 
  ggplot(aes(x = reorder(word, 
                         n, function(n) -n), y = n)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, 
                                                                                                                      hjust = 1)) + xlab("")

#Words that have no inherent meaning when talking, such as "a", "able", "according" etc. are all removed from the data set, to only evaluate words that actually affect the sentiment of a Tweet when posted. Furthermore, there are words which does not have any meaning other than in the context of the tweets, such as "t.co", "https", and "rt". These are also removed:
  
my_stop_words <- stop_words %>% select(-lexicon) %>% 
  bind_rows(data.frame(word = c("https", "t.co", "rt"))) # using a stop-word lexicon to remove stop words + removing "https", "t.co", and "rt". 

tweet_words_interesting <- tweet_words %>% anti_join(my_stop_words)
tweet_words_interesting %>% group_by(word) %>% tally(sort=TRUE) %>% slice(1:25) %>% 
  ggplot(aes(x = reorder(word, n, function(n) -n), y = n)) + geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("")

#Here, we start to see some more interesting words, that actually relates to the context of the Gamestock stock. "diamondhands" refers to individuals who has purchased Gamestop stock, and are not willing to sell, in an effort to increase the price. "gmetothemoon" refers to the stock price soaring, i.e. going "to the moon" etc.
#Now we can start conducting the actual sentiment analysis.


library(textdata)
tweet_words_interesting %>%
  count(word, id, sort = TRUE) %>%
  inner_join(get_sentiments("afinn"), by = "word") %>%
  group_by(word) %>%
  summarize(contribution = sum(n * value)) %>%
  slice_max(abs(contribution), n = 12) %>%
  mutate(word = reorder(word, contribution)) %>%
  ggplot(aes(contribution, word)) +
  geom_col() +
  labs(x = "Frequency*AFINN value", y = NULL)

#Some interesting words show up in the negative sentiments, such as panic, crazy, and different profanity. However, it is noticable that "shares" is the biggest contributor to the AFINN value, given it is inherently not a positive word. "Shares" in the context of financial data is not necesarily a positive word, but more likely being used as a netural noun (i.e. "TSLA is trading at $686,44/share")(https://www.tidytextmining.com/dtm.html) . This means that the AFINN lexicon is not good at capturing the actual sentiment behind words being used in the context of Tweets containing the hashtags "#GME" and "#Gamestop". Instead, other sentiment lexicons should be evaluated. One candidate is the Loughran and McDonald dictionary of financial sentiment terms. In the paper about this lexicon, the authors found that in a large sample of 10-Ks from 1994-2008, almost 3/4's of the words identified as negative by the Harvard Dictionary are not typically considered negative in financial contexts. The lexicon divides words into six sentiments: “positive”, “negative”, “litigious”, “uncertain”, “constraining”, and “superfluous” (Loughran and McDonald. 2011. “When Is a Liability Not a Liability? Textual Analysis, Dictionaries, and 10-Ks.” The Journal of Finance 66 (1): 35–65). Below, the lexicon is used on the Tweets containing "#Gamestop" and "#GME":

tweet_words_interesting %>%
  count(word) %>%
  inner_join(get_sentiments("loughran"), by = "word") %>%
  group_by(sentiment) %>%
  slice_max(n, n = 5, with_ties = FALSE) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  facet_wrap(~ sentiment, scales = "free") +
  labs(x = "Frequency of words in Tweets containing '#GME' or '#Gamestop'", y = NULL)
#Here, we see an arguable more accurate picture of the frequency of relevant words in the Tweets. "Halted" is the by far most negative word in relation to the Tweets, with a very high frequency. This makes sense, as there has been a lot of controversy involving the Gamestop stock, and different trading platforms limiting the amount of trades that can be made of this stock. Furthermore, there is no words that seem problematic in relation to the sentiment they are in. One problem to point out though is that there is 3 versions of the same word in the "uncertainty" sentiment, i.e. "prediction", "predictions", and "predicted". Since this dictionary actually properly captures the sentiments of the words, we can use it to check the count of the different sentiments surrounding the Gamestop stock:
 
stock_sentiment_count <- tweet_words_interesting %>%
  inner_join(get_sentiments("loughran"), by = "word") %>%
  count(sentiment) %>%
  spread(sentiment, n, fill = 0)


stock_sentiment_count$Movement <- ifelse((136.94-104.87)>0,1,0)

reg <- glm()



