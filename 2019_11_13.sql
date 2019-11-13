--unique table level constraint
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    --CONSTRAINT �������� �� CONSTRAINT TYPE [(�÷�...)]
    CONSTRAINT uk_dept_test_dname_loc UNIQUE (dname, loc)
);

INSERT INTO dept_test VALUES (1,'ddit','daejeon');
INSERT INTO dept_test VALUES (2,'ddit','daejeon');
--ù��° ������ ���� dname, loc���� �ߺ��ǹǷ� �ι�° ������ ������� �ʴ´�.

--foreign key(���� ����)
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES (1,'ddit','daejeon');
commit;

--emp_test(empno, ename, deptno)
DESC emp;

CREATE TABLE emp_test(
    dmpno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

--dept_test ���̺� 1�� �μ���ȣ�� �����ϰ� fk ������ dept_test.deptno �÷��� �����ϵ���
--�����Ͽ� 1�� �̿��� �μ���ȣ�� emp_test ���̺� �Էµ� �� ����.
INSERT INTO emp_test VALUES(9999,'brown',1);

--2���μ��� dept_test ���̺� �������� �ʴ� �����Ͱ� �ֱ� ������ fk ���࿡ ���� INSERT�� ����������
�������� �ʴ´�.
INSERT INTO emp_test VALUES(9998,'sally',2);

--���Ἲ ���࿡�� �߻��� ������ �ؾ� �ϴ°�?
--�� �θ����̺� ���� �Էµ��� �ʾҴ��� 

--fk ���� table level constraint
DROP TABLE emp_test;

CREATE TABLE emp_test(
    dmpno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
    (deptno) REFERENCES dept_test(deptno)
);

--FK������ �����Ϸ��� �����Ϸ��� �÷��� �ε����� �����Ǿ� �־�� �Ѵ�.

--DROP�Ͽ� ���̺��� ������� �ڽ����̺���� ���� �� �θ����̺��� ������ �Ѵ�.
DROP TABLE emp_test;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    /*PRIMARY KEY ==> UNIQUE ����X ==> �ε��� ����X*/
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

INSERT INTO dept_test VALUES (1,'ddit','daejeon');
INSERT INTO emp_test VALUES (9999,'brown',1);
commit;

--dept_test���̺� deptno���� �����ϴ� �����Ͱ� ���� ��� ������ �Ұ����ϴ�.
--�ڽ� ���̺��� �����ϴ� �����Ͱ� ����� �θ����̺��� �����͸� ������ �� �ִ�.
DELETE dept_test
WHERE deptno=1;

--FK���� �ɼ�
--default : ������ �Է�/������ ���������� ó������� fk ������ �������� �ʴ´�.
--ON DELETE CASCADE : �θ� ������ ������ �����ϴ� �ڽ� ���̺� ���� ����
--ON DELETE SET NULL : �θ� ������ ������ �����ϴ� �ڽ� ���̺� �� NULL ����
DROP TABLE emp_test;
CREATE TABLE emp_test(
    dmpno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
    (deptno) REFERENCES dept_test(deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

--FK ���� default �ɼǿ����� �θ� ���̺��� ����� ���� �ڽ����̺��� �����ϴ�
--�����Ͱ� ����� ���������� ������ �����ߴ�.
--ON DELETE CASCADE�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �����͸�
--���� �����Ѵ�.
--1. ���� ������ ���������� ����Ǵ���?
--2. �ڽ� ���̺� �����Ͱ� ���� �Ǿ�����?
DELETE dept_test
WHERE deptno=1;

SELECT *
FROM emp_test;

--FK���� ON DELETE SET NULL
--FK ���� default �ɼǿ����� �θ� ���̺��� ����� ���� �ڽ����̺��� �����ϴ�
--�����Ͱ� ����� ���������� ������ �����ߴ�.
--ON DELETE SET NULL�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �����͸�
--NULL�� �����Ѵ�.
DROP TABLE emp_test;
CREATE TABLE emp_test(
    dmpno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
    (deptno) REFERENCES dept_test(deptno) ON DELETE SET NULL
);

INSERT INTO dept_test VALUES (1,'ddit','daejeon');
INSERT INTO emp_test VALUES (9999,'brown',1);
commit;

DELETE dept_test
WHERE deptno=1;

SELECT *
FROM emp_test;

--CHECK ���� : �÷��� ���� ������ ���� Ȥ�� ���� �Էµ� �� �ֵ��� ����
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER CHECK (sal >= 0)
);

--sal �÷��� CHECK ���� ���ǿ� ���� 0�̰ų�, 0���� ū ���� �Է��� �����ϴ�.
INSERT INTO emp_test VALUES(9999,'brown',10000);
INSERT INTO emp_test VALUES(9998,'sall',-10000);

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --emp_gb : 01 - ������, 02 - ����
    emp_gb VARCHAR(2) CHECK (emp_gb IN('01','02'))
);

INSERT INTO emp_test VALUES(9999,'brown','01');
--emp_gb �÷� üũ���࿡ ���� 01, 02�� �ƴ� ���� �Էµ� �� ����.
INSERT INTO emp_test VALUES(9998,'sally','03');

-- SELECT ����� �̿��� TABLE ����
-- CREATE TABLE ���̺�� AS
-- SELECT ����
--> CTAS

DROP TABLE emp_test;
DROP TABLE dept_test;

-- CUSTOMER ���̺��� ����Ͽ� CUSTOMER_TEST ���̺�� ����
-- CUSTOMER ���̺��� �����͵� ���� ����
CREATE TABLE customer_test AS
SELECT *
FROM customer;

SELECT *
FROM customer_test;

CREATE TABLE test AS
SELECT SYSDATE dt
FROM dual;

SELECT *
FROM test;

DROP TABLE test;

-- �����ʹ� �������� �ʰ� Ư�� ���̺��� �÷� ���ĸ� �����ü� ������ ?
DROP TABLE customer_test;
CREATE TABLE customer_test AS
SELECT *
FROM customer
WHERE 1 = 2;

SELECT *
FROM customer_test;

CREATE TABLE test (
    c1 VARCHAR2(2) CHECK ( c1 in ('01', '02'))
    );

CREATE TABLE test2 AS
SELECT *
FROM test;

-- ���̺� ����
-- ���ο� �÷� �߰�
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10)
);

