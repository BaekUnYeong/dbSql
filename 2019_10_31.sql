--테이블에서 데이터 조회
/*
    SELECT 컬럼, | express (문자열상수) [as] 별칭
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건 (condition)
*/
DESC user_tables;

SELECT *
FROM user_tables
WHERE TABLE_NAME != 'CART';

--숫자 비교 연산
--부서번호가 30번 보다 크거나 같은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno >= 30;

--부서번호가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM EMP
WHERE deptno < 30;

--입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');  --아래와 같이 TO_DATE를 써주지 않아도 좋지만, 범용적으로 쓸 수 있도록 써주는게 좋다.
--WHERE hiredate >= '1982/01/01';

--AND - WHERE 이후 조건을 더 붙여줄 때 사용한다.

--col BETWEEN X AND Y 연산
--컬럼의 값이 X보다 크거나 같고, Y보다 작거나 같은 데이터
--급여(sal)가 1000보다 크거나 같고, 2000보다 작거나 같은 데이터

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다.
SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000 AND deptno = 30;

-- emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate 조회
--      (단 연산자는 between을 사용한다.)

SELECT ename, hiredate
FROM emp
WHERE hiredate
    BETWEEN TO_DATE ('1982/01/01', 'YYYY/MM/DD')
    AND TO_DATE('1983/01/01', 'YYYY/MM/DD');
    
-- emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate 조회
--      (단 연산자는 비교연산자를 사용한다.)

SELECT ename, hiredate
FROM emp
WHERE  hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
    AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- IN연산자
-- COL IN (values...)
-- 부서번호가 10 혹은 20인 직원 조회

SELECT *
FROM emp
--WHERE deptno IN (10, 20); -- IN 연산자 사용
-- IN 연산자는 OR 연산자로 표헌할 수 있다.
WHERE deptno = 10
    OR deptno = 20; -- OR 연산자 사용
   
-- useris 테이블에서 userid가 brown, cony, sally인 데이터 조회
--  (IN 연산자 사용)

SELECT * FROM users;

SELECT userid as "아이디", usernm as "이름", alias as "별명"
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

-- COL LIKE 'S%'
-- COL의 값이 대문자 S로 시작하는 모든 값
-- COL LIKE 'S____'
-- COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회
SELECT * FROM member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신__';

-- member 테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의 mem_id, mem_name을 조회
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

-- NULL 비교
-- COL IS NULL
-- EMP 테이블에서 MGR 정보가 없는 사람(NULL) 조회
SELECT *
FROM emp
WHERE MGR IS NULL;
-- WHERE MGR != NULL;   -- NULL 비교가 실패한다.

-- 소속 부서가 10번이 아닌직원들
SELECT *
FROM emp
WHERE deptno != '10';

SELECT * FROM emp;

-- emp 테이블에서 상여(comm)가 있는 회원의 정보를 조회
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- 관리자(mgr) 사번이 7698이고 급여가 1000 이상인 사람
SELECT *
FROM emp
WHERE mgr = 7698
    AND sal > 1000;
    
-- emp 테이블에서 관리자(mgr) 사번이 7698 이거나 급여(asl)가 1000 이상인 직원 조회
SELECT *
FROM emp
WHERE mgr = 7698
    OR sal >= 1000;

-- emp 테이블에서 관리자(mgr) 사번이 7698이 아니고, 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);  -- IN --> OR

-- 위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr NOT IN (7698)
    AND mgr NOT IN (7839);
    
-- IN, NOT IN 연산자의 NULL 처리
-- emp 테이블에서 관리자(mgr) 사번이 7698, 7839 또는 null이 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
-- IN 연산자에서 결과값에 NULL이 있을 경우 의도하지 않은 동작을 한다.

SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
    AND mgr IS NOT NULL;
    
-- emp 테이블에서 job이 SALESMAN 이고 입사일자가 1981년 6월 1일 이후인 직원 조회
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원 조회 (IN, NOT IN 연산자 사용 금지)
SELECT *
FROM emp
WHERE deptno != 10
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원 조회 (NOT IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno NOT IN 10
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
    
-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보 조회(부서는 10, 20, 30만 있다고 가정하고 IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno IN (20, 30)
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');