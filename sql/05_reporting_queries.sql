-- =====================================================================
-- Oracle HR Database: 05 Reporting queries
-- Each query answers a question an HR or finance team would ask.
-- =====================================================================

-- 1. Headcount and current payroll by department and city
SELECT d.department_name,
       l.city,
       COUNT(*)              AS headcount,
       SUM(v.salary)         AS current_payroll,
       ROUND(AVG(v.salary))  AS avg_salary
FROM   v_employment v
JOIN   departments d ON d.department_name = v.department_name
JOIN   locations   l ON l.location_guid   = d.location_guid
WHERE  v.end_date IS NULL
GROUP  BY d.department_name, l.city
ORDER  BY current_payroll DESC;

-- 2. Every raise with the percent change from the previous salary (LAG)
SELECT first_name || ' ' || last_name AS employee,
       start_date,
       salary,
       LAG(salary) OVER (PARTITION BY employee_guid ORDER BY start_date) AS prior_salary,
       ROUND(100 * (salary / LAG(salary) OVER (PARTITION BY employee_guid ORDER BY start_date) - 1), 1)
           AS raise_pct
FROM   v_employment
ORDER  BY employee, start_date;

-- 3. Who is paid outside the band for their job?
SELECT first_name, last_name, job_title, salary, min_salary, max_salary, band_status
FROM   v_salary_vs_band
WHERE  band_status <> 'Within band';

-- 4. Highest paid employee in each department (RANK handles ties)
SELECT department_name, employee, salary
FROM  (
        SELECT department_name,
               first_name || ' ' || last_name AS employee,
               salary,
               RANK() OVER (PARTITION BY department_name ORDER BY salary DESC) AS pay_rank
        FROM   v_employment
        WHERE  end_date IS NULL
      )
WHERE  pay_rank = 1;

-- 5. Tenure in years, from the hire date view
SELECT first_name, last_name, hire_date,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date) / 12, 1) AS years_of_service
FROM   v_employee
ORDER  BY hire_date;

-- 6. Audit trail: confirm the triggers stamped every row
SELECT 'EMPLOYEES' AS table_name, COUNT(*) AS total_rows,
       COUNT(created_id) AS rows_with_creator, MAX(updated_date) AS last_change
FROM   employees
UNION ALL
SELECT 'EMPLOYMENT_PAY', COUNT(*), COUNT(created_id), MAX(updated_date)
FROM   employment_pay;
