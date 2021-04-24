# Data Modelling Mikkel

# Load libraries
library("readr")
library("lubridate")
library("DataExplorer")
library("caret")
library("dplyr")
library("lattice")

# Load data
gme <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/GME_merged.csv", sep="," )
amc <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/AMC_merged.csv", sep="," )
bb <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/BB_merged.csv", sep="," )
pltr <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/PLTR_merged.csv", sep="," )
tsla <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/TSLA_merged.csv", sep="," )

# Tickers <- 


# Explore data
str(gme)

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



# Making sure that our response, lead movement is a factor

gme$lead_movement <- as.factor(gme$lead_movement)
amc$lead_movement <- as.factor(amc$lead_movement)
bb$lead_movement <- as.factor(bb$lead_movement)
pltr$lead_movement <- as.factor(pltr$lead_movement)
tsla$lead_movement <- as.factor(tsla$lead_movement)



# adding the lagged variables of the sentiments to each of the data sets
# lag 1 gme
gme$pos_lag1 <- dplyr::lag(gme[ , 1], 1L)
gme$neg_lag1 <- dplyr::lag(gme[ , 2], 1L)
gme$lit_lag1 <- dplyr::lag(gme[ , 3], 1L)
gme$sup_lag1 <- dplyr::lag(gme[ , 4], 1L)
gme$con_lag1 <- dplyr::lag(gme[ , 5], 1L)
gme$unc_lag1 <- dplyr::lag(gme[ , 6], 1L)

# lag 2 gme
gme$pos_lag2 <- dplyr::lag(gme[ , 1], 2L)
gme$neg_lag2 <- dplyr::lag(gme[ , 2], 2L)
gme$lit_lag2 <- dplyr::lag(gme[ , 3], 2L)
gme$sup_lag2 <- dplyr::lag(gme[ , 4], 2L)
gme$con_lag2 <- dplyr::lag(gme[ , 5], 2L)
gme$unc_lag2 <- dplyr::lag(gme[ , 6], 2L)

# lag 3 gme
gme$pos_lag3 <- dplyr::lag(gme[ , 1], 3L)
gme$neg_lag3 <- dplyr::lag(gme[ , 2], 3L)
gme$lit_lag3 <- dplyr::lag(gme[ , 3], 3L)
gme$sup_lag3 <- dplyr::lag(gme[ , 4], 3L)
gme$con_lag3 <- dplyr::lag(gme[ , 5], 3L)
gme$unc_lag3 <- dplyr::lag(gme[ , 6], 3L)


*************** AMC*************
# lag 1 amc
amc$pos_lag1 <- dplyr::lag(amc[ , 1], 1L)
amc$neg_lag1 <- dplyr::lag(amc[ , 2], 1L)
amc$lit_lag1 <- dplyr::lag(amc[ , 3], 1L)
amc$sup_lag1 <- dplyr::lag(amc[ , 4], 1L)
amc$con_lag1 <- dplyr::lag(amc[ , 5], 1L)
amc$unc_lag1 <- dplyr::lag(amc[ , 6], 1L)

# lag 2 amc
amc$pos_lag2 <- dplyr::lag(amc[ , 1], 2L)
amc$neg_lag2 <- dplyr::lag(amc[ , 2], 2L)
amc$lit_lag2 <- dplyr::lag(amc[ , 3], 2L)
amc$sup_lag2 <- dplyr::lag(amc[ , 4], 2L)
amc$con_lag2 <- dplyr::lag(amc[ , 5], 2L)
amc$unc_lag2 <- dplyr::lag(amc[ , 6], 2L)

# lag 3 amc
amc$pos_lag3 <- dplyr::lag(amc[ , 1], 3L)
amc$neg_lag3 <- dplyr::lag(amc[ , 2], 3L)
amc$lit_lag3 <- dplyr::lag(amc[ , 3], 3L)
amc$sup_lag3 <- dplyr::lag(amc[ , 4], 3L)
amc$con_lag3 <- dplyr::lag(amc[ , 5], 3L)
amc$unc_lag3 <- dplyr::lag(amc[ , 6], 3L)


