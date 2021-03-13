# Relationship between SoMe and Stocks (Sentiment analysis)

## Introduction
The efficient market hypothesis is a well known term in the financial world. It argues that current stock prices reflects all possible information about the stocks and thus the stocks at all times reflects their true value. This means that one can't predict the stock market with currently available data, as this would already be reflected in the prices.
However, given recent events involving Reddit and the Gamestop stock, one might re-evaluate whether the efficient market hypothesis actually holds true. The subreddit “Wallstreetbets” started discussion about the huge short positions that hedge funds held in the stock, and how this could affect the company in the future. Redditors started buying up shares of Gamestop, in an attempt to initiate what is known as a “short-squeeze”, similar to what happened with the Volkswagen stock in 2008 (https://www.reuters.com/article/us-volkswagen-idUSTRE49R3I920081028). This initiative would ultimately mean, if the redditors were to be successful, that the stock price of Gamestop would soar up. The snowball had now started rolling, and more and more redditors purchased Gamestop stock. The subreddit Wallstreetbets saw an increase in subscribers of from around 1.7 million to above 9 million over the period (https://subredditstats.com/r/wallstreetbets). This shows the huge potential of social media, specifically in making it possible for retail investors to rally together, and affect the price of stocks. And that is why we want to see if we can utilize social media to predict whether the most discussed stocks goes up or down in price, based on how retail investors are talking about the stocks.
 

## Research Question
"Is it possible to use Reddit and Twitter data, to predict short term movement in price of highly discussed stocks on these platforms?"

## Description
We want to analyze whether we can predict short term movements in the price of stocks. We will do this by collecting data from the platforms Twitter and Reddit. We will retrieve data from tweets regarding certain stocks and posts/comments on subreddits involving investing, such as "WallStreetBets" and "Investing". We will perform sentiment analysis on the text in relation to the mentioning of the stocks, which we will then compare to the actual market valuations of those stocks, to predict whether the price goes up or down.


# Research design 

## Methodology 

### Design 
In our study, we are applying a mixed method approach. We are analyzing natural language in the form of Reddit comments and Tweets, using sentiment analysis. We then apply quantitative predictive modelling methods. In this, we are applying a deductive approach, testing the existing theories of sentiment analysis and predictive modeling.

We are conducting a longitudinal study in the sense that we are sampling a population of stocks and their prices in certain daily intervals. We have chosen this approach to be better able to establish the sequence of events and identify changes in the stock prices over time. This ultimately helps us better determine if there is a cause-and-effect relationship between the sentiment of social media and the changes in stock prices discussed on the platforms reddit and twitter.


## Data Collection
Firstly, to identify the most mentioned stock in the chosen time frame, we will scrape relevant subreddits, using the "Pushshift Reddit API" available on github, that are concerned with the topic finance and investing. This will we result in primary data from users commenting on the chosen subreddits. 
The study will focus on the five most mentioned stocks available on the NASDAQ in these subreddits. 

Having identified the stocks, we will scrape relevant subreddits and twitter tweets (using the twitter API provided by Twitter) for their tickers, names and stock abbreviations. This will result in in primary data from both users mentioning the chosen stocks in comments on the chosen subreddits and twitter users mentioning the identified stock in tweets. 

When scraping data on Reddit and Twitter, we scrape comments containing the ticker of the relevant stocks, e.g. "$GME". We also considered scraping for both "$GME" and "Gamestop". However, we argue this is suboptimal in terms of the research question we want to answer. Based on our ethnographic research on Reddit, comments containing a dollar sign before the stock ticker, i.e. "$GME", will almost always be a comment placed in a financial context. Whereas a comment containing "Gamestop" could also just be someone talking about Gamestop in a non-financial context, i.e. "I drank a soda after going to Gamestop today". The same holds true for Twitter. And the last sentence will obviosuly not enrich us in regards to how specific stocks are talked about in financial contexts. 

Additionally, we will retrieve stock open and close prices for the identified stocks on yahoo finance. The secondary data on open and close stock price will be used as independent variable to measure stock movement i.e. if a stock value increases or decreases on a given day within the specified time frame. 

### Variables
 - Weekday
 - (Weekend as 1 day)
 - Sentiment score from lexicon -> 6 variables 
 - Stock (Ticker) 
 - Volume (Mentions count) 
 - DP = Stock movement Up/Down that day
 - (DP2 = Stock movement up/Down next day)

### General
- daily data (2 weeks) 
- only NASDAQ
  - during close market use all what is mentioned during after hours and night to predict first hour after opening

### Step 1
- choose/identify subreddits to identify most mentioned stocks in 
- i.e. /r/SecurityAnalysis, /r/Finance, /r/WallStreetBets, /r/FinancialIndependence, /R/Investing, /r/Stocks, /r/StockMarket
- Answer why these subreddits and why most mentioned stocks?

### Step 2
- scrape reddit comments from identified subreddits 
- use redditcomments to pick the 5 most mentioned stocks in that time period

## Data Preperation

### Step 3
- scrape reddit and twitter for the identified stocks in the chosen time period
  - use stock ticker and stock name

#### Step 3.1
- create datasets for each of the 5 stocks 
 - How are these beeing divided per day? 
 
#### Step 3.2
- get daily financial data and classify if the stock goes up or down during a given day

### Step 4
- Perform sentiment analysis on each dataset (NLP)
- add actuals from financial data to datasets as independent variable

## Data Modelling

### Step 5
- train data and tune model
- Extreme Gradient Boosting
- Random Forrest
- Logistic Regression
- SVM
- Neural networks

Sensitivity vs specificity depends on how risk averse the invester is. If the investor is more risk averse then the specificity should be higher aswell, in order to decrease the risk of making an investment that is predicted to increase, but decreases (a FP).  

### Step 5
- Predict if stock goes up or down in next hour based on sentiment analysis



## Limitations
We don't have the computational power which limits our possibilities in terms of doing hourly data collection and sentiment analysis

## Contrubtions
We have all equally contributed to the whole part of the project. This was done With the utilization of the GitHub platform that allowed us to all contribute to the main project from different branches while, revising all changes made together before mergering the changes to our main file. 
