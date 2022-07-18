-- 070
-- 집합 연사자로 데이터의 차이를 출력하기 (MINUS)

SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in(10,20)
MINUS
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (20,30);
  
-- 071
-- 서브 쿼리 사용하기 ① (단일행 서브쿼리)

-- JONES보다 더 많은 월급을 받는 사원들의 이름과 월급 출력
SELECT ename, sal
  FROM emp
  WHERE sal > (SELECT sal
                 FROM EMP
                 WHERE ename='JONES'); -- 괄호로 감싼 부분을 서브쿼리라 함

SELECT ename, sal
  FROM emp
  WHERE sal = (SELECT sal
                 FROM EMP
                 WHERE ename='JONES'); -- 같은 월급을 받는 사람, 하지만 SCOTT가 함께 나온다

SELECT ename, sal
  FROM emp
  WHERE sal = (SELECT sal
                 FROM EMP
                 WHERE ename='JONES') -- 서브쿼리
  AND ename != 'SCOTT'; -- 이 부분은 메인쿼리 / 메인쿼리에 조건을 준다

-- 072
-- 서브 쿼리 사용하기 ② (다중 행 서브쿼리)

SELECT ename, sal
  FROM emp
  WHERE sal IN (SELECT sal
                  FROM EMP
                  WHERE job='SALESMAN'); -- 서브쿼리 내 여러명이므로 in 대신 = 쓰면 에러
-- 서브 쿼리에서 메인 쿼리로 하나의 값이 아니라 여러개의 값이 반환되는 것을 다중 행 서브쿼리라고 함

/* 다중 행 서브쿼리의 연산자

IN 리스트의 값과 동일
NOT IN 리스트의 값과 동일하지 않음
> ALL 리스트에서 가장 큰 값 보다 크다
> ANY 리스트에서 가장 작은 값 보다 크다
< ALL 리스트에서 가장 작은 값 보다 작다
< ANY 리스트에서 가장 큰 값 보다 작다 */

-- 073
-- 서브 쿼리 사용하기 ③ (NOT IN)

-- 관리자가 아닌 사원들의 이름과 월급과 직업을 출력해보자
SELECT ename, sal, job
  FROM emp
  WHERE empno NOT IN (SELECT mgr
                        FROM emp
                        WHERE mgr is not null);

SELECT ename, sal, job
  FROM emp
  WHERE empno NOT IN (SELECT mgr FROM emp); -- 서브쿼리절에 null이 있음
                                            -- NOT IN 으로 작성된 서브쿼리문은 NULL이 하나라도 리턴되면 결과가 출력 X 

SELECT mgr FROM emp; -- null이 포함됨

-- 074
-- 서브 쿼리 사용하기 ④ (EXISTS와 NOT EXISTS)

-- 부서 테이블에 있는 부서 번호 중에서 사원 테이블에도 존재하는 부서 번호의 부서번호, 부서명, 부서위치를 출력해보자
SELECT *
  FROM dept d                                  -- 1) 여기 존재하는 부서 번호가
  WHERE EXISTS (SELECT *
                  FROM emp e                   -- 2) 여기 테이블에도 존재하는지 검색하는 쿼리
                  WHERE e.deptno = d.deptno);  -- * 이 조건에 의해 검색하게 됨

-- EXISTS는 테이블 내에 검색하고자 하는 사항이 보이면 바로 다음 것을 검색함(존재하는지만 확인)

-- DEPT 테이블에는 존재하지만, EMP 테이블에는 존재하지 않는 데이터를 검색할 때는 NOT EXISTS 문을 사용
SELECT *
  FROM dept d
  WHERE NOT EXISTS (SELECT *
                      FROM emp e
                      WHERE e.deptno = d.deptno);

-- 075
-- 서브 쿼리 사용하기 ⑤ (HAVING절의 서브 쿼리)

-- 직업과 직업별 총 월급을 출력하는데, 직업이 SALESMAN인 사원들의 토탈 월급보다 더 큰 값들만 출력해보기
SELECT job, sum(sal)
  FROM emp
  GROUP BY job
  HAVING sum(sal) > (SELECT sum(sal)
                       FROM emp
                       WHERE job = 'SALESMAN');

-- 076
-- 서브 쿼리 사용하기 ⑥ (FROM절의 서브 쿼리)

-- 이름과 월급과 순위를 출력하는데, 순위가 1위인 사원만 출력
SELECT v.ename, v.sal, v.순위
  FROM (SELECT ename, sal, rank() over (order by sal desc) 순위
          FROM emp) v -- FROM절의 서브쿼리를 in line view라고 함
  WHERE v.순위 = 1;  

