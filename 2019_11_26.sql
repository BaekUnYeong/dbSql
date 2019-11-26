-- 분석함수 RANK
SELECT ename, sal, deptno,
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank,
    DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) d_rank,
    ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rown
FROM emp;

-- 실습1
SELECT empno, ename, sal, deptno,
    RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
    ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_rank
FROM emp;

-- 실습2 부서별 직원수
SELECT empno, ename, a.*
FROM emp b,
(SELECT deptno, COUNT(deptno) cnt
FROM emp
GROUP BY deptno) a
WHERE a.deptno = b.deptno
ORDER BY a.deptno, b.empno;

-- 분석함수 사용했을때 (CONUT)
SELECT empno, ename, deptno,
    COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- 부서별 사원의 급여 합계
-- 분석함수 (SUM)
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

-- 실습 3
SELECT empno, ename, sal, deptno,
    ROUND(AVG(sal) OVER (PARTITION BY deptno),2) cnt
FROM emp;

-- 실습 4 부서별 급여가 높은사람
SELECT empno, ename, sal, deptno,
    MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- 실습 5 부서별 급여가 낮은사람
SELECT empno, ename, sal, deptno,
    MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

-- 부서별 사원번호가 가장 빠른사람
-- 부서별 사원번호가 가장 느린사람
-- LAST_VALUE는 확인 필요
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

-- LAG(이전행)
-- 현재행
-- LEAD(다음행)
-- 급여가 높은순으로 정렬 했을때 자기보다 한단계 급여가 낮은 사람의 급여,
--                            자기보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, sal, LAG(sal) OVER (ORDER BY sal) lag_sal,
                          LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

-- 실습 5
SELECT empno, ename, hiredate, sal,
    LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

-- 실습 6
SELECT empno, ename, hiredate, job, sal,
    LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) LAG_sal
FROM emp;

-- 실습 7
SELECT empno, ename, sal
FROM emp;

SELECT a.empno, a.ename, a.sal, SUM(b.sal) sum_sal
FROM
(SELECT a.*, ROWNUM rn
FROM
    (SELECT empno, ename, sal
     FROM emp
     ORDER BY sal, empno) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;


-- WINDOWING
-- UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든행
-- CURRENT ROW : 현재 행
-- UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든행
-- N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
-- N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

-- 실습 8
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
    SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
    
    SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
    SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;