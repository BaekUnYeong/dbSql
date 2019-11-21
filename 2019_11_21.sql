-- �μ��� ��� �޿��� ���� ��ü�� �޿� ��պ��� ���� �μ��� �μ���ȣ�� �μ��� �޿� ��� �ݾ� ��ȸ
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal), 2) AVG
    FROM emp
    GROUP BY deptno)
WHERE AVG > (SELECT ROUND(AVG(sal), 2)
             FROM emp);

-- ��ü ������ �޿� ���
SELECT ROUND(AVG(sal), 2)
FROM emp;

-- �μ��� ��� �޿�
SELECT deptno, ROUND(AVG(sal), 2) AVG
FROM emp
GROUP BY deptno;

-- ���� ���� WITH���� �����Ͽ� ������ �����ϰ� ǥ���Ѵ�.
WITH dept_avg_sal AS (
    SELECT deptno, ROUND(AVG(sal), 2) AVG
    FROM emp
    GROUP BY deptno
)
SELECT *
FROM dept_avg_sal
WHERE AVG > (SELECT ROUND(AVG(sal), 2)
             FROM emp);

-- �޷� �����
-- STEP1. �ش� ����� ���� �����
-- CONNECT BY LEVEL

-- DATE + ���� = ���� ���ϱ� ����
SELECT 
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon,
       MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wed,
       MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
       MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM')+(level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'iw')iw,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'd')d
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY DECODE(d, 1, a.iw+1, a.iw)
ORDER BY DECODE(d, 1, a.iw+1, a.iw);


SELECT NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 01, SUM(sales))),0) jan,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 02, SUM(sales))),0) feb,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 03, SUM(sales))),0) mar,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 04, SUM(sales))),0) apr,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 05, SUM(sales))),0) may,
       NVL(MAX(DECODE(TO_CHAR(DT, 'MM'), 06, SUM(sales))),0) jun
FROM sales
GROUP BY TO_CHAR(DT, 'MM');

-- ��������
-- START WITH : ������ ���� �κ��� ����
-- CONNECT BY : ������ ���� ������ ����

-- ����� �������� (���� �ֻ��� ������������ ��� ������ Ž��)
SELECT *
FROM dept_h
START WITH deptcd = 'dept0' --START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR ���� ���� ������(XXȸ��)

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ')|| dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT dept_h.*, LPAD(' ', (LEVEL-1)*4, ' ')|| dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;