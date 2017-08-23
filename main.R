# Model to Predict Employee Attrition

#Step:1 Import the dataset 
library(utils) 
setwd("~/Documents/stanford/datascience/employee_attrition_prediction")
data = read.csv("HR-Employee-Attrition.csv") 

#Step:2 Cleaning data
#Removing columns which have same value for all
cleaned_data=data[,-c(9,22,27)]
#removing all rows with any column as NA
cleaned_data=cleaned_data[complete.cases(cleaned_data), ]



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

