--hr �������� �ۼ�

SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC24';

SELECT *
FROM pc24.v_emp_dept;

--sem �������� ��ȸ��ȯ�� ���� V_EMP_DEPT view�� hr �������� ��ȸ�ϱ� ���ؼ���
--������.view�̸� �������� ����ؾ� �Ѵ�.
--�̶� �Ź� �������� ����ϱ� ���ŷӱ� ������ synonym�� ����Ѵ�.

CREATE SYNONYM V_EMP_DEPT FOR PC24.V_EMP_DEPT;

--PC07.V_EMP_DEPT => V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- �ó�� ����
DROP TABLE ���̺��;

DROP SYNONYM V_EMP_DEPT;

-- hr ���� ��й�ȣ : java
-- hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
-- ALTER USER PC24 IDENTIFIED BY java; // ���� ������ �ƴ϶� ����

-- dictionary
-- ���ξ� : USER : ����� ���� ��ü
--         ALL : ����ڰ� ��밡�� �� ��ü
--         DBA : ������ ������ ��ü ��ü(�Ϲ� ����ڴ� ��� �Ұ�)
--         V$ : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC24', 'HR');

-- ����Ŭ���� ������ SQL�̶� ?
-- ���ڰ� �ϳ��� Ʋ���� �ȵ�
-- ���� SQL���� ��������� ����� ���� ���� DBMS������ ���� �ٸ� SQL�� �νĵȴ�
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


SELECT a.sido, a.sigungu, a."��+��+K", b."�Ը�", ROUND(a."��+��+K"/b."�Ը�",2)result
FROM
(SELECT sido, sigungu, COUNT(*)"��+��+K"
FROM fastfood
WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
GROUP BY sido, sigungu) a,
(SELECT sido, sigungu, COUNT(*)"�Ը�"
FROM fastfood
WHERE gb = '�Ե�����'
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
GROUP BY a.sido, a.sigungu, a."��+��+K", b."�Ը�"
ORDER BY result DESC;