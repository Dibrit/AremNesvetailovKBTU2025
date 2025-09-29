DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
--1
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    department VARCHAR,
    salary INT,
    hire_date DATE,
    status VARCHAR DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR,
    budget INT,
    manager_id INT REFERENCES employees(emp_id)
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR,
    dept_id INT REFERENCES departments(dept_id),
    start_date DATE,
    end_date DATE,
    budget INT
);


--2
INSERT INTO employees (emp_id, first_name, last_name, department) VALUES (10, 'afg', 'adfd', 'b');
INSERT INTO employees (first_name, last_name, department, salary) VALUES ('a3', 'a4', 'b', DEFAULT);
INSERT INTO departments (dept_name, budget, manager_id) VALUES  ('b', 123, NULL), ('c', 456, NULL), ('d', 789, NULL);
INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES ('a', 'b', 'c', 50000 * 1.1, DATE('now'));


--3
UPDATE employees SET salary = salary * 1.1;
UPDATE employees SET status = 'Senior' WHERE salary > 60000 AND hire_date < '2020-01-01';
UPDATE employees SET department = CASE WHEN salary > 80000 THEN 'Management' WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior' ELSE 'Junior' END;
UPDATE employees SET department = DEFAULT WHERE status = 'Inactive';
UPDATE employees SET salary = salary * 1.15, status = 'Promoted' WHERE department = 'Sales';


--4
DELETE FROM employees WHERE status = 'Terminated';
DELETE FROM employees WHERE salary < 40000 AND hire_date > '2023-01-01' AND department IS NULL;
DELETE FROM projects WHERE end_date < '2023-01-01' RETURNING *;
INSERT INTO employees (first_name, last_name, salary, department) VALUES ('a', 'a', NULL, NULL);
UPDATE employees SET department = 'Unassigned' WHERE department IS NULL;
DELETE FROM employees WHERE salary IS NULL OR department IS NULL;
