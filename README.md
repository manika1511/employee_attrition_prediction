# Prediciting Employee Attrition using IBM HR Analytics Dataset
This project aims at finding the factors that lead to employee attrition and explore important questions such as ‘show me a breakdown of distance from home by job role and attrition’ or ‘compare average monthly income by education and attrition’. The dataset used is a fictional data set created by IBM data scientists.
Find the dataset: https://www.kaggle.com/xiaoxu9368/ibm-employee-attrition-prediction/data

1. This project is implemented in R
2. Different Classification Models, namely K-Nearest Neighbours, Support Vector Machine, Bridge Neural Network and Random Forest, are prepared to predict Employee Attritio in the organization 
3. Model comparison based on the accuracy and selecting the best model
4. Data Visualization using ggplot2 library 
5. bwplot is used to compare different models

The project helps in coming out with important features that contribute to Employee leaving the company so that the HR can develop strategies to retain the employee.

## Environment
1. RStudio 
2. Libraries used:
    * utils: to import the dataset
    * caret: for creating predictive models
    * ggplot2: for data visualization
    * mlbench: for feature selection
    * apriori: for association rule mining

## Approach

Step 1: Import the dataset
The data set (.csv) file is read using utils package in R. This reads the .csv file as a dataframe.

Step 2: Clean the dataset
The dataset contains some empty cells, so the rows containing empty cells are removed. Moreover, there are few columns which have same value for everyone like Employee Count, Over 18, etc. These columns are also pruned.

Step 3: Data Exploration
The data is explored by visualising the data points using various plots like scatter plot to see correlation, boxplot to see compare the median, violin plot for distribution.

![mi](https://user-images.githubusercontent.com/20146538/32033788-79021932-b9c3-11e7-8275-86b5b3477388.png)
![yelp](https://user-images.githubusercontent.com/20146538/32033789-7bd8b2ec-b9c3-11e7-9c93-da183caeaaf7.png)
![jl](https://user-images.githubusercontent.com/20146538/32033794-83071dec-b9c3-11e7-9043-c002c43fb9f0.png)

Step 4: Find highly correlated features
The features with high correlation are found and only one of them is kept.

Step 5: Feature selection 
Features are selected based on the Importance using varImp. For every model, different set of features are chosen as important. Here, I have used four models K-Nearest Neighbors, Support Vector Machines, Neural Network and Random forest.

Step 6: Train the model
The model is trained using different algorithms. Repeated k-fold cross-validation is used for splitting the dataset into train and test and then training the model with particular classification algorithm.

Step 7: Model evaluation
All the models are evaluated based on the basis of different metrics. For classification, Accuracy is used for comparison. The bwplot is used to compare all the models

<img width="672" alt="screen shot 2017-10-25 at 8 43 59 pm" src="https://user-images.githubusercontent.com/20146538/32034076-4880d9f4-b9c5-11e7-82c6-0d090bb5ddd9.png">

### It is found that Support Vector Machine performs best with approx. 87% accuracy.


