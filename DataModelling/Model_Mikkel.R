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
gme <- gme[,-c(1:6)]


##### 2.3 Missing treatment
plot_missing(gme)

is.na.data.frame(gme)

# We are missing the lead movement for the last day, last hour, but that is expected.
# I will remove that observation from the data frame as it can't be used for any predictions. 

gme <- gme[-48,]

summary(gme)
# There can be observed some big differences in the distributions of sentiment between the different observations.


plot_histogram(gme)
# Generally our numeric data looks normally distributed


plot_bar(gme$lead_movement)
# Fairly equal distribution of 1 and 0 of the lead movement, which is what we are trying to predict





gme0 <- subset(gme, lead_movement==0)
gme1 <- subset(gme, lead_movement==1)

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

# Naive guessing 1 = 0.5106383  (24/(24+23))
# This will be the baseline of our models



# Splitting the data in train, validation and test sets


gme$lead_movement <- as.factor(gme$lead_movement)

train <- gme[1:34,]

test <- gme[35:47,]


# setting up a time series CV 

trControl <- trainControl(method = 'timeslice',
                          initialWindow = 8,
                          horizon = 6,
                          fixedWindow = FALSE
                          )



# Logistic model


logit.CV <- train(lead_movement ~ ., data = train,
                  method = 'glmnet',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength= 5)


# Making predictions on test data

pred.log <- predict(logit.CV, newdata=test)


confusionMatrix(
  pred.log, 
  test$lead_movement)






# Support Vector machines

library("kernlab")


SVM.CV <- train(lead_movement ~ ., data = train,
                   method = "svmLinear",
                   trControl = trControl,
                   family = 'binomial', 
                   metric = "Accuracy",
                   tuneLength= 5)



# Making predictions on test data

pred.svm <- predict(SVM.CV, newdata=test)


confusionMatrix(
  pred.svm,
  test$lead_movement)



# Radial kernel SVM

RK.SVM.CV <- train(lead_movement ~ ., data = train,
                method = "svmRadial",
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)


pred.rk.svm <- predict(RK.SVM.CV, newdata=test)


confusionMatrix(
  pred.rk.svm,
  test$lead_movement)





# Random Forest

library("rpart")

RF.CV <- train(lead_movement ~ ., data = train,
                             method = "rf",
                             trControl = trControl,
                             family = 'binomial', 
                             metric = "Accuracy",
                             tuneLength= 5)


pred.rf <- predict(RF.CV, newdata=test)


confusionMatrix(
  pred.rf,
  test$lead_movement)







# Extreme Gradient Boosting 


XGB.CV <- train(lead_movement ~ ., data = train, 
                method = 'xgbTree',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)


pred.xgb <- predict(XGB.CV, newdata=test)


confusionMatrix(
  pred.xgb,
  test$lead_movement)




# Comparing the models

resamps <- resamples(list(log = logit.CV,
                          rf = RF.CV,
                          svm = SVM.CV,
                          rk.svm = RK.SVM.CV,
                          xgb = XGB.CV))


# Table

ss <- summary(resamps)

knitr::kable(ss[[3]]$Accuracy)



# Plotting

library(lattice)

trellis.par.set(caretTheme())
dotplot(resamps, metric = "Accuracy")












