CREATE OR REPLACE TRIGGER trg_restrict_access
BEFORE INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
DECLARE
    v_day   VARCHAR2(10);
    v_hour  NUMBER;
BEGIN
    v_day  := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=AMERICAN');
    v_hour := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));

    IF v_day IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Access not allowed on weekends.');
    END IF;

    IF v_hour < 8 OR v_hour >= 17 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Access allowed only from 08:00 to 17:00.');
    END IF;
END;
/
