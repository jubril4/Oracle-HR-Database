# Oracle HR Database

An 8 table human resources schema built in Oracle 21c for Database Management at Capitol Technology University.

- **Schema design:** 8 related tables linked by 7 foreign keys
- **Auditing:** PL/SQL triggers stamp every insert and update with the user and date
- **Reporting:** views that use joins and the `LEAD` window function to turn pay records into a full employment history, giving each salary period an end date

Run `hr_database.sql` in Oracle SQL Developer or SQL*Plus against an Oracle 21c database.
