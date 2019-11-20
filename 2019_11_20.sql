-- GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1
-- ������ ���� ��� 0

-- job �÷�
-- case1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--        job --> '�Ѱ�'
-- case else
--        job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ�' ELSE job END job,
        deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- ���� ������ deptno�� null���̸� '�Ұ�'�� �Է��ϱ� �ǽ� 2
SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ� : ' ELSE job END job,
       CASE WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN job || ' �Ұ�' 
       WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN ' ' ELSE TO_CHAR(deptno) END deptno,
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- �ǽ� 3
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

-- �ǽ� 4
SELECT dept.dname, emp.job, sum(sal) sal
FROM dept, emp
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dept.dname, emp.job)
ORDER BY dname, sal DESC;

-- �ǽ� 5
SELECT CASE WHEN dept.dname IS NULL THEN '�Ѱ�' ELSE dept.dname END dname, emp.job, sum(sal) sal
FROM dept, emp
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dept.dname, emp.job)
ORDER BY dname, sal DESC;

-- CUBE (col1, col2 ...) ���⼺�� ����. ROLLUP���� ����
-- CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
-- GROUP BY CUBE(job, deptno)
-- OO : GROUP BY job, deptno
-- OX : GROUP BY job
-- XO : GROUP BY deptno
-- XX : GROUP BY -- ��� �����Ϳ� ���ؼ� ...

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

CREATE TABLE emp_test AS
SELECT * FROM emp;

-- emp_test ���̺��� dept���̺��� �����ǰ� �ִ� ename �÷�(VARCHAR2 (14))�� �߰�
SELECT *
FROM emp_test;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

-- emp_test���̺��� dname �÷��� dept���̺��� dname �÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);

-- �ǽ� 1
ALTER TABLE dept_test ADD (empcnt NUMBER(3));

UPDATE dept_test SET empcnt = (SELECT COUNT(deptno)
                               FROM emp
                               WHERE dept_test.deptno = emp.deptno);

-- �ǽ� 2
CREATE TABLE dept_test2 AS
SELECT * FROM dept;

SELECT *
FROM dept_test2;

INSERT INTO dept_test2 VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test2 VALUES (98, 'it2', 'daejeon');

DELETE dept_test2 
WHERE NOT EXISTS (SELECT deptno
                  FROM emp
                  WHERE emp.deptno = dept_test2.deptno);

-- �ǽ� 3
SELECT * FROM emp_test;
UPDATE emp_test a SET sal = sal+200
WHERE sal < (SELECT ROUND(AVG(sal), 2)"�μ��� ��� �޿�"
             FROM emp_test b
             WHERE b.deptno = a.deptno);

-- emp, emp_test empno�÷����� ���� ������ ��ȸ
-- emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.deptno,
            (SELECT ROUND(AVG(emp.sal),2) AVG FROM emp WHERE emp.deptno = emp_test.deptno) AVG
FROM emp, emp_test
WHERE emp.empno = emp_test.empno
ORDER BY deptno DESC;