*************** BB *************
# lag 1 bb
bb$pos_lag1 <- dplyr::lag(bb[ , 1], 1L)
bb$neg_lag1 <- dplyr::lag(bb[ , 2], 1L)
bb$lit_lag1 <- dplyr::lag(bb[ , 3], 1L)
bb$sup_lag1 <- dplyr::lag(bb[ , 4], 1L)
bb$con_lag1 <- dplyr::lag(bb[ , 5], 1L)
bb$unc_lag1 <- dplyr::lag(bb[ , 6], 1L)

# lag 2 bb
bb$pos_lag2 <- dplyr::lag(bb[ , 1], 2L)
bb$neg_lag2 <- dplyr::lag(bb[ , 2], 2L)
bb$lit_lag2 <- dplyr::lag(bb[ , 3], 2L)
bb$sup_lag2 <- dplyr::lag(bb[ , 4], 2L)
bb$con_lag2 <- dplyr::lag(bb[ , 5], 2L)
bb$unc_lag2 <- dplyr::lag(bb[ , 6], 2L)

# lag 3 bb
bb$pos_lag3 <- dplyr::lag(bb[ , 1], 3L)
bb$neg_lag3 <- dplyr::lag(bb[ , 2], 3L)
bb$lit_lag3 <- dplyr::lag(bb[ , 3], 3L)
bb$sup_lag3 <- dplyr::lag(bb[ , 4], 3L)
bb$con_lag3 <- dplyr::lag(bb[ , 5], 3L)
bb$unc_lag3 <- dplyr::lag(bb[ , 6], 3L)
  
  
*************** PLTR *************
# lag 1 pltr
pltr$pos_lag1 <- dplyr::lag(pltr[ , 1], 1L)
pltr$neg_lag1 <- dplyr::lag(pltr[ , 2], 1L)
pltr$lit_lag1 <- dplyr::lag(pltr[ , 3], 1L)
pltr$sup_lag1 <- dplyr::lag(pltr[ , 4], 1L)
pltr$con_lag1 <- dplyr::lag(pltr[ , 5], 1L)
pltr$unc_lag1 <- dplyr::lag(pltr[ , 6], 1L)

# lag 2 pltr
pltr$pos_lag2 <- dplyr::lag(pltr[ , 1], 2L)
pltr$neg_lag2 <- dplyr::lag(pltr[ , 2], 2L)
pltr$lit_lag2 <- dplyr::lag(pltr[ , 3], 2L)
pltr$sup_lag2 <- dplyr::lag(pltr[ , 4], 2L)
pltr$con_lag2 <- dplyr::lag(pltr[ , 5], 2L)
pltr$unc_lag2 <- dplyr::lag(pltr[ , 6], 2L)

# lag 3 pltr
pltr$pos_lag3 <- dplyr::lag(pltr[ , 1], 3L)
pltr$neg_lag3 <- dplyr::lag(pltr[ , 2], 3L)
pltr$lit_lag3 <- dplyr::lag(pltr[ , 3], 3L)
pltr$sup_lag3 <- dplyr::lag(pltr[ , 4], 3L)
pltr$con_lag3 <- dplyr::lag(pltr[ , 5], 3L)
pltr$unc_lag3 <- dplyr::lag(pltr[ , 6], 3L)
  
  
*************** TSLA *************
# lag 1 tsla
tsla$pos_lag1 <- dplyr::lag(tsla[ , 1], 1L)
tsla$neg_lag1 <- dplyr::lag(tsla[ , 2], 1L)
tsla$lit_lag1 <- dplyr::lag(tsla[ , 3], 1L)
tsla$sup_lag1 <- dplyr::lag(tsla[ , 4], 1L)
tsla$con_lag1 <- dplyr::lag(tsla[ , 5], 1L)
tsla$unc_lag1 <- dplyr::lag(tsla[ , 6], 1L)

