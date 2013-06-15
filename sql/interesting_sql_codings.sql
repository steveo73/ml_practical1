### Train Data Set

source /home/steveo/kaggle/titanic/sql/drop_tables.sql;
source /home/steveo/kaggle/titanic/sql/create_table.sql;
source /home/steveo/kaggle/titanic/sql/load_table.sql;
source /home/steveo/kaggle/titanic/sql/update_data.sql;

### Test Data Set

source /home/steveo/kaggle/titanic/sql/test_data.sql;
source /home/steveo/kaggle/titanic/sql/update_data_test.sql;

LOAD DATA LOCAL INFILE '/path/to/file.txt' INTO TABLE your-table-name;
source /home/steveo/kaggle/titanic/create_table.sql
select sex, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack group by sex;
select sex, pclass, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack group by sex, pclass;
select sex, totl_family, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack group by sex, totl_family;
select sex, pclass, totl_family, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack group by sex,pclass, totl_family;
select sex, pclass, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack where sex = 1 group by sex, pclass;
select sex, pclass, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack where sex = -1 group by sex, pclass;

+------+--------+------+-------+---------------+
| sex  | pclass | surv | total | percent_lives |
+------+--------+------+-------+---------------+
| -1   |      1 |   45 |   122 |        0.3689 |
| -1   |      2 |   17 |   108 |        0.1574 |
| -1   |      3 |   47 |   347 |        0.1354 |
+------+--------+------+-------+---------------+
3 rows in set (0.00 sec)

MariaDB [titanic]> select sex, pclass, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack where sex = 1 group by sex, pclass;
+------+--------+------+-------+---------------+
| sex  | pclass | surv | total | percent_lives |
+------+--------+------+-------+---------------+
| 1    |      1 |   91 |    94 |        0.9681 |
| 1    |      2 |   70 |    76 |        0.9211 |
| 1    |      3 |   72 |   144 |        0.5000 |
+------+--------+------+-------+---------------+

Females in class 1 & 2 should state as survived.
Males in class 2 & 3 should state as dead.

2 interesting areas to focus on:-
1. Females in 3rd class
2. Males in 1st class


select * from train_data_hack where sex = -1 and pclass =1;
select age_banding, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack where sex = -1 and pclass =1 and totl_family > 0 group by age_banding;

Select totl_family, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack where sex = 1 and pclass =3 and totl_family > 0
group by 1;
Select parch, survived, name, embarked, age from train_data_hack where sex = 1 and pclass =3 and parch = 1 and age = 120;


Select * from train_data_hack where name like '%Lefebre%';

,
; -- > this might show a relationship

Select * from train_data_hack where sex = -1 and pclass =1  and name like '%Master%'  ; -> this is a winner.
Select ticket, Sum(survived) as surv, SUm(1)  as total, SUm(survived)/Sum(1) as percent_lives from train_data_hack where pclass =3 and sex = 1 group by 1 having SUm(1) > 1; -- another winner
Select * from train_data_hack where ticket = '1601';

Rule if female and ticket = dead then high probability death and reverse

INSERT INTO titanic.cabin_ind
(cabin
, cabin_survival_ind
)

SELECT
cabin
, SUM (CASE WHEN survived = 0 THEN -1
ELSE 1
END ) as cabin_ind

FROM titanic.train_data_hack

where sex = 1 and pclass =3
;

SELECT ticket, SUM(CASE WHEN survived = 0 THEN -1 ELSE 1 END)  as cabin_ind  FROM train_data_hack  where sex = 1 group by ticket;






