# Model to Predict Employee Attrition

#Step:1 Import the dataset 
library(utils) 
setwd("~/Documents/stanford/datascience/employee_attrition_prediction")
data = read.csv("HR-Employee-Attrition.csv") 

data_yes_attrition = data[!(data$Attrition=="No"),]
library(ggplot2)
ggplot(data,aes(data$MonthlyIncome,data$WorkLifeBalance, color=Attrition))+geom_point()

ggplot(data, aes(x=Attrition, y=JobSatisfaction, fill=Attrition)) + geom_violin() + theme_bw()
