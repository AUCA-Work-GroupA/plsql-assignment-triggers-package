CREATE TABLE access_violation_log (
    log_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username      VARCHAR2(50),
    action_type   VARCHAR2(20),
    table_name    VARCHAR2(50),
    attempted_on  DATE,
    reason        VARCHAR2(200)
);
