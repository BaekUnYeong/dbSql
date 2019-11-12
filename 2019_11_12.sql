-- DML
DESC emp;

INSERT INTO emp (ename, job)
VALUES ('matthew', null);

SELECT *
FROM emp
WHERE empno = 9999;

SELECT *
FROM USER_TAB_COLUMNS
WHERE table_name = 'EMP';

-- INSERT
INSERT INTO emp
VALUES (9999, 'matthew', 'CEO', null, sysdate, 4000, null, 99);

COMMIT;

SELECT *
FROM emp
WHERE empno = 9999;

INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;

-- UPDATE
-- UPDATE ���̺� SET �÷� = ��, �÷� = �� ...
-- WHERE condition;
UPDATE dept SET dname = '���IT', loc = 'ym'
WHERE deptno = 99;

SELECT *
FROM emp;

-- DELETE
-- DELETE ���̺��
-- WHERE condition;
-- �����ȣ�� 999�� ������ emp ���̺��� ����
DELETE emp
WHERE empno = 9999;

-- �μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5���� �����͸� ����
-- empno < 100 , between 10 AND 99
DELETE dept
WHERE deptno = 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

SELECT *
FROM dept;

-- LV1 --> LV3
SET TRANSACTION isolation LEVEL SERIALIZABLE;

-- DDL : AUTO COMMIT -> rollback�� �ȵ� (����!!)
-- CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,           -- ���� Ÿ��
    ranger_name VARCHAR2(50),   -- ���� Ÿ�� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate -- DEFAULT : SYSDATE
);

-- DDL�� rollback�� ������� �ʴ´�.
rollback;
SELECT *
FROM ranger_new;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'brown');

-- ��¥ Ÿ�Կ��� Ư�� �ʵ尡������
-- ex) sysdate���� �⵵�� ��������
SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM'),
EXTRACT(YEAR FROM reg_dt),EXTRACT(MONTH FROM reg_dt),EXTRACT(DAY FROM reg_dt)
FROM ranger_new;


-- ��������
-- DEPT ����ؼ� DEPT_TEST ����
DESC dept_test;

CREATE TABLE dept_test(
    deptno  NUMBER(2)   PRIMARY KEY,    -- deptno �÷��� �ĺ��ڷ� ����, �ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �ɼ� ����, null�� ���� ����
    dname   VARCHAR2(14),
    loc     VARCHAR2(13)
);

-- primary key ���� ���� Ȯ��
-- 1. deptno�÷��� null�� �� �� ����
-- 2. deptno�÷��� �ߺ��� ���� �� �� ����.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

rollback;

-- ����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2)    CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');
SELECT *
FROM dept_test;

-- NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2)    PRIMARY KEY,
    dname VARCHAR2(14)  NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, null, 'daejeon');      -- dname�� ������������ NOT NULL�� �����߱� ������ NULL ���� INSERT �Ұ�

-- UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2)    PRIMARY KEY,
    dname VARCHAR2(14)  UNIQUE,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon');    -- dname�� ������������ UNIQUE�� �����߱� ������ ������ ddit�� INSERT �Ұ