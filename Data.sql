
******************************* big table ****************************************
select
  a.user_id,  
  left(a.insert_dtm, 10) AS problem_time,
  b.amount, b.plan, left(b.insert_dtm, 10) AS pay_time,
  c.upgrade_status, c.state
FROM user_problem_t a
left join school_payment_t b
  on a.user_id = b.user_id
left join (select a.user_id, b.upgrade_status, b.state
            from user_role_t a
            left join school_t b
            on a.id = b.id) c
  on a.user_id = c.user_id  
where a.user_id in (SELECT user_id FROM user_role_t WHERE role_id = 2)
GROUP BY user_id, problem_time
ORDER BY user_id, problem_time
LIMIT 1000




SELECT
  a.*, 
  b.*,
  c.*,
  d.*,
  e.*,
  f.*,
  g.*
    FROM user_problem_t as a
    LEFT JOIN school_payment_t  as b
    ON a.user_id = b.user_id
    LEFT JOIN user_skill_t as c
    ON a.user_id = c.user_id
    LEFT JOIN user_login_t AS d
    ON a.user_id = d.user_id 
    LEFT JOIN user_level_t AS e
    ON a.user_id = e.user_id
    LEFT JOIN user_role_t f
    ON a.user_id = f.user_id
    LEFT JOIN school_t g
    ON f.id = g.id
LIMIT 1000  ;

************************************* user_problem_t userful columns **************************************
select
  user_id, skill_id, problem_id, problem_type, problem_status, tolerance, score, high_score, accuracy_score, 
  completion_score, correction_score, correction_high_score, user_attempts, access, insert_dtm
from user_problem_t
limit 1000


************************************** teacher ************************************************************
* prepare teachers' activity table
* join user_problem_t (user_id), school_payment_t(user_id), user_level_t (user_id), user_role_t (user_id, id), school_t (id)


select
  a.user_id, a.skill_id, a.problem_id, a.problem_type, a.problem_status, a.tolerance, a.score, a.high_score, a.accuracy_score, 
  a.completion_score, a.correction_score, a.correction_high_score, a.user_attempts, a.access, left(a.insert_dtm, 10) AS problem_time,
  b.amount, b.currency, b.plan, b.description, left(b.insert_dtm, 10) AS pay_time,
  c.upgrade_status, c.state, c.country
from user_problem_t a
left join school_payment_t b
  on a.user_id = b.user_id
left join (select a.user_id, b.upgrade_status, b.state, b.country
            from user_role_t a
            left join school_t b
            on a.id = b.id) c
  on a.user_id = c.user_id    
where a.user_id in (SELECT user_id FROM user_role_t WHERE role_id = 3)
limit 1000; 


select
  a.user_id, a.skill_id,
  SUM(a.tolerance) over (PARTITION BY a.user_id, LEFT(a.insert_dtm, 10)) AS avg_tolerance
   a.tolerance, a.score, a.high_score, a.accuracy_score, 
  a.completion_score, a.correction_score, a.correction_high_score, a.user_attempts, a.access, left(a.insert_dtm, 10) AS problem_time
FROM user_problem_t a

ORDER BY user_id
LIMIT 1000


**
SELECT
	user_id,
	(case when tolerance = 0 then NULL 
	 else tolerance end) AS tolerance
FROM user_problem_t 
		 






***************************** user_id
*** a
user_problem_t
  user_id
*** b  
school_payment_t
  user_id, school_id...
*** c   
user_skill_t
  user_id, skill_id...
*** d  
user_login_t (class_code and teachers' id are the same things)
  user_id, class_code
*** e
user_level_t
  user_id, level

*************************************id
*** f
user_role_t
  user_id, id, role_id
  
user_t    (email, state, country)
  id
*** g
school_t
  id, zip_code, class_code
********************************** skill_id
unit_skill_t
  skill_id, unit_id


************************************* student and teacher **************************************************
SELECT user_id FROM user_role_t WHERE role_id = 2



select distinct school_id
from school_payment_t
where amount != 0
  

 

SELECT
  a.*, 
  b.*
    FROM user_problem_t as a
    LEFT JOIN school_payment_t  as b
    ON a.user_id = b.user_id
WHERE a.user_id IN (SELECT user_id FROM user_role_t WHERE role_id = 2)
LIMIT 1000  
ORDER BY a.user_id, problem_id


***************************** user_id
*** a
user_problem_t
  user_id
*** b  
school_payment_t
  user_id, school_id...
*** c   
user_skill_t
  user_id, skill_id...
*** d  
user_login_t (class_code and teachers' id are the same things)
  user_id, class_code
*** e
user_level_t
  user_id, level

*************************************id
*** f
user_role_t
  user_id, id, role_id
  
user_t    (email, state, country)
  id
*** g
school_t
  id, zip_code, class_code
********************************** skill_id
unit_skill_t
  skill_id, unit_id
  

  
 
  
