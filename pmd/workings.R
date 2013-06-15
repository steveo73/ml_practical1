# Titanic Kaggle Comp
# Goal - Predict who lives and who dies

#VARIABLE DESCRIPTIONS:
#  survival        Survival
#(0 = No; 1 = Yes)
#pclass          Passenger Class
#(1 = 1st; 2 = 2nd; 3 = 3rd)
#name            Name
#sex             Sex
#age             Age
#sibsp           Number of Siblings/Spouses Aboard
#parch           Number of Parents/Children Aboard
#ticket          Ticket Number
#fare            Passenger Fare
#cabin           Cabin
#embarked        Port of Embarkation
#(C = Cherbourg; Q = Queenstown; S = Southampton)

#SPECIAL NOTES:
#  Pclass is a proxy for socio-economic status (SES)
#1st ~ Upper; 2nd ~ Middle; 3rd ~ Lower

#Age is in Years; Fractional if Age less than One (1)
#If the Age is Estimated, it is in the form xx.5

#With respect to the family relation variables (i.e. sibsp and parch)
#some relations were ignored.  The following are the definitions used
#for sibsp and parch.

#Sibling:  Brother, Sister, Stepbrother, or Stepsister of Passenger Aboard Titanic
#Spouse:   Husband or Wife of Passenger Aboard Titanic (Mistresses and Fiances Ignored)
#Parent:   Mother or Father of Passenger Aboard Titanic
#Child:    Son, Daughter, Stepson, or Stepdaughter of Passenger Aboard Titanic

#Other family relatives excluded from this study include cousins,
#nephews/nieces, aunts/uncles, and in-laws.  Some children travelled
#only with a nanny, therefore parch=0 for them.  As well, some
#travelled with very close friends or neighbors in a village, however,
#the definitions do not support such relations.

# set-up environment
rm(list=ls()); # remove everything from workspace
library(ggplot2); 
library(randomForest);
library(tree);
library(e1071);
library(glm2);
library(gbm);
options(stringsAsFactors = FALSE);
setwd("/home/steveo/kaggle/titanic");

### Training Data Set-Up
loaddata <-read.csv("./train.csv", header = TRUE, sep = ",");
traindata <- loaddata;
# view data
head(traindata);
# check the data
nrow(traindata); # 891 records
unique(traindata$survived); 
unique(traindata$pclass);
unique(traindata$sex);
unique(traindata$age); # data has NA values
unique(traindata$sibsp);
unique(traindata$parch);
unique(traindata$fare); # might be able to group this
unique(traindata$cabin); # might be able to spin this off - there is some funny data as well like multiple cabins
unique(traindata$embarked);
# remove variables not required
traindata$name<-NULL;
traindata$ticket<-NULL;
traindata$cabin<-NULL;
head(traindata);
# amend all character values from strings to numeric values
traindata$sex[traindata$sex == "male"] <- 1
traindata$sex[traindata$sex == "female"] <- 0
traindata$sex <- as.numeric(traindata$sex);
traindata$embarked[traindata$embarked == "S"] <- 1
traindata$embarked[traindata$embarked == "C"] <- 2
traindata$embarked[traindata$embarked == "Q"] <- 3
traindata$embarked <- as.numeric(traindata$embarked);
# amend all NA values to 0
traindata$pclass[is.na(traindata$pclass)] <- mean(traindata$pclass, na.rm = TRUE);
traindata$sex[is.na(traindata$sex)] <- mean(traindata$sex, na.rm = TRUE);
traindata$age[is.na(traindata$age)] <- mean(traindata$age, na.rm = TRUE);
traindata$sibsp[is.na(traindata$sibsp)] <- mean(traindata$sibsp, na.rm = TRUE);
traindata$parch[is.na(traindata$parch)] <- mean(traindata$parch, na.rm = TRUE);
traindata$fare[is.na(traindata$fare)] <- mean(traindata$fare, na.rm = TRUE);
traindata$embarked[is.na(traindata$embarked)] <- mean(traindata$embarked, na.rm = TRUE);
# look at the data
head(traindata);
str(traindata);
#split the data into train/validate data-sets
sub <- sample(nrow(traindata), floor(nrow(traindata) * 0.8));
training <- traindata[sub,];
testing <- traindata[-sub,];

