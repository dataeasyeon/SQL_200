alter session set nls_date_format='RR/MM/DD';

drop table emp;
drop table dept;

CREATE TABLE DEPT
       (DEPTNO number(10),
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE EMP (
 EMPNO               NUMBER(4) NOT NULL,
 ENAME               VARCHAR2(10),
 JOB                 VARCHAR2(9),
 MGR                 NUMBER(4) ,
 HIREDATE            DATE,
 SAL                 NUMBER(7,2),
 COMM                NUMBER(7,2),
 DEPTNO              NUMBER(2) );

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'81-11-17',5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'81-05-01',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'81-05-09',2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'81-04-01',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'81-09-10',1250,1400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'81-02-11',1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'81-08-21',1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'81-12-11',950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'81-02-23',1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'81-12-11',3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'80-12-11',800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'82-12-22',3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'83-01-15',1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'82-01-11',1300,NULL,10);

commit;

drop  table  salgrade;

create table salgrade
( grade   number(10),
  losal   number(10),
  hisal   number(10) );

insert into salgrade  values(1,700,1200);
insert into salgrade  values(2,1201,1400);
insert into salgrade  values(3,1401,2000);
insert into salgrade  values(4,2001,3000);
insert into salgrade  values(5,3001,9999);

commit;

select * from emp;

-- PART 1 입문
-- 001
-- 테이블에서 특정 열(COLUMN) 선택하기

SELECT empno, ename, sal
  FROM emp;

-- 002
-- 테이블에서 모든 열(COLUMN) 출력하기

SELECT *
  FROM emp;

SELECT *
  FROM dept;

SELECT dept.*, deptno
  FROM dept; -- 모든 컬럼을 출력하고, 다시 한번 특정 컬럼을 출력하는 경우, 테이블명.* 후, 한번 더 출력하고자 하는 컬럼명 작성

-- 003
-- 컬럼 별칭을 사용하여 출력되는 컬럼명 변경하기

SELECT empno as 사원번호, ename as 사원이름, sal as "Salary"
  FROM emp;
-- 컬럼별칭(column alias) : as 작성하고 출력하고 싶은 컬럼명 기술

-- "Salary"처럼 대소문자를 구분하고자 한다면 컬럼 별칭 양쪽에 더블 쿼테이션 마크('')로 감싸줌
/* 컬럼 별칭에 ''로 감싸줘야 하는 경우
    1. 대소문자를 구분하여 출력할 때
    2. 공백문자를 출력할 때
    3. 특수문자를 출력할 때($, _, #만 가능)
*/

-- 컬럼 별칭이 유용한 경우

SELECT ename, sal * (12 + 3000)
  FROM emp; -- 이 쿼리를
  
SELECT ename, sal * (12 + 3000) as 월급
  FROM emp
  ORDER BY 월급 desc; -- 별칭을 사용하여 ORDER BY를 사용할 때 유용함
  
-- 004
-- 연결 연산자 사용하기(||)

SELECT ename || sal
  FROM emp;

-- 연결 연산자를 이용하여 컬럼들을 서로 연결하였다면 컬럼 별칭은 맨 마지막에 사용
SELECT ename || '의 월급은 ' || sal || '입니다. ' as 월급정보
  FROM emp; 

SELECT ename || '의 직업은 ' || job || '입니다 ' as 직업정보
  FROM emp; 

-- 005
-- 중복된 데이터를 제거해서 출력하기(DISTINCT, UNIQUE)

SELECT DISTINCT job
  FROM emp;

SELECT UNIQUE job
  FROM emp;

-- 006
-- 데이터를 정렬해서 출력하기(ORDER BY)

SELECT ename, sal
  FROM emp
  ORDER BY sal asc; 
  
-- ORDER BY절은 맨 마지막에 실행됨
-- 그러므로 SELECT 절에서 사용한 컬럼 별칭을 ORDER BY절에서 사용 가능

SELECT ename, sal as 월급
  FROM emp
  ORDER BY 월급 asc;

