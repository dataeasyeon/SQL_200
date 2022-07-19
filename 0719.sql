-- 086
-- 서브 쿼리를 사용하여 데이터 수정하기

-- 직업이 SALESMAN인 사원들의 월급을 ALLEN의 월급으로 변경해보자

UPDATE emp -- UPDATE문은 모든 절에서 서브쿼리를 사용할 수 있음
  SET sal = (SELECT sal 
               FROM emp
               WHERE ename='ALLEN')
  WHERE job='SALESMAN';        
  
SELECT *
  FROM emp;

ROLLBACK;

SELECT *
  FROM emp;

-- 087
-- 서브 쿼리를 사용하여 데이터 삭제하기

DELETE FROM emp
WHERE sal > (SELECT sal
               FROM emp
               WHERE ename='SCOTT');

SELECT *
  FROM emp;

ROLLBACK;

SELECT *
  FROM emp;

DELETE FROM emp m
WHERE sal > (SELECT avg(sal)
               FROM emp s
               WHERE s.deptno = m.deptno);

SELECT *
  FROM emp;

ROLLBACK;

SELECT *
  FROM emp;

-- 088
-- 서브 쿼리를 사용하여 데이터 합치기

alter table dept
add sumsal  number(10);

MERGE INTO dept d
USING (SELECT deptno, sum(sal) sumsal
             FROM emp
             GROUP BY deptno) v
ON (d.deptno = v.deptno)
WHEN MATCHED THEN
UPDATE set d.sumsal = v.sumsal;

SELECT *
 FROM DEPT;
 
alter table dept
drop column sumsal;

-- 089
-- 계층형 질의문으로 서열을 주고 데이터 출력하기 ①

-- 계층형 질의문을 이용하여 사원 이름, 월급, 직업을 출력하는데 사원들간의 서열을 같이 출력해보자
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
  FROM emp
  START WITH ename='KING' -- START WITH절에서 루트 노드의 데이터를 지정
  CONNECT BY prior empno = mgr; -- CONNECT BY는 부모-자식 노드간에 관계를 지정하는 절
                                -- PRIOR을 가운데 두고 왼쪽이 부모, 오른쪽이 자식

-- 090
-- 계층형 질의문으로 서열을 주고 데이터 출력하기 ②

SELECT rpad(' ', level*3) || ename as employee, level, sal, job
  FROM emp
  START WITH ename='KING'
  CONNECT BY prior empno = mgr AND ename != 'BLAKE'; -- 직속 부하가 나오되, BLAKE와 그의 직속부하들은 안 나오게

-- 091
-- 계층형 질의문으로 서열을 주고 데이터 출력하기 ③

SELECT rpad(' ', level*3) || ename as employee, level, sal, job
  FROM emp
  START WITH ename='KING'
  CONNECT BY prior empno = mgr
  ORDER SIBLINGS BY sal desc; -- ORDER와 BY 사이에 SIBLINGS를 사용하면 계층형 질의문의 서열 순서를 깨트리지 않고 출력 가능
  
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
  FROM emp
  START WITH ename='KING'
  CONNECT BY prior empno = mgr
  ORDER BY sal desc; -- SIBLINGS를 사용하지 않았을 때

-- 092
-- 계층형 질의문으로 서열을 주고 데이터 출력하기 ④

-- SYS_CONNECT_BY_PATH(ename,'/')를 이용해 서열 순서를 가로로 출력 가능
SELECT ename, SYS_CONNECT_BY_PATH(ename,'/') as path
  FROM emp
  START WITH ename='KING'
  CONNECT BY prior empno = mgr;

SELECT ename, LTRIM(SYS_CONNECT_BY_PATH(ename,'/'), '/') as path -- 맨 이름앞에 /를 제거하고 출력
  FROM emp
  START WITH ename = 'KING'
  CONNECT BY prior empno = mgr;

-- 093
-- 일반 테이블 생성하기(CREATE TABLE)

CREATE TABLE EMP01
(EMPNO NUMBER(10),
 ENAME VARCHAR2(10),
 SAL NUMBER(10,2),
 HIREDATE DATE);

SELECT *
  FROM EMP01;

DROP  TABLE  emp01;

-- 094
-- 임시 테이블 생성하기 (CREATE TEMPORARY TABLE)

-- 사원 번호, 이름, 월급을 저장할 수 있는 테이블을 생성하는데 COMMIT 할 때까지만 데이터를 저장할 수 있도록 생성
CREATE GLOBAL TEMPORARY TABLE EMP37 -- GLOBAL TEMPORARY : 임시 테이블 생성임을 나타내기 위해 기술
(  EMPNO NUMBER(10),
   ENAME VARCHAR2(10),
   SAL NUMBER(10))
   ON COMMIT DELETE ROWS; -- ON COMMIT DELETE ROWS : 임시 테이블에 데이터를 입력하고 COMMIT 할 때까지만 데이터 보관
                                                  -- COMMIT을 하면 데이터가 사라진다

INSERT INTO EMP37 VALUES(1111,'SCOTT',3000);
INSERT INTO EMP37 VALUES(2222,'SMITH',4000);

