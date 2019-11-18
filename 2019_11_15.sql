-- emp ���̺� empno�÷��� �������� PRIMARY KEY�� ����
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE ==> �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)

-- empno �÷����� �ε����� �����ϴ� ��Ȳ���� �ٸ��÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emP
WHERE mgr = 'MANAGER';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- �ε��� ���� �÷���  SELECT ���� ����Ѱ��
-- ���̺� ������ �ʿ� ����.

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)

-- �÷��� �ߺ��� ������ non-unique �ε��� ���� �� unique index���� �����ȹ ��
-- PIRMARY KEY �������� ����(unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/idx_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)

-- emp ���̺� job �÷����� �ι�° �ε��� ����
-- job �÷��� �ٸ� �ο��� job �÷��� �ߺ��� ������ �ɷ��̴�.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   261 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   261 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
 
Note
-----

-- emp ���̺� job, ename �÷��� �������� non-unique �ε��� ����
CREATE INDEX IDX_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)

-- emp ���̺� ename, job �÷����� non-unique �ε��� ����
CREATE INDEX IDX_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
   2 - access("JOB"='MANAGER')
 
Note
-----

-- HINT�� ����� �����ȹ ����
EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_04 ) */ *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE TABLE DEPT_TEST AS
SELECT *
FROM DEPT WHERE 1=1;

-- INDEX �ǽ� 1
CREATE UNIQUE INDEX idx_dept_01 ON dept_test (deptno);
CREATE INDEX idx_dept_02 ON dept_test (dname);
CREATE INDEX idx_dept_03 ON dept_test (deptno, dname);

-- INDEX �ǽ� 2
DROP INDEX idx_dept_01;
DROP INDEX idx_dept_02;
DROP INDEX idx_dept_03;

CREATE INDEX idx_emp_01 ON emp (empno);
CREATE INDEX idx_emp_02 ON emp (ename);
CREATE INDEX idx_emp_03 ON emp (sal, deptno);
CREATE INDEX idx_emp_04 ON emp (deptno);
CREATE INDEX idx_emp_05 ON emp (mgr, deptno);

DROP INDEX idx_emp_05;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7298;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = 'SCOTT';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN 500 AND 7000
AND deptno = 20;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = 10
AND emp.empno LIKE '78%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.deptno = 30;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
