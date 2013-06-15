CREATE TABLE titanic.train_data
(
id MEDIUMINT NOT NULL AUTO_INCREMENT
, survived int
, pclass int
, name text
, sex text
, age int
, sibsp int
, parch int
, ticket text
, fare double
, cabin text
, embarked text
, PRIMARY KEY(id)
)
;

CREATE TABLE titanic.train_data_hack
(
id INT NOT NULL AUTO_INCREMENT, PRIMARY KEY(id)
, survived int
, pclass int
, name text
, salutatory text
, name_score int
, sex text
, age int
, age_banding INT
, sibsp int
, parch int
, totl_family INT
, ticket text
, fare double
, fare_individual DOUBLE
, cabin text
, embarked text
)
;

CREATE TABLE titanic.final_model
(
survived int
, pclass int
, name_score int
, sex int
, age_banding INT
, totl_family INT
)
;

CREATE TABLE titanic.salutatory
(
salutatory text
, name_score int
)
;

