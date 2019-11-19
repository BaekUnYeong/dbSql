SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
FROM tax
ORDER BY sal DESC;
ORDER BY point DESC;

-- �������� �õ�, �ñ��� | �������� �õ� �ñ���
-- �õ�, �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�

SELECT a.sido, a.sigungu, a.result, a.rn, b.sido, b.sigungu, sal, b.rn
FROM
    (SELECT a.*, ROWNUM rn
    FROM 
        (SELECT a.sido, a.sigungu, a."��+��+K", b."�Ը�", ROUND(a."��+��+K"/b."�Ը�",2)result
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
        ORDER BY result DESC) a) a,
    (SELECT b.*, ROWNUM rn
    FROM
        (SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
        FROM tax
        ORDER BY sal DESC) b) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu(+)
ORDER BY a.rn;



SELECT *
FROM emp_test;

-- emp_test ���̺� ����
DROP TABLE emp_test;

-- multiple insert�� ���� �׽�Ʈ ���̺� ����
-- empno, ename �ΰ��� �÷��� ���� emp_test, emp_test2 ���̺��� emp ���̺�� ���� �����Ѵ� (CTAS)
-- �����ʹ� �������� �ʴ´�
-- emp_test ���̺� ����
CREATE TABLE emp_test AS
-- emp_test2 ���̺� ����
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

-- INSERT ALL
-- �ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

-- INSERT ������ Ȯ��
SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

-- INSERT ALL �÷� ����
rollback;

INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

-- multiple insert (conditional insert)
rollback;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE -- ������ ������� ���� ���� ����;
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno , 'sally' ename FROM dual;

-- INSERT ������ Ȯ��
SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

-- INSERT FIRST
-- ���ǿ� �����ϴ� ù��° INSERT ������ ����
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno , 'sally' ename FROM dual;

-- MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--         ���ǿ� �����ϴ� �����Ͱ� ������ INSERT

-- empno�� 7369�� �����͸� emp ���̺�� ���� ����(insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;


SELECT *
FROM emp_test;

-- emp���̺��� �������� emp_test ���̺��� empno�� ���� ���� ���� �����Ͱ� �������
-- emp_test.ename = ename || '_merge' ������ update
-- �����Ͱ� ���� ��쿡�� emp_test ���̺� insert

ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
MERGE INTO emp_test
USING (SELECT empno, ename
       FROM emp
       WHERE emp.empno IN (7369, 7499))emp
    ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

-- �ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������ merge �ϴ� ���
-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� update
-- empno�� ���� ���� ������ �ű� insert

MERGE INTO emp_test
USING dual
    ON(emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (1, 'brown');

-- �׷캰 �հ�, ��ü �հ踦 ������ ���� ���Ϸ��� ?? �ǽ� 1
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno
UNION
SELECT null,SUM(sal)
FROM emp;

-- �� ������ ROLLUP���·� ����
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno);

-- rollup
-- group by �� ���� �׷��� ����
-- GROUP BY ROLLUP ( {col1, ...} )
-- �÷��� �����ʿ������� �����ذ��鼭 ���� ����׷��� GROUP BY �Ͽ� UNION �� �Ͱ� ����
-- ex) GROUP BY ROLLUP (job, deptno
--     GROUP BY job, deptno
--     UNION
--     GROUP BY job
--     UNION
--     GROUP BY --> �Ѱ� (��� �࿡ ���� �׷��Լ� ����)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- GROUPING SETS (col1, col2 ...)
-- GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�
-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- emp ���̺��� �̿��Ͽ� �μ��� �޿��հ�, ������(job)�� �޿����� ���Ͻÿ�

-- �μ���ȣ, job, �޿��հ�
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(deptno, job);