-- 077
-- 서브 쿼리 사용하기 ⑦ (SELECT절의 서브 쿼리)

-- 직업이 SALESMAN인 사원들의 이름과 월급을 출력하는데, 직업이 SALESMAN인 사원들의 최대 월급과 최소 월급도 함께 출력해보자
SELECT ename, sal, (select max(sal) from emp where job='SALESMAN') as 최대월급,
                   (select min(sal) from emp where job='SALESMAN') as 최소월급 -- 스칼라 서브 쿼리라고 함
  FROM emp
  WHERE job='SALESMAN';

-- 078
-- 데이터 입력하기(INSERT)

-- 사원 테이블에 데이블에 데이터를 입력한느데 사원번호 2812, 사원이름 JACK, 월급 3500, 입사일 2019년 6월 5일, 직업 ANALYST로 넣어보자
INSERT INTO emp(empno, ename, sal, hiredate, job) -- 컬럼명 순서대로 입력
  VALUES(2812, 'JACK', 3500, TO_DATE('2019/06/05', 'RRRR/MM/DD'), 'ANALYST');

-- 079
-- 데이터 수정하기(UPDATE)

UPDATE emp
  SET sal = 3200
  WHERE ename='SCOTT';

UPDATE emp
  SET sal = 3200, comm=200
  WHERE ename='SCOTT';

UPDATE emp
  SET sal = (SELECT sal FROM emp WHERE ename='KING') -- 서브쿼리 사용 가능
  WHERE ename='SCOTT';

-- 080
-- 데이터 삭제하기 (DELETE, TRUNCATE, DROP)

DELETE FROM emp
  WHERE ename='SCOTT';

-- 081
-- 데이터 저장 및 취소하기 (COMMIT, ROLLBACK)

INSERT INTO emp(empno, ename, sal, deptno)
 VALUES(1122,'JACK',3000, 20) ;

COMMIT; -- 이전에 수행했던 DML 작업들을 데이터 베이스에 영구히 반영하는 TCL

UPDATE emp
  SET sal = 4000
  WHERE ename='SCOTT';

SELECT *
  FROM emp
  WHERE ename='SCOTT';

ROLLBACK; -- COMMIT 명령어 수행한 이후 DML 문을 취소하는 TCL

SELECT *
  FROM emp
  WHERE ename='SCOTT';
 
DELETE FROM EMP
  WHERE ENAME='JACK';
 
 COMMIT;

SELECT *
  FROM EMP;

-- 082
-- 데이터 입력, 수정, 삭제 한번에 하기 (MERGE)

ALTER TABLE emp
   ADD loc varchar2(10);

MERGE INTO emp e
USING dept d
ON (e.deptno = d.deptno)
WHEN MATCHED THEN  --> MERGE UPDATE절
UPDATE set e.loc = d.loc 
WHEN NOT MATCHED THEN  --> MERGE INSERT절
INSERT (e.empno, e.deptno, e.loc) VALUES (1111, d.deptno, d.loc) ;

SELECT *
  FROM EMP;

ALTER TABLE emp
   DROP  COLUMN  loc;
   
DELETE FROM emp
  WHERE empno = 1111;

COMMIT;

SELECT *
  FROM EMP;

-- 083
-- 락(LOCK) 이해하기

-- 터미널로 진행하는 것 같아서 책을 읽었음
-- 오라클에서는 일관성을 위해 LOCK을 사용하여 UPDATE문을 수행하면 해당 행에 LOCK을 건다

-- 084
-- SELECT FOR UPDATE절 이해하기

-- SELECT FOR UPDATE : 검색하는 행에 락을 거는 SQL문

-- 085
-- 서브 쿼리를 사용하여 데이터 입력하기

CREATE TABLE emp2
    as
       SELECT *
          FROM emp
          WHERE 1=2; -- EMP의 구조만 가져오고 데이터는 없음

SELECT *
  FROM emp2;

INSERT INTO emp2(empno, ename, sal, deptno)
 SELECT empno, ename, sal, deptno -- values절에 values 대신 입력하고자 하는 서브 쿼리문을 기술
    FROM emp                      -- 서브쿼리를 사용하여 INSERT를 수행하면 여러개 행을 한 번에 입력 가능
    WHERE deptno = 10; 

SELECT *
  FROM emp2;

DROP  TABLE  emp2;