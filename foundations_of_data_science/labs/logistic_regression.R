# linear regression

> install.packages('caTools')
> install.packages('ROCR')
library(caTools)
library(ROCR)

quality <- read.csv('./quality.csv')
str(quality)
table(quality$PoorCare)

# > table(quality$PoorCare)
# 0  1 
# 98 33 
# Baseline accuracy = 98/(98+33) assuming our model predicts everyone correctly.
# > 98/(98+33)
# [1] 0.7480916

set.seed(88)
split <- sample.split(quality$PoorCare, SplitRatio = 0.75)
qualityTrain <- subset(quality, split == TRUE)
qualityTest <- subset(quality, split == FALSE)
nrow(qualityTrain)
nrow(qualityTest)
QualityLog <- glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family = binomial)
summary(QualityLog)
predictTrain = predict(QualityLog, type='response')
summary(predictTrain)
tapply(predictTrain, quality$PoorCare, mean)

# confusion matrix
table(quality$PoorCare, predictTrain > 0.5)

# sensitivity <- 10/25 => 0.4
# specificity <- 70/74 => .9459459

ROCRpred <- prediction(predictTrain, qualityTrain$PoorCare)
ROCRperf <- performance(ROCRpred, 'tpr', 'fpr')
plot(ROCRperf)
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0, 1, 0.1), text.adj=c(-0.2, 1.7))