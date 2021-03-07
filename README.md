# Relationship between SoMe and Stocks (Sentiment analysis)

## Introduction
The efficient market hypothesis is a well known term in the financial world. It arhues that current stock prices reflects all possible information about the stocks and thus the stocks at all times reflects their true value. This means that one can't predict the stock market with currently avaliable data, as this would already be reflected in the prices.  

## Research Question
"Is it possible to use Reddit and Twitter data, to predict short term movement in price of highly discussed stocks on these platforms?"

## Description
We want to analyze whether we can predict short term movements in the price of stocks. We will do this by collecting data from the platforms Twitter and Reddit. We will retrieve data from tweets regarding certain stocks and posts/comments on subreddits involving investing, such as "WallStreetBets" and "Investing". We will perform sentiment analysis on the text in relation to the mentioning of the stocks, which we will then compare to the actual market valuations of those stocks, to predict whether the price goes up or down.


# Research design 

## Methodology 

## Data Collection
Firstly, to identify the most mentioned stock in the chosen time frame, we will scrape relevant subreddits, using the "Pushshift Reddit API" available on github, that are concerned with the topic finance and investing. This will we result in primary data from users commenting on the chosen subreddits. 
The study will focus on the five most mentioned stocks available on the NASDAQ in these subreddits. 

Having identified the stocks, we will scrape relevant subreddits and twitter tweets (using the twitter API provided by Twitter) for their tickers, names and stock abbreviations. This will result in in primary data from both users mentioning the chosen stocks in comments on the chosen subreddits and twitter users mentioning the identified stock in tweets. 

Additionally, we will retrieve stock open and close prices for the identified stocks on yahoo finance. The secondary data on open and close stock price will be used as independent variable to measure stock movement i.e. if a stock value increases or decreases on a given day within the specified time frame. 

### Variables
 - Weekday 
 - Sentiment score (Aggregated, -3 : 3?) 
 - Stock (Ticker) 
 - Volume (Mentions count) 
 - DP = Stock movement Up/Down

### General
- Hourly data (5 weekdays) 
- only NASDAQ
  - during open market use hour-over-hour 
  - during close market use all what is mentioned during after hours and night to predict first hour after opening

### Step 1
- choose/identify subreddits to identify most mentioned stocks in 
- i.e. /r/SecurityAnalysis, /r/Finance, /r/WallStreetBets, /r/FinancialIndependence, /R/Investing, /r/Stocks, /r/StockMarket

### Step 2
- scrape reddit comments from identified subreddits 
- use redditcomments to pick the 5 most mentioned stocks in that time period

### Step 3
- scrape reddit and twitter for the identified stocks in the chosen time period
  - use stock ticker and stock name

#### Step 3.1
- create hourly datasets for each of the 5 stocks 

#### Step 3.2
- get hourly financial data and classify if the stock goes up or down during a given hour

### Step 4
- Perform sentiment analysis on each dataset (NLP)
- add actuals from financial data to datasets as independent variable

### Step 5
- train data and tune model
- Extreme Gradient Boosting
- Random Forrest
- Logistic Regression

### Step 5
- Predict if stock goes up or down in next hour based on sentiment analysis



## Limitations
We don't have the computational power which limits our possibilities in terms of doing hourly data collection and sentiment analysis

## Project time schedule
