-- 101
-- 실수로 지운 데이터 복구하기 ③ (FLASHBACK DROP)

-- 내 오라클 버전에서는 지원하지 않는다ㅠ...

DROP TABLE emp; -- 지우고

SELECT original_name, droptime
  FROM user_recyclebin; -- 휴지통에 존재하는 지 확인하는 방법

FLASHBACK TABLE emp TO BEFORE DROP; -- 다시 복구하는 법
FLASHBACK TABLE emp TO BEFORE DROP RENAME TO emp2; -- 다른 이름으로 변경해서 복구하는 법

-- 102, 103 실행 불가

-- 104
-- 데이터의 품질 높이기 ① (PRIMARY KEY)

CREATE TABLE DEPT2
( DEPTNO  NUMBER(10) CONSTRAINT DPET2_DEPNO_PK  PRIMARY KEY,
  DNAME   VARCHAR2(14),
  LOC   VARCHAR2(10) );
-- PRIMARY KEY 제약이 걸린 컬럼에는 중복된 데이터와 NULL값을 입력할 수 없다.
-- 제약 이름은 '테이블명_컬럼명_제약종류 축약'으로 명시

-- 테이블에 생성된 제약을 확인하는 방법
SELECT a.CONSTRAINT_NAME, a.CONSTRAINT_TYPE, b.COLUMN_NAME
   FROM USER_CONSTRAINTS a, USER_CONS_COLUMNS b
   WHERE a.TABLE_NAME = 'DEPT2'
   AND a.CONSTRAINT_NAME = b.CONSTRAINT_NAME;

-- 제약을 생성하는 시점은 두 가지인데 위와 같이 테이블 생성과 동시에 제약을 생성,
-- 아래와 같이 테이블 생성 후 제약을 생성 가능 
CREATE TABLE DEPT2
( DEPTNO  NUMBER(10),
  DNAME   VARCHAR2(13),
  LOC   VARCHAR2(10) );

ALTER TABLE DEPT2
  ADD CONSTRAINT DEPT2_DEPTNO_PK PRIMARY KEY(DEPTNO);

-- 105
-- 데이터의 품질 높이기 ② (UNIQUE)

-- UNIQUE : 테이블의 특정 컬럼에 중복된 데이터가 입력되지 않게 제약을 걸 수 있음
-- PRIMARY KEY와 다르게 NULL값을 입력할 수 있다

CREATE TABLE DEPT3
( DEPTNO  NUMBER(10), 
  DNAME   VARCHAR2(14) CONSTRAINT DEPT3_DNAME_UN UNIQUE, 
  LOC   VARCHAR2(10) );

-- 생성 제약조건을 알아보는 법

SELECT a.CONSTRAINT_NAME, a.CONSTRAINT_TYPE, b.COLUMN_NAME
  FROM USER_CONSTRAINTS a, USER_CONS_COLUMNS b
  WHERE a.TABLE_NAME = 'DEPT3'
  AND a.CONSTRAINT_NAME = b.CONSTRAINT_NAME;

-- PRIMARY KEY와 같이 테이블 생성 후 제약 생성이 가능
CREATE TABLE DEPT4
( DEPTNO  NUMBER(10),
  DNAME   VARCHAR2(13),
  LOC   VARCHAR2(10) );

ALTER TABLE DEPT4
  ADD CONSTRAINT DEPT4_DNAME_UN UNIQUE(DNAME);

-- 106
-- 데이터의 품질 높이기 ③ (NOT NULL)

-- 테이블의 특정 컬럼에 NULL 값 입력을 허용하지 않게 하려면 NOT NULL 제약을 생성해야 함
CREATE TABLE DEPT5
( DEPTNO  NUMBER(10), 
  DNAME   VARCHAR2(14), 
  LOC   VARCHAR2(10) CONSTRAINT DEPT5_LOC_NN NOT NULL );

-- 테이블을 생성하고, 제약조건 생성 시 데이터에 NULL값이 존재하지 않아야 제약이 생성된다
CREATE TABLE DEPT6
( DEPTNO  NUMBER(10),
  DNAME   VARCHAR2(13),
  LOC   VARCHAR2(10) );

