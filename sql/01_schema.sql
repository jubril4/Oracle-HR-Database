-- =====================================================================
-- Oracle HR Database: 01 Schema
-- 8 tables, 7 foreign keys, GUID primary keys, audit columns
-- Run as the schema owner (for example HR_APP). Oracle 19c or later.
-- =====================================================================

-- Geography: regions > countries > locations > departments
CREATE TABLE regions (
    region_guid   VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    region_name   VARCHAR2(25)  NOT NULL,
    created_id    VARCHAR2(30),
    created_date  DATE,
    updated_id    VARCHAR2(30),
    updated_date  DATE,
    CONSTRAINT regions_pk PRIMARY KEY (region_guid),
    CONSTRAINT regions_name_uk UNIQUE (region_name)
);

CREATE TABLE countries (
    country_guid  VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    country_name  VARCHAR2(40)  NOT NULL,
    region_guid   VARCHAR2(32)  NOT NULL,
    created_id    VARCHAR2(30),
    created_date  DATE,
    updated_id    VARCHAR2(30),
    updated_date  DATE,
    CONSTRAINT countries_pk PRIMARY KEY (country_guid),
    CONSTRAINT countries_fk1 FOREIGN KEY (region_guid) REFERENCES regions (region_guid)
);

CREATE TABLE locations (
    location_guid   VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    street_address  VARCHAR2(40)  NOT NULL,
    postal_code     VARCHAR2(12),
    city            VARCHAR2(30)  NOT NULL,
    state_province  VARCHAR2(25),
    country_guid    VARCHAR2(32)  NOT NULL,
    created_id      VARCHAR2(30),
    created_date    DATE,
    updated_id      VARCHAR2(30),
    updated_date    DATE,
    CONSTRAINT locations_pk PRIMARY KEY (location_guid),
    CONSTRAINT locations_fk1 FOREIGN KEY (country_guid) REFERENCES countries (country_guid)
);

CREATE TABLE departments (
    department_guid  VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    department_name  VARCHAR2(30)  NOT NULL,
    location_guid    VARCHAR2(32)  NOT NULL,
    manager_guid     VARCHAR2(32),
    created_id       VARCHAR2(30),
    created_date     DATE,
    updated_id       VARCHAR2(30),
    updated_date     DATE,
    CONSTRAINT departments_pk PRIMARY KEY (department_guid),
    CONSTRAINT departments_fk1 FOREIGN KEY (location_guid) REFERENCES locations (location_guid)
);

-- People and jobs
CREATE TABLE employees (
    employee_guid  VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    first_name     VARCHAR2(20),
    last_name      VARCHAR2(25)  NOT NULL,
    email          VARCHAR2(40)  NOT NULL,
    phone_number   VARCHAR2(20),
    created_id     VARCHAR2(30),
    created_date   DATE,
    updated_id     VARCHAR2(30),
    updated_date   DATE,
    CONSTRAINT employees_pk PRIMARY KEY (employee_guid),
    CONSTRAINT employees_email_uk UNIQUE (email)
);

CREATE TABLE jobs (
    job_guid      VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    job_title     VARCHAR2(35)  NOT NULL,
    min_salary    NUMBER(8, 2),
    max_salary    NUMBER(8, 2),
    created_id    VARCHAR2(30),
    created_date  DATE,
    updated_id    VARCHAR2(30),
    updated_date  DATE,
    CONSTRAINT jobs_pk PRIMARY KEY (job_guid),
    CONSTRAINT jobs_salary_band_ck CHECK (min_salary <= max_salary)
);

-- An employment record ties one employee to one job in one department
CREATE TABLE employment (
    employment_guid  VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    employee_guid    VARCHAR2(32)  NOT NULL,
    job_guid         VARCHAR2(32)  NOT NULL,
    department_guid  VARCHAR2(32)  NOT NULL,
    created_id       VARCHAR2(30),
    created_date     DATE,
    updated_id       VARCHAR2(30),
    updated_date     DATE,
    CONSTRAINT employment_pk PRIMARY KEY (employment_guid),
    CONSTRAINT employment_fk1 FOREIGN KEY (job_guid)        REFERENCES jobs (job_guid),
    CONSTRAINT employment_fk2 FOREIGN KEY (employee_guid)   REFERENCES employees (employee_guid),
    CONSTRAINT employment_fk3 FOREIGN KEY (department_guid) REFERENCES departments (department_guid)
);

-- Each pay change is a new row; end dates are derived in V_EMPLOYMENT
CREATE TABLE employment_pay (
    employment_pay_guid  VARCHAR2(32)  DEFAULT RAWTOHEX(SYS_GUID()) NOT NULL,
    employment_guid      VARCHAR2(32)  NOT NULL,
    effective_date       DATE          NOT NULL,
    salary               NUMBER(8, 2),
    commission_pct       NUMBER(3, 2),
    created_id           VARCHAR2(30),
    created_date         DATE,
    updated_id           VARCHAR2(30),
    updated_date         DATE,
    CONSTRAINT employment_pay_pk PRIMARY KEY (employment_pay_guid),
    CONSTRAINT employment_pay_fk1 FOREIGN KEY (employment_guid) REFERENCES employment (employment_guid),
    CONSTRAINT employment_pay_salary_ck CHECK (salary > 0),
    CONSTRAINT employment_pay_comm_ck CHECK (commission_pct BETWEEN 0 AND 1),
    CONSTRAINT employment_pay_once_uk UNIQUE (employment_guid, effective_date)
);

-- Index every foreign key column so joins and parent deletes stay fast
CREATE INDEX countries_region_ix        ON countries (region_guid);
CREATE INDEX locations_country_ix       ON locations (country_guid);
CREATE INDEX departments_location_ix    ON departments (location_guid);
CREATE INDEX employment_employee_ix     ON employment (employee_guid);
CREATE INDEX employment_job_ix          ON employment (job_guid);
CREATE INDEX employment_department_ix   ON employment (department_guid);
