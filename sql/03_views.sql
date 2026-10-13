-- =====================================================================
-- Oracle HR Database: 03 Reporting views
-- =====================================================================

-- One row per employee with their hire date (earliest pay record)
CREATE OR REPLACE VIEW v_employee AS
SELECT e.employee_guid,
       e.first_name,
       e.last_name,
       e.email,
       e.phone_number,
       MIN(ep.effective_date) AS hire_date
FROM   employees e
JOIN   employment     em ON em.employee_guid   = e.employee_guid
JOIN   employment_pay ep ON ep.employment_guid = em.employment_guid
GROUP  BY e.employee_guid, e.first_name, e.last_name, e.email, e.phone_number;

-- Full pay history. LEAD looks at the employee's next pay record, so each
-- salary period gets an end date the day before the next one starts.
-- The current period has a NULL end date.
CREATE OR REPLACE VIEW v_employment AS
SELECT e.employee_guid,
       em.employment_guid,
       e.first_name,
       e.last_name,
       j.job_title,
       d.department_name,
       ep.effective_date AS start_date,
       LEAD(ep.effective_date) OVER (
           PARTITION BY e.employee_guid
           ORDER BY ep.effective_date
       ) - 1             AS end_date,
       ep.salary,
       ep.commission_pct
FROM   employees e
JOIN   employment     em ON em.employee_guid   = e.employee_guid
JOIN   jobs           j  ON j.job_guid         = em.job_guid
JOIN   departments    d  ON d.department_guid  = em.department_guid
JOIN   employment_pay ep ON ep.employment_guid = em.employment_guid;

-- Current salary per employee compared with the pay band for their job
CREATE OR REPLACE VIEW v_salary_vs_band AS
SELECT v.first_name,
       v.last_name,
       v.job_title,
       v.department_name,
       v.salary,
       j.min_salary,
       j.max_salary,
       CASE
           WHEN v.salary < j.min_salary THEN 'Below band'
           WHEN v.salary > j.max_salary THEN 'Above band'
           ELSE 'Within band'
       END AS band_status
FROM   v_employment v
JOIN   jobs j ON j.job_title = v.job_title
WHERE  v.end_date IS NULL;
