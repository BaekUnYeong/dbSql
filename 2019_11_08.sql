-- ���� ����
-- RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�
-- EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ������� �μ���ȣ�� �����ְ�,
-- �μ���ȣ�� ���� DEPT ���̺�� ������ ���� �ش� �μ��� ������ ������ �� �ִ�.

-- ������ȣ, �����̸�, �����ǼҼ� �μ���ȣ, �μ��̸�
SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno;

-- �μ���ȣ, �μ���, �ش�μ��� �ο���
-- conut(col) : col ���� �����ϸ� 1, null �̸� 0
--              ����� �ñ��� ���̸� * ���
SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname
ORDER BY dname;

-- TOTAL ROW : 14
SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;

-- OUTER JOIN : ���ο� ���п��� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ ����� �������� �ϴ� ���� ����
-- LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ���� ����
-- RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ���� ����
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIM - �ߺ�����

-- ���� ������, �ش� ������ ������ ���� outer join
SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l LEFT OUTER JOIN emp r ON (l.mgr = r.empno);

SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l RIGHT OUTER JOIN emp r ON (l.mgr = r.empno);

-- oracle outer join (left, right�� ���� fullouter�� �������� ����)
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

-- oracle outer ���������� outer ���̺��̵Ǵ� ��� �÷��� (+)�� �ٿ���� outer joingn�� ���������� �����Ѵ�.
SELECT l.empno, l.ename, r.empno, r.ename
FROM emp l, emp r
WHERE l.mgr = r.empno(+)
AND r.deptno(+) = 10;

-- ANSI RIGHT OUTER
SELECT l.empno, l.ename, l.mgr, r.ename
FROM emp l RIGHT OUTER JOIN emp r ON (l.mgr = r.empno);

-- buyprod ���̺� �������ڰ� 2005��1��25���� �����ʹ� 3ǰ�� �ۿ� ����. ��� ǰ���� ���ü� �ֵ��� ���� �ۼ�
SELECT * FROM buyprod;
SELECT * FROM prod;

-- ANSI LEFT OUTER JOIN ���
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = '05/01/25');

-- ORACLE OUTER JOIN ���
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod, buyprod
WHERE prod.prod_ID = buyprod.buy_prod(+)
AND buy_date(+) = '05/01/25';

-- ���� ��ȸ ������ ����Ͽ� buy_date �÷��� null�� �׸��� �ȳ������� �����͸� ä�켼��.
-- CASE ~ END ���
SELECT 
CASE
    WHEN buyprod.buy_date is null then TO_DATE('05/01/25', 'YY/MM/DD') 
    else buyprod.buy_date
    end buy_date,
    buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = '05/01/25');
-- DECOED ���
SELECT 
DECODE(buyprod.buy_date, null ,TO_DATE('05/01/25', 'YY/MM/DD'),
    buyprod.buy_date) buy_date,
    buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

-- ���� ��ȸ ������ ����Ͽ� buy_qty �÷��� null�� �׸��� �ȳ������� �����͸� ä�켼��.
-- CASE ~ END ���
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
-- DECOED ���
SELECT 
DECODE(buyprod.buy_date, null ,TO_DATE('05/01/25', 'YY/MM/DD'),
    buyprod.buy_date) buy_date,
    buyprod.buy_prod, prod.prod_id, prod.prod_name, 
DECODE(buyprod.buy_qty, null, 0, buyprod.buy_qty)buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- buy_date �� TO_DATE ���, buy_qty �� NVL ���
SELECT TO_DATE('05/01/25', 'YY/MM/DD') buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, NVL(buyprod.buy_qty, 0) buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (prod.prod_ID = buyprod.buy_prod AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

-- cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�, �������� �ʴ� ��ǰ�� ������ ���� ��ȸ(���� cid = 1�� �� , null ó��)
SELECT * FROM cycle;
SELECT * FROM product;
SELECT * FROM customer;

SELECT product.pid, product.pnm, NVL(cycle.cid,1)cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0)cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = 1);

-- cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�, �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�Ǹ� ���̸��� ����(���� cid = 1�� �� , null ó��)
SELECT product.pid, product.pnm, NVL(cycle.cid,1)cid, NVL(customer.cnm, 'brown')cnm, NVL(cycle.day,0) day, NVL(cycle.cnt,0)cnt
FROM (product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = 1)) LEFT OUTER JOIN customer ON (customer.cid = cycle.cid)
ORDER BY pid DESC;

-- customer, product ���̺��� �̿��Ͽ� ���� ���� ������ ��� ��ǰ�� ������ �����Ͽ� ��ȸ
SELECT cid, cnm, pid, pnm
FROM product, customer;

-- subquery : main ������ ���ϴ� �κ� ����
-- ���Ǵ� ��ġ :
-- SELECT - scalar subquery(�ϳ��� ��� �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�)
-- FROM - inline view
-- WHERE - subquery

-- SELECT - scalar subquery
SELECT empno, ename, (SELECT SYSDATE FROM dual)now
FROM emp;

-- SMITH ����� ���� �μ��� ��� ��� ����
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
-- ��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT avg(sal)avg_sal
             FROM emp);

-- ��� �޿����� ���� �޿��� �޴� ������ ������ ��ȸ
SELECT *
FROM emp
WHERE sal > (SELECT avg(sal)avg_sal
             FROM emp);

-- SMITH�� WARD����� ���� �μ��� ��� ��� ������ ��ȸ
SELECT empno, ename, job, mgr, TO_CHAR(hiredate, 'YYYY/MM/DD')hiredate, sal, comm, deptno
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));