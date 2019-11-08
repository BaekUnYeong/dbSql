-- 조인 복습
-- RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다
-- EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는 부서번호만 갖고있고,
-- 부서번호를 통해 DEPT 테이블과 조인을 통해 해당 부서의 정보를 가져올 수 있다.

-- 직원번호, 직원이름, 직원의소속 부서번호, 부서이름
SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno;

-- 부서번호, 부서명, 해당부서의 인원수
-- conut(col) : col 값이 존재하면 1, null 이면 0
--              행수가 궁금한 것이면 * 사용
SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname
ORDER BY dname;

-- TOTAL ROW : 14
SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;

-- OUTER JOIN : 조인에 실패에도 기준이 되는 테이블의 데이터는 조회 결과가 나오도록 하는 조인 형태
-- LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인 형태
-- RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인 형태
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIM - 중복제거

-- 직원 정보와, 해당 직원의 관리자 정보 outer join
SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l LEFT OUTER JOIN emp r ON (l.mgr = r.empno);

SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l RIGHT OUTER JOIN emp r ON (l.mgr = r.empno);

-- oracle outer join (left, right만 존재 fullouter는 지원하지 않음)
SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l, emp r
WHERE l.mgr = r.empno(+);

SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l, emp r
WHERE l.mgr = r.empno;

-- ANSI LEFT OUTER
SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l LEFT OUTER JOIN emp r ON (l.mgr = r.empno AND r.deptno = 10);

SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l LEFT OUTER JOIN emp r ON (l.mgr = r.empno)
WHERE r.deptno = 10;

-- oracle outer 문법에서는 outer 테이블이되는 모든 컬럼에 (+)를 붙여줘야 outer joingn이 정상적으로 동작한다.
SELECT l.empno, l.ename, r.empno, r.ename
FROM emp l, emp r
WHERE l.mgr = r.empno(+)
AND r.deptno(+) = 10;

-- ANSI RIGHT OUTER
SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l RIGHT OUTER JOIN emp r ON (l.mgr = r.empno);

-- buyprod 테이블에 구매일자가 2005년1월25일인 데이터는 3품목 밖에 없다. 모든 품목이 나올수 있도록 쿼리 작성
SELECT * FROM buyprod;
SELECT * FROM prod;

-- ANSI LEFT OUTER JOIN 사용
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = '05/01/25');

-- ORACLE OUTER JOIN 사용
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod, buyprod
WHERE prod.prod_ID = buyprod.buy_prod(+)
AND buy_date(+) = '05/01/25';

-- 위의 조회 내역을 사용하여 buy_date 컬럼이 null인 항목이 안나오도록 데이터를 채우세요.
-- CASE ~ END 사용
SELECT 
CASE
    WHEN buyprod.buy_date is null then TO_DATE('05/01/25', 'YY/MM/DD') 
    else buyprod.buy_date
    end buy_date,
    buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = '05/01/25');
-- DECOED 사용
SELECT 
DECODE(buyprod.buy_date, null ,TO_DATE('05/01/25', 'YY/MM/DD'),
    buyprod.buy_date) buy_date,
    buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

-- 위의 조회 내역을 사용하여 buy_qty 컬럼이 null인 항목이 안나오도록 데이터를 채우세요.
-- CASE ~ END 사용
SELECT 
CASE
    WHEN buyprod.buy_date is null then TO_DATE('05/01/25', 'YY/MM/DD') 
    else buyprod.buy_date
    end buy_date,
    buyprod.buy_prod, prod.prod_id, prod.prod_name,
CASE
    WHEN buyprod.buy_qty is null then 0 
    else buyprod.buy_qty end buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = '05/01/25');
-- DECOED 사용
SELECT 
DECODE(buyprod.buy_date, null ,TO_DATE('05/01/25', 'YY/MM/DD'),
    buyprod.buy_date) buy_date,
    buyprod.buy_prod, prod.prod_id, prod.prod_name, 
DECODE(buyprod.buy_qty, null, 0, buyprod.buy_qty)buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- buy_date 는 TO_DATE 사용, buy_qty 는 NVL 사용
SELECT TO_DATE('05/01/25', 'YY/MM/DD') buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, NVL(buyprod.buy_qty, 0) buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

-- cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과 같이 조회(고객은 cid = 1인 고객 , null 처리)
SELECT * FROM cycle;
SELECT * FROM product;
SELECT * FROM customer;

SELECT product.pid, product.pnm, NVL(cycle.cid,1)cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0)cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = 1);

-- cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과 같이 조회되며 고객이름을 포함(고객은 cid = 1인 고객 , null 처리)
SELECT product.pid, product.pnm, NVL(cycle.cid,1)cid, NVL(customer.cnm, 'brown')cnm, NVL(cycle.day,0) day, NVL(cycle.cnt,0)cnt
FROM (product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = 1)) LEFT OUTER JOIN customer ON (customer.cid = cycle.cid)
ORDER BY pid DESC;

-- customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 조회
SELECT cid, cnm, pid, pnm
FROM product, customer;

-- subquery : main 쿼리에 속하는 부분 쿼리
-- 사용되는 위치 :
-- SELECT - scalar subquery(하나의 행과 하나의 컬럼만 조회되는 쿼리이어야 한다)
-- FROM - inline view
-- WHERE - subquery

-- SELECT - scalar subquery
SELECT empno, ename, (SELECT SYSDATE FROM dual)now
FROM emp;

-- SMITH 사원이 속한 부서의 모든 사원 정보
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT avg(sal)avg_sal
             FROM emp);

-- 평균 급여보다 높은 급여를 받는 직원의 정보를 조회
SELECT *
FROM emp
WHERE sal > (SELECT avg(sal)avg_sal
             FROM emp);

-- SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회
SELECT empno, ename, job, mgr, TO_CHAR(hiredate, 'YYYY/MM/DD')hiredate, sal, comm, deptno
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));