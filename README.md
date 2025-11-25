AUCA System Access Policy (PL/SQL Triggers)
Group (A) – Monday
Course: INSY 8311 – Database Development with PL/SQL
Lecturer: Maniraguha Eric

👥 Group Members

BAHATI Theoneste : 28497

NDARUHUTSE Moise : 28340

BYISHIMO Kevin : 28056

GAKWAYA Samuel : 25427

Part I

1. What the Question Was About

The task was to implement the AUCA system access restrictions using Oracle PL/SQL triggers.

According to the business rules:

Users cannot access or modify data on Saturday or Sunday.

Users can only access the system Monday–Friday between 08:00 AM and 05:00 PM.

Any attempt outside allowed days or hours must be blocked and logged automatically for auditing.

This required:

A target table

A logging table

A trigger to restrict access

A trigger to log violations

2. How We Solved It
 Step 1 — Created a Target Table (EMPLOYEES)

Used for testing the access restrictions.

 Step 2 — Inserted Sample Records

To have data inside the table for update/delete tests.

 Step 3 — Created a Logging Table (access_violation_log)

Stores the username, table name, time, and reason for every blocked action.

 Step 4 — Trigger 1 (Restriction Trigger)

This trigger checks:

Day of the week

Current hour (24-hour format)

If it's weekend or outside 08:00–17:00, the trigger blocks the operation with:

ORA-20001 or ORA-20002

 Step 5 — Trigger 2 (Violation Logger)

This trigger uses an autonomous transaction to insert the blocked attempt into the log table.

 Step 6 — Testing

We tested by performing:

INSERT during restricted time

UPDATE outside allowed hours

Weekend access attempt

And then checked the log table to confirm violations were stored.


Part II

1. Assignment Overview

Scenario:
The goal of this assignment was to design a PL/SQL package for an HR Employee Management System to manage employee salaries and taxes efficiently. The package should:

Calculate RSSB tax for employees.

Return the net salary after deducting RSSB tax.

Include a dynamic procedure that displays employee salary information.

Demonstrate the correct usage of USER / CURRENT_USER and DEFINER / INVOKER rights.

Key requirements:

Create functions to compute RSSB tax and net salary.

Use a dynamic procedure to display employee salary info.

Include comments explaining code logic and security context.

2. Solution Approach

Step 1: Create a sample workers table
A simple table workers was created to store employee details including worker_id, full_name, and gross_salary.

CREATE TABLE workers (
    worker_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100),
    gross_salary NUMBER
);


Sample data inserted:

INSERT INTO workers VALUES (1, 'John Doe', 500000);
INSERT INTO workers VALUES (2, 'Peace Uwase', 320000);
INSERT INTO workers VALUES (3, 'Mike Ishimwe', 250000);


Step 2: Create the PL/SQL package salary_pkg

Function calc_rssb: Computes 3% RSSB tax for a given gross salary.

Function net_salary: Returns net salary after deducting RSSB tax.

Procedure show_worker_salary: Dynamically retrieves a worker’s details using their worker_id and displays the gross salary, RSSB tax, and net salary using DBMS_OUTPUT.PUT_LINE.

Exception handling: Handles NO_DATA_FOUND if the worker_id does not exist.

Package Specification:

CREATE OR REPLACE PACKAGE salary_pkg AS
    FUNCTION calc_rssb(gross NUMBER) RETURN NUMBER;
    FUNCTION net_salary(gross NUMBER) RETURN NUMBER;
    PROCEDURE show_worker_salary(p_worker_id NUMBER);
END salary_pkg;
/


Package Body:

CREATE OR REPLACE PACKAGE BODY salary_pkg AS
    FUNCTION calc_rssb(gross NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN gross * 0.03;
    END calc_rssb;

    FUNCTION net_salary(gross NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN gross - calc_rssb(gross);
    END net_salary;

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

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No worker found with ID ' || p_worker_id);
    END show_worker_salary;
END salary_pkg;
/


Step 3: Testing the Package
To test the package, we called the dynamic procedure:

SET SERVEROUTPUT ON;

BEGIN
    salary_pkg.show_worker_salary(1);
END;
/


Output:

Worker Name: John Doe
Gross Salary: 500000
RSSB Tax (3%): 15000
Net Salary: 485000

3. Security Context: USER vs CURRENT_USER

USER: Returns the name of the schema that owns the current session.

CURRENT_USER: Returns the user who is executing the PL/SQL code, which may differ if the package is executed with DEFINER/INVOKER rights.

Usage in this package:

DBMS_OUTPUT.PUT_LINE('Schema Owner (USER): ' || USER);
DBMS_OUTPUT.PUT_LINE('Executing User (CURRENT_USER): ' || CURRENT_USER);


DEFINER rights (default): The package executes with privileges of the owner.

INVOKER rights: Executes with privileges of the user calling the package.
6. Optional Challenge: Handling Multiple Employees in Bulk

To extend the package, a new procedure show_all_salaries was added to handle multiple employees using a cursor loop. This allows the package to display salary information for all employees automatically, instead of one at a time.

New Procedure in Package Specification:

PROCEDURE show_all_salaries;


Logic in Package Body:

A cursor c_workers selects all employees from the workers table.

For each employee, the procedure calculates RSSB tax and net salary.

Results are printed using DBMS_OUTPUT.PUT_LINE.

The loop continues until all employees are processed.

Example Call:

SET SERVEROUTPUT ON;

BEGIN
    salary_pkg.show_all_salaries;
END;
/


Sample Output:

Worker Name: John Doe
Gross Salary: 500000
RSSB Tax (3%): 15000
Net Salary: 485000
-------------------------
Worker Name: Peace Uwase
Gross Salary: 320000
RSSB Tax (3%): 9600
Net Salary: 310400
-------------------------
Worker Name: Mike Ishimwe
Gross Salary: 250000
RSSB Tax (3%): 7500
Net Salary: 242500
-------------------------


Notes:

The procedure uses PL/SQL cursors to iterate through multiple records efficiently.

You can extend it to handle a subset of employees by adding a WHERE clause in the cursor query.


This demonstrates bulk processing, dynamic SQL usage, and proper exception handling in PL/SQL.
