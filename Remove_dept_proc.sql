CREATE OR REPLACE PROCEDURE remove_dept (
    old_dep_id_in   IN employees.department_id%TYPE,
    new_dep_id_in   IN employees.department_id%TYPE
) IS
    emp_count   NUMBER;
BEGIN
    UPDATE employees
    SET
        department_id = new_dep_id_in
    WHERE
        department_id = old_dep_id_in;

    DELETE FROM departments
    WHERE
        department_id = old_dep_id_in;

END;
