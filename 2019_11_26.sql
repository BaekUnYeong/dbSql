-- �м��Լ� RANK
SELECT ename, sal, deptno,
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank,
    DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) d_rank,
    ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rown
FROM emp;

-- �ǽ�1
SELECT empno, ename, sal, deptno,
    RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
    ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_rank
FROM emp;

-- �ǽ�2 �μ��� ������
SELECT empno, ename, a.*
FROM emp b,
(SELECT deptno, COUNT(deptno) cnt
FROM emp
GROUP BY deptno) a
WHERE a.deptno = b.deptno
ORDER BY a.deptno, b.empno;

-- �м��Լ� ��������� (CONUT)
SELECT empno, ename, deptno,
    COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- �μ��� ����� �޿� �հ�
-- �м��Լ� (SUM)
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

-- �ǽ� 3
SELECT empno, ename, sal, deptno,
    ROUND(AVG(sal) OVER (PARTITION BY deptno),2) cnt
FROM emp;

-- �ǽ� 4 �μ��� �޿��� �������
SELECT empno, ename, sal, deptno,
    MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- �ǽ� 5 �μ��� �޿��� �������
SELECT empno, ename, sal, deptno,
    MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

-- �μ��� �����ȣ�� ���� �������
-- �μ��� �����ȣ�� ���� �������
-- LAST_VALUE�� Ȯ�� �ʿ�
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

-- LAG(������)
-- ������
-- LEAD(������)
-- �޿��� ���������� ���� ������ �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--                            �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�
SELECT empno, ename, sal, LAG(sal) OVER (ORDER BY sal) lag_sal,
                          LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

-- �ǽ� 5
SELECT empno, ename, hiredate, sal,
    LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

-- �ǽ� 6
SELECT empno, ename, hiredate, job, sal,
    LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) LAG_sal
FROM emp;

-- �ǽ� 7
SELECT empno, ename, sal
FROM emp;

SELECT a.empno, a.ename, a.sal, SUM(b.sal) sum_sal
FROM
(SELECT a.*, ROWNUM rn
FROM
    (SELECT empno, ename, sal
     FROM emp
     ORDER BY sal, empno) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;


-- WINDOWING
-- UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� �����
-- CURRENT ROW : ���� ��
-- UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� �����
-- N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
-- N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

-- �ǽ� 8
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
    SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
    
    SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
    SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;