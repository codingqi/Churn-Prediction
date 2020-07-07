/* 
Data Query
1. I queried data from positive physics' database, and generated three csv files for next step's data engineering. 
The three csv files are: teacher_info.csv, teacher_problem.csv, teacher_student.csv, teacher_login_30.csv

2. I also explored teachers' usage of the three levels. 
*/
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
--- teacher_info.csv
--- teacher_info with  teachers' payment, state, login information, email, num_student

DROP TABLE teacher_info; 
create table teacher_info as (
select 
    a.user_id as teacher_id, 
    a.amount, 
    a.plan, 
    a.upgrade_method, 
    (case when (a.amount>0 OR a.upgrade_method = 'manual') AND LEFT(a.insert_dtm, 10) < '2020-03-12' then 1
    ELSE 0 END) AS paid,
    left(min(a.insert_dtm), 10) as upgrade_time, 
    b.state, 
    c.browser_type, 
    c.device_type, 
    left(c.insert_dtm, 10) as log_time, 
    count(DISTINCT c.insert_dtm) as login_times, 
    max(c.insert_dtm) - min(c.insert_dtm) as login_gap,
    d.email,
    e.num_student
from school_payment_t a
left join school_t b
    on a.school_id = b.id
LEFT JOIN login_info_t c
    ON c.user_id = a.user_id
left join user_t d
    on d.id = a.user_id
left join (SELECT teacher_id, COUNT(DISTINCT student_id) AS num_student
FROM teacher_student
GROUP BY teacher_id) e
    on e.teacher_id = a.user_id
where a.user_id in (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY a.user_id, log_time);

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
--- teacher_problem.csv tracks teachers activity through problem table
create table teacher_problem as(
SELECT 
	user_id,
	COUNT(*) AS num_problems,
	LEFT(insert_dtm, 10) AS TIME,
	SUM(case when problem_type = 1 then 1 ELSE 0 END)/COUNT(*) AS ratio_problem_type1,
	SUM(case when problem_type = 2 then 1 ELSE 0 END)/COUNT(*) AS ratio_problem_type2,
	SUM(case when problem_type = 3 then 1 ELSE 0 END)/COUNT(*) AS ratio_problem_type3
FROM user_problem_t
WHERE user_id IN (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY user_id, TIME); 

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
--- teacher_student.csv identifies teacher and student relationship, and students' score/performance

--- First, identify teacher_student pair. 
DROP TABLE teacher_student; 
create  TABLE teacher_student AS(
SELECT 
	a.user_id AS teacher_id, b.user_id as student_id
	from
		(SELECT * FROM user_school_t
		where user_id IN (SELECT user_id FROM user_role_t WHERE role_id = 2)) a 
	left JOIN 
		(SELECT * from user_school_t
		where user_id IN (SELECT user_id FROM user_role_t WHERE role_id = 3)) b
	on a.school_id = b.school_id 
ORDER BY a.user_id);

--- Second, query students' score. 
--- student_score
CREATE TABLE student_score0 AS (
SELECT 
	 a.*, 
    b.unit_id, 
    COUNT(*) AS num_problems,
	 (case when a.problem_type = 1 then AVG(a.accuracy_score)
	 ELSE AVG(a.score) end ) AS avg_score
from
	 (select
    	user_id AS student_id, 
    	problem_type,
    	skill_id,
    	score,
    	accuracy_score,
    	insert_dtm,
    	update_dtm
 	 from user_problem_t
 		where 
      user_id IN (SELECT user_id FROM user_role_t WHERE role_id = 3)
      and(score>0 or
      accuracy_score>0) ) a
left join unit_skill_t b
    on b.skill_id = a.skill_id
GROUP BY a.student_id, b.unit_id, a.problem_type);

--- Thrid, add teacher_id to student_score
create table student_score as (
SELECT 
	a.student_id,
	a.problem_type,
	a.insert_dtm,
	a.update_dtm,
	a.unit_id,
	a.num_problems,
	a.avg_score,
	b.teacher_id
FROM student_score0 a
LEFT JOIN teacher_student b
ON b.student_id = a.student_id);




-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
--- teacher_login_30.csv identifies teacher first 30 days' login behavior
--- id, first_lot, last_log, age_days= last-first, churn = 1 if age_day<30, # of login first 30 days



SELECT e.*, f.churn
from
(SELECT d.user_id, COUNT(log_date) AS num_log_30
from
(SELECT c.* from
(SELECT a.*, b.first_log_30
from
(select user_id, left(insert_dtm, 10) as log_date
from login_info_t
where user_id in (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY user_id, log_date) a
LEFT JOIN 
(SELECT 
	user_id, 
	date_add(first_log, INTERVAL 30 day) AS first_log_30
from
(SELECT 
	user_id, 
	MIN(log_date) as first_log
from
(select user_id, left(insert_dtm, 10) as log_date
from login_info_t
where user_id in (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY user_id, log_date) a
GROUP BY user_id) b) b
ON a.user_id = b.user_id) c
WHERE c.log_date<c.first_log_30) d
GROUP BY d.user_id) e
LEFT JOIN
(SELECT 
	user_id, 
	(case when age_days<=30 then 1
	ELSE 0 END) AS churn
from
(SELECT user_id, DATEDIFF(last_log, first_log) AS age_days 
from
(SELECT 
	user_id, 
	MIN(log_date) as first_log, 
	max(log_date) as last_log
from
(select user_id, left(insert_dtm, 10) as log_date
from login_info_t
where user_id in (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY user_id, log_date) a
GROUP BY user_id) b) c
) f
ON e.user_id = f.user_id
where e.user_id in (SELECT b.user_id from
(SELECT 
	user_id, 
	MIN(log_date) as first_log
from
(select user_id, left(insert_dtm, 10) as log_date
from login_info_t
where user_id in (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY user_id, log_date) a
GROUP BY user_id) b
WHERE b.first_log <'2020-01-01')




-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
--- Users number by level
--- Teachers
SELECT COUNT(DISTINCT user_id) AS num_teachers, LEVEL
FROM user_level_t
WHERE user_id IN  (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY LEVEL; 

--- Students
SELECT COUNT(DISTINCT user_id) AS num_teachers, LEVEL
FROM user_level_t
WHERE user_id IN  (SELECT user_id FROM user_role_t WHERE role_id = 3)
GROUP BY LEVEL; 



