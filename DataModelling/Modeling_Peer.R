# Data Modelling Mikkel

# Load libraries
library("readr")
library("lubridate")
library("DataExplorer")
library("caret")
library(caTools)
library(e1071)

# Load data
 gme <- read.delim("~/Desktop/Uni/BI/2. semester/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/GME_merged.csv", sep="," )

#plot sentments over time (all sentiments)
library(ggplot2)
library(reshape2)


gme.plot <- gme[,c(1, 8:13)]
gme.plot[2:7] <- scale(gme.plot[2:7], scale = T, center = T)
gme.plot <- melt(gme.plot)
str(gme.plot)
#create line plot for each column in data frame
ggplot(gme.plot, aes(created_utc, value, group = variable)) +
  geom_line(aes(colour = variable)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#plot sentments over time (positive, negative, uncertainty
library(ggplot2)
library(reshape2)


gme.plot <- gme[,c(1,5, 8:9,13)]
gme.plot[2:5] <- scale(gme.plot[2:5], scale = T, center = T)
gme.plot <- melt(gme.plot)
str(gme.plot)
#create line plot for each column in data frame
ggplot(gme.plot, aes(created_utc, value, group = variable)) +
  geom_line(aes(colour = variable, size = variable)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_size_manual(values = c("close" = 1.5, "positive_percent" = 0.5, "negative_percent" = 0.5,"uncertainty_percent" = 0.5))


#plot sentments over time (positive)
library(ggplot2)
library(reshape2)


gme.plot <- gme[,c(1,5, 8)]
gme.plot[2:3] <- scale(gme.plot[2:3], scale = T, center = T)
gme.plot <- melt(gme.plot)
str(gme.plot)
#create line plot for each column in data frame
ggplot(gme.plot, aes(created_utc, value, group = variable)) +
  geom_line(aes(colour = variable, size = variable)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_size_manual(values = c("close" = 1.5, "positive_percent" = 0.5))


#plot sentments over time (negative)
library(ggplot2)
library(reshape2)


gme.plot <- gme[,c(1,5, 9)]
gme.plot[2:3] <- scale(gme.plot[2:3], scale = T, center = T)
gme.plot <- melt(gme.plot)
str(gme.plot)
#create line plot for each column in data frame
ggplot(gme.plot, aes(created_utc, value, group = variable)) +
  geom_line(aes(colour = variable, size = variable)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_size_manual(values = c("close" = 1.5, "negative_percent" = 0.5))

#plot sentments over time (uncertainty)
library(ggplot2)
library(reshape2)


gme.plot <- gme[,c(1,5, 13)]
gme.plot[2:3] <- scale(gme.plot[2:3], scale = T, center = T)
gme.plot <- melt(gme.plot)
str(gme.plot)
#create line plot for each column in data frame
ggplot(gme.plot, aes(created_utc, value, group = variable)) +
  geom_line(aes(colour = variable, size = variable)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_size_manual(values = c("close" = 1.5, "uncertainty_percent" = 0.5))

# PLOTTING USINF VEGALITE
#devtools::install_github("hrbrmstr/vegalite")
library(vegalite)

gme.plot <- gme[,c(1,5, 8:13)]
gme.plot[2:8] <- scale(gme.plot[2:8], scale = T, center = T)
gme.plot <- melt(gme.plot)
gme.plot[,2] <- as.character(gme.plot[,2])

reticulate::use_python("/Users/peerwoyzcechowski/venv38/bin/python", required = TRUE)
reticulate::use_condaenv("venv38")
install.packages("altair")
library("altair")
install_altair()

chart <- 
  alt$Chart(gme.plot())$
  mark_line()$
  encode(
    x = alt$X("created_utc", type = "temporal"),
    y = alt$Y("value", type = "quantitative"),
    color = alt$Color("variable", type = "nominal")
    )

vegawidget(chart)


csv <- read.csv("https://vega.github.io/vega-editor/app/data/stocks.csv")
vegalite(viewport_height=500) %>%
  cell_size(400, 400) %>%
  add_data("https://vega.github.io/vega-editor/app/data/stocks.csv") %>%
  encode_x("date", "temporal") %>%
  encode_y("price", "quantitative") %>%
  encode_color("symbol", "nominal") %>%
  mark_line()

# DO GRANGER CORRELATION TEST

# Explore data
str(gme) 
head(gme)
gme$created_utc <- as.POSIXct(gme$created_utc, format, tryFormats= "%Y-%m-%d %H:%M:%S", tz="UTC")

# Removing the first and lead column column
gme <- gme[,-c(1,7)]
str(gme)

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


plot_bar(gme$lead_movement)
# Fairly equal distribution of 1 and 0 of the lead movement, which is what we are trying to predict





gme0 <- subset(gme, lead_movement==0)
gme1 <- subset(gme, lead_movement==1)

summary(gme0)
summary(gme1)

# Looking at the 2 factors individually, then it can be observed that there is in fact differences in the sentiments between 1 and 0 
# i.e. negative percentage tend to be higher for a 0 in lead_movement 
# and positive tend to be higher for a 1 in lead_movement

# significant difference between groups



# Base naive predictions

table(gme$lead_movement)

#The ratio of 0 and 1
#  0    1 
#  23   24 

# Naive guessing 1 = 0.5106383
# This will be the baseline of our models




# Logistic model
head(gme)
## Testing without the sentiments
train <- gme[1:25, -c(1:5)]
test <- gme[26:47, -c(1:5)]

log.fit <- glm(lead_movement ~ ., family="binomial", data=train)

summary(log.fit)


pred <- predict(log.fit, newdata=test, type="response")
pred
confusionMatrix(factor(ifelse(pred > 0.5, "1", "0")), 
                factor(test$lead_movement), positive = "1") 


# Predictions on test data
log.pred <- predict(log.fit, newdata = test , type = "response")

#ROC & AUC
colAUC(log.pred, test$lead_movement, plotROC =T)



## Support Vector machines
#  To run a SV machines you need to establish the parameter "cost"
#  use tune() to search for the best cost among a range of possible values

set.seed(1)

tune.linear <- tune(svm, lead_movement ~ ., data = train, kernel = "linear", ranges = list(cost = 10^seq(-2, 1, by = 0.25), gamma=c(0.5,1,2,3,4)))

summary(tune.linear)
tune.linear$best.parameters$cost
tune.linear$best.parameters$gamma
# at 0.2825788 cost, lowest error

svm.linear <- svm(lead_movement ~ ., kernel = "linear", data = train, cost = tune.linear$best.parameter$cost, gamma=tune.linear$best.parameter$gamma)
summary(svm.linear)


svm.linear.pred <- predict(svm.linear, test)

confusionMatrix(factor(ifelse(svm.linear.pred > 0.5, "1", "0")), 
                factor(test$lead_movement), positive = "1") 

#ROC & AUC
colAUC(svm.linear.pred, test$lead_movement, plotROC =T)
# extremely high sensistivity but low specificity only .45 accuracy
# worse than baseline model



# Support vector machine - with radial kernel
set.seed(1)

tune.nonlinear <- tune(svm, lead_movement ~ ., data = train, kernel = "radial", ranges = list(cost = 10^seq(-2, 1, by = 0.25), gamma=c(0.5,1,2,3,4)))

summary(tune.nonlinear)
tune.nonlinear$best.parameters$cost

#  now train the model with the tuned parameters
svm.nonlinear <- svm(lead_movement ~ .,method ="C-classification", kernel = "radial", data = train, cost = tune.nonlinear$best.parameter$cost, gamma=tune.nonlinear$best.parameter$gamma)

svm.nonlinear.pred <- predict(svm.nonlinear, test)

confusionMatrix(factor(ifelse(svm.nonlinear.pred > 0.5, "1", "0")), 
                factor(test$lead_movement), positive = "1") 

#ROC & AUC
colAUC(svm.nonlinear.pred, test$lead_movement, plotROC =T)










# Random Forest












# Extreme Gradient Boosting 










# Neural Networks






















