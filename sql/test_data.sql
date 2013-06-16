Use titanic;

Delete from  train_data_test;
Delete from  train_data_hack_test;
Delete from  final_model_test;

LOAD DATA LOCAL INFILE '/home/steveo/kaggle/titanic/sql/test.csv' INTO TABLE train_data_test
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
( pclass
, name
, sex
, age
, sibsp
, parch
, ticket
, fare
, cabin
, embarked
)
;

INSERT INTO train_data_hack_test
(
id
, pclass
, name
, sex
, age
, sibsp
, parch
, ticket
, fare
, cabin
, embarked
)

Select * from train_data_test
;



