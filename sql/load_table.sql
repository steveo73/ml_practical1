USE titanic;

LOAD DATA LOCAL INFILE '/home/steveo/kaggle/titanic/sql/train_combined.csv' INTO TABLE train_data
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
( survived
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
;
Delete from train_data where pclass is null;

INSERT INTO train_data_hack
(
id
, survived
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

Select * from train_data
;

INSERT INTO salutatory
(
salutatory
)
select Substring(name from locate(',',name)+2 for (locate('.',name) - locate(',',name)-2)) from train_data group by 1
;