SELECT ename, deptno, sal
  FROM emp
  ORDER BY deptno asc, sal desc; -- 부서 번호 기준 오름차순, 월급 기준 내림차순 정렬

SELECT ename, deptno, sal
  FROM emp
  ORDER BY 2 asc, 3 desc; -- ORDER BY 절에 컬럼명 대신 숫자를 적어줄 수도 있다. 숫자는 SELECT절 컬럼의 순서.

-- 007
-- WHERE절 배우기 ① (숫자 데이터 검색)

SELECT ename, sal, job
  FROM emp
  WHERE sal = 3000; -- 월급이 3000인 사원의 이름과 월급, 직업을 출력하는 SQL

/* WHERE절의 검색 조건으로 사용하는 비교 연산자

1. 비교 연산자
    > 크다
    < 작다
    >= 크거나 같다
    <= 작거나 같다
    = 같다
    != 같지 않다
    ^= 같지 않다
    <> 같지 않다

2. 기타 비교 연산자
    BETWEEN AND ~사이에 있는
    LIKE 일치하는 문자 패턴 검색
    IS NULL NULL 값인지 여부
    IN 값 리스트 중 일치하는 값 검색
    
*/

SELECT ename as 이름, sal as 월급
  FROM emp
  WHERE sal >= 3000;

SELECT ename as 이름, sal as 월급
  FROM emp
  WHERE 월급 >= 3000; -- "월급": invalid identifier(부적합한 식별자)
-- 오류의 원인: SQL의 실행 순서 (FROM - WHERE - SELECT 순으로 실행하기 때문)

-- 008
-- WHERE절 배우기 ② (문자와 날짜 검색)

SELECT ename, sal, job, hiredate, deptno
  FROM emp
  WHERE ename='SCOTT'; -- 문자 검색 시, 문자 양쪽에 싱글 쿼테이션 마크를 감싸주어야 함

SELECT ename, hiredate
  FROM emp
  WHERE hiredate = '81/11/17'; -- 날짜도 양쪽에 싱글 쿼테이션 마크를 감싸주어야 함
                               -- 날짜 데이터 검색의 경우, 현재 접속한 session의 날짜 형식에 맞추어 작성해야 함
                               -- session : 데이터베이스 유저로 로그인해서 로그아웃 할 때 까지의 한 단위

-- 현재 접속한 session의 날짜 형식 조회하는 법
SELECT *
  FROM NLS_SESSION_PARAMETERS
  WHERE PARAMETER = 'NLS_DATE_FORMAT'; -- RR/MM/DD -> 연/월/일, RR : 현재 세기를 기준으로 이전 세기를 인식, YY : 현재 세기를 인식

-- 현재 접속한 session의 파라미터를 변경하는 법
ALTER SESSION SET NLS_DATE_FORMAT='YY/MM/DD';
ALTER SESSION SET NLS_DATE_FORMAT='RR/MM/DD';

-- 009
-- 산술 연산자 배우기 (*,/,+,-)

SELECT ename, sal*12 as 연봉
  FROM emp
    WHERE sal*12 >= 36000;

SELECT ename, sal, comm, sal + comm
  FROM emp
  WHERE deptno = 10; -- 데이터가 없는 상태 NULL값을 볼 수 있음
                     -- NULL값 : 데이터가 할당되지 않은 상태 또는 알 수 없는 값

-- NVL 함수 : NULL 데이터를 처리하는 함수
-- NVL(comm,0) : comm을 출력할 때 NULL이면 0으로 출력하라는 뜻
SELECT sal + NVL(comm,0)
  FROM emp
  WHERE ename='KING';

-- 010
-- 비교 연산자 배우기 ① (>,<,>=,<=,=,!=,<>,^=)

SELECT ename, sal, job, deptno
  FROM emp
  WHERE sal <= 1200; -- 월급이 1200 이하인 사원들의 이름과 월급, 직업, 부서 번호 출력