# Model to Predict Employee Attrition

#Step:1 Import the dataset 
library(utils) 
setwd("~/Documents/stanford/datascience/employee_attrition_prediction")
data = read.csv("HR-Employee-Attrition.csv") 

#Step:2 Cleaning data
#Removing columns which have same value for all
cleaned_data=data[,-c(9,10,22,27)]
#replacing all blank cells with NA
cleaned_data[cleaned_data==""]=NA
#removing all rows with any blank cell
cleaned_data=cleaned_data[complete.cases(cleaned_data), ]

#Step:3 Find highly correlated features
library(mlbench)
library(caret)

set.seed(7)
correlation_matrix=cor(cleaned_data[sapply(cleaned_data, is.numeric)])
highlyCorrelated = findCorrelation(correlation_matrix, cutoff=0.8)
highlyCorrelated

#Step:4 Feature Selection
#For K-neighbours algorithm
control=trainControl(method="repeatedcv", number=10, repeats=3)
model=train(Attrition~., cleaned_data, method="kknn", preProcess="scale", trControl=control)
importance=varImp(model, scale=FALSE)
importance

#Step:5 Filter data to contain only selected features
final_data=cleaned_data[, -c(3,7,8,10, 11,18,19,21,22,23)]

#Step:6 Seperate data into training and test dataset
training = final_data[seq(1,nrow(final_data), 2),]
testing = final_data[seq(2,nrow(final_data), 2),]

#Step:7 Train the model
model_trained=train(Attrition ~., training, method="kknn")

#Try different plots
library(ggplot2)

#scatter plot between monthly income, work life balance and attrition
ggplot(data,aes(data$MonthlyIncome,data$WorkLifeBalance, color=Attrition))+geom_point()
#scatter plot between monthly income, JobLevel and attrition
ggplot(data,aes(data$MonthlyIncome,data$JobLevel, color=Attrition))+geom_point()

#violin plot between attrition and job satisfaction
ggplot(data, aes(x=Attrition, y=JobSatisfaction, fill=Attrition)) + geom_violin() + theme_bw()

#boxplot between monthly income and attrition
ggplot(data,aes(Attrition,MonthlyIncome,fill=Attrition))+geom_boxplot()

#jitter plot between monthly income and attrition
ggplot(data,aes(Attrition,MonthlyIncome,color=Attrition))+geom_jitter()

#heat map between monthly income, joblevel, attrition
ggplot(data,aes(data$MonthlyIncome,data$JobLevel,fill=Attrition))+geom_tile()

#boxplot between monthly income and attrition
ggplot(data,aes(Attrition,YearsSinceLastPromotion,fill=Attrition))+geom_jitter()
ggplot(data,aes(Attrition,MaritalStatus,color=Attrition))+geom_jitter()

