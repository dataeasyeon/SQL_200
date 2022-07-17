-- 030
-- 문자형으로 데이터 유형 변환하기 (TO_CHAR)

SELECT ename, TO_CHAR(hiredate, 'DAY') as 요일, TO_CHAR(sal, '999,999') as 월급
  FROM emp
  WHERE ename='SCOTT';

-- TO_CHAR(hiredate, 'DAY')는 입사일을 요일로 출력
-- TO_CHAR(sal, '999,999')는 월급을 출력할 때 천 단위를 표시하여 출력
-- TO_CHAR 함수는 1) 숫자형 → 문자형, 2) 날짜형 → 문자형으로 변환할때 사용

-- 날짜를 문자로 변환해서 출력하면 날짜에서 년, 월, 일, 요일 등을 추출해서 출력할 수 있음
SELECT hiredate, TO_CHAR(hiredate, 'RRRR') as 연도, TO_CHAR(hiredate, 'MM') as 달,
                 TO_CHAR(hiredate, 'DD') as 일, TO_CHAR(hiredate,'DAY') as 요일
  FROM emp
  WHERE ename='KING';
  
-- 1981년도에 입사한 사원의 이름과 입사일을 출력하는 쿼리
SELECT ename, hiredate
  FROM emp
  WHERE TO_CHAR(hiredate,'RRRR') = '1981';
  
-- 날짜 컬럼에서 연도/월/일/시간/분/초를 추출하기 위해 EXTRACT 함수를 사용해도 됨

SELECT ename as 이름, EXTRACT(year from hiredate) as 연도,
                     EXTRACT(month from hiredate) as 달,
                     EXTRACT(day from hiredate) as 요일
  FROM emp;

-- 월급을 출력할 때 천 단위를 표시해서 출력
SELECT ename as 이름, to_char(sal, '999,999') as 월급
  FROM emp;

-- 숫자 9는 자릿수이고, 이 자리에 0~9까지 어떤 수가 와도 된다는 뜻
-- 쉼표는 천 단위를 나타내는 표시

SELECT ename as 이름, TO_CHAR(sal*200, '999,999,999') as 월급
  FROM emp;
  
-- 알파벳 L을 사용하면 화폐단위를 붙여서 출력 가능
SELECT ename as 이름, TO_CHAR(sal*200, 'L999,999,999') as 월급
  FROM emp;

-- 031
-- 날짜형으로 데이터 유형 변환하기 (TO_CHAR)

SELECT ename, hiredate
  FROM emp
  WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

-- 날짜 데이터를 검색할 때는 접속한 세션의 날짜 형식을 확인해야 에러 없이 검색 가능
-- 현재 접속한 세션의 날짜 형식을 확인하는 쿼리

SELECT *
  FROM NLS_SESSION_PARAMETERS
  WHERE parameter = 'NLS_DATE_FORMAT'; -- RR/MM/DD
  
-- 만약 RR/MM/DD면
SELECT ename, hiredate
  FROM emp
  WHERE hiredate = '81/11/17';

-- 접속한 세션 날짜 형식을 DD/MM/RR로 변경해보자
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/RR';

-- DD/MM/RR이면 아래와 같이 검색
SELECT ename, hiredate
  FROM emp
  WHERE hiredate = '17/11/81';

-- 내가 접속한 세션마다 날짜 형식이 다를 수 있으므로 일관되게 날짜를 검색하기 위해
-- 아래와 같이 검색하면 세션의 날짜 형식과 관계없이 검색할 수 있다
SELECT ename, hiredate
  FROM emp
  WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

-- 다시 날짜 포맷을 RR/MM/DD 형식으로 변환
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-- 032
-- 암시적 형 변환 이해하기

SELECT ename, sal
  FROM emp
  WHERE sal = '3000'; -- 문자형으로 입력했지만 오라클이 숫자형으로 형 변환을 해준다

-- 예제를 위한 스크립트
DROP TABLE EMP32;

