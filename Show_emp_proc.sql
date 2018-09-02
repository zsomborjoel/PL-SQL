CREATE OR REPLACE PROCEDURE showemps (
    where_in IN VARCHAR2 := NULL
) IS

    TYPE cv_typ IS REF CURSOR;
    cv     cv_typ;
    v_id   employees.employee_id%TYPE;
    v_nm   employees.last_name%TYPE;

BEGIN
    OPEN cv FOR 'SELECT employee_id, last_name
FROM employees
WHERE ' || nvl(where_in,'1=1');

    LOOP
        FETCH cv INTO
            v_id,
            v_nm;
        EXIT WHEN cv%notfound;
        dbms_output.put_line(TO_CHAR(v_id)
                               || '='
                               || v_nm);
    END LOOP;

    CLOSE cv;
END;
