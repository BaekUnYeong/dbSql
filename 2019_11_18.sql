--hr 계정에서 작성

SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC24';

SELECT *
FROM pc24.v_emp_dept;

--sem 계정에서 조회권환을 받은 V_EMP_DEPT view를 hr 계정에서 조회하기 위해서는
--계정명.view이름 형식으로 기술해야 한다.
--이때 매번 계정명을 기술하기 번거롭기 때문에 synonym을 사용한다.

CREATE SYNONYM V_EMP_DEPT FOR PC24.V_EMP_DEPT;

--PC07.V_EMP_DEPT => V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- 시노님 삭제
DROP TABLE 테이블명;

DROP SYNONYM V_EMP_DEPT;

-- hr 계정 비밀번호 : java
-- hr 계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY hr;
-- ALTER USER PC24 IDENTIFIED BY java; // 본인 계정이 아니라 에러

-- dictionary
-- 접두어 : USER : 사용자 소유 객체
--         ALL : 사용자가 사용가능 한 객체
--         DBA : 관리자 관점의 전체 객체(일반 사용자는 사용 불가)
--         V$ : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC24', 'HR');

-- 오라클에서 동일한 SQL이란 ?
-- 문자가 하나라도 틀리면 안됨
-- 다음 SQL들은 같은결과를 만들어 낼지 몰라도 DBMS에서는 서로 다른 SQL로 인식된다
SELECT /* bind_test */* FROM EMP;
Select /* bind_test */* FROM emp;
select /* bind_test */* FROM emp;

Select /* bind_test */* FROM emp WHERE empno = 7369;
Select /* bind_test */* FROM emp WHERE empno = 7499;
Select /* bind_test */* FROM emp WHERE empno = 7521;

select /* bind_test */* FROM emp WHERE empno = :empno;

SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%bind_test%';


SELECT *
FROM fastfood;


SELECT a.sido, a.sigungu, a."버+맥+K", b."롯리", ROUND(a."버+맥+K"/b."롯리",2)result
FROM
(SELECT sido, sigungu, COUNT(*)"버+맥+K"
FROM fastfood
WHERE gb IN ('버거킹','맥도날드','KFC')
GROUP BY sido, sigungu) a,
(SELECT sido, sigungu, COUNT(*)"롯리"
FROM fastfood
WHERE gb = '롯데리아'
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
GROUP BY a.sido, a.sigungu, a."버+맥+K", b."롯리"
ORDER BY result DESC;