CREATE TABLE EMP32
( ENAME  VARCHAR2(10),
 SAL      VARCHAR2(10) );

INSERT INTO EMP32 VALUES('SCOTT','3000');
INSERT INTO EMP32 VALUES('SMITH','1200');
COMMIT; 

SELECT ename, sal
  FROM emp32
  WHERE sal = '3000';
  
SELECT ename, sal
  FROM emp32
  WHERE sal = 3000; -- 이 쿼리를
  
SELECT ename, sal
  FROM emp32
  WHERE TO_NUMBER(SAL) = 3000; -- 이렇게 내부적으로 실행해서 검색된다
  
-- 오라클이 내부적으로 실행하는 SQL을 확인하려면 다음과 같이 수행해야 함
SET AUTOT ON -- SQL을 실행할때 출력되는 결과와 SQL을 실행하는 실행 계획을 한번에 보여달라는 SQLPLUS 명령어
             -- 실행 계획이란, 오라클이 SQL을 실행할 때 어떠한 방법으로 데이터를 검색하겠다는 계획서

SELECT ename, sal
  FROM emp32
  WHERE SAL = 3000;

/*

PLAN_TABLE_OUTPUT                                                                                                                                                                                                                                                                                           
--------------------------------------
 
   1 - filter(TO_NUMBER("SAL")=3000)

이렇게 오라클이 암시적으로 문자형을 숫자형으로 형변환함을 알 수 있다

*/

-- 033
-- NULL 값 대신 다르데이터 출력하기 (NVL, NVL2)

-- 이름과 커미션을 출력하는데, 커미션이 NULL인 사원들은 0으로 출력해보자
SELECT ename, comm, NVL(comm,0)
  FROM emp;

-- 이름, 월급, 커미션, 월급 + 커미션을 출력하는 쿼리
SELECT ename, sal, comm, sal+comm
  FROM emp
  WHERE job IN ('SALESMAN','ANALYST');

-- 위 쿼리에 NVL을 적용하면
SELECT ename, sal, NVL(comm,0), sal+NVL(comm,0)
  FROM emp
  WHERE job IN ('SALESMAN','ANALYST');

-- NVL2를 적용하여 커미션이 NULL이 아닌 사원들은 sal+comm을 출력하고, NULL인 사람들은 sal을 출력하는 예제
SELECT ename, sal, comm, NVL2(comm, sal+comm, sal) -- NVL2(comm 기준으로, NULL X면 sal+comm, NULL O면 sal)
  FROM emp
  WHERE job IN ('SALESMAN','ANALYST');

SET AUTOT OFF

-- 034
-- IF문을 SQL로 구현하기 ① (DECODE)

SELECT ename, deptno, DECODE(deptno,10,300,20,400,0) as 보너스
  FROM emp;             -- 부서 번호가 10번이면 300 / 20번이면 400 / 10, 20번이 아니면 0으로 출력
  
/* IF DEPTNO = 10 THEN 300
ELSE IF DEPTNO = 20 THEN 400
ELSE 0 과 같다 */
  
SELECT empno, mod(empno,2), DECODE(mod(empno,2),0,'짝수',1,'홀수') as 보너스
  FROM emp; -- default값이 없음, default값은 생략 가능

/* IF mod(empno,2) = 0 THEN '짝수'
ELSE IF mod(empno,2) = 1 THEN '홀수'
ELSE 0 과 같다 */

SELECT ename, job, DECODE(job, 'SALESMAN', 5000, 2000) as 보너스
  FROM emp; -- job이 SALESMAN이면 5000을 출력하고, 그 외 직업은 2000을 출력
            -- IF JOB = 'SALESMAN' THEN 5000 ELSE 2000 과 같다

-- 034
-- IF문을 SQL로 구현하기 ② (CASE)

SELECT ename, job, sal, CASE WHEN sal >= 3000 THEN 500
                            WHEN sal >= 2000 THEN 300
                            WHEN sal >= 1000 THEN 200
                            ELSE 0 END AS BONUS
  FROM emp
  WHERE job IN ('SALESMAN','ANALYST');

