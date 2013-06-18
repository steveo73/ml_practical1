USE titanic;
update train_data_hack set sex = -1 where sex = 'male';
update train_data_hack set sex = 1 where  sex = 'female';
update train_data_hack
SET salutatory = Substring(name from locate(',',name)+2 for (locate('.',name) - locate(',',name)-2));
update salutatory Set name_score = 0 where name_score IS NULL;
update salutatory Set name_score = 5 where salutatory = 'Master';
update salutatory Set name_score = 2 where salutatory = 'Sir';
update salutatory Set name_score = 2 where salutatory = 'Miss';
update train_data_hack Set ticket_ind = 0 where ticket_ind IS NULL;

update train_data_hack
JOIN salutatory
ON train_data_hack.salutatory =salutatory.salutatory 
Set train_data_hack.name_score = salutatory.name_score
;

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
-- the trick here is that there is no negative weighting for non surviving males and only females get updated rating
INSERT INTO ticket (ticket, ticket_ind )
SELECT TICKET, SUM(ticket_ind) FROM
(
SELECT ticket, CASE WHEN survived = 0 THEN -1 ELSE 1 END  as ticket_ind  FROM train_data_hack  
WHERE sex = 1
UNION ALL
SELECT ticket, survived as ticket_ind  FROM train_data_hack  
WHERE sex = - 1 
) as ci group by TICKET
having SUM(ticket_ind ) <> 0
;

update train_data_hack
JOIN ticket
ON train_data_hack.ticket = ticket.ticket
Set train_data_hack.ticket_ind = ticket.ticket_ind
where   train_data_hack.sex = 1
;

INSERT INTO final_model
(survived
, pclass
, name_score
, sex
, age_banding
, ticket_ind
, cabin_ind
)

SELECT
survived
, pclass
, name_score
, sex
, age_banding
, ticket_ind
, CASE WHEN cabin IS NULL THEN 0 ELSE 1 END

FROM train_data_hack
;

