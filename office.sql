create database office;
select * from emp;
select * from emp_sal;
use office;

---Q1.) Joins & Basic Retrieval

-- Retrieve the employee name, department, and salary.
select 
    e.name , 
    es.dept , 
    es.salary 
from emp e 
inner join 
emp_sal es 
on e.eid=es.eid;

-- List employees who do not have a salary record.
select 
    e.name from emp e 
    inner join 
emp_sal es on 
e.eid = es.eid 
where 
es.salary is null ;

-- List employees with salary more than 300000, along with designation and city.
select 
    e.name , 
    e.city , 
    es.salary , 
    es.desi 
from emp e 

inner join

emp_sal es 
on e.eid=es.eid 
    where 
es.salary>300000;

-- Get all employees from Delhi working in the HR department.
select 
    e.name from emp e 
inner join 
emp_sal es 
on 
    e.eid=es.eid 
where e.city='Delhi' and dept='HR';

--- Q2.) Aggregations & Grouping

-- Count distinct salary from emp_sal
select count(distinct(salary)) 
from emp_sal;

-- Find the average salary per department.
select 
    dept , 
    avg(salary) 
as 'avg salary' 
from emp_sal 
group by dept;

-- Identify the highest-paid employee in each department.
SELECT 
    name, 
    dept, 
    salary
FROM 
(
SELECT e.name, es.dept, es.salary,
ROW_NUMBER() OVER (PARTITION BY es.dept ORDER BY es.salary DESC) 
AS rn 
FROM emp e 
INNER JOIN emp_sal es ON e.eid = es.eid
)
ranked WHERE rn = 1;

-- Count how many employees joined per year (use DOJ).
select 
    count(eid) as 'Number of employees',
    year(DOJ) as ' year of joining' 
from emp 
group by 
YEAR(DOJ);

-- Show department-wise salary distribution (min, max, avg).
select 
    min(salary) as 'minimum salary',
    max(salary) as 'max salary' , avg(salary)
as 'average salary' , dept 
from emp_sal
group by dept;

---Q3.) String & Date Functions

-- Extract birth year and calculate current age from DOB.
SELECT 
    name,
    YEAR(dob) AS birth_year,
    YEAR(Getdate()) - YEAR(dob) AS age
FROM emp;

-- Format the phone numbers uniformly (e.g., +91-XXXXXXXXXX).
SELECT 
    phone,
    '+91-' + RIGHT(phone, 10) AS formatted_phone
FROM emp;

-- Split email ID username and domain separately.
SELECT 
    CASE 
        WHEN CHARINDEX('@', email) > 0 THEN SUBSTRING(email, 1, CHARINDEX('@', email) - 1)
        ELSE NULL
    END AS Username,
    CASE 
        WHEN CHARINDEX('@', email) > 0 THEN SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email))
        ELSE NULL
    END AS Domain
FROM emp;

--- Q4.) Conditional & Advanced Filters

-- Find employees whose designation is ‘Manager’ but salary < 250000.
select 
    e.name from emp e 
inner join 
emp_sal es 
on e.eid=es.eid 
where
desi='Manager' and salary<250000;

-- Get employees whose name contains ‘Sharma’.
select 
    name from emp
where 
name like '%Sharma%';

-- List employees who joined before 2013 and are still earning < 300000.
select 
    e.name from emp e 
inner join
emp_sal es on e.eid=es.eid 
where YEAR(e.DOJ)<2013 
and
es.SALARY<300000;


---Q5.) Window Functions (for advanced roles):

-- Rank employees based on salary within each department.
select 
    e.name ,
    es.dept ,  
rank() over
(
partition by es.dept
order by 
es.salary desc
) 
as [Rank]
from emp e 
inner join 
emp_sal es on e.eid=es.eid;

-- Get the second-highest salary in each department.
select name , salary from 
(
select e.name , es.salary , 
rank() over(partition by es.dept order by es.salary desc
)
as rm from emp e 
inner join 
emp_sal es on e.eid=es.eid
)
ranked where rm=2;

-- Calculate cumulative salary distribution per department.
select 
    dept,
    salary,
    sum(salary) 
over 
(
partition by dept order by salary desc
)
as [total salary] from emp_sal;

--- Q6.) Data Cleaning & Transformation Questions

-- Standardize date formats (DD-MM-YYYY → YYYY-MM-DD).
select 
    DOB , 
    DOJ , format(DOB, 'yyyy-MM-dd')
as [Formatted DOB] , format(DOJ , 'dd-MM-yyyy') 
as [Formatted DOJ] from emp;

-- Convert email IDs to lowercase.
select email , Lower(email) as [small] from emp;

-- Identify duplicate employees (based on NAME, DOB, city?).
select 
    name , 
    DOB , 
    DOJ , 
    count(Name) as count from emp 
group by 
    name , 
    dob , 
    doj 
having 
count(*)>1;


--- Q7.) Analytical / Business-Oriented Questions

-- Which city has the highest average salary?
select 
    e.city , 
    avg(es.salary) as [Avg Salary] 
    from emp e 
inner join 
emp_sal es on e.eid=es.eid 
    group by e.city 
    order by 
    avg(es.salary) desc;  
-- Conclusion:- Delhi has the highest average salary

-- Which department seems underpaid compared to others?
select 
    dept ,
    avg(salary) as [Avg Salary] 
from emp_sal 
group by 
dept order by 
avg(salary) desc;  
-- Conclusion:- Temp department seems underpaid as compared to others.

What is the salary gap between designations (Associate vs Manager vs VP)?
SELECT 
    desi,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM emp_sal
where desi in ('Assocoate' , 'manager' , 'VP')
GROUP BY desi
ORDER BY avg_salary DESC;

