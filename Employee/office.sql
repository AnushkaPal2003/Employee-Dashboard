--------------- Employee Data Analysis & Business Insights using SQL --------------------

CREATE DATABASE office;
USE office;

SELECT * FROM emp;
SELECT * FROM emp_sal;

------------------- STEP 1: DATA CLEANING -------------------

-- Check missing salary records
SELECT *
FROM emp_sal
WHERE salary IS NULL;

-- Check employees without salary record
SELECT e.*
FROM emp e
LEFT JOIN emp_sal es ON e.eid = es.eid
WHERE es.eid IS NULL;

-- Find duplicate employees
SELECT name, dob, city, COUNT(*) AS duplicate_count
FROM emp
GROUP BY name, dob, city
HAVING COUNT(*) > 1;

-- Format DOB and DOJ
SELECT 
    eid,
    FORMAT(dob, 'yyyy-MM-dd') AS formatted_dob,
    FORMAT(doj, 'yyyy-MM-dd') AS formatted_doj
FROM emp;

-- Convert emails to lowercase
SELECT 
    email,
    LOWER(email) AS cleaned_email
FROM emp;

-- Format phone numbers to +91 format
SELECT 
    phone,
    '+91-' + RIGHT(phone, 10) AS formatted_phone
FROM emp;

-- Check for orphan records (salary without employee)
SELECT *
FROM emp_sal es
LEFT JOIN emp e ON es.eid = e.eid
WHERE e.eid IS NULL;

------------------- STEP 2: JOINS & BASIC RETRIEVAL -------------------

-- Retrieve employee name, department, and salary
SELECT 
    e.name, 
    es.dept, 
    es.salary
FROM emp e
INNER JOIN emp_sal es ON e.eid = es.eid;

-- Employees without salary record (FIXED)
SELECT 
    e.name
FROM emp e
LEFT JOIN emp_sal es ON e.eid = es.eid
WHERE es.eid IS NULL;

-- Employees with salary > 300000
SELECT 
    e.name, 
    e.city, 
    es.salary, 
    es.desi
FROM emp e
INNER JOIN emp_sal es ON e.eid = es.eid
WHERE es.salary > 300000;

-- Employees from Delhi in HR
SELECT 
    e.name
FROM emp e
INNER JOIN emp_sal es ON e.eid = es.eid
WHERE e.city = 'Delhi' AND UPPER(es.dept) = 'HR';

------------------- STEP 3: AGGREGATIONS -------------------

-- Count distinct salaries
SELECT COUNT(DISTINCT salary) AS distinct_salary_count
FROM emp_sal;

-- Average salary per department
SELECT 
    dept, 
    AVG(salary) AS avg_salary
FROM emp_sal
GROUP BY dept;

-- Highest-paid employee per department
SELECT name, dept, salary
FROM (
    SELECT 
        e.name, 
        es.dept, 
        es.salary,
        ROW_NUMBER() OVER (PARTITION BY es.dept ORDER BY es.salary DESC) AS rn
    FROM emp e
    INNER JOIN emp_sal es ON e.eid = es.eid
) ranked
WHERE rn = 1;

-- Employees joined per year
SELECT 
    YEAR(doj) AS joining_year,
    COUNT(eid) AS employee_count
FROM emp
GROUP BY YEAR(doj);

-- Salary distribution per department
SELECT 
    dept,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary
FROM emp_sal
GROUP BY dept;

------------------- STEP 4: STRING & DATE FUNCTIONS -------------------

-- Extract birth year and accurate age
SELECT 
    name,
    YEAR(dob) AS birth_year,
    DATEDIFF(YEAR, dob, GETDATE()) AS age
FROM emp;

-- Format phone numbers
SELECT 
    phone,
    '+91-' + RIGHT(phone, 10) AS formatted_phone
FROM emp;

-- Split email into username and domain
SELECT 
    CASE 
        WHEN CHARINDEX('@', email) > 0 
        THEN SUBSTRING(email, 1, CHARINDEX('@', email) - 1)
        ELSE NULL
    END AS username,
    CASE 
        WHEN CHARINDEX('@', email) > 0 
        THEN SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email))
        ELSE NULL
    END AS domain
FROM emp;

------------------- STEP 5: CONDITIONAL QUERIES -------------------

-- Managers earning less than 250000
SELECT 
    e.name
FROM emp e
INNER JOIN emp_sal es ON e.eid = es.eid
WHERE es.desi = 'Manager' AND es.salary < 250000;

-- Employees with name containing 'Sharma'
SELECT 
    name
FROM emp
WHERE name LIKE '%Sharma%';

-- Employees joined before 2013 and earning < 300000
SELECT 
    e.name
FROM emp e
INNER JOIN emp_sal es ON e.eid = es.eid
WHERE YEAR(e.doj) < 2013 AND es.salary < 300000;

------------------- STEP 6: WINDOW FUNCTIONS -------------------

-- Rank employees by salary within department
SELECT 
    e.name,
    es.dept,
    RANK() OVER (PARTITION BY es.dept ORDER BY es.salary DESC) AS salary_rank
FROM emp e
INNER JOIN emp_sal es ON e.eid = es.eid;

-- Second-highest salary in each department
SELECT name, salary
FROM (
    SELECT 
        e.name,
        es.salary,
        RANK() OVER (PARTITION BY es.dept ORDER BY es.salary DESC) AS rnk
    FROM emp e
    INNER JOIN emp_sal es ON e.eid = es.eid
) ranked
WHERE rnk = 2;

-- Cumulative salary distribution
SELECT 
    dept,
    salary,
    SUM(salary) OVER (PARTITION BY dept ORDER BY salary DESC) AS cumulative_salary
FROM emp_sal;

------------------- STEP 7: BUSINESS INSIGHTS -------------------

-- City with highest average salary
SELECT TOP 1
    e.city,
    AVG(es.salary) AS avg_salary
FROM emp e
INNER JOIN emp_sal es ON e.eid = es.eid
GROUP BY e.city
ORDER BY avg_salary DESC;

-- Department with lowest average salary (underpaid)
SELECT TOP 1
    dept,
    AVG(salary) AS avg_salary
FROM emp_sal
GROUP BY dept
ORDER BY avg_salary ASC;

-- Salary gap across designations (FIXED)
SELECT 
    desi,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM emp_sal
WHERE desi IN ('Associate', 'Manager', 'VP')
GROUP BY desi
ORDER BY avg_salary DESC;

