LOAD DATA LOCAL INFILE '/home/steveo/kaggle/titanic/sql/train.csv' INTO TABLE train_data
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

load data infile '/home/user1/test.txt' into table chargertest fields terminated by ',' (name,x,y);

INSERT INTO titanic.train_data_hack
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

Select * from titanic.train_data
;

INSERT INTO titanic.salutatory
(
salutatory
)
select Substring(name from locate(',',name)+2 for (locate('.',name) - locate(',',name)-2)) from train_data group by 1;

