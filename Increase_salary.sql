--Increase salary for those who has even ID number and her/his salary smaller then the avarage salary.
SET serveroutput on;

DROP TABLE Emp;
CREATE TABLE Emp
AS SELECT * FROM Employees;

DECLARE
	CURSOR EvenID IS
		SELECT Employee_ID, Salary
			FROM Emp
			WHERE MOD(Employee_ID,2) = 0;

	v_Avg Emp.Salary%TYPE;

	BEGIN
		SELECT AVG(Salary)
			INTO v_Avg
			FROM Emp Emp_A
			JOIN(
				SELECT Employee_ID
					FROM Emp
					WHERE MOD(Employee_ID,2) = 0
				) Emp_B
			ON Emp_A.Employee_ID = Emp_B.Employee_ID;

		DBMS_OUTPUT.PUT_LINE('Avarage salary of those who have Even ID number: ' || TO_CHAR(v_Avg));

		--Checking the employees
		FOR Onebyone IN(
			SELECT Employee_ID, Salary
			FROM Emp
			)

		LOOP
			FOR i IN EvenID
			LOOP
				IF (Onebyone.Employee_ID = i.Employee_ID)
					AND (v_Avg - Onebyone.Salary > 0)
				THEN
					UPDATE Emp
						SET Salary = Salary + ROUND((v_Avg - Salary) * 0.2)
						WHERE Emp.Employee_ID = i.Employee_ID;

				DBMS_OUTPUT.PUT_LINE(TO_CHAR(Onebyone.Employee_ID) || ' ' || TO_CHAR(v_Avg - Onebyone.Salary));

				EXIT;
				END IF;
			END LOOP;
		END LOOP;
	END;
