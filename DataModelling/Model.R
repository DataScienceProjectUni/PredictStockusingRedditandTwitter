# Data Modelling Mikkel

# Load libraries
library("readr")
library("lubridate")


# Load data
gme <- read.delim("~/R-data/Data Science Project/PredictStockusingRedditandTwitter/PreProcessedData/GME_merged.csv", sep="," )


# Explore data
str(gme)
gme$created_utc <- as.POSIXct(gme$created_utc)


# Base naive predictions





# Logistic model







# Support Vector machines









# Random Forest












# Extreme Gradient Boosting 










# Neural Networks






