# lag 2 tsla
tsla$pos_lag2 <- dplyr::lag(tsla[ , 1], 2L)
tsla$neg_lag2 <- dplyr::lag(tsla[ , 2], 2L)
tsla$lit_lag2 <- dplyr::lag(tsla[ , 3], 2L)
tsla$sup_lag2 <- dplyr::lag(tsla[ , 4], 2L)
tsla$con_lag2 <- dplyr::lag(tsla[ , 5], 2L)
tsla$unc_lag2 <- dplyr::lag(tsla[ , 6], 2L)

# lag 3 tsla
tsla$pos_lag3 <- dplyr::lag(tsla[ , 1], 3L)
tsla$neg_lag3 <- dplyr::lag(tsla[ , 2], 3L)
tsla$lit_lag3 <- dplyr::lag(tsla[ , 3], 3L)
tsla$sup_lag3 <- dplyr::lag(tsla[ , 4], 3L)
tsla$con_lag3 <- dplyr::lag(tsla[ , 5], 3L)
tsla$unc_lag3 <- dplyr::lag(tsla[ , 6], 3L)
  
  
  
# Splitting the data in 70% training and 30% testing and staring from obs 4
# As there are no lagges sentimetns from the forst 3 observations 

train.gme <- gme[4:35,]
train.amc <- amc[4:35,]
train.tsla <- tsla[4:35,]
train.bb <- bb[4:35,]
train.pltr <- pltr[4:35,]


test.gme <- gme[36:47,]
test.amc <- amc[36:47,]
test.tsla <- tsla[36:47,]
test.bb <- bb[36:47,]
test.pltr <- pltr[36:47,]


# setting up a time series CV 

trControl <- trainControl(method = 'timeslice',
                          initialWindow = 8,
                          horizon = 6,
                          fixedWindow = FALSE
                          )



********************************** Models GME *************************************

# Logistic model
set.seed(2)
logit.gme <- train(lead_movement ~ ., data = train.gme,
                  method = 'glmnet',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength = 5)


varImp(logit.gme)

# Can see that movement doesn't make sense to include in our model as it just makes noise



# Step GLM
set.seed(2)
STEP.GLM.gme <- train(lead_movement ~ ., data = train.gme,
                  method = 'glmStepAIC',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength= 5)


# Support Vector machines
set.seed(2)
SVM.gme <- train(lead_movement ~ ., data = train.gme,
                   method = "svmLinear",
                   trControl = trControl,
                   family = 'binomial', 
                   metric = "Accuracy",
                   tuneLength= 5)


# Radial kernel SVM
set.seed(2)
RK.SVM.gme <- train(lead_movement ~ ., data = train.gme,
                method = "svmRadial",
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)



# SVM polynomial
set.seed(2)
POLY.SVM.gme <- train(lead_movement ~ ., data = train.gme, 
                method = 'svmPoly',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)



# Random Forest
set.seed(2)
RF.gme <- train(lead_movement ~ ., data = train.gme,
                             method = "rf",
                             trControl = trControl,
                             family = 'binomial', 
                             metric = "Accuracy",
                             tuneLength = 5)

# KNN
set.seed(2)
KNN.gme <- train(lead_movement ~ ., data = train.gme, 
                method = 'kknn',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength = 5)



# Extreme Gradient Boosting 
set.seed(2)
XGB.gme <- train(lead_movement ~ ., data = train.gme, 
                method = 'xgbTree',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)



# Comparing the models for GME
resamps.gme <- resamples(list(log = logit.gme,
                          step.glm = STEP.GLM.gme,
                          rf = RF.gme,
                          svm = SVM.gme,
                          svm.rk = RK.SVM.gme,
                          svm.poly = POLY.SVM.gme,
                          knn = KNN.gme,
                          xgb = XGB.gme))


