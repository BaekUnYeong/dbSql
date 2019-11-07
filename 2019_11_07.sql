SELECT empno, ename
FROM emp;
SELECT ename, deptno
FROM emp
GROUP BY ename, deptno;
-- emp 테이블에는 부서번호(deptno)만 존재
-- emp 테이블에서 부서명을 조회하기 위해서는
-- dept 테이블과 조인을 통해 부서명 조회

-- 조인 문법
-- ANSI : 테이블 join 테이블2 on(조인 조건 (테이블.컬럼 = 테이블2.컬럼));
--        emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE : FROM 테이블, 테이블2 WHERE 테이블.컬럼 = 테이블2.컬럼
--          FROM emp, dept WHERE emp.detpno = dept.deptno

-- 사원번호, 사원명, 부서번호, 부서명
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno);

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- emp, dept 테이블을 이용하여 다음과 같이 조회 (급여 2500 초과)
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500
ORDER BY deptno;

-- ANSI(JOIN ON) 사용
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno AND sal > 2500)
ORDER BY deptno;

-- emp,dept 테이블을 이용하여 다음과 같이 조회 ( 급여 2500초과, 사번이 7600 초과 )
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500 AND empno > 7600
ORDER BY deptno;

-- ANSI (JOIN ON) 사용
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
AND sal > 2500 AND empno > 7600
ORDER BY deptno;

-- emp,dept 테이블을 이용하여 다음과 같이 조회 ( 급여 2500초과, 사번이 7600 초과 하고 부서명이 RESEARCH인 부서)
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY deptno;

-- ANSI (JOIN ON) 사용
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY deptno;

-- erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인 하여 다음과 같이 조회
SELECT * FROM lprod;
SELECT * FROM prod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE lprod_gu = prod_lgu
ORDER BY prod_id;

-- ANSI (JOIN ON) 사용
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod JOIN prod ON (lprod_gu = prod_lgu)
ORDER BY prod_id;

-- erd 다이어그램을 참고하여 buyer,prod 테이블을 조인하여 buyer별 담당하는 제품 정보를 조회
SELECT * FROM buyer;
SELECT * FROM prod;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer_id = prod_buyer
ORDER BY prod_id;

-- ANSI (JOIN ON) 사용
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (buyer_id = prod_buyer)
ORDER BY prod_id;

-- erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 장바구니에 담은 제품정보 조회
SELECT * FROM member;
SELECT * FROM cart;
SELECT * FROM prod;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE cart_member = mem_id AND prod_id = cart_prod;

-- ANSI (JOIN ON) 사용
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (cart_member = mem_id) JOIN prod ON (prod_id = cart_prod);

-- erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수를 조회
-- (고객명이 brown,sally 만 조회)
SELECT * FROM customer;
SELECT * FROM cycle;

SELECT c.cid, c.cnm, cy.pid, cy.day, cy.cnt
FROM customer c, cycle cy
WHERE c.cid = cy.cid
AND c.cnm IN ('brown','sally');

-- erd 다이어그램을 참고하여 customer,cycle,product 테이블을 조인하여 고객별 애음제품, 애음요일, 개수, 제품명을 조회
-- (고객명이 brown,sally 만 조회)
SELECT * FROM customer;
SELECT * FROM cycle;
SELECT * FROM product;

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
AND customer.cnm IN ('brown','sally');

-- erd 다이어그램을 참고하여 customer,cycle,product 테이블을 조인하여 애음요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명 조회
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt)cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY cycle.cnt, product.pnm, customer.cid, customer.cnm, cycle.pid;

-- erd 다이어그램을 참고하여 cyclem product 테이블을 이용하여 제품별, 개수의 합과, 제품명을 조회
SELECT * FROM cycle;
SELECT * FROM product;

SELECT cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm
ORDER BY pid;