SELECT * FROM EMP37;

COMMIT;

SELECT * FROM EMP37; -- 커밋하고 보면 데이터가 사라짐

-- 095
-- 복잡한 쿼리를 단순하게 하기 ① (VIEW)

-- 직업이 SALESMAN인 사원들의 사원 번호, 이름, 월급, 직업, 부서 번호를 출력하는 VIEW를 생성
CREATE VIEW EMP_VIEW
AS -- 여기 다음에 VIEW를 통해 보여줘야 할 쿼리를 작성
SELECT empno, ename, sal, job, deptno
  FROM emp
  WHERE job='SALESMAN';
  
SELECT * FROM emp_view; -- EMP 테이블의 일부 컬럼만 볼수 있어서 보안상 공개가 불가능한 데이터에 대해 유용함

-- 뷰를 변경하면 실제 테이블도 변경될까?

UPDATE EMP_VIEW SET sal=0 WHERE ename='MARTIN';
SELECT * FROM emp WHERE ename='MARTIN'; -- 변경된다
-- 이유 : 뷰를 쿼리하면 뷰를 만들 때 작성했던 쿼리문이 수행되면서 실제 EMP 테이블을 쿼리함

ROLLBACK; 
DROP  VIEW  emp_view; 

-- 096
-- 복잡한 쿼리를 단순하게 하기 ② (VIEW)

CREATE VIEW EMP_VIEW2
AS
SELECT deptno, round(avg(sal)) 평균월급 -- 뷰의 쿼리문에 그룹함수를 사용할때는 반드시 컬럼 별칭이 필요!
  FROM emp
  GROUP BY deptno;

SELECT * FROM EMP_VIEW2;

-- 이번에도 VIEW를 수정해보자
UPDATE EMP_VIEW2
  SET 평균월급 = 3000
  WHERE deptno=30; -- 안 됨 / deptno 30인 사람의 월급을 어떻게 변경해야할지 애매한 상황이라서

DROP  VIEW  emp_view2;

-- 097
-- 데이터 검색 속도를 높이기 (INDEX)

-- INDEX는 테이블에서 데이터를 검색할때 검색 속도를 높이기 위해 사용하는 데이터베이스 객체
CREATE INDEX EMP_SAL
  ON EMP(SAL); -- ON절 다음에 생성하고자하는 테이블과 컬럼명을 '테이블명(컬럼명)'으로 작성

DROP  INDEX  EMP_SAL;

-- 098
-- 절대로 중복되지 않는 번호 만들기 (SEQUENE)

-- 시퀀스 : 일련 번호 생성기
-- 숫자 1번부터 100번까지 출력하는 시퀀스 생성
CREATE SEQUENCE SEQ1 -- 시퀀스 이름을 SEQ1로 생성
START WITH 1 -- 시작 숫자는 1
INCREMENT BY 1 -- 증가치는 1
MAXVALUE 100 -- 출력 최대 숫자는 100
NOCYCLE; -- 최대 숫자가 출력된 이후 다시 처음 1번부터 번호를 생성할지 여부를 나타냄

-- 시퀀스를 이용해 사원번호를 입력해보자
CREATE TABLE EMP02
( EMPNO   NUMBER(10),
 ENAME    VARCHAR2(10),
 SAL  NUMBER(10) );

-- 시퀀스이름.NEXTVAL : 시퀀스의 다음 번호를 출력 또는 확인할 때 사용
INSERT INTO EMP02 VALUES( SEQ1.NEXTVAL, 'JACK', 3500);
INSERT INTO EMP02 VALUES( SEQ1.NEXTVAL, 'JAMES', 4500);

SELECT *
FROM emp02;

DROP SEQUENCE SEQ1;
DROP TABLE  EMP02;

-- 099
-- 실수로 지운 데이터 복구하기 ① (FLASHBACK QUERY)

SELECT *
  FROM EMP
  AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE) -- AS OF TIMESTAMP절에 과거 시점을 작성 / 현재 시간에서 5분 뺸 시간
  WHERE ENAME = 'KING';

-- KING의 월급을 0으로 바꾸고 다시 복구해보기
SELECT ename, sal
  FROM emp
  WHERE ename = 'KING';

UPDATE EMP
  SET SAL = 5000
  WHERE ENAME='KING';
  
COMMIT;

SELECT *
  FROM EMP
  AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE) 
  WHERE ENAME = 'KING';

-- 테이블을 플래쉬백 할 수 있는 골든 타임은 기본이 15분
SELECT name, value
  FROM V$PARAMETER
  WHERE name ='undo_retention'; -- 900초

-- 100
-- 실수로 지운 데이터 복구하기 ② (FLASHBACK QUERY)

-- 사원 테이블을 5분 전으로 되돌려보자
ALTER TABLE emp ENABLE ROW MOVEMENT; 

-- 아래 쿼리가 플래쉬백 하는 건데, 내 컴퓨터에서는 지원이 안된다....
FLASHBACK TABLE EMP TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE);

SELECT *
  FROM emp
  WHERE ename='KING';