--  CASE문과 DECODE의 다르점: DECODE는 = 등호만 비교 가능, CASE는 부등호와 등호 다 가능함

SELECT ename, job, comm, CASE WHEN comm is null THEN 500
                              ELSE 0 END BONUS -- 커미션이 NULL 이면 500 NULL 아니면 0 출력
  FROM emp
  WHERE job IN ('SALESMAN','ANALYST');

SELECT ename, job, CASE WHEN job in ('SALESMAN','ANALYST') THEN 500
                       WHEN job in ('CLERK', 'MANAGER') THEN 400
                  ELSE 0 END as 보너스
  FROM emp;                

-- 036
-- 최대값 출력하기 (MAX)

SELECT MAX(sal)
  FROM emp; -- 사원 테이블 중 최대 월급 출력
  
SELECT MAX(sal)
  FROM emp
  WHERE job = 'SALESMAN'; -- SALESMAN 중 월급이 제일 높은 사람
  
SELECT job, MAX(sal)
  FROM emp
  WHERE job = 'SALESMAN'; -- 위 쿼리에서 SELECT절에 job을 넣으면 오류가 남
                          -- 이유는 job은 다양한 컬럼을 출력하고 싶으나, MAX는 하나만 출력해야 하므로...
                          -- 그래서 GROUPBY 절이 필요(데이터를 GROUPING 해줌)
                          
SELECT job, MAX(sal)         -- 4
  FROM emp                   -- 실행순서 1
  WHERE job = 'SALESMAN'     -- 2
  GROUP BY job;              -- 3
  
SELECT deptno, MAX(sal)
  FROM emp
  GROUP BY deptno; -- 부서 번호별 최대 월급을 출력하는 쿼리
  
-- 037
-- 최소값 출력하기 (MIN)  

SELECT MIN(sal)
  FROM emp
  WHERE job = 'SALESMAN';

SELECT job, MIN(sal) 최소값 
  FROM emp
  GROUP BY job
  ORDER BY 최소값 DESC;

-- 그룹함수의 특징은 WHERE절이 거짓이라도 항상 결과를 출력한다
SELECT MIN(sal)
  FROM emp
  WHERE 1 = 2 ; -- 이 경우 NULL이 출력된다(내 컴에선 0으로 보이지만)

SELECT NVL(MIN(sal),0)
  FROM emp
  WHERE 1 = 2 ; -- NVL을 써보면 NULL이 출력됨을 알 수 있다
  
-- SALESMAN을 제외한 직업 중 직업별 최소 월급이 높은 것 부터 출력하라는 쿼리
SELECT job, MIN(sal)
  FROM emp
  WHERE job != 'SALESMAN'
  GROUP BY job
  ORDER BY MIN(sal) DESC;
  
-- 038
-- 평균값 출력하기 (AVG)

SELECT AVG(comm)
  FROM emp; -- 그룹함수는 NULL값을 무시함 / 이 결과는 4개의 comm으로 평균을 냄
  
SELECT ROUND(AVG(NVL(comm,0)))
  FROM emp; -- NULL인 comm을 0으로 채우고 다 더해서 14로 나눔

-- SUM의 경우는 다 더하는 것이므로 NVL 해서 0으로 채운후 SUM 하는것 보다 그냥 SUM 하는 것이 성능에 더 좋다

-- 039
-- 토탈값 출력하기 (SUM)

SELECT deptno, SUM(sal)
  FROM emp
  GROUP BY deptno;
  
-- 직업과 직업별 토탈 월급을 내림차순으로 출력
SELECT job, SUM(sal)
  FROM emp
  GROUP BY job
  ORDER BY SUM(sal) desc;
  
-- 직업과 직업별 토탈 월급을 구하되, 월급이 4000 이상인 것만 출력
SELECT job, SUM(sal)
  FROM emp
  WHERE sum(sal) >= 4000
  GROUP BY job; -- '그룹함수는 허가되지 않습니다' 라는 메세지가 뜬다...왜?
                -- WHERE절에 그룹함수를 사용해 조건을 주면 그룹함수는 허가되지 않는다!
                -- 그룹 함수에 조건을 줄떄는 WHERE절 대신 HAVING절을 사용해야 함

