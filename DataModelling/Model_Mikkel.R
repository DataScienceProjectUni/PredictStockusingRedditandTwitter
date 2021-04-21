# Data Modelling Mikkel

# Load libraries
library("readr")
library("lubridate")
library("DataExplorer")
library("caret")

# Load data
gme <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/GME_merged.csv", sep="," )
amc <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/AMC_merged.csv", sep="," )
bb <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/BB_merged.csv", sep="," )
pltr <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/PLTR_merged.csv", sep="," )
tsla <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/TSLA_merged.csv", sep="," )

# Tickers <- 


# Explore data
str(gme)
gme$created_utc <- as.POSIXct(gme$created_utc, format, tryFormats= "%Y-%m-%d %H:%M:%OS")

# Removing the first columns with
gme <- gme[,-c(1:7)]
amc <- amc[,-c(1:7)]
bb <- bb[,-c(1:7)]
pltr <- pltr[,-c(1:7)]
tsla <- tsla[,-c(1:7)]


##### 2.3 Missing treatment
plot_missing(gme)

is.na.data.frame(gme)

# We are missing the lead movement for the last day, last hour, but that is expected.
# I will remove that observation from the data frame as it can't be used for any predictions. 

gme <- gme[-48,]
amc <- amc[-48,]
bb <- bb[-48,]
pltr <- pltr[-48,]
tsla <- tsla[-48,]

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
amc$lead_movement <- as.factor(amc$lead_movement)
bb$lead_movement <- as.factor(bb$lead_movement)
pltr$lead_movement <- as.factor(pltr$lead_movement)
tsla$lead_movement <- as.factor(tsla$lead_movement)



# lag 1
library("dplyr")

gme$pos_lag1 <- dplyr::lag(gme[ , 1], 1L)
gme$sup_lag1 <- dplyr::lag(gme[ , 4], 1L)


# lag 2
gme$pos_lag2 <- dplyr::lag(gme[ , 1], 2L)
gme$sup_lag2 <- dplyr::lag(gme[ , 4], 2L)


# lag 3
gme$pos_lag3 <- dplyr::lag(gme[ , 1], 3L)
gme$sup_lag3 <- dplyr::lag(gme[ , 4], 3L)


#gme$lag2 <- dplyr::lag(gme[ , 1:6], 2L)
#gme$lag3 <- dplyr::lag(gme[ , 1:6], 3L)



# Splitting the data in 70% training and 30% testing

train.gme <- gme[4:32,]
train.amc <- amc[1:32,]
train.tsla <- tsla[1:32,]
train.bb <- bb[1:32,]
train.pltr <- pltr[1:32,]


test.gme <- gme[33:47,]
test.amc <- amc[33:47,]
test.tsla <- tsla[33:47,]
test.bb <- bb[33:47,]
test.pltr <- pltr[33:47,]

# setting up a time series CV 

trControl <- trainControl(method = 'timeslice',
                          initialWindow = 8,
                          horizon = 6,
                          fixedWindow = FALSE
                          )






********************************** Models GME *************************************

# Logistic model

set.seed(2)
logit.CV <- train(lead_movement ~ ., data = train.gme,
                  method = 'glmnet',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength= 5)


varImp(logit.CV)














# Making predictions on test data

pred.log <- predict(logit.CV, newdata=test.gme)


cm.log <- confusionMatrix(
          pred.log, 
         test$lead_movement)

varImp(logit.CV)

# Can see that movement doesn't make sense to include in our model as it just makes noise
Overall
constraining_percent 100.0000
litigious_percent     13.6368
superfluous_percent   10.7325
positive_percent       8.7572
negative_percent       0.6823
uncertainty_percent    0.0000
movement               0.0000






# Step GLM

set.seed(2)
STEP.GLM.CV <- train(lead_movement ~ ., data = train.gme,
                  method = 'glmStepAIC',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength= 5)


# Making predictions on test data

STEP.GLM.CV$finalModel

pred.STEP <- predict(STEP.GLM.CV, newdata=test)


cm.step.glm <- confusionMatrix(
               pred.STEP, 
               test$lead_movement)






# Support Vector machines

set.seed(1)
SVM.CV <- train(lead_movement ~ ., data = train.gme,
                   method = "svmLinear",
                   trControl = trControl,
                   family = 'binomial', 
                   metric = "Accuracy",
                   tuneLength= 5)



# Making predictions on test data

pred.svm <- predict(SVM.CV, newdata=test)


cm.svm <- confusionMatrix(
           pred.svm,
           test$lead_movement)






# Radial kernel SVM

set.seed(1)
RK.SVM.CV <- train(lead_movement ~ ., data = train.gme,
                method = "svmRadial",
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)


pred.rk.svm <- predict(RK.SVM.CV, newdata=test)


cm.svm.rk <- confusionMatrix(
            pred.rk.svm,
             test$lead_movement)







# SVM polynomial

set.seed(2)
SVM.POLY.CV <- train(lead_movement ~ ., data = train.gme, 
                method = 'svmPoly',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)


pred.svm.poly <- predict(SVM.POLY.CV, newdata=test.gme)


cm.svm.poly <- confusionMatrix(
  pred.svm.poly,
  test$lead_movement)







# Random Forest

library("rpart")

set.seed(1)
RF.CV <- train(lead_movement ~ ., data = train.gme,
                             method = "rf",
                             trControl = trControl,
                             family = 'binomial', 
                             metric = "Accuracy",
                             tuneLength= 5)

pred.rf <- predict(RF.CV, newdata=test)


cm.rf <- confusionMatrix(
            pred.rf,
            test$lead_movement)






# KNN

set.seed(1)
KNN.CV <- train(lead_movement ~ ., data = train.gme, 
                method = 'kknn',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)


pred.knn <- predict(KNN.CV, newdata=test.gme)


cm.knn <- confusionMatrix(
  pred.knn,
  test$lead_movement)








# Extreme Gradient Boosting 

set.seed(1)
XGB.CV <- train(lead_movement ~ ., data = train.gme, 
                method = 'xgbTree',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)


pred.xgb <- predict(XGB.CV, newdata=test)


cm.xgb <- confusionMatrix(
           pred.xgb,
           test$lead_movement)












# Comparing the models

resamps <- resamples(list(log = logit.CV,
                          step.glm = STEP.GLM.CV,
                          rf = RF.CV,
                          svm = SVM.CV,
                          svm.rk = RK.SVM.CV,
                          svm.poly = SVM.POLY.CV,
                          knn = KNN.CV,
                          xgb = XGB.CV))



resamps <- resamples(list(log = logit.CV,
                          step.glm = STEP.GLM.CV,
                          rf = RF.CV,
                          svm = SVM.CV,
                          svm.rk = RK.SVM.CV,
                          svm.poly = SVM.POLY.CV,
                          knn = KNN.CV,
                          xgb = XGB.CV))



# Table

ss <- summary(resamps)

knitr::kable(ss[[3]]$Accuracy)



# Plotting

library(lattice)

trellis.par.set(caretTheme())
dotplot(resamps, metric = "Accuracy")






cm.matrix <- rbind(cm.log$overall[1],
                   cm.


