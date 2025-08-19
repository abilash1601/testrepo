create database project_db;
use project_db;

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER, DEPT from emp_record_table;

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER, DEPT,EMP_RATING from emp_record_table where 
EMP_RATING <2 ;

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER, DEPT,EMP_RATING from emp_record_table where 
EMP_RATING>4 ;

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER, DEPT,EMP_RATING from emp_record_table where 
EMP_RATING between 2 and 4 ;

select concat (FIRST_NAME,' ',LAST_NAME) as name, dept from emp_record_table where dept like '%Finance%';

SELECT m.EMP_ID,m.ROLE,COUNT(e.EMP_ID) as "EMP_COUNT" FROM emp_record_table
 as m  INNER join emp_record_table as e ON m.EMP_ID = e.MANAGER_ID group by m.emp_id,m.role order by role desc;


select * from emp_record_table  where dept like '%finance%' or dept like '%healthcare%';

SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM emp_record_table WHERE DEPT = "HEALTHCARE" UNION 
SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM emp_record_table WHERE DEPT = "FINANCE"ORDER BY DEPT,EMP_ID;

select EMP_ID,FIRST_NAME,LAST_NAME,role,DEPT,EMP_RATING,
max(emp_rating) over(partition by dept) as maxrating from emp_record_table ;

select role,
min(salary) as min_sal,
max(salary) as max_sal from emp_record_table group by role ;

select emp_id,concat(first_name,' ',last_name) as name,EXP,
dense_rank() over(order by exp desc ) as emp_rANk from emp_record_table;

 create view emp_detail as select emp_id,concat(first_name,' ',last_name) as name,country,continent from emp_record_table where salary>6000;

select * from emp_detail;


select * from emp_record_table where exp>10;


delimiter :
create procedure retrieve()
begin
select * from emp_record_table where exp>3;
end:
delimiter ;
call retrieve();

DELIMITER &&
create function setstandards(exp decimal(10,2) )
RETURNS VARCHAR(50)
deterministic
BEGIN
	DECLARE jobprofile varchar(50) default '' ;
	IF exp <= 2 THEN SET jobprofile = 'junior data scientist' ;
    ELSEIF exp BETWEEN 2 AND 5 THEN SET jobprofile = 'associate data scientist' ;
	ELSEIF exp BETWEEN 5 AND 10 THEN SET jobprofile = 'senior data scientist' ;
	ELSEIF exp BETWEEN 10 AND 12 THEN SET jobprofile = 'lead data scientist' ;
    ELSE SET jobprofile = 'manager' ;
    end if ;
    RETURN(jobprofile) ;
END &&
delimiter ;
select role, exp,first_name, 
setstandards(exp) AS 'StoredFunction'
from data_science_team ;


create index name
on emp_record_table(first_name(50));

select * from emp_record_table where first_name= 'eric';

select emp_id,emp_rating,salary,((salary*0.05)*emp_rating) as bonus from emp_record_table;

select avg(salary),country,continent from emp_record_table group by country,continent order by COUNTRY,CONTINENT;