ALTER TABLE DEPT6
  MODIFY LOC CONSTRAINT DEPT6_LOC_NN NOT NULL;
-- NOT NULL 제약은 ADD가 아닌 MODIFY로 생성 / 그리고 NOT NULL 뒤에 괄호 열고 컬럼명을 명시하지 않는다

-- 107
-- 데이터의 품질 높이기 ④ (CHECK)

-- CHECK 제약 : 특정 컬럼에 특정 조건의 데이터만 입력되거나 수정되도록 제한을 거는 제약
CREATE TABLE emp6
( empno  NUMBER(10),
  ename   VARCHAR2(20),
  sal        NUMBER(10) CONSTRAINT emp6_sal_ck 
  CHECK (sal BETWEEN 0 AND 6000 )    );

INSERT  INTO emp6 VALUES (7839, 'KING', 5000);
INSERT  INTO emp6 VALUES (7698, 'BLAKE', 2850);
INSERT  INTO emp6 VALUES (7782, 'CLARK', 2450);
INSERT  INTO emp6 VALUES (7839, 'JONES', 2975);
COMMIT;

SELECT  * FROM emp6;

UPDATE emp6
  SET sal = 9000
  WHERE ename='CLARK'; -- 제약조건 6000을 넘으니까 오류

INSERT  INTO emp6 VALUES (7566, 'ADAMS', 9000); -- 이것도 마찬가지

ALTER TABLE emp6
  DROP CONSTRAINT emp6_sal_ck; -- 제약조건을 삭제해주고

INSERT INTO emp6 VALUES (7566, 'ADAMS', 9000); -- 입력 가능

-- 108
-- 데이터의 품질 높이기 ⑤ (FOREIGN KEY)

CREATE TABLE DEPT7
( DEPTNO  NUMBER(10) CONSTRAINT DEPT7_DEPTNO_PK PRIMARY KEY, -- PRIMARY KEY
  DNAME  VARCHAR2(14),
  LOC  VARCHAR2(10) );

CREATE TABLE EMP7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
(EMPNO   NUMBER(10),
 ENAME    VARCHAR2(20),
 SAL       NUMBER(10),
 DEPTNO  NUMBER(10) 
 CONSTRAINT EMP7_DEPTNO_FK REFERENCES DEPT7(DEPTNO) );
-- DEPT7 테이블에 DEPTNO를 참조하겠다는 뜻(DEPT7은 부모 테이블, EMP7은 자식 테이블이 됨)

ALTER TABLE DEPT7
  DROP CONSTRAINT DEPT7_DEPTNO_PK; -- 삭제 불가 -> 자식 테이블 EMP7이 부모 테이블 DEPT7을 참조하고 있기 때문

ALTER TABLE DEPT7
  DROP CONSTRAINT DEPT7_DEPTNO_PK CASCADE; -- CASCADE 옵션을 붙여주면 삭제 됨(이때 EMP7 테이블의 FK 제약도 같이 삭제)

-- 109
-- WITH절 사용하기 ① (WITH ~ AS)

-- 검색 시간이 오래 걸리는 SQL이 하나의 SQL 내에서 반복되어 사용될 때 성능을 높이기 위한 방법으로 WITH절을 사용
WITH JOB_SUMSAL AS ( SELECT JOB, SUM(SAL) as 토탈
                       FROM EMP
                       GROUP BY JOB ) -- 여기까지 3줄 : 직업과 직업 토탈 월급을 출력하여 임시 저장영역에 JOB_SUMSAL로 명명해 저장
SELECT JOB, 토탈
  FROM JOB_SUMSAL
  WHERE 토탈 > ( SELECT  AVG(토탈) 
                   FROM JOB_SUMSAL  ); -- 임시저장영역에 지정된 테이블 JOB_SUMSAL을 불러와서 직업별 토탈 월급의 평균보다
                                       -- 더 큰 직업별 토탈 월급을 출력 -- 시간을 반으로 줄여준다

