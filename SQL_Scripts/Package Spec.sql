CREATE OR REPLACE PACKAGE salary_pkg AS
    -- Function to calculate RSSB tax
    FUNCTION calc_rssb(gross NUMBER) RETURN NUMBER;

    -- Function to calculate net salary
    FUNCTION net_salary(gross NUMBER) RETURN NUMBER;

    -- Dynamic procedure to show salary info
    PROCEDURE show_worker_salary(p_worker_id NUMBER);
END salary_pkg;
/