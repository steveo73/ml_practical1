USE titanic;
update train_data_hack set sex = -1 where sex = 'male';
update train_data_hack set sex = 1 where  sex = 'female';
update train_data_hack set totl_family = sibsp + parch;
update train_data_hack set fare_individual = fare/totl_family;
update train_data_hack set fare_individual = fare where totl_family = 0;
update train_data_hack
Set salutatory = Substring(name from locate(',',name)+2 for (locate('.',name) - locate(',',name)-2));
update salutatory Set name_score = 5 where salutatory = 'Master';
update salutatory Set name_score = 2 where salutatory = 'Sir';
update salutatory Set name_score = 0 where name_score IS NULL;
update train_data_hack Set cabin_survival_ind= 0 where cabin_survival_ind IS NULL;

update train_data_hack
JOIN salutatory
ON train_data_hack.salutatory =salutatory.salutatory 
Set train_data_hack.name_score = salutatory.name_score
;

UPDATE train_data_hack set age = 120 where age = 0  and name_score = 0;

update train_data_hack
set age_banding = (
    CASE WHEN age <10 THEN 0
    WHEN AGE BETWEEN 10 AND 20 THEN 1
    WHEN AGE BETWEEN 20 AND 30 THEN 2
    WHEN AGE BETWEEN 30 AND 40 THEN 3
    WHEN AGE BETWEEN 40 AND 50 THEN 4
    WHEN AGE BETWEEN 50 AND 60 THEN 5
    WHEN AGE BETWEEN 60 AND 70 THEN 6
    WHEN AGE BETWEEN 70 AND 80 THEN 7
    WHEN AGE BETWEEN 80 AND 90 THEN 8
    ELSE 9
    END)
  ;  

INSERT INTO cabin_ind (ticket, cabin_survival_ind )
SELECT ticket, SUM(CASE WHEN survived = 0 THEN -1 ELSE 1 END)  as cabin_ind  FROM train_data_hack  where sex = 1 group by ticket
;

update train_data_hack
JOIN cabin_ind
ON train_data_hack.ticket = cabin_ind.ticket
Set train_data_hack.cabin_survival_ind = cabin_ind.cabin_survival_ind
where   train_data_hack.sex = 1
;

INSERT INTO final_model
(survived
, pclass
, name_score
, sex
, age_banding
, totl_family
, cabin_survival_ind
)

SELECT
survived
, pclass
, name_score
, sex
, age_banding
, totl_family
, cabin_survival_ind

FROM train_data_hack
;




