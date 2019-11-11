SELECT empno, ename, job, mgr, TO_CHAR(hiredate, 'YYYY/MM/DD')hiredate, sal, comm, deptno
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN(:name1, :name2));

-- ANY : set�߿� �����ϴ°� �ϳ��� ������ ��(ũ���)
-- SMITH, WARD �� ����� �ѻ���� �޿����� ���� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));

-- SMITH�� WARD���� �޿��� ���� ���� ��ȸ
-- SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� �������(AND)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
-- NOT IN
-- �������� ��������
-- 1. �������� ����� ��ȸ
-- . mgr �÷��� ���� ������ ����
SELECT DISTINCT mgr
FROM emp;

-- � ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

-- ������ ������ ���� ���� �Ϲ� ��� ���� ��ȸ
-- �� NOT IN ������ ����� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
-- NULL ó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);

-- pairwise
-- ��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
-- �����߿� �����ڿ� �μ���ȣ�� (7698, 30), (7839, 10) �� ���
-- mgr, deptno �÷��� [����]�� ���� ��Ű�� ���� ���� ��ȸ
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

-- SCALAR SUBQUERY : SELECT ���� �����ϴ� ���� ����(�� ���� �ϳ��� ��, �ϳ��� �÷�)
-- ������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

-- dept ���̺� �ǽ��� ������ INSERT
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM emp
ORDER BY deptno;

-- dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ���� ������ ������ ���� �μ��� ��ȸ
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);

-- customer, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� ��ȸ
SELECT * FROM cycle
WHERE cid = 1;
SELECT * FROM product;

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

-- cycle ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ�� cid = 1�� ���� �����ϴ� ��ǰ�� �������� ��ȸ
SELECT* FROM cycle
WHERE cid = 2;

SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid FROM cycle WHERE cid = 2);

-- �ǽ� 7 (����)
-- cycle, product ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ�� cid = 1�� ���� �����ϴ� ��ǰ�� �������� ��ȸ(����� ��ǰ����� ����)
SELECT * FROM customer;
SELECT * FROM cycle;
SELECT * FROM product;

SELECT cycle.cid, customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid = product.pid AND cycle.cid = customer.cid
AND product.pid IN (SELECT cycle.pid FROM cycle WHERE cycle.cid = 2);

-- EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
-- �����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

-- MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
-- MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE empno = a.mgr);

-- SUBQUERY�� ������� �ʰ� �Ŵ����� �����ϴ� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- �μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ
SELECT *
FROM dept a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = a.deptno);
-- IN ������ ���      
SELECT *
FROM dept a
WHERE deptno IN (SELECT deptno
                 FROM emp);

-- �ǽ� 9 (����)
-- cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� ��ȸ (EXISTS ���)
SELECT * FROM cycle
WHERE cid = 1;
SELECT * FROM product;

SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND product.pid = cycle.pid);

-- ���տ���
-- UNION : ������, �ߺ��� ����
--         DBMS������ �ߺ��� �����ϱ����� �����͸� ����(�뷮�� �����Ϳ� ���� ���Ľ� ����)
-- UNION ALL : UNION�� ��������
--             �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� => �ߺ�����
--             ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ� UNION �����ں��� ���ɸ鿡�� ����
-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
UNION
-- ����� 7369, 7698�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7698;


-- UNION ALL(�ߺ� ���)
-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
UNION ALL
-- ����� 7369, 7698�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7698;


-- INTERSECT(������ : �� �Ʒ� ���հ� ���� ������)
-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7698, 7499);


-- MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
-- ������ ����
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



















