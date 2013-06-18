USE titanic;
update train_data_hack_test set sex = -1 where sex = 'male';
update train_data_hack_test set sex = 1 where  sex = 'female';
update train_data_hack_test
Set salutatory = Substring(name from locate(',',name)+2 for (locate('.',name) - locate(',',name)-2));
update train_data_hack_test Set ticket_ind= 0 where ticket_ind IS NULL;
update train_data_hack_test Set name_score = 0 where name_score IS NULL;

update train_data_hack_test
JOIN salutatory
ON train_data_hack_test.salutatory =salutatory.salutatory 
Set train_data_hack_test.name_score = salutatory.name_score
;

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
JOIN ticket
ON train_data_hack_test.ticket = ticket.ticket
Set train_data_hack_test.ticket_ind = ticket.ticket_ind
where   train_data_hack_test.sex = 1
;

INSERT INTO final_model_test
(pclass
, name_score
, sex
, age_banding
, ticket_ind
, cabin_ind
)

SELECT
pclass
, name_score
, sex
, age_banding
, ticket_ind
, CASE WHEN cabin IS NULL THEN 0 ELSE 1 END

FROM train_data_hack_test
;
