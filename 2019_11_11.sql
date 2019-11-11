SELECT empno, ename, job, mgr, TO_CHAR(hiredate, 'YYYY/MM/DD')hiredate, sal, comm, deptno
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN(:name1, :name2));

-- ANY : set중에 만족하는게 하나라도 있으면 참(크기비교)
-- SMITH, WARD 두 사람중 한사람의 급여보다 작은 직원 정보 조회
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));

-- SMITH와 WARD보다 급여가 높은 직원 조회
-- SMITH보다도 급여가 높고 WARD보다도 급여가 높은사람(AND)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
-- NOT IN
-- 관리자의 직원정보
-- 1. 관리자인 사람만 조회
-- . mgr 컬럼에 값이 나오는 직원
SELECT DISTINCT mgr
FROM emp;

-- 어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

-- 관리자 역할을 하지 않은 일반 사원 정보 조회
-- 단 NOT IN 연산자 사용지 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
-- NULL 처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);

-- pairwise
-- 사번 7499, 7782인 직원의 관리자, 부서번호 조회
-- 직원중에 관리자와 부서번호가 (7698, 30), (7839, 10) 인 사람
-- mgr, deptno 컬럼을 [동시]에 만족 시키는 직원 정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
-- non pairwise
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499, 7782));

-- SCALAR SUBQUERY : SELECT 절에 등장하는 서브 쿼리(단 값이 하나의 행, 하나의 컬럼)
-- 직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

-- dept 테이블에 실습용 데이터 INSERT
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM emp
ORDER BY deptno;

-- dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음 지원이 속하지 않은 부서를 조회
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);

-- customer, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회
SELECT * FROM cycle
WHERE cid = 1;
SELECT * FROM product;

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

-- cycle 테이블을 이용하여 cid = 2인 고객이 애음하는 제품중 cid = 1인 고객도 애음하는 제품의 애음정보 조회
SELECT* FROM cycle
WHERE cid = 2;

SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid FROM cycle WHERE cid = 2);

-- 실습 7 (과제)
-- cycle, product 테이블을 이용하여 cid = 2인 고객이 애음하는 제품중 cid = 1인 고객도 애음하는 제품의 애음정보 조회(고객명과 제품명까지 포함)
SELECT * FROM customer;
SELECT * FROM cycle;
SELECT * FROM product;

SELECT cycle.cid, customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid = product.pid AND cycle.cid = customer.cid
AND product.pid IN (SELECT cycle.pid FROM cycle WHERE cycle.cid = 2);

-- EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
-- 만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에 성능면에서 유리

-- MGR이 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
-- MGR이 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE empno = a.mgr);

-- SUBQUERY를 사용하지 않고 매니저가 존재하는 직원 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- 부서에 소속된 직원이 있는 부서 정보 조회
SELECT *
FROM dept a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = a.deptno);
-- IN 연산자 사용      
SELECT *
FROM dept a
WHERE deptno IN (SELECT deptno
                 FROM emp);

-- 실습 9 (과제)
-- cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회 (EXISTS 사용)
SELECT * FROM cycle
WHERE cid = 1;
SELECT * FROM product;

SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND product.pid = cycle.pid);

-- 집합연산
-- UNION : 합집합, 중복을 제거
--         DBMS에서는 중복을 제거하기위해 데이터를 정렬(대량의 데이터에 대해 정렬시 부하)
-- UNION ALL : UNION과 같은개념
--             중복을 제거하지 않고, 위 아래 집합을 결합 => 중복가능
--             위아래 집합에 중복되는 데이터가 없다는 것을 확신하면 UNION 연산자보다 성능면에서 유리
-- 사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
UNION
-- 사번이 7369, 7698인 사원 조회(사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7698;


-- UNION ALL(중복 허용)
-- 사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
UNION ALL
-- 사번이 7369, 7698인 사원 조회(사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7698;


-- INTERSECT(교집합 : 위 아래 집합간 공통 데이터)
-- 사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7698, 7499);


-- MINUS(차집합 : 위 집합에서 아래 집합을 제거)
-- 순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7698, 7499);





SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC24'
AND TABLE_NAME IN ('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN ('P', 'R');



