SELECT job, SUM(sal)
  FROM emp
  GROUP BY job
  HAVING sum(sal) >= 4000;

SELECT job, sum(sal)         -- 5
  FROM emp                   -- 실행순서 1
  WHERE job != 'SALESMAN'    -- 2
  GROUP BY job               -- 3
  HAVING sum(sal) >= 4000;   -- 4
  
-- 040
-- 건수 출력하기 (COUNT)

SELECT COUNT(empno)
  FROM emp;
  
SELECT COUNT(comm)
  FROM emp; -- COUNT는 null값을 카운트 하지 않는다
  
-- 041
-- 데이터 분석 함수로 순위 출력하기 ① (RANK)

-- RANK() : 순위를 출력하는 데이터 분석 함수
-- RANK() over (출력하고 싶은 데이터를 정렬하는 SQL 문장) 형식으로 사용

SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) 순위
  FROM emp
  WHERE job in ('ANALYST', 'MANAGER');
  
-- 직업별로 월급이 높은 순서대로 순위를 부여해서 각각 출력
SELECT ename, sal, job, RANK() over (PARTITION BY job -- 직업별로 순위를 부여하기전에 PARTITION BY 사용
                                     ORDER BY sal DESC) as 순위
  FROM emp; 
  
-- 042
-- 데이터 분석 함수로 순위 출력하기 ② (DENSE_RANK)

SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) as RANK,
                        DENSE_RANK() over (ORDER BY sal DESC) as DENSE_RANK
  FROM emp
  WHERE job in ('ANALYST','MANAGER'); -- RANK와 DENSE_RANK의 순위 산정 방식이 다름
  
SELECT job, ename, sal, DENSE_RANK() OVER (PARTITION BY job
                                           ORDER BY sal DESC) 순위
  FROM emp
  WHERE hiredate BETWEEN to_date('1981/01/01','RRRR/MM/DD/')
                     AND to_date('1981/12/31','RRRR/MM/DD/');

-- 월급이 2975인 사원은 사원 테이블에서 월급의 순위가 어떻게 되는지 출력하는 쿼리
SELECT DENSE_RANK(2975) within group (ORDER BY sal DESC) 순위
  FROM emp;

-- 입사일이 81년 11월 17월인 사원은 사원 테이블에서 몇 번째인가?
SELECT DENSE_RANK('81/11/17') within group (ORDER BY hiredate ASC) 순위
  FROM emp;

-- 043
-- 데이터 분석 함수로 등급 출력하기 (NTILE)

SELECT ename, job, sal,
       NTILE(4) over (order by sal desc nulls last) 등급 -- 월급을 4등급으로 나누자
  FROM emp
  WHERE job in ('ANALYST','MANAGER','CLERK');

-- 044
-- 데이터 분석 함수로 순위의 비율 출력하기 (CUME_DIST)

SELECT ename, sal, RANK() over (order by sal desc) as RANK,
                   DENSE_RANK() over (ORDER BY sal desc) as DENSE_RANK,
                   CUME_DIST() over (order by sal desc) as CUME_DIST
  FROM emp;                   

-- PARTITION BY를 이용해 직업별로 출력
SELECT ename, sal, RANK() over (partition by job
                                order by sal desc) as RANK,
                   CUME_DIST() over (partition by job
                                     order by sal desc) as CUME_DIST
  FROM emp;  

-- 045
-- 데이터 분석 함수로 데이터를 가로로 출력하기 (LISTAGG)

-- LISTAGG : 데이터를 가로로 출력하는 함수
-- LISTAGG(ename,',') : 구분자로 ,를 사용
SELECT deptno, LISTAGG(ename,',') within group (order by ename) as EMPLOYEE
  FROM emp
  GROUP BY deptno;

