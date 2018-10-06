--Based on the 'HR' database

--Department checker

SET SERVEROUTPUT ON;

ACCEPT Province PROMPT 'Enter the province name: '
ACCEPT City PROMPT 'Enter the city name: '
ACCEPT Street PROMPT 'Enter the street adress: '

BEGIN
	--Loop is required if the input location has multiply departments
    For rec IN
    (
	SELECT
		Dept.Department_name DeptName,
		SUM(Emp.Salary) SumSal,
		COUNT(Emp.Employee_id) NumOfEmp
	FROM Employees Emp
	JOIN Departments Dept
		ON Emp.Department_id = Dept.Department_id
	JOIN Locations Loc
		ON Dept.Location_id = Loc.Location_id
	WHERE UPPER (Loc.State_province) LIKE UPPER ('%&Province%')
		AND UPPER (Loc.City) LIKE UPPER('%&City%')
		AND UPPER (Loc.Street_address) LIKE UPPER ('%&Street%')
	GROUP BY Dept.Department_name
    )

	LOOP
        DBMS_OUTPUT.PUT_LINE('In the ' || rec.DeptName || ' department the total salary is ' || rec.SumSal || '$.');
        DBMS_OUTPUT.PUT_LINE('In the ' || rec.DeptName || ' department the number of employees are ' || rec.NumOfEmp || '.');
    END LOOP;
	
	EXCEPTION 
		WHEN VALUE_ERROR THEN
			DBMS_OUTPUT.PUT_LINE('One of the provided value is not compatible');
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('An error occured. Please contact your IT department.');
END;