### Test Data Set-Up
testdata <-read.csv("./test.csv", header = TRUE, sep = ",");
nrow(testdata); # 418 records
testdata_upload <-testdata # create new dataframe
testdata_upload[is.na(testdata_upload)] <- 0 # amend all NA values to 0
# remove variables not required for modelling
# remove variables not required
testdata_upload$name<-NULL;
testdata_upload$ticket<-NULL;
testdata_upload$cabin<-NULL;
# amend all character values from strings to numeric values
testdata_upload$sex[testdata_upload$sex == "male"] <- 1
testdata_upload$sex[testdata_upload$sex == "female"] <- 0
testdata_upload$sex <- as.numeric(testdata_upload$sex);
testdata_upload$embarked[testdata_upload$embarked == "S"] <- 1
testdata_upload$embarked[testdata_upload$embarked == "C"] <- 2
testdata_upload$embarked[testdata_upload$embarked == "Q"] <- 3
testdata_upload$embarked <- as.numeric(testdata_upload$embarked);
# amend all NA values to 0
testdata_upload$pclass[is.na(testdata_upload$pclass)] <- mean(testdata_upload$pclass, na.rm = TRUE);
testdata_upload$sex[is.na(testdata_upload$sex)] <- mean(testdata_upload$sex, na.rm = TRUE);
testdata_upload$age[is.na(testdata_upload$age)] <- mean(testdata_upload$age, na.rm = TRUE);
testdata_upload$sibsp[is.na(testdata_upload$sibsp)] <- mean(testdata_upload$sibsp, na.rm = TRUE);
testdata_upload$parch[is.na(testdata_upload$parch)] <- mean(testdata_upload$parch, na.rm = TRUE);
testdata_upload$fare[is.na(testdata_upload$fare)] <- mean(testdata_upload$fare, na.rm = TRUE);
testdata_upload$embarked[is.na(testdata_upload$embarked)] <- mean(testdata_upload$embarked, na.rm = TRUE);
# check data
str(testdata_upload);
head(testdata_upload);
nrow(testdata_upload);

## Random Forest Model
# build the model
rfModel <- randomForest(as.factor(survived)~ embarked,data=training, ntree = 5, proximity = FALSE);
summary(rfModel);
# complete cross-validation
pred1 <- predict(rfModel, newdata=testing, type="class");
mytable <-table(pred1, testing$survived);
mytable;
misclass <- (sum(mytable[row(mytable) != col(mytable)]) / sum(mytable)) *100;
misclass;
# complete Prediction
predtestdata <- predict(fModel, newdata=testdata_upload, type="class");
str(predtestdata);
# extract prediction
write.table(predtestdata,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

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

## Logistic regression
# build the model
glmModel <- glm(survived ~ ., data = training);
summary(glmModel);
# complete cross-validation
glmModelpred <- predict(glmModel, newdata=testing, type='response');
glmtable <-table(round(glmModelpred,0), testing$survived); # round the function to convert to a 1 or 0
glmtable;
misclassglm <- (sum(glmtable[row(glmtable) != col(glmtable)]) / sum(glmtable)) *100;
misclassglm;
# complete prediction
predtestdatalgr <- round(predict(glmModel, newdata=testdata_upload, type='response'),0);
# extract prediction
write.table(predtestdatalgr,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

## Gradient Boosting Models
# build the model
gbmModel <- gbm(survived ~ ., data = training, n.trees=1000, interaction.depth=2,distribution="bernoulli");
summary(gbmModel);
# complete cross-validation
gbmModelpred <- predict(gbmModel, newdata=testing, n.trees=1000, type='response');
gbmtable <-table(round(gbmModelpred,0), testing$survived); # round the function to convert to a 1 or 0
gbmtable;
misclassgbm <- (sum(gbmtable[row(gbmtable) != col(gbmtable)]) / sum(gbmtable)) *100;
misclassgbm;
# complete prediction
predtestdatalgr <- round(predict(gbmModel, newdata=testdata_upload, n.trees=1000, type='response'),0);
# extract prediction
write.table(predtestdatalgr,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);

# Ensemble
# Change SVM to regression not classification
svmModelpredreg <- predict(svmModelreg, newdata=testing);
svmtablereg <-table(round(svmModelpredreg,0), testing$survived);
svmtablereg;
misclasssvmreg <- (sum(svmtablereg[row(svmtablereg) != col(svmtablereg)]) / sum(svmtablereg)) *100;
misclasssvmreg;
gbmModelpred <- .3 * (predict(gbmModel, newdata=testing, n.trees=1000, type='response'));
glmModelpred <- .3 * (predict(glmModel, newdata=testing, type='response'));
svmModelpredreg <- .4* (predict(svmModelreg, newdata=testing));
enstable <-table(round(gbmModelpred + glmModelpred + svmModelpredreg ,0), testing$survived);
enstable;
misclassens <- (sum(enstable[row(enstable) != col(enstable)]) / sum(enstable)) *100;
misclassens;
# complete prediction
gbmModelpredupload <- .3 * (predict(gbmModel, newdata=testdata_upload, n.trees=1000, type='response'));
glmModelpredupload <- .3 * (predict(glmModel, newdata=testdata_upload, type='response'));
svmModelpredregupload <- .4* (predict(svmModelreg, newdata=testdata_upload));
predtestdatalgr <- round(svmModelpredregupload + gbmModelpredupload + glmModelpredupload,0);
# extract prediction
write.table(predtestdatalgr,file = "stevesprediction.csv", row.names = FALSE, col.names = FALSE);


## workings
# A couple of options - update fare
ds1 <- data.frame("model_prediction" = round(glmModelpred,0),testing)
dsa1 <- ds1 [ds1$model_prediction != ds1$survived & ds1$sex ==0 ,]

## Logistic regression
# build the model
glmModel <- glm(survived ~ fare, data = training);
summary(glmModel);
# complete cross-validation
glmModelpred <- predict(glmModel, newdata=testing, type='response');
glmtable <-table(round(glmModelpred,0), testing$survived); # round the function to convert to a 1 or 0
glmtable;
misclassglm <- (sum(glmtable[row(glmtable) != col(glmtable)]) / sum(glmtable)) *100;
misclassglm;



