-- GROUPING (cube, rollup 절의 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우 1
-- 사용되지 않은 경우 0

-- job 컬럼
-- case1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--        job --> '총계'
-- case else
--        job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계' ELSE job END job,
        deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- 위의 쿼리중 deptno가 null값이면 '소계'로 입력하기 실습 2
SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계 : ' ELSE job END job,
       CASE WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN job || ' 소계' 
       WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN ' ' ELSE TO_CHAR(deptno) END deptno,
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- 실습 3
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

-- 실습 4
SELECT dept.dname, emp.job, sum(sal) sal
FROM dept, emp
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dept.dname, emp.job)
ORDER BY dname, sal DESC;

-- 실습 5
SELECT CASE WHEN dept.dname IS NULL THEN '총계' ELSE dept.dname END dname, emp.job, sum(sal) sal
FROM dept, emp
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dept.dname, emp.job)
ORDER BY dname, sal DESC;

-- CUBE (col1, col2 ...) 방향성이 없다. ROLLUP과의 차이
-- CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
-- GROUP BY CUBE(job, deptno)
-- OO : GROUP BY job, deptno
-- OX : GROUP BY job
-- XO : GROUP BY deptno
-- XX : GROUP BY -- 모든 데이터에 대해서 ...

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

CREATE TABLE emp_test AS
SELECT * FROM emp;

-- emp_test 테이블의 dept테이블에서 관리되고 있는 ename 컬럼(VARCHAR2 (14))을 추가
SELECT *
FROM emp_test;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

-- emp_test테이블의 dname 컬럼을 dept테이블의 dname 컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);

-- 실습 1
ALTER TABLE dept_test ADD (empcnt NUMBER(3));

UPDATE dept_test SET empcnt = (SELECT COUNT(deptno)
                               FROM emp
                               WHERE dept_test.deptno = emp.deptno);

-- 실습 2
CREATE TABLE dept_test2 AS
SELECT * FROM dept;

SELECT *
FROM dept_test2;

INSERT INTO dept_test2 VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test2 VALUES (98, 'it2', 'daejeon');

DELETE dept_test2 
WHERE NOT EXISTS (SELECT deptno
                  FROM emp
                  WHERE emp.deptno = dept_test2.deptno);

-- 실습 3
SELECT * FROM emp_test;
UPDATE emp_test a SET sal = sal+200
WHERE sal < (SELECT ROUND(AVG(sal), 2)"부서별 평균 급여"
             FROM emp_test b
             WHERE b.deptno = a.deptno);

-- emp, emp_test empno컬럼으로 같은 값끼리 조회
-- emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.deptno,
            (SELECT ROUND(AVG(emp.sal),2) AVG FROM emp WHERE emp.deptno = emp_test.deptno) AVG
FROM emp, emp_test
WHERE emp.empno = emp_test.empno
ORDER BY deptno DESC;