# Comparing with a Table
ss.gme <- summary(resamps.gme)
knitr::kable(ss.gme[[3]]$Accuracy)


# Plotting the accuracies on the validation sets
trellis.par.set(caretTheme())
dotplot(resamps.gme, metric = "Accuracy", main = "GME Validation Accuracy", ylab = "Models")





********************************** Models AMC *************************************

# Logistic model
set.seed(2)
logit.amc <- train(lead_movement ~ ., data = train.amc,
                   method = 'glmnet',
                   trControl = trControl,
                   family = 'binomial', 
                   metric = "Accuracy",
                   tuneLength = 5)


varImp(logit.amc)

# Can see that movement doesn't make sense to include in our model as it just makes noise



# Step GLM
set.seed(2)
STEP.GLM.amc <- train(lead_movement ~ ., data = train.amc,
                      method = 'glmStepAIC',
                      trControl = trControl,
                      family = 'binomial', 
                      metric = "Accuracy",
                      tuneLength= 5)


# Support Vector machines
set.seed(2)
SVM.amc <- train(lead_movement ~ ., data = train.amc,
                 method = "svmLinear",
                 trControl = trControl,
                 family = 'binomial', 
                 metric = "Accuracy",
                 tuneLength= 5)


# Radial kernel SVM
set.seed(2)
RK.SVM.amc <- train(lead_movement ~ ., data = train.amc,
                    method = "svmRadial",
                    trControl = trControl,
                    family = 'binomial', 
                    metric = "Accuracy",
                    tuneLength= 5)



# SVM polynomial
set.seed(2)
POLY.SVM.amc <- train(lead_movement ~ ., data = train.amc, 
                      method = 'svmPoly',
                      trControl = trControl,
                      family = 'binomial', 
                      metric = "Accuracy",
                      tuneLength= 5)



# Random Forest
set.seed(2)
RF.amc <- train(lead_movement ~ ., data = train.amc,
                method = "rf",
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength = 5)

# KNN
set.seed(2)
KNN.amc <- train(lead_movement ~ ., data = train.amc, 
                 method = 'kknn',
                 trControl = trControl,
                 family = 'binomial', 
                 metric = "Accuracy",
                 tuneLength = 5)



# Extreme Gradient Boosting 
set.seed(2)
XGB.amc <- train(lead_movement ~ ., data = train.amc, 
                 method = 'xgbTree',
                 trControl = trControl,
                 family = 'binomial', 
                 metric = "Accuracy",
                 tuneLength= 5)



# Comparing the models for GME
resamps.amc <- resamples(list(log = logit.amc,
                              step.glm = STEP.GLM.amc,
                              rf = RF.amc,
                              svm = SVM.amc,
                              svm.rk = RK.SVM.amc,
                              svm.poly = POLY.SVM.amc,
                              knn = KNN.amc,
                              xgb = XGB.amc))


# Comparing with a Table
ss.amc <- summary(resamps.amc)
knitr::kable(ss.amc[[3]]$Accuracy)


# Plotting the accuracies on the validation sets
trellis.par.set(caretTheme())
dotplot(resamps.amc, metric = "Accuracy", main = "AMC Validation Accuracy", ylab = "Models")




********************************** Models BB *************************************
  
# Logistic model
set.seed(2)
logit.bb <- train(lead_movement ~ ., data = train.bb,
                   method = 'glmnet',
                   trControl = trControl,
                   family = 'binomial', 
                   metric = "Accuracy",
                   tuneLength = 5)


varImp(logit.bb)

# Can see that movement doesn't make sense to include in our model as it just makes noise



# Step GLM
set.seed(2)
STEP.GLM.bb <- train(lead_movement ~ ., data = train.bb,
                      method = 'glmStepAIC',
                      trControl = trControl,
                      family = 'binomial', 
                      metric = "Accuracy",
                      tuneLength= 5)


# Support Vector machines
set.seed(2)
SVM.bb <- train(lead_movement ~ ., data = train.bb,
                 method = "svmLinear",
                 trControl = trControl,
                 family = 'binomial', 
                 metric = "Accuracy",
                 tuneLength= 5)


