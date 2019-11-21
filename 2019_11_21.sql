-- 부서별 평균 급여가 직원 전체의 급여 평균보다 높은 부서의 부서번호와 부서별 급여 평균 금액 조회
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal), 2) AVG
    FROM emp
    GROUP BY deptno)
WHERE AVG > (SELECT ROUND(AVG(sal), 2)
             FROM emp);

-- 전체 직원의 급여 평균
SELECT ROUND(AVG(sal), 2)
FROM emp;

-- 부서별 평균 급여
SELECT deptno, ROUND(AVG(sal), 2) AVG
FROM emp
GROUP BY deptno;

-- 쿼리 블럭을 WITH절에 선언하여 쿼리를 간단하게 표현한다.
WITH dept_avg_sal AS (
    SELECT deptno, ROUND(AVG(sal), 2) AVG
    FROM emp
    GROUP BY deptno
)
SELECT *
FROM dept_avg_sal
WHERE AVG > (SELECT ROUND(AVG(sal), 2)
             FROM emp);

-- 달력 만들기
-- STEP1. 해당 년월의 일자 만들기
-- CONNECT BY LEVEL

-- DATE + 정수 = 일자 더하기 연산
SELECT 
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon,
       MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wed,
       MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
       MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM')+(level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'iw')iw,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'd')d
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY DECODE(d, 1, a.iw+1, a.iw)
ORDER BY DECODE(d, 1, a.iw+1, a.iw);


SELECT NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 01, SUM(sales))),0) jan,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 02, SUM(sales))),0) feb,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 03, SUM(sales))),0) mar,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 04, SUM(sales))),0) apr,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 05, SUM(sales))),0) may,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 06, SUM(sales))),0) jun
FROM sales
GROUP BY TO_CHAR(DT, 'MM');

-- 계층쿼리
-- START WITH : 계층의 시작 부분을 정의
-- CONNECT BY : 계층간 연결 조건을 정의

-- 하향식 계층쿼리 (가장 최상위 조직에서부터 모든 조직을 탐색)
SELECT *
FROM dept_h
START WITH deptcd = 'dept0' --START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR 현재 읽은 데이터(XX회사)

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ')|| dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT dept_h.*, LPAD(' ', (LEVEL-1)*4, ' ')|| dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;