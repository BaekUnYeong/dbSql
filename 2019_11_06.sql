-- 그룹함수
-- multi row function : 여러개의 행을 입력으로 하나의 결과 행을 생성
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능

-- 직원중 가장 높은 급여 조회
-- 14개 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

-- 부서별 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        else 'DDIT'
    END dname, MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal, COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp
GROUP BY
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        else 'DDIT'
    END
ORDER BY max_sal DESC;

SELECT
    DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT') dname,
    MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal,
    COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT')
ORDER BY dname;

-- emp 테이블을 이용하여 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm,COUNT(hiredate)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

-- emp테이블을 이용하여 직원의 입사 년별로 몇명의 직원이 입사했는지 조회
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyy, COUNT(hiredate)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy')
ORDER BY TO_CHAR(hiredate, 'yyyy');

-- 회사에 존재하는 부서의 개수는 몇개인지 조회
SELECT COUNT(deptno) cnt
FROM dept;

-- JOIN
-- emp 테이블에는 dname 컬럼이 없다
desc emp;

-- emp 테이블에 부서이름을 저장할수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO = 20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO = 30;
COMMIT;

SELECT dname, MAX(sal)max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;
COMMIT;

-- ansi natural join : 테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

-- ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

-- FROM 절에 조인 대상 테이블 나열
-- WHERE 절에 조인조건 기술
-- 기존에 사용하던 조건 제약도 기술가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job = 'SALESMAN'; --job이 SALES인 사람만 대상으로 조회

SELECT emp.empno, emp.ename, dept.dname
FROM dept, emp
WHERE emp.job = 'SALESMAN'
AND emp.deptno = dept.deptno; 

-- JOIN with ON (개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- SELF join : 같은 테이블끼리 조인
-- emp테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
-- a : 직원 정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

SELECT *
FROM salgrade;

-- emp 테이블에서 salgrade 테이블과 조인하여 sal 등급을 조회
SELECT e.empno, e.ename, e.sal, s.*
FROM emp e, salgrade s
WHERE e.sal between s.losal AND s.hisal;

--위의 조회한 내용을 join on 으로 변경
SELECT e.empno, e.ename, e.sal, s.*
FROM emp e JOIN salgrade s ON (e.sal between s.losal AND s.hisal);

-- non equi joing
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
AND a.empno = 7369;

-- emp, dept 테이블을 이용하여 다음과 같이 조회
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = 7369;

-- emp,dept 테이블을 이용하여 다음과 같이 조회 (부서번호가 10, 30인 데이터만 조회
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno IN (10,30);

-- emp,dept 테이블을 이용하여 다음과 같이 조회
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORdER BY deptno;