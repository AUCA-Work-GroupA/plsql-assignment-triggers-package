CREATE OR REPLACE PACKAGE BODY salary_pkg AS

    -- Function: 3% RSSB tax
    FUNCTION calc_rssb(gross NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN gross * 0.03;
    END calc_rssb;

    -- Function: Net salary after RSSB
    FUNCTION net_salary(gross NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN gross - calc_rssb(gross);
    END net_salary;

    -- Procedure: Show salary for a single worker
    PROCEDURE show_worker_salary(p_worker_id NUMBER) IS
        v_name workers.full_name%TYPE;
        v_gross workers.gross_salary%TYPE;
        v_tax NUMBER;
        v_net NUMBER;
    BEGIN
        SELECT full_name, gross_salary
        INTO v_name, v_gross
        FROM workers
        WHERE worker_id = p_worker_id;

        v_tax := calc_rssb(v_gross);
        v_net := net_salary(v_gross);

        DBMS_OUTPUT.PUT_LINE('Worker Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Gross Salary: ' || v_gross);
        DBMS_OUTPUT.PUT_LINE('RSSB Tax (3%): ' || v_tax);
        DBMS_OUTPUT.PUT_LINE('Net Salary: ' || v_net);
        DBMS_OUTPUT.PUT_LINE('-------------------------');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No worker found with ID ' || p_worker_id);
    END show_worker_salary;

    -- Procedure: Show salary for all workers using a cursor loop
    PROCEDURE show_all_salaries IS
        CURSOR c_workers IS
            SELECT worker_id, full_name, gross_salary FROM workers;
        v_worker c_workers%ROWTYPE;
        v_tax NUMBER;
        v_net NUMBER;
    BEGIN
        OPEN c_workers;
        LOOP
            FETCH c_workers INTO v_worker;
            EXIT WHEN c_workers%NOTFOUND;

            v_tax := calc_rssb(v_worker.gross_salary);
            v_net := net_salary(v_worker.gross_salary);

            DBMS_OUTPUT.PUT_LINE('Worker Name: ' || v_worker.full_name);
            DBMS_OUTPUT.PUT_LINE('Gross Salary: ' || v_worker.gross_salary);
            DBMS_OUTPUT.PUT_LINE('RSSB Tax (3%): ' || v_tax);
            DBMS_OUTPUT.PUT_LINE('Net Salary: ' || v_net);
            DBMS_OUTPUT.PUT_LINE('-------------------------');
        END LOOP;
        CLOSE c_workers;
    END show_all_salaries;

END salary_pkg;
/
