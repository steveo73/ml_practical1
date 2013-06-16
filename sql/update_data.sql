USE titanic;
update train_data_hack set sex = -1 where sex = 'male';
update train_data_hack set sex = 1 where  sex = 'female';
update train_data_hack set totl_family = sibsp + parch;
update train_data_hack set fare_individual = fare/totl_family;
update train_data_hack set fare_individual = fare where totl_family = 0;
update train_data_hack
Set salutatory = Substring(name from locate(',',name)+2 for (locate('.',name) - locate(',',name)-2));
update salutatory Set name_score = 0 where name_score IS NULL;
update salutatory Set name_score = 5 where salutatory = 'Master';
update salutatory Set name_score = 2 where salutatory = 'Sir';
update salutatory Set name_score = 2 where salutatory = 'Miss';
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
-- creating list survivors females and cabin listing
INSERT INTO cabin_ind (ticket, cabin_survival_ind )
SELECT TICKET, SUM(Cabin_ind) FROM
(
SELECT ticket, CASE WHEN survived = 0 THEN -1 ELSE 1 END  as cabin_ind  FROM train_data_hack  
WHERE sex = 1
UNION ALL
SELECT ticket, survived as cabin_ind  FROM train_data_hack  
WHERE sex = - 1 
) as ci group by TICKET
having SUM(cabin_ind ) <> 0
;

-- creating list survivors and cabin listing
-- the trick here is that there is no negative weighting for non surviving males and only females get updated rating
INSERT INTO cabin_ind (ticket, cabin_survival_ind )
SELECT ticket, SUM(survived )  as cabin_ind  FROM train_data_hack  
WHERE sex = - 1 
group by ticket
having SUM(survived ) <> 0
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
, age
, age_banding
, sibsp
, parch
, totl_family
, cabin_survival_ind
)

SELECT
survived
, pclass
, name_score
, sex
, age
, age_banding
, sibsp
, parch
, totl_family
, cabin_survival_ind

FROM train_data_hack
;

-- Set value of 0
UPDATE final_model
SET weighting = 0
WHERE weighting IS NULL
;

-- 1st class females
UPDATE final_model
SET weighting = 100 
WHERE sex = 1 
AND pclass = 1
;

-- 2nd and 3rd class females with higher cabin survival rate
UPDATE final_model
SET weighting = 80
WHERE sex = 1 
AND pclass IN (2,3)
AND cabin_survival_ind > 0
;

-- 2nd class females with no cabin survival rate
UPDATE final_model
SET weighting = 50
WHERE sex = 1 
AND pclass = 2
;

-- 3rd class females with lower cabin survival rate
UPDATE final_model
SET weighting = -50
WHERE sex = 1 
AND pclass = 3
AND cabin_survival_ind < 0
;

-- 1st class males with name master
UPDATE final_model
SET weighting = 100
WHERE sex = - 1 
AND name_score = 5 
AND pclass = 1
;

-- 1st class males with name <> master
UPDATE final_model
SET weighting = - 10
WHERE sex = - 1 
AND name_score <> 5 
AND pclass = 1
;


-- 2nd class males
UPDATE final_model
SET weighting = -50
WHERE sex = -1 
AND pclass = 2
;

-- 3rd class males
UPDATE final_model
SET weighting = -50
WHERE sex = -1 
AND pclass = 3
;

