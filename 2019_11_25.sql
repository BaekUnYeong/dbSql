CREATE TABLE member2 AS
SELECT *
FROM member;

UPDATE member2 SET mem_job = '±ºÀÎ'
WHERE mem_id = 'a001';
COMMIT;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';

SELECT *
FROM buyprod;

SELECT buy_prod, SUM(buy_qty) SUM_QTY, SUM(buy_cost) SUM_COST
FROM buyprod
GROUP BY buy_prod
ORDER BY buy_prod;



CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT buyprod.buy_prod, prod.prod_name, SUM(buy_qty) SUM_QTY, SUM(buy_cost) SUM_COST
FROM buyprod, prod
WHERE buyprod.buy_prod = prod.prod_id
GROUP BY buy_prod, prod.prod_name
ORDER BY buy_prod;

SELECT *
FROM USER_VIEWS;


SELECT a.*, ROWNUM rank
FROM
(SELECT ename, sal, deptno
FROM emp
GROUP BY ename, sal, deptno
ORDER BY deptno, sal DESC) a;

-- ºÎ¼­º° ·©Å·
SELECT a.deptno, b.rn
FROM
(SELECT deptno, COUNT(*) rank
FROM emp
GROUP BY deptno)a ,
(SELECT ROWNUM rn
FROM emp) b
WHERE a.rank >= b.rn
ORDER BY deptno, rn;

-- ¼±»ý´Ô Äõ¸®
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

-- RANK
SELECT ename, sal, deptno,
    ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;