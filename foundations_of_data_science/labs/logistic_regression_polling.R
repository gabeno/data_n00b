library(mice)

polling <- read.csv('./data/PollingData.csv')
str(polling)

# pollsters were so sure of the outcomes of the 5 missing states that it is
# safe to go ahead with this data.
# > table(polling$Year)
# 2004 2008 2012 
# 50   50   45
table(polling$Year)

# Rasmussen and SurveyUSA has decent count of NAs
summary(polling)

# set missing values based on existing ones.
simple <- polling[c('Rasmussen', 'SurveyUSA', 'PropR', 'DiffCount')]
summary(simple)
set.seed(144)
imputed <- complete(mice(simple))
summary(imputed)
polling$Rasmussen <- imputed$Rasmussen
polling$SurveyUSA <- imputed$SurveyUSA
summary(polling)

# split data based on year
Train <- subset(polling, Year == 2004 | Year == 2008)
Test <- subset(polling, Year == 2012)
table(Train$Republican)

# baseline
table(sign(Train$Rasmussen))
table(Train$Republican, sign(Train$Rasmussen))

# Logistic regression method
cor(Train)
cor(Train[c('Rasmussen', 'SurveyUSA', 'DiffCount', 'PropR', 'Republican')])
# PropR has the highest correlation to the dependent variable Republican .94
# using it for modelling
mod1 <- glm(Republican ~ PropR, data=Train, family = binomial)
summary(mod1)

# prediction
pred1 <- predict(mod1, type='response')
table(Train$Republican, pred1 >= 0.5) # training set prediction

# another model?
# picking a pair of variables that are least correlated
# they each add different behaviour to the model
mod2 <- glm(Republican ~ SurveyUSA + DiffCount, data=Train, family = binomial)
summary(mod2)
pred2 <- predict(mod2, type="response")
table(Train$Republican, pred2 >= 0.5)


# predict on the testing set
table(Test$Republican, sign(Test$Rasmussen))
TestPred <- predict(mod2, newdata = Test, type="response")
table(Test$Republican, TestPred >= 0.5)

# inspect the mistake
subset(Test, TestPred >= 0.5 & Republican == 0)