SELECT job, LISTAGG(ename,',') within group (order by ename asc) as EMPLOYEE
  FROM emp
  GROUP BY job;

-- 연결 연산자를 사용해서 월급까지 함께 출력하기
SELECT job, 
       LISTAGG(ename||'('||sal||')',',') within group (order by ename asc) as EMPLOYEE
  FROM emp
  GROUP BY job;

-- 046
-- 데이터 분석 함수로 바로 전 행과 다음 행 출력하기 (LAG, LEAD)

-- LAG : 바로 전 행의 데이터를 출력하는 함수 / 숫자 1을 사용하면 전 행, 2를 사용하면 전 전 행
-- LEAD : 바로 다음 행의 데이터를 출력하는 함수 / 숫자 1을 사용하면 다음 행, 2를 사용하면 다다음 행
SELECT empno, ename, sal,
       LAG(sal,1) over (order by sal asc) "전 행",
       LEAD(sal,1) over (order by sal asc) "다음 행"
  FROM emp
  WHERE job in ('ANALYST','MANAGER');

SELECT empno, ename, hiredate,
       LAG(hiredate,1) over (order by hiredate asc) "전 행",
       LEAD(hiredate,1) over (order by hiredate asc) "다음 행"
  FROM emp
  WHERE job in ('ANALYST','MANAGER');

-- 부서별로 나눠서 써보기
SELECT deptno, empno, ename, hiredate,
       LAG(hiredate,1) over (partition by deptno
                             order by hiredate asc) "전 행",
       LEAD(hiredate,1) over (partition by deptno
                              order by hiredate asc) "다음 행"
  FROM emp;  
  
-- 047
-- COLUMN을 ROW로 출력하기 ① (SUM+DECODE)

-- 부서별 총 월급을 가로로 출력
SELECT SUM(DECODE(deptno, 10, sal)) as "10",
       SUM(DECODE(deptno, 20, sal)) as "20",
       SUM(DECODE(deptno, 30, sal)) as "30"
  FROM emp;

-- 위 코드의 원리
SELECT deptno, DECODE(deptno, 10, sal) as "10"
  FROM emp;

SELECT SUM(DECODE(deptno, 10, sal)) as "10"
  FROM emp;

SELECT SUM(DECODE(deptno, 10, sal)) as "10",
       SUM(DECODE(deptno, 20, sal)) as "20",
       SUM(DECODE(deptno, 30, sal)) as "30"
  FROM emp;

-- 직업, 직업별 총 월급을 출력
SELECT SUM(DECODE(job, 'ANALYST', sal)) as "ANALYST",
       SUM(DECODE(job, 'CLERK', sal)) as "CLERK",
       SUM(DECODE(job, 'MANAGER', sal)) as "MANAGER",
       SUM(DECODE(job, 'SALESMAN', sal)) as "SALESMAN"
  FROM emp;

-- 부서 번호별 각각 직업의 총 월급을 출력
SELECT deptno, SUM(DECODE(job, 'ANALYST', sal)) as "ANALYST",
               SUM(DECODE(job, 'CLERK', sal)) as "CLERK",
               SUM(DECODE(job, 'MANAGER', sal)) as "MANAGER",
               SUM(DECODE(job, 'SALESMAN', sal)) as "SALESMAN"
  FROM emp
  GROUP BY deptno;
  
-- 048
-- COLUMN을 ROW로 출력하기 ② (PIVOT)

-- 부서 번호, 부서 번호별 토탈 월급 출력
SELECT *
  FROM (select deptno, sal from emp) -- 1) 필요한 데이터는 부서번호와 월급뿐이므로 이렇게 조회하고
  PIVOT (sum(sal) for deptno in (10,20,30)); -- 2) 부서번호 10, 20, 30에 대해 출력
  
SELECT *
  FROM (select job, sal from emp)
  PIVOT (sum(sal) for job in ('ANALYST' as "ANALYST", 'CLERK' as "CLERK", 'MANAGER' as "MANAGER", 'SALESMAN' as "SALESMAN"));
  