-- 110
-- WITH절 사용하기 ② (SUBQUERY FACTORING)

-- SUBQUERY FACTORING : WITH절의 쿼리 결과를 임시 테이블로 생성하는 것

WITH JOB_SUMSAL AS ( SELECT JOB, SUM(SAL)  토탈
                       FROM   EMP
                       GROUP BY JOB ) ,  -- JOB_SUMSAL로 직업과 직업 토탈 월급 임시 저장 영역에 저장
        DEPTNO_SUMSAL AS ( SELECT DEPTNO, SUM(SAL) 토탈
                              FROM EMP 
                              GROUP BY DEPTNO
                              HAVING SUM(SAL) > ( SELECT AVG(토탈) + 3000
                                                    FROM JOB_SUMSAL )
                               )  
SELECT DEPTNO, 토탈
  FROM DEPTNO_SUMSAL ;

-- 111
-- SQL로 알고리즘 문제 풀기 ① (구구단 2단 출력)

SELECT LEVEL AS NUM
  FROM DUAL
  CONNECT BY LEVEL <= 9;

WITH LOOP_TABLE as (SELECT LEVEL as NUM
                      FROM DUAL
                      CONNECT BY LEVEL <= 9) -- 숫자 1~9까지 출력되는 결과를 WITH절로 LOOP_TABLE에 저장
  SELECT '2' || 'X' || NUM || '=' || 2 * NUM AS "2단" -- 숫자 2와 LOOP_TABLE의 숫자를 통해서 만든다
    FROM LOOP_TABLE;

-- 112
-- SQL로 알고리즘 문제 풀기 ② (구구단 1~9단 출력)

WITH LOOP_TABLE AS (SELECT LEVEL AS NUM
                      FROM DUAL
                      CONNECT BY LEVEL <= 9), -- 1~9 저장
     GUGU_TABLE AS (SELECT LEVEL +1 AS GUGU
                      FROM DUAL
                      CONNECT BY LEVEL <= 8) -- 2~9 저장
     SELECT TO_CHAR(A.NUM) || 'X' || TO_CHAR(B.GUGU) || ' = ' || TO_CHAR(B.GUGU * A.NUM) AS 구구단
       FROM LOOP_TABLE A, GUGU_TABLE B;

-- 113
-- SQL로 알고리즘 문제 풀기 ③ (직각 삼각형 출력)

WITH LOOP_TABLE AS (SELECT LEVEL AS NUM
                      FROM DUAL
                      CONNECT BY LEVEL <=8)
  SELECT LPAD('★', NUM, '★') AS STAR
    FROM LOOP_TABLE;

-- 114
-- SQL로 알고리즘 문제 풀기 ④ (삼각형 출력)

WITH LOOP_TABLE AS (SELECT LEVEL AS NUM
                      FROM DUAL
                      CONNECT BY LEVEL <= 8)
  SELECT LPAD(' ', 10-NUM, ' ') || LPAD('★', NUM, '★') AS "Triangle"
    FROM LOOP_TABLE;

         ★ -- 9★
        ★★ -- 8★★

-- 치환변수(&)를 사용하면 입력받은 숫자만큼 삼각형 출력 가능

undefine 숫자1
undefine 숫자2

WITH LOOP_TABLE AS (SELECT LEVEL AS NUM
                      FROM DUAL
                      CONNECT BY LEVEL <= &숫자1)
  SELECT LPAD(' ', &숫자2-NUM, ' ') || LPAD('★', NUM, '★') AS "Triangle"
    FROM LOOP_TABLE;

-- 115
-- SQL로 알고리즘 문제 풀기 ⑤ (마름모 출력)

undefine p_num
ACCEPT p_num prompt '숫자 입력 : '

SELECT lpad(' ', &p_num-level, ' ') || rpad('★', level, '★') as star
  FROM DUAL
  CONNECT BY level <&p_num+1
UNION ALL
SELECT lpad(' ', level, ' ') || rpad('★', (&p_num)-level, '★') as star
  FROM DUAL
  CONNECT BY level <&p_num;
