-- ���� WHERE
-- job�� SALESMAN�̰ų� �Ի����ڰ� 1981��6��1�� ������ ���� ���� ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- ROWNUM
-- ORDER BY���� SELECT �� ���Ŀ� ����
-- ROWNUM �����÷��� ����ǰ��� ���ĵǱ� ������ �츮�� ���ϴ´�� ù��° �����ͺ��� �������� ��ȣ �ο��� ���� �ʴ´�.
SELECT ROWNUM, e. *
FROM emp e;

-- ORDER BY ���� ������ �ζ��� �並 ����
SELECT ROWNUM, a.*
FROM (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--ROWNUM : 1������ �о�� �ȴ�
--WHERE ���� ROWNUM���� �߰��� �д°� �Ұ���
--�ȵǴ� ���̽�
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >= 2

--������ ���̽�
-- WHERE ROWNUM = 1
-- WHERE ROWNUM <= 10

SELECT ROWNUM, a.*
FROM (SELECT e.*
    FROM emp e
    ORDER BY ename) a;

-- ����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش� SQL�� INLINE VIEW�� ���ΰ� ��Ī�� ���� ����¡ ó��

SELECT *
FROM
    (SELECT ROWNUM RN, a.*
    FROM (SELECT e.*
        FROM emp e
        ORDER BY ename) a)
        WHERE RN between 10 AND 14;

--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
--SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
--LENGTH : ���ڿ��� ����
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
--LPAD : ���ڿ��� Ư�� ���ڿ��� ����(���ʺ���)
SELECT CONCAT(CONCAT('HELLO', ', WOR'), 'LD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1,
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr,
        -- INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        INSTR('HELLO, WORLD', 'O', 6) instr1,
        -- LPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���Ұ�� �߰��� ����) ���ʺ���
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad, -- �߰��� ���ڿ��� ���� ������ �������� ���Ե� (' ') �� ����
        -- RPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���Ұ�� �߰��� ����) �����ʺ���
        RPAD('HELLO, WORLD', 15, '*') rpad,
        -- REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
        REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'),'WORLD', 'world') replace,
        TRIM('   HELLO, WORLD   ') trim,
        TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

-- ROUND(������, �ݿø� ��� �ڸ���)
SELECT
    ROUND(105.24, 1) r1, --�Ҽ��� ��° �ڸ����� �ݿø�
    ROUND(105.55, 1) r2, --�Ҽ��� ��° �ڸ����� �ݿø�
    ROUND(105.55, 0) r3, --�Ҽ��� ù° �ڸ����� �ݿø�
    ROUND(105.55, -1) r4 -- ���� ù° �ڸ����� �ݿø�
FROM dual;

SELECT empno, ename, sal, ROUND(sal/1000) quotient, MOD(sal,1000) reminder
FROM emp;

--TRUNC
SELECT
    TRUNC(105.24, 1) r1, --�Ҽ��� ��° �ڸ����� ����
    TRUNC(105.55, 1) r2, --�Ҽ��� ��° �ڸ����� ����
    TRUNC(105.55, 0) r3, --�Ҽ��� ù° �ڸ����� ����
    TRUNC(105.55, -1) r4 -- ���� ù° �ڸ����� ����
FROM dual;

-- SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð������� ����
-- ������ ���ڰ� ���� �Լ�

-- TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
-- ��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT 
    TO_CHAR (SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
    TO_CHAR (SYSDATE + (1/24/60) * 30 , 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

SELECT
    TO_DATE ('2019/12/31') LASTDAY,-- 2019�� 12�� 31���� date������ ǥ��
    TO_DATE ('2019/12/31')-5 LASTDAY_BEFORE5,
    TO_CHAR (SYSDATE, 'YYYY/MM/DD') NOW,    -- ���糯¥
    TO_CHAR (SYSDATE - 3, 'YYYY/MM/DD') NOW_BEFORE3    --���� ��¥���� 3�� �� ��
FROM dual;

-- date format
-- �⵵ : YYYY, YY, RRRR, RR : ���ڸ��϶��� 4�ڸ��϶��� �ٸ�
-- RR : 50���� Ŭ��� ���ڸ��� 19, 50���� ������� ���ڸ��� 20
-- YYYY, RRRR�� ���� �������̸� ��������� ǥ��
-- D : ������ ���ڷ� ǥ�� ( �Ͽ��� = 1, ������ = 2, ȭ���� = 3 ... ����� = 7)
SELECT 
    TO_CHAR(TO_DATE ('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
    TO_CHAR(TO_DATE ('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2,
    TO_CHAR(TO_DATE ('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
    TO_CHAR(SYSDATE, 'D') d, --������ ������ > 2�� ����
    TO_CHAR(SYSDATE, 'IW') iw, --������ ������ > 45
    TO_CHAR(TO_DATE('2019/12/29', 'YYYY/MM/DD'), 'IW') this_year
FROM dual;

-- ���� ��¥�� ������ ���� �������� ��ȸ
SELECT 
    TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_width_time,
    TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;