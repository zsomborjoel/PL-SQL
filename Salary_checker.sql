--Based on the 'HR' database

--Salary checker
SET SERVEROUTPUT ON;

VARIABLE Delta1 NUMBER

ACCEPT inp_Salary PROMPT 'Enter the salary: '

DECLARE
    AvgSalary EMPLOYEES.SALARY%TYPE;
	Salary EMPLOYEES.SALARY%TYPE;
	Delta2 EMPLOYEES.SALARY%TYPE;

BEGIN
	SELECT ROUND(AVG(Salary))
	INTO AvgSalary
	FROM Employees;

	Salary := TO_NUMBER('&inp_Salary');
    :Delta1 := AvgSalary - Salary;
    Delta2 := Salary - AvgSalary;

	DBMS_OUTPUT.PUT_LINE('===============================================================');
    IF Salary < AvgSalary
    THEN
        DBMS_OUTPUT.PUT_LINE('This salary is less with ' || :Delta1 || '$ than the avarage salary.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('This salary is more with ' || Delta2 || '$ then the average salary.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('===============================================================');
END;
