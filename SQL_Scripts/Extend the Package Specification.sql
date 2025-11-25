CREATE OR REPLACE PACKAGE salary_pkg AS
    -- Function to calculate RSSB tax
    FUNCTION calc_rssb(gross NUMBER) RETURN NUMBER;

    -- Function to calculate net salary
    FUNCTION net_salary(gross NUMBER) RETURN NUMBER;

    -- Procedure: Show salary for a single worker
    PROCEDURE show_worker_salary(p_worker_id NUMBER);

    -- Procedure: Show salary for all workers (bulk)
    PROCEDURE show_all_salaries;
END salary_pkg;
/