# Radial kernel SVM
set.seed(2)
RK.SVM.bb <- train(lead_movement ~ ., data = train.bb,
                    method = "svmRadial",
                    trControl = trControl,
                    family = 'binomial', 
                    metric = "Accuracy",
                    tuneLength= 5)



# SVM polynomial
set.seed(2)
POLY.SVM.bb <- train(lead_movement ~ ., data = train.bb, 
                      method = 'svmPoly',
                      trControl = trControl,
                      family = 'binomial', 
                      metric = "Accuracy",
                      tuneLength= 5)



# Random Forest
set.seed(2)
RF.bb <- train(lead_movement ~ ., data = train.bb,
                method = "rf",
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength = 5)

# KNN
set.seed(2)
KNN.bb <- train(lead_movement ~ ., data = train.bb, 
                 method = 'kknn',
                 trControl = trControl,
                 family = 'binomial', 
                 metric = "Accuracy",
                 tuneLength = 5)



# Extreme Gradient Boosting 
set.seed(2)
XGB.bb <- train(lead_movement ~ ., data = train.bb, 
                 method = 'xgbTree',
                 trControl = trControl,
                 family = 'binomial', 
                 metric = "Accuracy",
                 tuneLength= 5)



# Comparing the models for GME
resamps.bb <- resamples(list(log = logit.bb,
                              step.glm = STEP.GLM.bb,
                              rf = RF.bb,
                              svm = SVM.bb,
                              svm.rk = RK.SVM.bb,
                              svm.poly = POLY.SVM.bb,
                              knn = KNN.bb,
                              xgb = XGB.bb))


# Comparing with a Table
ss.bb <- summary(resamps.bb)
knitr::kable(ss.bb[[3]]$Accuracy)


# Plotting the accuracies on the validation sets
trellis.par.set(caretTheme())
dotplot(resamps.bb, metric = "Accuracy", main = "BB Validation Accuracy", ylab = "Models")
  


********************************** Models PLTR *************************************
  
# Logistic model
set.seed(2)
logit.pltr <- train(lead_movement ~ ., data = train.pltr,
                  method = 'glmnet',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength = 5)


varImp(logit.pltr)

# Can see that movement doesn't make sense to include in our model as it just makes noise



# Step GLM
set.seed(2)
STEP.GLM.pltr <- train(lead_movement ~ ., data = train.pltr,
                     method = 'glmStepAIC',
                     trControl = trControl,
                     family = 'binomial', 
                     metric = "Accuracy",
                     tuneLength= 5)


# Support Vector machines
set.seed(2)
SVM.pltr <- train(lead_movement ~ ., data = train.pltr,
                method = "svmLinear",
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)


# Radial kernel SVM
set.seed(2)
RK.SVM.pltr <- train(lead_movement ~ ., data = train.pltr,
                   method = "svmRadial",
                   trControl = trControl,
                   family = 'binomial', 
                   metric = "Accuracy",
                   tuneLength= 5)



# SVM polynomial
set.seed(2)
POLY.SVM.pltr <- train(lead_movement ~ ., data = train.pltr, 
                     method = 'svmPoly',
                     trControl = trControl,
                     family = 'binomial', 
                     metric = "Accuracy",
                     tuneLength= 5)



# Random Forest
set.seed(2)
RF.pltr <- train(lead_movement ~ ., data = train.pltr,
               method = "rf",
               trControl = trControl,
               family = 'binomial', 
               metric = "Accuracy",
               tuneLength = 5)

# KNN
set.seed(2)
KNN.pltr <- train(lead_movement ~ ., data = train.pltr, 
                method = 'kknn',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength = 5)



# Extreme Gradient Boosting 
set.seed(2)
XGB.pltr <- train(lead_movement ~ ., data = train.pltr, 
                method = 'xgbTree',
                trControl = trControl,
                family = 'binomial', 
                metric = "Accuracy",
                tuneLength= 5)



