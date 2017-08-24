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

#Model-1: k-Nearest Neighbors
#Step:4 Feature Selection
control_kknn=trainControl(method="repeatedcv", number=10, repeats=3)
model=train(Attrition~., cleaned_data, method="kknn", preProcess="scale", trControl=control_kknn)
importance_kknn=varImp(model, scale=FALSE)
importance_kknn

#Step:5 Filter data to contain only selected features
final_data_kknn=cleaned_data[, -c(3,7,8,10, 11,18,19,21,22,23)]

#Step:6 Seperate data into training and test dataset
training_kknn = final_data_kknn[seq(1,nrow(final_data_kknn), 2),]
testing_kknn = final_data_kknn[seq(2,nrow(final_data_kknn), 2),]

#Step:7 Train the model
model_trained_kknn=train(Attrition ~., training_kknn, method="kknn")

#Step:8 Predict using model and test dataset
predicted_attrition_kknn=predict(model_trained_kknn,testing)

#Step:9 Measure Accuracy (0.84897976)
model_accuracy_kknn=sum(predicted_attrition_kknn == testing_kknn$Attrition)/nrow(testing_kknn)
model_accuracy_kknn

#Model-2: Random Forest
#Step:4 Feature Selection
control_rf=trainControl(method="repeatedcv", number=10, repeats=3)
model_rf=train(Attrition~., cleaned_data, method="rf", preProcess="scale", trControl=control_rf)
importance_rf=varImp(model_rf, scale=FALSE)
importance_rf

#Step:5 Filter data to contain only selected features
final_data_rf=cleaned_data[, -c(3,5,7,8,10,13,14,16,22,29)]

#Step:6 Seperate data into training and test dataset
training_rf = final_data_rf[seq(1,nrow(final_data_rf), 2),]
testing_rf = final_data_rf[seq(2,nrow(final_data_rf), 2),]

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

