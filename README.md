# Stock Movement Prediction using Reddit and Twitter Sentiments

## Introduction
Predicting stock prices has been an important and tested problem within the financial world for decades and its frontier has, with time, expanded into the field of data science and even more so with the rise of electronic trading (Bodie et al., 2017, p.66-68).   
   
Whether it is possible to predict stock prices has been widely discussed in financial forums. It initially led to the efficient market hypothesis (EMH) which, in its essence, states that stock prices follow a random walk, and price changes for that reason are random and unpredictable because the market always holds all the relevant information. Since then the EMH has been debunked, revised, and expanded to multiple layers. One thing everyone agrees on however, is that it is difficult, if not impossible to predict stock prices (Bodie et al., 2017, p.333-365).   
   
From January 21, 2021 until January 27, 2021 the stock price of GameStop Corp. rose from USD 43 to USD 347 - an increase of approx. 807% in 6 days (GME Stock Price, 2021). In the same period, the number of subscribers on the subReddit wallstreetbets, a discussion forum for stock and security trading (wallstreetbets, 2012). Wallstreetbets increased from approx. 1.8 to 4.9 million subscribers  (SubReddit Stats, 2021). The subReddit wallstreetbets started a discussion about the big short positions that hedge funds held in the stock, and how this could affect the company in the future. Redditors started buying up shares of Gamestop, in an attempt to initiate what is known as a short-squeeze (Investopedia, 2021).   
   
This inspires the thinking that, in modern times when the online forums and communities have increased to such a magnitude, perhaps there is some information in the social media (SoMe) platforms that can be exploited for predicting stock prices. This motivated the following research question we seek to answer in this study:
"Can social media, in particular the sentiment of Reddit comments and tweets, predict short term movements of highly discussed stocks?”
With sentiment analysis and machine learning modelling, we seek to investigate whether there is a correlation between the sentiments on SoMe platforms about highly discussed stocks, and the stock movement of these stocks. By exploiting this information on an hourly basis, we aim to develop a trading strategy that utilizes the stock movement predictions before the market can absorb the information contained in the sentiments. The intra-day trading strategy will be simulated on the predictions obtained to evaluate whether it can be utilized to achieve financial gains.   
   

 
## Conclusion
The undertaken project posed the question “Can social media, in particular the sentiment of Reddit comments and tweets, predict short term movement of highly discussed stocks?”. To answer the research question, we developed an end-to-end process from data collection and preprocessing to establishing an hourly prediction model based on social media sentiments. The project was completed by utilizing the obtained predictions in a hypothetical trading strategy.   
   
During the project, we found evidence that indicates social media content has a small correlation with the hourly movements for highly discussed stocks. The sentiment categories were supplied by a financial lexicon proven to be effective at classifying stock sentiments.    
   
Especially, the sentiments category superfluous had a negative correlation with next hour stock movement in our data. Furthermore, our findings suggest that there may be a stronger correlation between the stock price movement and sentiments during extreme events. Extreme volatility and fluctuation within a given hour seems to generate more definite and stronger sentiments within Social Media posts. Thus, to answer our research question: SoMe activity has the potential to be exploited in order to predict short term stock movement.    
   
Across all selected stocks, the most accurate model was a Polynomial Kernel Support Vector Machine. The model’s predictors were solely based on the six sentiment categories. We were able to outperform our validation accuracy for all stocks with an average of 60,88%.  
   
When utilizing the ML model on our hold-out data, the prediction accuracy was only 53,34% on average. This indicates that our model was either overfitting the training data or that the small amount of observations in the test data is not representative. We concluded that it would be necessary to collect more data in order to validate our findings and increase the accuracy of our prediction model.   
   
After testing the model, we developed and simulated a simple intraday trading strategy to implement the proposed prediction model in a real-life setting. Based on the prediction whether a given stock will increase or decrease in the succeeding hour, the strategy was to buy or sell shares respectively. We were able to make $4.234 in profits by simulating our trading strategy on the twelve hour test set predictions, which is equivalent to a percentage gain of 1.22%. The trading simulation concluded the life-cycle of the project.  


