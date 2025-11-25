CREATE OR REPLACE TRIGGER trg_log_violations
AFTER SERVERERROR ON DATABASE
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_user     VARCHAR2(50);
    v_message  VARCHAR2(200);
BEGIN
    v_user    := SYS_CONTEXT('USERENV', 'SESSION_USER');
    v_message := DBMS_UTILITY.format_error_stack;

    INSERT INTO access_violation_log (
        username, action_type, table_name, attempted_on, reason
    ) VALUES (
        v_user,
        'DML',
        ora_dict_obj_name,
        SYSDATE,
        v_message
    );

    COMMIT;
END;
/
