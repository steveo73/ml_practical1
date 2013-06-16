USE titanic;
update train_data_hack_test set sex = -1 where sex = 'male';
update train_data_hack_test set sex = 1 where  sex = 'female';
update train_data_hack_test set totl_family = sibsp + parch;
update train_data_hack_test set fare_individual = fare/totl_family;
update train_data_hack_test set fare_individual = fare where totl_family = 0;
update train_data_hack_test
Set salutatory = Substring(name from locate(',',name)+2 for (locate('.',name) - locate(',',name)-2));
update train_data_hack_test Set cabin_survival_ind= 0 where cabin_survival_ind IS NULL;

update train_data_hack_test Set name_score = 0 where name_score IS NULL;

update train_data_hack_test
JOIN salutatory
ON train_data_hack_test.salutatory =salutatory.salutatory 
Set train_data_hack_test.name_score = salutatory.name_score
;

UPDATE train_data_hack_test set age = 120 where age = 0  and name_score = 0;

update train_data_hack_test
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

update train_data_hack_test
JOIN cabin_ind
ON train_data_hack_test.ticket = cabin_ind.ticket
Set train_data_hack_test.cabin_survival_ind = cabin_ind.cabin_survival_ind
where   train_data_hack_test.sex = 1
;

INSERT INTO final_model_test
(pclass
, name_score
, sex
, age
, age_banding
, sibsp
, parch
, totl_family
, cabin_survival_ind
)

SELECT
pclass
, name_score
, sex
, age
, age_banding
, sibsp
, parch
, totl_family
, cabin_survival_ind

FROM train_data_hack_test
;

-- sex, class, cabin_ind, name
-- Set value of 0
UPDATE final_model_test
SET weighting = 0
WHERE weighting IS NULL
;

-- 1st class females
UPDATE final_model_test
SET weighting = 100 
WHERE sex = 1 
AND pclass = 1
;

-- 2nd and 3rd class females with higher cabin survival rate
UPDATE final_model_test
SET weighting = 80
WHERE sex = 1 
AND pclass IN (2,3)
AND cabin_survival_ind > 0
;

-- 2nd class females with no cabin survival rate
UPDATE final_model_test
SET weighting = 50
WHERE sex = 1 
AND pclass = 2
;

-- 3rd class females with lower cabin survival rate
UPDATE final_model_test
SET weighting = -50
WHERE sex = 1 
AND pclass = 3
AND cabin_survival_ind < 0
;

-- 1st class males with name master
UPDATE final_model_test
SET weighting = 100
WHERE sex = - 1 
AND name_score = 5 
AND pclass = 1
;

-- 1st class males with name <> master
UPDATE final_model_test
SET weighting = - 10
WHERE sex = - 1 
AND name_score <> 5 
AND pclass = 1
;

-- 2nd class males
UPDATE final_model_test
SET weighting = -50
WHERE sex = -1 
AND pclass = 2
;

-- 3rd class males
UPDATE final_model_test
SET weighting = -50
WHERE sex = -1 
AND pclass = 3
;

