# set-up environment
rm(list=ls());
library(ggplot2); 
library(RMySQL); 
library(randomForest);
library(tree);
library(e1071);
library(glm2);
library(gbm);
options(stringsAsFactors = FALSE);
setwd("/home/steveo/kaggle/titanic/sql");

# get training data
m<-MySQL();
con<-dbConnect(m,dbname='titanic');
traindata<-dbGetQuery(con, "select * from final_model");

#split the data into train/validate data-sets
sub <- sample(nrow(traindata), floor(nrow(traindata) * 0.8));
training <- traindata[sub,];
testing <- traindata[-sub,];

## SVM
# build the model
svmModel <- svm(as.factor(survived) ~ ., data = training);
summary(svmModel);
# complete cross-validation
svmModelpred <- predict(svmModel, newdata=testing);
svmtable <-table(svmModelpred, testing$survived);
svmtable;
misclasssvm <- (sum(svmtable[row(svmtable) != col(svmtable)]) / sum(svmtable)) *100;
misclasssvm;


# complete prediction
predtestdatasvm <- predict(svmModel, newdata=testdata_upload, type="class");
# extract prediction
write.table(predtestdatasvm,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);