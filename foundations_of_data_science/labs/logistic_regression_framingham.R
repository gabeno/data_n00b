# framingham

library(caTools)
library(ROCR)

framingham <- read.csv('./data/framingham.csv')
str(framingham)

set.seed(1000)
split <- sample.split(framingham$TenYearCHD, SplitRatio = .65)
train <- subset(framingham, split==TRUE)
test <- subset(framingham, split==FALSE)
nrow(test)
nrow(train)

framinghamLogit <- glm(TenYearCHD ~ ., data=framingham, family=binomial)
summary(framinghamLogit)

predictTest = predict(framinghamLogit, type='response', newdata = test)
table(test$TenYearCHD, predictTest > 0.5)

# model accuracy
accuracy <- (1069+17) / (1069 + 10 + 17 + 176)
accuracy

# baseline - no CHD
baseline <- (1069 + 10) / (1069 + 10 + 17 + 176)
baseline

ROCRpred <- prediction(predictTest, test$TenYearCHD)
as.numeric(performance(ROCRpred, "auc")@y.values)
