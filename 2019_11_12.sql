-- DML
DESC emp;

INSERT INTO emp (ename, job)
VALUES ('matthew', null);

SELECT *
FROM emp
WHERE empno = 9999;

SELECT *
FROM USER_TAB_COLUMNS
WHERE table_name = 'EMP';

-- INSERT
INSERT INTO emp
VALUES (9999, 'matthew', 'CEO', null, sysdate, 4000, null, 99);

COMMIT;

SELECT *
FROM emp
WHERE empno = 9999;

INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;

-- UPDATE
-- UPDATE 테이블 SET 컬럼 = 값, 컬럼 = 값 ...
-- WHERE condition;
UPDATE dept SET dname = '대덕IT', loc = 'ym'
WHERE deptno = 99;

SELECT *
FROM emp;

-- DELETE
-- DELETE 테이블명
-- WHERE condition;
-- 사원번호가 999인 직원을 emp 테이블에서 삭제
DELETE emp
WHERE empno = 9999;

-- 부서테이블을 이용해서 emp 테이블에 입력한 5건의 데이터를 삭제
-- empno < 100 , between 10 AND 99
DELETE dept
WHERE deptno = 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

SELECT *
FROM dept;

-- LV1 --> LV3
SET TRANSACTION isolation LEVEL SERIALIZABLE;

-- DDL : AUTO COMMIT -> rollback이 안됨 (주의!!)
-- CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,           -- 숫자 타입
    ranger_name VARCHAR2(50),   -- 문자 타입 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate -- DEFAULT : SYSDATE
);

-- DDL은 rollback이 적용되지 않는다.
rollback;
SELECT *
FROM ranger_new;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'brown');

-- 날짜 타입에서 특정 필드가져오기
-- ex) sysdate에서 년도만 가져오기
SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM'),
EXTRACT(YEAR FROM reg_dt),EXTRACT(MONTH FROM reg_dt),EXTRACT(DAY FROM reg_dt)
FROM ranger_new;


-- 제약조건
-- DEPT 모방해서 DEPT_TEST 생성
DESC dept_test;

CREATE TABLE dept_test(
    deptno  NUMBER(2)   PRIMARY KEY,    -- deptno 컬럼을 식별자로 지정, 식별자로 지정이 되면 값이 중복이 될수 없고, null일 수도 없다
    dname   VARCHAR2(14),
    loc     VARCHAR2(13)
);

-- primary key 제약 조건 확인
-- 1. deptno컬럼에 null이 들어갈 수 없다
-- 2. deptno컬럼에 중복된 값이 들어갈 수 없다.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

rollback;

-- 사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2)    CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');
SELECT *
FROM dept_test;

-- NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2)    PRIMARY KEY,
    dname VARCHAR2(14)  NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, null, 'daejeon');      -- dname에 제약조건으로 NOT NULL를 설정했기 때문에 NULL 값은 INSERT 불가

-- UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2)    PRIMARY KEY,
    dname VARCHAR2(14)  UNIQUE,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon');    -- dname에 제약조건으로 UNIQUE를 설정했기 때문에 동일한 ddit는 INSERT 불가