# Comparing the models for GME
resamps.pltr <- resamples(list(log = logit.pltr,
                             step.glm = STEP.GLM.pltr,
                             rf = RF.pltr,
                             svm = SVM.pltr,
                             svm.rk = RK.SVM.pltr,
                             svm.poly = POLY.SVM.pltr,
                             knn = KNN.pltr,
                             xgb = XGB.pltr))


# Comparing with a Table
ss.pltr <- summary(resamps.pltr)
knitr::kable(ss.pltr[[3]]$Accuracy)


# Plotting the accuracies on the validation sets
trellis.par.set(caretTheme())
dotplot(resamps.pltr, metric = "Accuracy", main = "PLTR Validation Accuracy", ylab = "Models")
  
  


********************************** Models TSLA *************************************
# Logistic model
set.seed(2)
logit.tsla <- train(lead_movement ~ ., data = train.tsla,
                    method = 'glmnet',
                    trControl = trControl,
                    family = 'binomial', 
                    metric = "Accuracy",
                    tuneLength = 5)


varImp(logit.tsla)

# Can see that movement doesn't make sense to include in our model as it just makes noise



# Step GLM
set.seed(2)
STEP.GLM.tsla <- train(lead_movement ~ ., data = train.tsla,
                       method = 'glmStepAIC',
                       trControl = trControl,
                       family = 'binomial', 
                       metric = "Accuracy",
                       tuneLength= 5)


# Support Vector machines
set.seed(2)
SVM.tsla <- train(lead_movement ~ ., data = train.tsla,
                  method = "svmLinear",
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength= 5)


# Radial kernel SVM
set.seed(2)
RK.SVM.tsla <- train(lead_movement ~ ., data = train.tsla,
                     method = "svmRadial",
                     trControl = trControl,
                     family = 'binomial', 
                     metric = "Accuracy",
                     tuneLength= 5)



# SVM polynomial
set.seed(2)
POLY.SVM.tsla <- train(lead_movement ~ ., data = train.tsla, 
                       method = 'svmPoly',
                       trControl = trControl,
                       family = 'binomial', 
                       metric = "Accuracy",
                       tuneLength= 5)



# Random Forest
set.seed(2)
RF.tsla <- train(lead_movement ~ ., data = train.tsla,
                 method = "rf",
                 trControl = trControl,
                 family = 'binomial', 
                 metric = "Accuracy",
                 tuneLength = 5)

# KNN
set.seed(2)
KNN.tsla <- train(lead_movement ~ ., data = train.tsla, 
                  method = 'kknn',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength = 5)



# Extreme Gradient Boosting 
set.seed(2)
XGB.tsla <- train(lead_movement ~ ., data = train.tsla, 
                  method = 'xgbTree',
                  trControl = trControl,
                  family = 'binomial', 
                  metric = "Accuracy",
                  tuneLength= 5)



# Comparing the models for GME
resamps.tsla <- resamples(list(log = logit.tsla,
                               step.glm = STEP.GLM.tsla,
                               rf = RF.tsla,
                               svm = SVM.tsla,
                               svm.rk = RK.SVM.tsla,
                               svm.poly = POLY.SVM.tsla,
                               knn = KNN.tsla,
                               xgb = XGB.tsla))


# Comparing with a Table
ss.tsla <- summary(resamps.tsla)
knitr::kable(ss.tsla[[3]]$Accuracy)


# Plotting the accuracies on the validation sets
trellis.par.set(caretTheme())
dotplot(resamps.tsla, metric = "Accuracy", main = "TSLA Validation Accuracy", ylab = "Models")




  
********************************** Predictions on Test data *************************************

# Making predictions on test data with the best model
pred <- predict(POLY.SVM.tsla, newdata=test.tsla)

cm <- confusionMatrix(
  pred, 
  test.tsla$lead_movement)





