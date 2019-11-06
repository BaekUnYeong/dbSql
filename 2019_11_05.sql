-- 년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
-- 201911 --> 30 / 201912 --> 31

-- 한달 더한후 원래값을 빼면 = 일수
-- 마지막날짜 구한후 --> DD 만 추출
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE empno = 7369 + '69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, '$999,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll이 null일 경우 대체할 값)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
       sal + comm,
       sal + nvl(comm, 0),
       nvl(sal + comm, 0)
FROM emp;

--NVL2(coll, coll이 null이 아닐경우 표현되는 값, coll null일 경우 표현 되는 값
SELECT empno, ename, sal, comm, NVL2(comm, 0, comm) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 같으면 null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--함수 인자중 null이 아닌 첫번째 인자
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

-- emp테이블의 정보를 다음과 같이 조회
SELECT empno, ename, mgr,
       nvl(mgr, 9999) mgr_n,
       nvl2(mgr, mgr, 9999) mgr_n,
       coalesce(mgr, 9999) mgr_n
FROM emp;

SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) reg_dt
FROM users;

--case when
SELECT empno, ename, job, sal,
    CASE
      WHEN job = 'SALESMAN' THEN sal * 1.05 
      WHEN job = 'MANAGER' THEN sal * 1.10
      WHEN job = 'PRESIDENT' THEN sal * 1.20
      else sal
    END case_sal
FROM emp;

--decode(col, search1, return1, search2, return2 ..... default)
SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal*1.05,
                'MANAGER', sal*1.10,
                'PRESIDENT', sal*1.20,
                            sal) decode_sal
FROM emp;

--emp 테이블을 이용하여 deptno에 따라 부서명으로 변경 해서 다음과 같이 조회
--CASE ~ END 사용
SELECT empno, ename,
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
                        else 'DDIT'
    END dname
FROM emp;
--DECODE 사용
SELECT empno, ename,
    DECODE(deptno, 10, 'ACCOUNTING',
                   20, 'RESEARCH',
                   30, 'SALES',
                   40, 'OPERATIONS',
                   'DDIT') dname
FROM emp;

--emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회
SELECT empno, ename, hiredate,
    CASE
--        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'),2) THEN '건강검진 대상자'
        WHEN MOD(TO_CHAR(sysdate, 'YYYY') - TO_CHAR(hiredate, 'YYYY'),2) = 0 THEN '건강검진 대상자'
        else '건강겁진 비대상자'
    END contact_to_doctor
FROM emp;

--올 해수는 짝수인가? 홀수인가?
--1. 올해 년도 구하기 (DATE --> TO_CHAR(DATE, FORMAT))
--2. 올해 년도가 짝수인지 계산
-- 어떤수를 2로 나누면 나머지는 항상 2보다 작다
-- 2로 나눌경우 나머지는 0,1
-- MOD(대상, 나눌값)

SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'),2)
FROM dual;

-- users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회
SELECT userid, usernm, alias, reg_dt,
    CASE
        WHEN MOD(TO_CHAR(reg_dt, 'YY') - TO_CHAR(SYSDATE, 'YY'),2) = 0 THEN '건강검진 대상자'
        else '건강검진 비대상자'
    END contact_to_doctor
FROM users;

--그룹함수 (AVG, MAX, MIN, SUM, COUNT)
--그룹함수는 NULL값을 계산대상에서 제외한다
--SUM(comm), COUNT(*), COUNT(mgr)
--직원중 가장 높은 급여를 받는사람의 급여
--직원중 가장 낮은 급여를 받는사람의 급여
--직원의 급여 평균 (소수점 둘쨰자리 까지만 나오게 --> 소수점 3째자리에서 반올림)
--직원의 급여 전체합
--직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal, COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

--부서별 가장 높은 급여를 받는사람의 급여
--GROUP BY 절에 기술되지 않은 컬럼이 SELECT 절에 기술될 경우 에러 !!
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal, COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--부서별 최대 급여
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--emp테이블을 이용하여 다음을 구하시오
SELECT MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal, COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp;

--emp테이블을 이용하여 다음을 구하시오
SELECT deptno, MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal, COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp
GROUP BY deptno;

--위에서 작성한 쿼리에서 deptno 대신 부서명이 나오도록 수정
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




-- UPDATE 방법
--UPDATE users SET reg_dt = null
--WHERE userid = 'moon';
--
--commit;