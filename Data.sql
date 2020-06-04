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
LIMIT 1000  

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
user_login_t (class_code is important to identify pair)
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
  

  
 
  
