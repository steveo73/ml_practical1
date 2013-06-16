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
sub <- sample(nrow(traindata), floor(nrow(traindata) * 0.8));
training <- traindata[sub,];
testing <- traindata[-sub,];

## Logistic Regression
glmModel <- glm(survived ~ sex + pclass + name_score + cabin_survival_ind , data = training);
summary(glmModel);
# complete cross-validation
glmModelpred <- predict(glmModel, newdata=testing, type='response');
# get classifications
glmModelclass <- regclass(glmModelpred);
glmtable <-table(glmModelclass, testing$survived); 
misclassglm <- (sum(glmtable[row(glmtable) != col(glmtable)]) / sum(glmtable)) *100;
misclassglm;

# complete prediction
testdata_upload<-dbGetQuery(con, "select * from final_model_test");
predtestdatalgr <- round(predict(glmModel, newdata=testdata_upload, type='response'),0);
# extract prediction
write.table(predtestdatalgr,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

## SVM
# build the model
svmModel <- svm(as.factor(survived) ~ ., data = training);
summary(svmModel);
# complete cross-validation
svmModelpred <- predict(svmModel, newdata=testing);
svmtable <-table(svmModelpred, testing$survived);
misclasssvm <- (sum(svmtable[row(svmtable) != col(svmtable)]) / sum(svmtable)) *100;
misclasssvm;
# complete prediction
testdata_upload<-dbGetQuery(con, "select * from final_model_test");
predtestdatasvm <- predict(svmModel, newdata=testdata_upload, type="class");
# extract prediction
write.table(predtestdatasvm,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);
