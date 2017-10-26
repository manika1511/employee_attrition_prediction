# Model to Predict Employee Attrition
library(utils)    #for importing the file
library(mlbench)  #for correlation matrix
library(caret)    #for models
library(ggplot2)  #for plotting graphs

#Step:1 Import the dataset 

setwd("~/Documents/stanford/datascience/employee_attrition_prediction")
data = read.csv("HR-Employee-Attrition.csv") 

#Step:2 Cleaning data

#Removing columns which have same value for all
cleaned_data=data[,-c(9,10,22,27)]
#replacing all blank cells with NA
cleaned_data[cleaned_data==""]=NA
#removing all rows with any blank cell
cleaned_data=cleaned_data[complete.cases(cleaned_data), ]

#Step:3 Data Exploration

#scatter plot between monthly income, work life balance and attrition
ggplot(data,aes(data$MonthlyIncome,data$WorkLifeBalance, color=Attrition))+geom_point()

#scatter plot between monthly income, JobLevel and attrition
ggplot(data,aes(data$MonthlyIncome,data$JobLevel, color=Attrition))+geom_point()

#boxplot between monthly income and attrition
ggplot(data,aes(Attrition,MonthlyIncome,fill=Attrition))+geom_boxplot()

#boxplot between monthly income and attrition
ggplot(data,aes(Attrition,YearsSinceLastPromotion,fill=Attrition))+geom_violin()

#Correlation between Marital status and Attrition
ggplot(data,aes(Attrition,MaritalStatus,color=Attrition))+geom_jitter()

#Step:3 Find highly correlated features (optional)
correlation_matrix=cor(cleaned_data[sapply(cleaned_data, is.numeric)])
highlyCorrelated = findCorrelation(correlation_matrix, cutoff=0.6)
highlyCorrelated

#Step:4 Define train control for models using method as "repeatedcv"(repeated K-fold cross-validation)
train_control=trainControl(method="repeatedcv", number=5, repeats=3)

#Model-1: k-Nearest Neighbors
#Step:4 Feature Selection
#train the model and then find importance of features using varImp
model_kknn=train(Attrition~., cleaned_data, method="kknn", trControl=train_control)
importance_kknn=varImp(model_kknn, scale=FALSE)
importance_kknn

#Step:5 Filter data to contain only selected features
#final_data_kknn=cleaned_data[, -c(3,7,8,10, 11,18,19,21,22,23)]
final_data_kknn=cleaned_data[, -c(3,7,8,10, 11,18,19,23)]

#Step:6 Train the model
set.seed(7)         #use same set of random numbers everytime you train and run the model
model_trained_kknn=train(Attrition~., final_data_kknn, method="kknn", trControl=train_control)

#Step:7 Predict using model and dataset
predicted_attrition_kknn=predict(model_trained_kknn,final_data_kknn)

#Step:8 Measure Accuracy (0.9183673)
model_accuracy_kknn=sum(predicted_attrition_kknn == final_data_kknn$Attrition)/nrow(final_data_kknn)
model_accuracy_kknn

#Model-2: Support Vector Machines with Linear Kernel
#Step:4 Feature Selection
model_svm=train(Attrition~., cleaned_data, method="svmLinear", trControl=train_control)
importance_svm=varImp(model_svm, scale=FALSE)
importance_svm

#Step:5 Filter data to contain only selected features
#final_data_svm=cleaned_data[, -c(3,7,8,10,11,18,19,21,22,23)]
final_data_svm=cleaned_data[, -c(3,7,8,10,11,18,19,23)]

#Step:6 Train the model
model_trained_svm=train(Attrition ~., final_data_svm, method="svmLinear", trControl=train_control)

#Step:7 Predict using model and dataset
predicted_attrition_svm=predict(model_trained_svm,final_data_svm)

#Step:8 Measure Accuracy (0.8693878)
model_accuracy_svm=sum(predicted_attrition_svm == final_data_svm$Attrition)/nrow(final_data_svm)
model_accuracy_svm

#Model-3: Neural Network
#Step:4 Feature Selection
model_nn=train(Attrition~., cleaned_data, method="dnn", trControl=train_control)
importance_nn=varImp(model_nn, scale=FALSE)
importance_nn

#Step:5 Filter data to contain only selected features
#final_data_nn=cleaned_data[, -c(3, 7,8,10,11,18,19,21,22,23)]
final_data_nn=cleaned_data[, -c(3, 7,8,10,11,18,19,23)]

#Step:6 Train the model
model_trained_nn=train(Attrition ~., final_data_nn, method="dnn", trControl=train_control)

#Step:7 Predict using model and dataset
predicted_attrition_nn=predict(model_trained_nn,final_data_nn)

#Step:8 Measure Accuracy (0.8387755)
model_accuracy_nn=sum(predicted_attrition_nn == final_data_nn$Attrition)/nrow(final_data_nn)
model_accuracy_nn

#Model-4: Random Forest
#Step:4 Feature Selection
model_rf=train(Attrition~., cleaned_data, method="rf", trControl=train_control)
importance_rf=varImp(model_rf, scale=FALSE)
importance_rf

#Step:5 Filter data to contain only selected features
#final_data_rf=cleaned_data[, -c(3,5,7,8,10,13,14,16,22,29)]
final_data_rf=cleaned_data[, -c(3,5,7,8,10,13,14,16,29)]

#Step:6 Train the model
model_trained_rf=train(Attrition ~., final_data_rf, method="rf", trControl=train_control)

#Step:7 Predict using model and dataset
predicted_attrition_rf=predict(model_trained_rf,final_data_rf)

#Step:8 Measure Accuracy (1)
model_accuracy_rf=sum(predicted_attrition_rf == final_data_rf$Attrition)/nrow(final_data_rf)
model_accuracy_rf

#allModels=resamples(list(KNearestNeighbors=model_trained_kknn,SVM=model_trained_svm,DeepNeuralNet=model_trained_nn,RandomForest=model_trained_rf)) 
allModels=resamples(list(KNearestNeighbour=model_trained_kknn, SVM=model_trained_svm, NeuralNetwork=model_trained_nn, RandomForest=model_trained_rf))
bwplot(allModels,scales=list(relation="free"))

#Apply Association Rule mining to get some rules governing Attrition
library(arules)
data_for_rule_mining=cleaned_data
cols=c(6)
for (i in cols){data_for_rule_mining[,i]=discretize(data_for_rule_mining[,i])}
rules = apriori(data_for_rule_mining,parameter = list(minlen=2, supp=0.005, conf=0.8), 
                 appearance = list(rhs=c("Attrition=Yes", "Attrition=No"), default="lhs"))
top_rules_by_support=sort(rules, decreasing = TRUE, na.last = NA, by = "lift")
inspect(head(top_rules_by_support, 50)) 
inspect(top_rules_by_support)

#Try different plots

