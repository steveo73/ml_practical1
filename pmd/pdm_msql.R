# set-up environment
rm(list=ls());
# create reg to class function
regclass <- function(rlist){
  x <- 0
  for (i in 1:length(rlist))
    if(rlist[i]>.5){
      x <- append(x, 1, after = i-1)
    } else{
      x <- append(x, 0, after = i-1)
    }
  
  return (x[1:length(x)-1])
};
# get libraries
library(RMySQL); 
library(glm2);
library(e1071);
options(stringsAsFactors = FALSE);
setwd("/home/steveo/kaggle/titanic/sql");

# get training data
m<-MySQL();
con<-dbConnect(m,dbname='titanic');
traindata<-dbGetQuery(con, "select * from final_model");

#split the data into train/validate data-sets
sub <- sample(nrow(traindata), floor(nrow(traindata) * 1.0));
training <- traindata[sub,];
testing <- traindata[-sub,];

## Logistic Regression
glmModel <- glm(survived ~ . , data = training);
# complete cross-validation
glmModelpred <- predict(glmModel, newdata=training, type='response');
glmModelround <- regclass(glmModelpred);
glmtable <-table(glmModelround, training$survived); 
misclassglm <- (sum(glmtable[row(glmtable) != col(glmtable)]) / sum(glmtable)) *100;
misclassglm;

# complete upload prediction -- logistic regression
testdata_upload<-dbGetQuery(con, "select * from final_model_test");
predtestdatalgr <- regclass(predict(glmModel, newdata=testdata_upload, type='response'));
# extract prediction
write.table(predtestdatalgr,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

## SVM
# build the model
svmModel <- svm(survived ~ . , data = training);
# complete cross-validation
svmModelpred <- predict(svmModel, newdata=training);
svmModelround <- regclass(svmModelpred);
svmtable <-table(svmModelround, training$survived);
misclasssvm <- (sum(svmtable[row(svmtable) != col(svmtable)]) / sum(svmtable)) *100;
misclasssvm;

# complete upload prediction - svm
testdata_upload<-dbGetQuery(con, "select * from final_model_test");
predtestdatasvm <- regclass(predict(svmModel, newdata=testdata_upload));
# extract prediction
write.table(predtestdatasvm,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

# Ensemble + validation
enstable <- table(regclass(.5 * glmModelpred + .5 * svmModelpred));
misclassens <- (sum(enstable[row(enstable) != col(enstable)]) / sum(enstable)) *100;
misclassens;

# complete upload prediction - ensemble
# get data
testdata_upload<-dbGetQuery(con, "select * from final_model_test");
# run predictions
ensglm <- predict(glmModel, newdata=testdata_upload, type='response');
enssvm <- predict(svmModel, newdata=testdata_upload);
# complete ensemble
predtestdataen <- regclass(.4 * ensglm + .6 * enssvm);
# extract prediction
write.table(predtestdataen,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

