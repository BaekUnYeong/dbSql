-- CURSOR를 명시적으로 선언하지 않고
-- LOOP에서 inline 형태로 cursor 사용

-- 익명블록
set serveroutput ON;
DECLARE
    --cursor 선언 --> LOOP에서 inline 선언
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE avgdt
IS
    idx NUMBER := 0;
    ddt DATE;
    tmp NUMBER := 0;
    summ NUMBER := 0;
BEGIN
    FOR res IN (SELECT dt FROM dt ORDER BY dt DESC) LOOP
        --dbms_output.put_line(res.dt);
        IF idx = 0 THEN
            ddt := res.dt;
        ELSIF idx > 0 THEN
            tmp := ddt - res.dt;
            ddt := res.dt;
        END IF;
            idx := idx+1;
            summ := tmp + summ;
    END LOOP;
    dbms_output.put_line(summ/(idx-1));
END;
/
exec avgdt;

-- 
CREATE OR REPLACE PROCEDURE avgdt
IS
    -- 선언부
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    -- dt 테이블 모든 데이터 조회
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        -- rec : dt 컬럼
        -- 먼저읽은 데이터(dt) - 다음 데이터(dt) :
        IF ind = 0 THEN -- LOOP의 첫 시작
            prev_dt := rec.dt;
        ELSE
            diff := diff + prev_dt - rec.dt;
            prev_dt := rec.dt;
        END IF;
        
        ind := ind + 1;
    END LOOP;
    dbms_output.put_line('ind : ' || ind);
    dbms_output.put_line('diff : ' || diff / (ind -1));
END;
/

-- 실습4 1/2
SELECT *
FROM CYCLE;
SELECT *
FROM DAILY;

CREATE OR REPLACE PROCEDURE create_daily_sales (p_yyyymm VARCHAR2)
IS
  
  --달력의 행정보를 저장할 RECORD TYPE
  TYPE cal_row IS RECORD (
    dt VARCHAR2(8),
    d  VARCHAR2(1));
    
    -- 달력 정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    -- 애음주기 cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
    
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'DD'));
    
    -- 생성하려고 하는 년월의 실적 데이터를 삭제한다
    DELETE daily
    WHERE day LIKE p_yyyymm || '%';
    
    -- 애음주기 loop
    FOR rec IN cycle_cursor LOOP
        FOR i IN 1..cal.count LOOP
            -- 애음주기의 요일이랑 일자의 요일이랑 같은지 비교
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid, cal(i).dt, rec.cnt);
            END IF;
        END LOOP;
    END LOOP;
    
    COMMIT;

END;
/

exec create_daily_sales('201911');
--
SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD')) ld
FROM dual;

SELECT TO_CHAR(TO_DATE('201911', 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
       TO_CHAR(TO_DATE('201911', 'YYYYMM') + (LEVEL-1), 'D') dt
FROM dual
CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD')); --