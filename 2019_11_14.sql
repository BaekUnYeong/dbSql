-- 제약조건 활성화 / 비활성화
-- 어떤 제약조건을 활성화(비활성화) 시킬지 대상 ??

-- emp fk제약 (dept테이블의 deptno컬럼 참조)
-- FK_EMP_DEPT 비활성화
ALTER TABLE emp DISABLE CONSTRAINT fk_emp_dept;

-- 제약조건에 위배되는 데이터가 들어갈 수 있지 않을까?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

-- FK_EMP_DEPT 활성화
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;

-- 제약조건에 위배되는 데이터(소속 부서번호가 80번인 데이터)가 존재하여 제약조건 활성화 불가
DELETE emp
WHERE deptno = 80;

-- FK_EMP_DEPT 활성화
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;
COMMIT;

-- 현재 계정에 존재하는 테이블 목록 view : USER_TABLES
-- 현재 계정에 존재하는 제약조건 view : USER_CONSTRAINTS
-- 젼재 계정에 존재하는 제약조건의 컬럼 view : USER_CONS_COLUMNS

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CYCLE';

-- fk_emp_dept
SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'PK_CYCLE';

-- 테이블에 설정된 제약조건 조회 (VIEW 조인)
-- 테이블 명 / 제약조건 명 / 컬럼 명 / 컬럼 포지션
SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P'
ORDER BY table_name, position; -- PRIMARY KEY만 조회

-- emp 테이블과 8가지 컬럼 주석달기
-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

-- 테이블 주석 view : USER_TAB_COMMENTS

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp 테이블 주석
COMMENT ON TABLE emp IS '사원';

-- emp 테이블의 컬럼 주석
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '사원번호';
COMMENT ON COLUMN emp.ename IS '이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '관리자 사번';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '상여';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';


-- 실습 user_tab_comments, user_col_comments view를 이용하여 customer, product, cycle, daily 테이블과 컬럼의 주석 정보 조회
SELECT * FROM user_col_comments;

SELECT a.table_name, a.table_type, a.comments tab_comment, b.column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY')
AND a.table_name = b.table_name;

-- VIEW 생성 (emp 테이블에서 sal, comm 두개 컬럼을 제외한다)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- INLINE VIEW
SELECT *
FROM ( SELECT empno, ename, job, mgr, hiredate, deptno
       FROM emp);
       
-- VIEW (위 인라인뷰와 동일하다)
SELECT *
FROM v_emp;

-- 조인된 쿼리 결과를 view로 생성 : v_emp_dept
-- emp, dept : 부서명, 사원번호, 사원명, 담당업무, 입사일자
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

-- VIEW 제거
DROP VIEW v_emp;

-- VIEW를 구성하는 테이블의 데이터를 변경하면 VIEW에도 영향이 간다
-- dept 30 = SALES
SELECT *
FROM v_emp_dept;

-- dept테이블의 SALES --> MARKET SALES
UPDATE dept SET dname = 'SALES'
WHERE deptno = 30;

-- hr 계정에게 v_emp_dept view 조회권한을 준다
GRANT SELECT ON v_emp_dept TO hr;
-- hr 계정에게 v_emp_dept view 조회권한을 삭제
REVOKE SELECT ON v_emp_dept FROM hr;

-- SEQUENCE 생성 (게시글 번호 부여용 시퀀스)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;

-- 시퀀스 복습
-- 시퀀스 : 중복되지 않는 정수 값을 리턴 해주는 객체
-- 1, 2, 3, ....

DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(15)
    );

CREATE SEQUENCE seq_emp_test;

INSERT INTO emp_test VALUES (seq_emp_test.nextval, 'brown');

SELECT *
FROM emp_test;

SELECT seq_post.nextval, seq_post.currval
FROM dual;

SELECT seq_post.currval
FROM dual;

SELECT *
FROM post
WHERE reg_id = 'brown'
AND title = '하하하하 재미있다.'
AND reg_dt = TO_DATE('2019/11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE post_id = 1;

-- index
-- rowid : 테이블 행의 물리적 주소, 해당 주소를 알면 빠르게 테이블에 접근하는 것이 가능하다

SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFNcAAFAAAAHeAAA';

-- table : pid, pnm
-- pk_product : pid
SELECT pid
FROM product
WHERE  ROWID = 'AAAFNcAAFAAAAHeAAA';

-- 실행계획을 통한 인덱스 사용여부 확인
-- emp 테이블에 empno 컬럼을 기준으로 인덱스가 없을 때
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

-- 인덱스가 없기 때문에 empno = 7369인 데이터를 찾기 위해 emp 테이블 전체를 찾아봐야한다 => TABLE FULL SCAN

SELECT *
FROM TABLE(dbms_xplan.display);