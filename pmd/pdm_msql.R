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

## Random Forest Model
# build the model
rfModel <- randomForest(as.factor(survived)~ .,data=traindata,  proximity = FALSE);
summary(rfModel);
# complete cross-validation
pred1 <- predict(rfModel, newdata=training, type="class");
mytable <-table(pred1, testing$survived);
mytable;
misclass <- (sum(mytable[row(mytable) != col(mytable)]) / sum(mytable)) *100;
misclass;

# complete prediction
testdata_upload<-dbGetQuery(con, "select * from final_model_test");
predtestdatarf <- predict(rfModel, newdata=testdata_upload, type="class");
# extract prediction
write.table(predtestdatarf,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

