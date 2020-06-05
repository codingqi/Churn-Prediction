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
  


SELECT
  a.*, 
  b.*
    FROM user_problem_t as a
    LEFT JOIN school_payment_t  as b
    ON a.user_id = b.user_id
LIMIT 1000  

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
  

  
 
  
