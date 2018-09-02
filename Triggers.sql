--This Trigger dont let the user drop any schema.
CREATE OR REPLACE TRIGGER undroppable_schema
BEFORE DROP ON SCHEMA
	BEGIN
		RAISE_APPLICATION_ERROR(-20000,'You cannot drop schema in production database');
	END;



--This trigger dont let the user drop, insert, or increase salary for those employees whos salary is higher than the avarage

--1) First we create a sub function for the TRIGGER
CREATE OR REPLACE FUNCTION Sub_avg_sal(Deptno NUMBER)
RETURN NUMBER
IS
  v_avg NUMBER(8,2);

BEGIN
  DBMS_OUTPUT.PUT_LINE('Counting the average salary');
  SELECT AVG(Salary)
    INTO v_avg
    FROM Employees
    GROUP BY Department_ID
    HAVING Department_ID = Deptno;
  RETURN v_avg;
END;

--2) Than we create the trigger
CREATE OR REPLACE TRIGGER Dml_check
BEFORE DELETE OR INSERT OR UPDATE ON Employees
FOR EACH ROW

DECLARE
  v_avg NUMBER;
  DeleteError EXCEPTION;
  InsertError EXCEPTION;
  UpdateError EXCEPTION;
BEGIN
  DBMS_OUTPUT.PUT_LINE('The DML Checking trigger is active.');
  IF DELETING THEN
    IF :OLD.Salary >= Sub_avg_sal(:OLD.Department_ID)
    THEN
      RAISE DeleteError;
    END IF;
  ELSIF INSERTING THEN
    IF :NEW.Salary >= Sub_avg_sal(:NEW.Department_ID)
    THEN
      RAISE InsertError;
    END IF;
  ELSIF UPDATING THEN
    IF :OLD.Salary >= Sub_avg_sal(:OLD.Department_ID)
    THEN
      RAISE UpdateError;
    END IF;
  END IF;

EXCEPTION
  WHEN DeleteError THEN
    RAISE_APPLICATION_ERROR(-20001,'Can not be deleted.');
  WHEN InsertError THEN
    RAISE_APPLICATION_ERROR(-20002,'Can not be inserted.');
  WHEN UpdateError THEN
    RAISE_APPLICATION_ERROR(-20003,'Can not be updated.');
END;
