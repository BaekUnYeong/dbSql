-- ����� ��������
-- Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�)
-- ���������� �������� ���� �μ��� ��ȸ
-- �������� dept0_00_0
SELECT dept_h.*, LPAD(' ', (LEVEL-1)*4, ' ')|| dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

-- �ǽ� h_4
SELECT *
FROM h_sum;

SELECT LPAD(' ',(LEVEL-1)*4,' ')|| h_sum.s_id s_id , value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

-- �ǽ� h_5
SELECT *
FROM no_emp;

SELECT LPAD(' ',(LEVEL-1)*4, ' ')||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- pruning branch (����ġ��)
-- ������������ [WHERE]���� START WITH, CONNECT BY ���� ���� ����� ���Ŀ� ����ȴ�.

-- dept_h ���̺��� �ֻ��� ��� ���� ��������� ��ȸ
SELECT deptcd, LPAD(' ', (level-1)*4, ' ')||deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ���������� �ϼ��� ���� WHERE���� ����ȴ�.
SELECT deptcd, LPAD(' ', (level-1)*4, ' ')||deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', (level-1)*4, ' ')||deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
AND deptnm != '������ȹ��';

-- CONNECT_BY_ROOT(col) : col�� �ֻ��� ��� �÷� ��
-- SYS_CONNECT_BY_PATH(col, ������) : col�� �������� ������ �����ڷ� ���� ���
--      LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� ���� �ִ� ���°� �Ϲ���
--  CONNECT_BY_ISLEAF : �ش� row�� leaf node���� �Ǻ� ( 1 : O, 0 : X )
SELECT LPAD(' ',(level-1)*4, ' ')||org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '->'), '->') path_org_cd,
        CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- �ǽ� h6
SELECT *
FROM board_test;

SELECT seq, LPAD(' ',(LEVEL-1)*4,' ')||title title
FROM board_test
START WITH parent_seq is null -- or IN (1,2,4) <- ������ ���
CONNECT BY PRIOR seq = parent_seq;

-- �ǽ� h7
SELECT seq, LPAD(' ',(LEVEL-1)*4,' ')||title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;

-- ���������� �����߸��� �ʰ� �����ϱ�
SELECT seq, LPAD(' ',(LEVEL-1)*4,' ')||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC, parent_seq;

SELECT seq, LPAD(' ',(LEVEL-1)*4,' ')||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq END DESC, seq;
-------------------------------------------------------------------
SELECT *
FROM
(SELECT seq, LPAD(' ',(LEVEL-1)*4,' ')||title title,
        CONNECT_BY_ROOT(seq) r_seq
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
ORDER BY r_seq DESC;

SELECT *
FROM board_test;
-- �� �׷��ȣ �÷� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ',(LEVEL-1)*4,' ')||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;


SELECT a.ename, a.sal, b.sal
FROM
(SELECT ename, sal, ROWNUM rn
FROM
    (SELECT ename, sal
    FROM emp
    ORDER BY sal DESC))a,
(SELECT ename, sal, ROWNUM-1 rn2
FROM
    (SELECT ename, sal
    FROM emp
    ORDER BY sal DESC))b
WHERE a.rn = b.rn2(+);