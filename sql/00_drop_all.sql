-- =====================================================================
-- Oracle HR Database: 00 Reset (optional)
-- Drops every object so the scripts can be rerun from a clean slate.
-- Errors on the first run are expected because nothing exists yet.
-- =====================================================================

DROP VIEW v_salary_vs_band;
DROP VIEW v_employment;
DROP VIEW v_employee;
DROP TABLE employment_pay CASCADE CONSTRAINTS PURGE;
DROP TABLE employment     CASCADE CONSTRAINTS PURGE;
DROP TABLE jobs           CASCADE CONSTRAINTS PURGE;
DROP TABLE employees      CASCADE CONSTRAINTS PURGE;
DROP TABLE departments    CASCADE CONSTRAINTS PURGE;
DROP TABLE locations      CASCADE CONSTRAINTS PURGE;
DROP TABLE countries      CASCADE CONSTRAINTS PURGE;
DROP TABLE regions        CASCADE CONSTRAINTS PURGE;
