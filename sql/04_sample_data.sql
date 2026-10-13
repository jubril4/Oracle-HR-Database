-- =====================================================================
-- Oracle HR Database: 04 Sample data (fictional people and places)
-- Primary keys fill in automatically with SYS_GUID, and foreign keys are
-- looked up by name, so no GUIDs need to be typed by hand.
-- =====================================================================

-- Regions and countries
INSERT INTO regions (region_name) VALUES ('Americas');
INSERT INTO regions (region_name) VALUES ('Europe');

INSERT INTO countries (country_name, region_guid)
SELECT 'United States', region_guid FROM regions WHERE region_name = 'Americas';
INSERT INTO countries (country_name, region_guid)
SELECT 'Canada', region_guid FROM regions WHERE region_name = 'Americas';
INSERT INTO countries (country_name, region_guid)
SELECT 'United Kingdom', region_guid FROM regions WHERE region_name = 'Europe';

-- Locations
INSERT INTO locations (street_address, postal_code, city, state_province, country_guid)
SELECT '100 Innovation Way', '20708', 'Laurel', 'MD', country_guid FROM countries WHERE country_name = 'United States';
INSERT INTO locations (street_address, postal_code, city, state_province, country_guid)
SELECT '250 Peachtree Center Ave', '30303', 'Atlanta', 'GA', country_guid FROM countries WHERE country_name = 'United States';
INSERT INTO locations (street_address, postal_code, city, state_province, country_guid)
SELECT '12 Harbour Street', 'E14 5AB', 'London', NULL, country_guid FROM countries WHERE country_name = 'United Kingdom';

-- Departments
INSERT INTO departments (department_name, location_guid)
SELECT 'Information Technology', location_guid FROM locations WHERE city = 'Laurel';
INSERT INTO departments (department_name, location_guid)
SELECT 'Human Resources', location_guid FROM locations WHERE city = 'Laurel';
INSERT INTO departments (department_name, location_guid)
SELECT 'Finance', location_guid FROM locations WHERE city = 'Atlanta';
INSERT INTO departments (department_name, location_guid)
SELECT 'Operations', location_guid FROM locations WHERE city = 'London';

-- Jobs with pay bands
INSERT INTO jobs (job_title, min_salary, max_salary) VALUES ('IT Support Technician',  45000,  70000);
INSERT INTO jobs (job_title, min_salary, max_salary) VALUES ('Systems Administrator',  65000,  95000);
INSERT INTO jobs (job_title, min_salary, max_salary) VALUES ('HR Generalist',          50000,  75000);
INSERT INTO jobs (job_title, min_salary, max_salary) VALUES ('Financial Analyst',      60000,  90000);
INSERT INTO jobs (job_title, min_salary, max_salary) VALUES ('Operations Manager',     80000, 120000);

-- Employees
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Avery',   'Brooks',   'abrooks@example.com',   '301-555-0101');
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Jordan',  'Mitchell', 'jmitchell@example.com', '301-555-0102');
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Taylor',  'Nguyen',   'tnguyen@example.com',   '301-555-0103');
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Morgan',  'Patel',    'mpatel@example.com',    '404-555-0104');
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Casey',   'Okafor',   'cokafor@example.com',   '404-555-0105');
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Riley',   'Thompson', 'rthompson@example.com', '+44 20 5550 0106');
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Quinn',   'Alvarez',  'qalvarez@example.com',  '301-555-0107');
INSERT INTO employees (first_name, last_name, email, phone_number) VALUES ('Devon',   'Carter',   'dcarter@example.com',   '404-555-0108');

-- Employment records: employee + job + department
INSERT INTO employment (employee_guid, job_guid, department_guid)
SELECT e.employee_guid, j.job_guid, d.department_guid
FROM   employees e, jobs j, departments d
WHERE  (e.email, j.job_title, d.department_name) IN (
         ('abrooks@example.com',   'IT Support Technician', 'Information Technology'),
         ('jmitchell@example.com', 'Systems Administrator', 'Information Technology'),
         ('tnguyen@example.com',   'HR Generalist',         'Human Resources'),
         ('mpatel@example.com',    'Financial Analyst',     'Finance'),
         ('cokafor@example.com',   'Financial Analyst',     'Finance'),
         ('rthompson@example.com', 'Operations Manager',    'Operations'),
         ('qalvarez@example.com',  'IT Support Technician', 'Information Technology'),
         ('dcarter@example.com',   'Systems Administrator', 'Information Technology'));

-- Pay history: each raise is a new row
INSERT INTO employment_pay (employment_guid, effective_date, salary, commission_pct)
SELECT em.employment_guid, p.effective_date, p.salary, p.commission_pct
FROM   employment em
JOIN   employees e ON e.employee_guid = em.employee_guid
JOIN  (
        SELECT 'abrooks@example.com'   email, DATE '2022-06-01' effective_date, 48000 salary, CAST(NULL AS NUMBER) commission_pct FROM dual UNION ALL
        SELECT 'abrooks@example.com',          DATE '2023-06-01', 52000, NULL FROM dual UNION ALL
        SELECT 'abrooks@example.com',          DATE '2024-06-01', 56500, NULL FROM dual UNION ALL
        SELECT 'jmitchell@example.com',        DATE '2021-03-15', 70000, NULL FROM dual UNION ALL
        SELECT 'jmitchell@example.com',        DATE '2023-03-15', 78000, NULL FROM dual UNION ALL
        SELECT 'tnguyen@example.com',          DATE '2022-01-10', 52000, NULL FROM dual UNION ALL
        SELECT 'tnguyen@example.com',          DATE '2024-01-10', 57000, NULL FROM dual UNION ALL
        SELECT 'mpatel@example.com',           DATE '2023-09-05', 62000, 0.05 FROM dual UNION ALL
        SELECT 'cokafor@example.com',          DATE '2020-11-02', 64000, 0.05 FROM dual UNION ALL
        SELECT 'cokafor@example.com',          DATE '2022-11-01', 71000, 0.08 FROM dual UNION ALL
        SELECT 'cokafor@example.com',          DATE '2024-11-01', 93000, 0.10 FROM dual UNION ALL
        SELECT 'rthompson@example.com',        DATE '2019-07-01', 85000, NULL FROM dual UNION ALL
        SELECT 'rthompson@example.com',        DATE '2022-07-01', 98000, NULL FROM dual UNION ALL
        SELECT 'qalvarez@example.com',         DATE '2024-08-19', 43000, NULL FROM dual UNION ALL
        SELECT 'dcarter@example.com',          DATE '2023-02-01', 72000, NULL FROM dual UNION ALL
        SELECT 'dcarter@example.com',          DATE '2025-02-01', 80000, NULL FROM dual
      ) p ON p.email = e.email;

-- Make the IT staff report to the senior systems administrator
UPDATE departments
SET    manager_guid = (SELECT employee_guid FROM employees WHERE email = 'jmitchell@example.com')
WHERE  department_name = 'Information Technology';

COMMIT;