-- �ű� �÷� �߰�
ALTER TABLE emp_test ADD ( deptno NUMBER(2) );
desc emp_test;

-- ���� �÷� ����
ALTER TABLE emp_test MODIFY ( ename VARCHAR2 (200) );

ALTER TABLE EMP_TEST MODIFY ( ename NUMBER );

-- �����Ͱ� �ִ� ��Ȳ���� �÷� ���� : �������̴�
INSERT INTO EMP_TEST VALUES (9999, 1000, 10);
COMMIT;

-- ������ Ÿ���� �����ϱ� ���ؼ��� �÷� ���� ��� �־�� �Ѵ�.
ALTER TABLE EMP_TEST MODIFY ( ename VARCHAR2(10) );

-- DEFAULT ����
DESC EMP_TEST;
ALTER TABLE EMP_TEST MODIFY ( deptno DEFAULT 10 );

-- �÷��� ����
ALTER TABLE EMP_TEST RENAME COLUMN deptno TO dno;

-- �÷� ����(DROP)
ALTER TABLE emp_test DROP COLUMN dno;
ALTER TABLE emp_test DROP dno;

-- ���̺� ���� : �������� �߰�
-- PRIMARY KEY
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

-- �������� ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

-- UNIQUE ���� - empno
ALTER TABLE emp_test ADD CONSTRAINT uk_emp_test UNIQUE (empno);

-- UNIQUE ���� ���� : uk_emp_test
ALTER TABLE emp_test DROP CONSTRAINT uk_emp_test;

-- FOREIGN KEY �߰�
-- �ǽ�
-- 1.DEPT ���̺��� DEPTNO�÷����� PRIMARY KEY ������ ���̺� ����
-- ddl�� ���� ����
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

-- 2.EMP ���̺��� EMPNO�÷����� PRIMARY KEY ������ ���̺� ����
-- ddl�� ���� ����
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

-- 3.EMP ���̺��� DEPTNO�÷����� DEPT ���̺��� DEPTNO �÷���
-- �����ϴ� fk ������ ���̺� ���� ddl�� ���� ����
-- emp --> dept (deptno)
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

-- emp_test -> dept.deptno fk ���� ���� (ALTER TABLE)
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

-- CHECK ���� �߰� (ename ���� üũ, ���̰� 3���� �̻�)
ALTER TABLE emp_test ADD CONSTRAINT check_ename_len CHECK (LENGTH(ename) > 3);

INSERT INTO emp_test VALUES (9999,'brown',10);
INSERT INTO emp_test VALUES (9998,'br',10);
ROLLBACK;

-- CHECK ���� ����
ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;

-- NOT NULL ���� �߰�
ALTER TABLE emp_test MODIFY (ename NOT NULL);

-- NOT NULL ���� ����
ALTER TABLE emp_test MODIFY (ename NULL);