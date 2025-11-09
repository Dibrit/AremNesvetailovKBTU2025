DROP TABLE IF EXISTS employees; 
DROP TABLE IF EXISTS departments; 
DROP TABLE IF EXISTS projects;
CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 emp_name VARCHAR(50),
 dept_id INT,
 salary DECIMAL(10, 2)
);

CREATE TABLE departments (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(50),
 location VARCHAR(50)
);

CREATE TABLE projects (
 project_id INT PRIMARY KEY,
 project_name VARCHAR(50),
 dept_id INT,
 budget DECIMAL(10, 2)
);
INSERT INTO employees (emp_id, emp_name, dept_id, salary) 
VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id, 
budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);

-- 2.1
CREATE VIEW employee_details AS SELECT e.emp_name, e.salary, d.dept_name, d.location FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id;
SELECT * FROM employee_details;

-- 2.
CREATE VIEW dept_statistics AS SELECT d.dept_name, COUNT(e.emp_id) employee_count, AVG(e.salary) avg_salary, MAX(e.salary) max_salary, MIN(e.salary) min_salary FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id GROUP BY d.dept_id, d.dept_name;
SELECT * FROM dept_statistics ORDER BY employee_count DESC;

-- 2.3
CREATE VIEW project_overview AS SELECT p.project_name, p.budget, d.dept_name, d.location, COUNT(e.emp_id) team_size FROM projects p LEFT JOIN departments d ON p.dept_id = d.dept_id LEFT JOIN employees e ON d.dept_id = e.dept_id GROUP BY p.project_id, p.project_name, p.budget, d.dept_name, d.location;
SELECT * FROM project_overview ORDER BY team_size DESC;

--2.4
CREATE VIEW high_earners AS SELECT e.emp_name, e.salary, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id WHERE e.salary > 55000;
SELECT * FROM high_earners;

-- 3.1
CREATE VIEW employee_details AS SELECT e.emp_name, e.salary, d.dept_name, d.location, CASE WHEN e.salary > 60000 THEN 'High' WHEN e.salary > 50000 THEN 'Medium' ELSE 'Standard' END salary_grade FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id;
SELECT * FROM employee_details;

-- 3.2
CREATE VIEW top_performers AS SELECT * FROM high_earners;
DROP VIEW high_earners;
SELECT * FROM top_performers;

-- 3.3
CREATE VIEW temp_view AS SELECT emp_name, salary FROM employees WHERE salary < 50000;
SELECT * FROM temp_view;

-- 4.1
CREATE VIEW employee_salaries AS SELECT emp_id, emp_name, dept_id, salary FROM employees;
-- 4.2
UPDATE employee_salaries SET salary = 52000 WHERE emp_name = 'John Smith';
SELECT * FROM employees WHERE emp_name = 'John Smith';
-- 4.3
INSERT INTO employee_salaries (emp_id, emp_name, dept_id, salary) VALUES (6, 'Alice Johnson', 102, 58000);
 SELECT * FROM employees WHERE emp_name = 'Alice Johnson';
-- 4.4 
CREATE VIEW it_employees AS SELECT emp_id, emp_name, dept_id, salary FROM employees WHERE dept_id = 101 WITH LOCAL CHECK OPTION;
INSERT INTO it_employees (emp_id, emp_name, dept_id, salary) VALUES (7, 'Bob Wilson', 103, 60000);

-- 5 part miss
-- 6.1 
CREATE ROLE analyst;
CREATE ROLE data_viewer LOGIN PASSWORD 'viewer123';
CREATE ROLE report_user LOGIN PASSWORD 'report456';
-- (6.2) 
CREATE ROLE db_creator LOGIN CREATEDB PASSWORD 'creator789';
CREATE ROLE user_manager LOGIN CREATEROLE PASSWORD 'manager101';
CREATE ROLE admin_user LOGIN SUPERUSER PASSWORD 'admin999';
-- 6.3
GRANT SELECT ON employees, departments, projects TO analyst;
GRANT ALL PRIVILEGES ON employee_details TO data_viewer;
GRANT SELECT, INSERT ON employees TO report_user;
-- 6.4
CREATE ROLE hr_team;
CREATE ROLE finance_team;
CREATE ROLE it_team;
CREATE ROLE hr_user1 LOGIN PASSWORD 'hr001';
CREATE ROLE hr_user2 LOGIN PASSWORD 'hr002';
CREATE ROLE finance_user1 LOGIN PASSWORD 'fin001';
GRANT hr_team TO hr_user1;
GRANT hr_team TO hr_user2;
GRANT finance_team TO finance_user1;
GRANT SELECT, UPDATE ON employees TO hr_team; 
GRANT SELECT ON dept_statistics TO finance_team;
-- 6.5
REVOKE UPDATE ON employees FROM hr_team;
REVOKE hr_team FROM hr_user2;
REVOKE ALL PRIVILEGES ON employee_details FROM data_viewer;
-- 6.6 
ALTER ROLE analyst LOGIN PASSWORD 'analyst123';
 ALTER ROLE user_manager SUPERUSER;
 ALTER ROLE analyst PASSWORD NULL;
 ALTER ROLE data_viewer CONNECTION LIMIT 5;

-- 7.1 

--67.2
CREATE ROLE project_manager LOGIN PASSWORD 'pm123';
ALTER VIEW dept_statistics OWNER TO project_manager;
ALTER TABLE projects OWNER TO project_manager;
-- 7.3
CREATE ROLE temp_owner LOGIN;
CREATE TABLE temp_table (id INT);
ALTER TABLE temp_table OWNER TO temp_owner;
REASSIGN OWNED BY temp_owner TO postgres;
DROP OWNED BY temp_owner;                        
DROP ROLE temp_owner;
-- 7.4
CREATE VIEW hr_employee_view AS SELECT * FROM employees WHERE dept_id = 102;
GRANT SELECT ON hr_employee_view TO hr_team;
CREATE VIEW finance_employee_view AS SELECT emp_id, emp_name, salary FROM employees;
GRANT SELECT ON finance_employee_view TO finance_team;
-- 8.1
CREATE VIEW dept_dashboard AS SELECT d.dept_name, d.location, COUNT(e.emp_id) AS employee_count, ROUND(AVG(e.salary)::numeric,2) AS avg_salary, COUNT(DISTINCT p.project_id) AS active_projects, COALESCE(SUM(p.budget),0) AS total_project_budget, ROUND(COALESCE(SUM(p.budget),0)/NULLIF(COUNT(e.emp_id),0),2) AS budget_per_employee FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id LEFT JOIN projects p ON d.dept_id = p.dept_id GROUP BY d.dept_name, d.location;
-- 8.2 
ALTER TABLE projects ADD COLUMN created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
CREATE VIEW high_budget_projects AS SELECT p.project_name, p.budget, d.dept_name, p.created_date, CASE WHEN p.budget > 150000 THEN 'Critical Review Required' WHEN p.budget > 100000 THEN 'Management Approval Needed' ELSE 'Standard Process' END AS approval_status FROM projects p LEFT JOIN departments d ON p.dept_id = d.dept_id WHERE p.budget > 75000;
-- 8.3


--2.1 2.3 3.1 3.3 4.2 5ф 6.1 6.2 7.2 7.3 8.3