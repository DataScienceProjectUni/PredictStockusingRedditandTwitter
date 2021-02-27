# install.packages("RedditExtractoR")
library(RedditExtractoR)


wsb_dd = get_reddit(search_terms = "subreddit:wallstreetbets AND flair:DD")
dd_comments <- cbind(wsb_dd$comm_date,wsb_dd$comment)
# View(dd_comments)

wsb_disc = get_reddit(search_terms = "subreddit:wallstreetbets AND flair:Discussion")
disc_comments <- cbind(wsb_disc$comm_date,wsb_disc$comment)
# View(disc_comments)

wsb_gain = get_reddit(search_terms = "subreddit:wallstreetbets AND flair:Gain")
gain_comments <- cbind(wsb_gain$comm_date,wsb_gain$comment)
# View(disc_comments)

wsb_loss = get_reddit(search_terms = "subreddit:wallstreetbets AND flair:Loss")
loss_comments <- cbind(wsb_loss$comm_date,wsb_loss$comment)
# View(disc_comments)

wsb = get_reddit(search_terms = "subreddit:wallstreetbets")
wsb_comments <- cbind(wsb$comm_date,wsb$comment)
# View(wsb_comments)

install.packages("slam")
install.packages("tm")
library(wordcloud)
wordcloud(wsb_comments)

textList <- as.list(rep(as.character(""), length(wsb_comments)))
# View(textList)
textTable <- table(allText)
textTable <- sort(textTable, decreasing = TRUE)

rainbow(30,s=.8,v=.6,start=.5,end=1,alpha=1) -> pal
wordcloud(names(textTable[1:200]), textTable[1:200], scale = c(4,.5), max.words = 200, colors = pal)

# install.packages("tidytext")
# library(tidytext)
# get_sentiments(lexicon = c("bing"))

install.packages("sentimentr")
library(sentimentr)

Asentiment <- sentiment_by(wsb_comments)
# View(sentiment)
summary(sentiment)




