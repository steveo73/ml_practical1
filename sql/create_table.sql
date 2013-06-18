use titanic;
CREATE TABLE train_data
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

CREATE TABLE train_data_test
(
id MEDIUMINT NOT NULL AUTO_INCREMENT
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

CREATE TABLE train_data_hack
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
, ticket_ind int
, cabin_ind int
, embarked text
)
;

CREATE TABLE train_data_hack_test
(
id INT NOT NULL AUTO_INCREMENT, PRIMARY KEY(id)
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
, ticket_ind int
, cabin_ind int
, embarked text
)
;

CREATE TABLE final_model
(
survived int
, pclass int
, name_score int
, sex int
, age_banding int
, ticket_ind int
, cabin_ind int
)
;

CREATE TABLE final_model_test
(
pclass int
, name_score int
, sex int
, age_banding int
, ticket_ind int
, cabin_ind int
)
;

CREATE TABLE salutatory
(
salutatory text
, name_score int
)
;

CREATE TABLE ticket
(
ticket text
, ticket_ind int
)
;