-- 049
-- ROW을 COLUMN으로 출력하기 (UNPIVOT)

-- 실습을 위한 테이블 생성
drop  table order2;

create table order2
( ename  varchar2(10),
  bicycle  number(10),
  camera   number(10),
  notebook  number(10) );

insert  into  order2  values('SMITH', 2,3,1);
insert  into  order2  values('ALLEN',1,2,3 );
insert  into  order2  values('KING',3,2,2 );

commit;

SELECT *
FROM order2;

SELECT *
  FROM order2
  UNPIVOT (건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));

SELECT *
  FROM order2
  UNPIVOT (건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

UPDATE ORDER2 SET NOTEBOOK=NULL WHERE ENAME='SMITH'; -- NULL 데이터를 집어넣고

SELECT *
  FROM order2
  UNPIVOT (건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N')); -- 실행하면 SMITH의 NOTEBOOK은 출력 안됨
 
-- NULL을 포함시키려면
SELECT *
  FROM order2
  UNPIVOT INCLUDE NULLS (건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N')); -- 포함 완

-- 050
-- 데이터 분석 함수로 누적 데이터 출력하기 (SUM OVER)

SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY empno ROWS
                                         BETWEEN UNBOUNDED PRECEDING
                                         AND CURRENT ROW) 누적치
  FROM emp
  WHERE job in ('ANALYST','MANAGER');

/* UNBOUNDED PRECEDING 맨 첫 번째 행
UNBOUNDED FOLLOWING 맨 마지막 행
CURRENT ROW 현재 행 */

-- 051
-- 데이터 분석 함수로 비율 출력하기 (RATIO_TO_REPORT)

SELECT empno, ename, sal, RATIO_TO_REPORT(sal) OVER () AS 비율
  FROM emp
  WHERE deptno = 20;

SELECT empno, ename, sal, RATIO_TO_REPORT(sal) OVER () AS 비율,
                          SAL/SUM(sal) OVER () as "비교 비율"
  FROM emp
  WHERE deptno = 20;

-- 052
-- 데이터 분석 함수로 집계 결과 출력하기 ① (ROLLUP)

SELECT job, sum(sal)
  FROM emp
  GROUP BY ROLLUP(job); -- 맨 아래에 전체 월급을 추가적으로 출력하는 쿼리
  
SELECT deptno, job, sum(sal)
  FROM emp
  GROUP BY ROLLUP(deptno, job); -- 부서별 총 월급, 전체 총 월급이 출력

-- 053
-- 데이터 분석 함수로 집계 결과 출력하기 ② (CUBE)

SELECT job, sum(sal)
  FROM emp
  GROUP BY CUBE(job); -- 첫번째 행에 총 월급 출력

SELECT deptno, job, sum(sal)
  FROM emp
  GROUP BY CUBE(deptno, job);

-- 054
-- 데이터 분석 함수로 집계 결과 출력하기 ③ (GROUPING SETS)

SELECT deptno, job, sum(sal)
  FROM emp
  GROUP BY GROUPING SETS((deptno), (job), ()); -- 집계하고 싶은 컬럼명을 기술하면 기술한대로 나옴

SELECT deptno, job, sum(sal)
  FROM emp
  GROUP BY GROUPING SETS((deptno), (job));

-- 055
-- 데이터 분석 함수로 출력 결과 넘버링 하기 (ROW_NUMBER)

SELECT empno, ename, sal, RANK() over (ORDER BY sal DESC) as RANK,
                          DENSE_RANK() over (ORDER BY sal DESC) as DENSE_RANK,
                          ROW_NUMBER() over (ORDER BY sal DESC) 번호 -- 출력되는 각 행에 고유한 숫자값을 부여하는 데이터 분석 함수
  FROM emp
  WHERE deptno = 20;

SELECT empno, ename, sal, ROW_NUMBER() over () 번호 -- over 다음 괄호 안에 ORDER BY절을 기술해줘야 한다
  FROM emp
  WHERE deptno = 20; -- 오류

SELECT deptno, ename, sal, ROW_NUMBER() over (PARTITION BY deptno -- PARTITION BY를 통해 부서 번호별로 파티션 해 순위를 부여
                                              ORDER BY sal DESC) 번호
  FROM emp
  WHERE deptno in (10,20);

-- PART 3 중급
-- 056
-- 출력되는 행 제한하기 ① (ROWNUM)

SELECT ROWNUM, empno, ename, job, sal
  FROM emp
  WHERE ROWNUM <= 5; -- 파이썬의 head 같은 기능

-- 057
-- 출력되는 행 제한하기 ② (Simple TOP-n Queries)
-- 내 컴퓨터에서는 실행이 안됨(12c 버전부터 가능)

SELECT empno, ename, job, sal
  FROM emp
  ORDER BY sal DESC FETCH FIRST 4 ROWS ONLY; -- 월급이 높은 사원순으로 4개의 행 출력

SELECT empno, ename, job, sal
  FROM emp
  ORDER BY sal desc
  FETCH FIRST 20 PERCENT ROWS ONLY; -- 월급이 높은 사원 중 20%에 해당하는 사원 출력

SELECT empno, ename, job, sal
  FROM emp
  ORDER BY sal DESC FETCH FIRST 2 ROWS WITH TIES;
-- WITH TIES 옵션을 이용하면 여러 행이 N번째 행과 값이 동일하다면 같이 출력해준다
-- 2개를 출력해달라고 했지만 3개의 행이 출력됨

SELECT empno, ename, job, sal
  FROM emp
  ORDER BY sal DESC OFFSET 9 ROWS;
-- OFFSET 옵션을 이용하면 출력이 시작되는 행의 위치를 지정 가능
-- 결과를 보면 첫 행이 10번째(9+1)로 높은 사원 / 여기부터 끝까지 결과를 출력함

SELECT empno, ename, job, sal
  FROM emp
  ORDER BY sal DESC OFFSET 9 ROWS
  FETCH FIRST 2 ROWS ONLY;
-- OFFSET과 FETCH를 조합해서 사용 가능
-- OFFSET 9로 출력된 5개 행 중 2개의 행을 출력

-- 058
-- 여러 테이블의 데이터를 조인해서 출력하기 ① (EQUI JOIN)

-- 사원 테이블과 부서 테이블을 조인하여 이름과 부서위치를 출력
SELECT ename, loc
  FROM emp, dept
  WHERE emp.deptno = dept.deptno; -- emp 테이블의 부서번호 = dept 테이블의 부서번호

SELECT ename, loc
  FROM emp, dept; -- 조인조건 없이 기술하면 그냥 14X4한 사람이 됨

-- 조인 조건이 이퀄(=)이면 EQUI JOIN이라고 함

SELECT ename, loc, job
  FROM emp, dept
  WHERE emp.deptno = dept.deptno and emp.job='ANALYST'; -- 조인 조건 and 검색 조건을 and 연산자로 연결하여 작성

SELECT ename, loc, job, deptno
  FROM emp, dept
  WHERE emp.deptno = dept.deptno and emp.job='ANALYST'; -- deptno의 정의가 애매하다는 에러
                                                        -- 이유는 emp, dept에 다 deptno가 있어서

SELECT ename, loc, job, emp.deptno -- 이렇게 테이블 이름을 앞에 써주면 됨
  FROM emp, dept
  WHERE emp.deptno = dept.deptno and emp.job='ANALYST';

-- 검색속도 향상을 위해 열 이름앞에 테이블 이름을 붙여주자
SELECT emp.ename, dept.loc, emp.job
  FROM emp, dept
  WHERE emp.deptno = dept.deptno and emp.job='ANALYST';

-- 일일이 써주면 코드가 길어지니까 테이블 별칭을 이용해 조인 코드를 더 간결하게 작성
SELECT e.ename, d.loc, e.job
  FROM emp e, dept d
  WHERE e.deptno = d.deptno and e.job='ANALYST';

-- 059
-- 여러 테이블의 데이터를 조인해서 출력하기 ② (NON EQUI JOIN)

SELECT e.ename, e.sal, s.grade
  FROM emp e, salgrade s
  WHERE e.sal between s.losal and s.hisal; -- 조인 조건에 =을 줄 수가 없다. 왜냐면 sal이 범위 안에 들어가는걸 비교해야하니...
                                           -- 그래서 조인조건에 equi조건을 줄 수 없을때 사용하는 조인을 non equi join이라고 함

SELECT * FROM salgrade;

-- 060
-- 여러 테이블의 데이터를 조인해서 출력하기 ③ (OUTER JOIN)

SELECT e.ename, d.loc
  FROM emp e, dept d
  WHERE e.deptno (+) = d.deptno;

-- 061
-- 여러 테이블의 데이터를 조인해서 출력하기 ④ (SELF JOIN)

SELECT e.ename as 사원, e.job as 직업, m.ename as 관리자, m.job as 직업
  FROM emp e, emp m
  WHERE e.mgr = m. empno and e.job='SALESMAN';

-- 062
-- 여러 테이블의 데이터를 조인해서 출력하기 ⑤ (ON절)

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e JOIN dept d
  ON (e.deptno = d.deptno) -- 조인 조건을 ON절에 작성
  WHERE e.job='SALESMAN'; -- 검색 조건은 WHERE절에 작성

/* 오라클 조인 : EQUI, NON EQUI, OUTER, SELF JOIN
ANSI 표준 조인 : ON, LEFT/RIGHT/FULL OUTER JOIN, USING, NATURAL, CROSS JOIN */

-- 063
-- 여러 테이블의 데이터를 조인해서 출력하기 ⑥ (USING절)

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e join dept d
  USING (deptno) -- 반드시 괄호를 사용해야함
  WHERE e.job='SALESMAN';

-- 064
-- 여러 테이블의 데이터를 조인해서 출력하기 ⑦ (NATURAL JOIN)

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e natural join dept d -- 두 테이블에서 동일한 컬럼 deptno을 찾아서 수행한다
  WHERE e.job='SALESMAN';

-- 065
-- 여러 테이블의 데이터를 조인해서 출력하기 ⑧ (LEFT/RIGHT OUTER JOIN)

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e RIGHT OUTER JOIN dept d
  ON (e.deptno = d.deptno);

-- 예제를 위한 데이터 추가
INSERT INTO emp(empno, ename, sal, job, deptno)
       VALUES(8282, 'JACK', 3000, 'ANALYST', 50) ;

COMMIT;

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e LEFT OUTER JOIN dept d
  ON (e.deptno = d.deptno);

-- 066
-- 여러 테이블의 데이터를 조인해서 출력하기 ⑨ (FULL OUTER JOIN)

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e FULL OUTER JOIN dept d
  ON (e.deptno = d.deptno);

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e LEFT OUTER JOIN dept d
  ON (e.deptno = d.deptno)
UNION
SELECT e.ename , e.job ,  e.sal  , d.loc
  FROM emp e RIGHT OUTER JOIN dept d
  ON (e.deptno = d.deptno);

-- 067
-- 집합 연산자로 데이터를 위아래로 연결하기 ① (UNION ALL)

-- 예제를 위해 데이터 삭제
delete  from  emp
 where ename='JACK';

commit;

SELECT deptno, sum(sal)
  FROM emp
  GROUP BY deptno
UNION ALL
SELECT TO_NUMBER(null) as deptno, sum(sal)
  FROM emp;

-- 068
-- 집합 연산자로 데이터를 위아래로 연결하기 ② (UNION)

SELECT deptno, sum(sal)
  FROM emp
  GROUP BY deptno
UNION 
SELECT null as deptno, sum(sal)
  FROM emp;

-- 069
-- 집합 연산자로 데이터의 교집합을 출력하기 ② (INTERSECT)

SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (10,20)
INTERSECT
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (20,30);
