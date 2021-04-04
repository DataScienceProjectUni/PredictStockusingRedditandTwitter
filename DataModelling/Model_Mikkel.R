# Data Modelling Mikkel

# Load libraries
library("readr")
library("lubridate")
library("DataExplorer")
library("caret")

# Load data
gme <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/GME_merged.csv", sep="," )


# Explore data
str(gme)
gme$created_utc <- as.POSIXct(gme$created_utc, format, tryFormats= "%Y-%m-%d %H:%M:%OS")

# Removing the first column
gme <- gme[,-1]


##### 2.3 Missing treatment
plot_missing(gme)

is.na.data.frame(gme)

# We are missing the lead movement for the last day, last hour, but that is expected.
# I will remove that observation from the data frame as it can't be used for any predictions. 

gme <- gme[-48,]

summary(gme)
# There can be obserserved some big differences in the deistributions of sentiment between the different observations.


plot_histogram(gme)
# Genrelly our numeric data looks normally distibuted


plot_bar(gme1$lead_movement)
# Fairly equal distribution of 1 and 0 of the lead movement, which is what we are trying to predict





gme0 <- subset(gme1, lead_movement==0)
gme1 <- subset(gme1, lead_movement==1)

summary(gme0)
summary(gme1)

# Looking at the 2 factors individually, then it can be observed that there is in fact differences in the sentiments between 1 and 0 
# i.e. negative percentage tend to be higher for a 0 in lead_movement 
# and positive tend to be higher for a 1 in lead_movement





# Base naive predictions

table(gme$lead_movement)

#The ratio of 0 and 1
#  0    1 
#  23   24 

# Naive guessing 1 = 0.5106383
# This will be the baseline of our models




# Logistic model

## Testing without the sentiments
gme_base_train <- gme[1:25,c(1:6, 13)]
gme_base_test <- gme[26:47, c(1:6, 13)]

logist.fit <- glm(lead_movement ~ ., family="binomial", data=gme_base_train)

summary(logist.fit)


predictions1 <- predict(logist.fit, newdata=gme_base_test, type="response")

confusionMatrix(factor(ifelse(predictions1 > 0.5, "1", "0")), 
                factor(gme_base_test$lead_movement), positive = "1") 



# Testing using sentiments


gme_train <- gme[1:25,]
gme_test <- gme[26:47,]

trControl <- trainControl(method = 'repeatedcv',
                          number = 5,
                          repeats =  5,
                          search = 'random')


logit.CV <- train(x= gme_train[,-13]  , y= gme_train$lead_movement, 
                  method = 'glmnet',
                  trControl = trControl,
                  family = 'binomial' )



logit.CV
plot(logit.CV)

varImp(logit.CV)

predict(gme_test)



?predict



# Support Vector machines









# Random Forest












# Extreme Gradient Boosting 










# Neural Networks






















