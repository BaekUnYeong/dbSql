-- 실습 3
CREATE OR REPLACE PROCEDURE update_dept_test (p_deptno IN dept.deptno%TYPE,
                                              p_dname IN dept.dname%TYPE,
                                              p_loc IN dept.loc%TYPE)
IS
BEGIN
    UPDATE dept_test SET dname = p_dname
    WHERE deptno = p_deptno;
    COMMIT;
ENd;
/

exec update_dept_test (99, 'ddit_m', 'daejeon');
SELECT *
FROM dept_test;

-- ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조 타입
set serveroutput on;
DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || dept_row.dname || ', ' || dept_row.loc);
END;
/
-- 복합변수 : RECORD
DECLARE
    -- UserVo userVo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE);
        
    v_row dept_row;
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ', ' || v_row.dname);
END;
/

-- tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    -- java : 타입 + 변수명;
    -- PL/SQL : 변수명 타입;
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
BEGIN
    bi := 100;
    dbms_output.put_line(bi);

    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    --dbms_output.put_line(v_dept(0).dname); 1번부터 시작
    
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;
    
END;
/

SELECT *
FROM dept;

-- IF
-- ELSE IF --> ELSIF
-- END IF;

DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF' || ind);
    ELSE
        dbms_output.put_line('ELSE');
    END IF;
END;
/

-- FOR LOOP :
-- FOR 인덱스 변수 IN 시작값..종료값 LOOP
-- END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/

-- LOOP : 계속 실행 판단 로직을 LOOP 안에서 제어
-- java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_line(i);
        i := i+2;
        -- loop 계속 진행여부 판단
        EXIT WHEN i >= 5;
    END LOOP;
END;
/

SELECT *
FROM dt;

DECLARE
    TYPE v_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    dt_test v_dt;
    
    i NUMBER;
    result NUMBER;
    avg1 NUMBER;
BEGIN
    result := 0;

    SELECT *
    BULK COLLECT INTO dt_test
    FROM dt;
    
    FOR i IN 1..dt_test.count-1 LOOP
    --dbms_output.put_line(dt_test(i).dt);
    result := result + dt_test(i).dt - dt_test(i+1).dt;
    --dbms_output.put_line(result);
    END LOOP;
    avg1 := result/(dt_test.count-1);
    
    dbms_output.put_line(avg1);
END;
/

-- lead, lag 현재행의 이전, 이후 데이터를 가져올 수 있다.
SELECT *
FROM dt
ORDER BY dt DESC;

SELECT AVG(lead)
FROM
(SELECT dt, dt - LEAD(dt) OVER (ORDER BY dt DESC) lead
FROM dt);

-- 분석함수를 사용하지 못하는 환경에서
SELECT AVG(a.dt-b.dt)
FROM
    (SELECT ROWNUM rn, dt
    FROM dt
    ORDER BY dt DESC)a,
    (SELECT ROWNUM rn, dt
    FROM dt
    ORDER BY dt DESC)b
WHERE a.rn = b.rn-1;

-- HALL OF HONOR
SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)-1)
FROM dt;

DECLARE
    -- 커서 선언
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
        
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    -- 커서 열기
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- 더이상 읽을 데이터가 없을 때 종료.
    END LOOP;
END;
/

-- FOR LOOP CURSOR 결합
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

-- 파라미터가 있는 명시적 커서
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;

BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_line(emp.empno || ', ' || emp.ename || ', ' || emp.job);
    END LOOP;
END;
/