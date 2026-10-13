-- =====================================================================
-- Oracle HR Database: 02 Audit triggers
-- One trigger per table stamps who created and last changed each row.
-- USER is the database account; SYSDATE is the server date and time.
-- =====================================================================

CREATE OR REPLACE TRIGGER trg_regions_audit
    BEFORE INSERT OR UPDATE ON regions
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_countries_audit
    BEFORE INSERT OR UPDATE ON countries
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_locations_audit
    BEFORE INSERT OR UPDATE ON locations
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_departments_audit
    BEFORE INSERT OR UPDATE ON departments
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_employees_audit
    BEFORE INSERT OR UPDATE ON employees
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_jobs_audit
    BEFORE INSERT OR UPDATE ON jobs
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_employment_audit
    BEFORE INSERT OR UPDATE ON employment
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_employment_pay_audit
    BEFORE INSERT OR UPDATE ON employment_pay
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_id   := USER;
        :NEW.created_date := SYSDATE;
    END IF;
    :NEW.updated_id   := USER;
    :NEW.updated_date := SYSDATE;
END;
/
