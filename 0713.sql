-- 011
-- 비교 연산자 배우기 ② (BETWEEN AND)

SELECT ename, sal
  FROM emp
  WHERE sal BETWEEN 1000 AND 3000; -- 'BETWEEN 하한값 AND 상한값'으로 작성 해야 함

SELECT ename, sal
  FROM emp
  WHERE (sal >= 1000 AND sal <= 3000); -- 위와 같다

SELECT ename, sal
  FROM emp
  WHERE sal NOT BETWEEN 1000 AND 3000; -- 월급이 1000에서 3000 사이가 아닌 사원들의 이름, 월급을 조회

SELECT ename, sal
  FROM emp
  WHERE (sal < 1000 OR sal > 3000); -- 위와 같다 / 이퀄(=)이 붙지 않는다
  
SELECT ename, hiredate
  FROM emp
  WHERE hiredate BETWEEN '1982/01/01' AND '1982/12/31'; -- 1982년에 입사한 사원의 이름과 입사일을 조회하는 쿼리

-- 012
-- 비교 연산자 배우기 ③ (LIKE)

SELECT ename, sal
  FROM emp
  WHERE ename LIKE 'S%'; 

/* %는 와일드 카드라고 함
와일드 카드 %는 이 자리에 어떠한 철자가 와도 상관없고 철자의 개수가 몇 개가 되든 관계 없다는 뜻
(0개 이상의 임의 문자와 일치) */

SELECT ename
  FROM emp
  WHERE ename LIKE '_M%'; -- 두 번째 철자가 M인 사원의 이름을 찾아라 

/* _도 와일드 카드
와일드 카드 _는 어떠한 철자가 와도 관계 없으나 자리수는 한 자리여야 한다는 뜻 */

SELECT ename
  FROM emp
  WHERE ename LIKE '%T'; -- 이름 끝자리가 T인 사원을 출력하라
  
SELECT ename
  FROM emp
  WHERE ename LIKE '%A%'; -- 와일드 카드를 양쪽으로 기술하게 되면 이름에 A가 포함된 사원 전부를 검색함

-- 013
-- 비교 연산자 배우기 ④ (IS NULL)

SELECT ename, comm
  FROM emp
  WHERE comm is null; -- 커미션이 NULL인 사원들의 이름과 커미션을 출력하는 쿼리

-- NULL : 데이터가 할당되지 않은 상태, 알 수 없는 값 → 그러므로 이퀄 연산자(=)로 비교할 수 없음, IS NULL 연산자 사용

-- 014
-- 비교 연산자 배우기 ⑤ (IN)

SELECT ename, sal, job
  FROM emp
  WHERE job in ('SALESMAN', 'ANALYST', 'MANAGER');
-- 직업이 'SALESMAN', 'ANALYST', 'MANAGER'인 사원들의 이름, 월급, 직업을 출력
-- IN 연산자는 여러 리스트의 값을 조회할 수 있음

SELECT ename, sal, job
  FROM emp
  WHERE (job = 'SALESMAN' or job = 'ANALYST' or job = 'MANAGER'); -- 위와 같은 결과
  
SELECT ename, sal, job
  FROM emp
  WHERE job NOT in ('SALESMAN', 'ANALYST', 'MANAGER');
-- 직업이 'SALESMAN', 'ANALYST', 'MANAGER'가 아닌 사원들의 이름, 월급, 직업을 출력

SELECT ename, sal, job
  FROM emp
  WHERE (job != 'SALESMAN' and job != 'ANALYST' and job != 'MANAGER'); -- 위와 같은 결과

-- 015
-- 논리 연산자 배우기 (AND, OR, NOT)

SELECT ename, sal, job
  FROM emp
  WHERE job='SALESMAN' AND sal >= 1200;
  
SELECT ename, sal, job
  FROM emp
  WHERE job='ABCDEF' AND sal >= 1200; -- 둘 중 하나라도 조건이 FALSE면 데이터가 반환되지 않는다.
  
/* 

TRUE AND TRUE → TRUE
TRUE AND FALSE → FALSE

AND는 둘 다 TRUE여야 TRUE가 반환
OR는 둘 중 하나만 TRUE여도 TRUE를 반환

TRUE AND NULL → NULL : NULL은 알 수 없는 값이기에 T인지 F인지 알 수 없음

*/

-- PART 2 초급
-- 016
-- 대소문자 변환 함수 배우기 (UPPER, LOWER, INITCAP)

SELECT UPPER(ename), LOWER(ename), INITCAP(ename) -- 대문자 / 소문자 / 첫 번째 철자만 대문자, 나머지 소문자 출력하는 함수
  FROM emp;

SELECT ename, sal
  FROM emp
  WHERE LOWER(ename) = 'scott';

-- 017
-- 문자에서 특정 철자 추출하기 (SUBSTR)

SELECT SUBSTR('SMITH',1,3) -- 1 : 추출할 철자의 시작 위치 번호, 3 : 시작 위치로부터 몇 개의 철자를 추출할지 정하는 숫자
  FROM DUAL;

SELECT SUBSTR('SMITH',2,2)
  FROM DUAL;

SELECT SUBSTR('SMITH',-2,2) -- -2는 뒤에서 두 번째니까 T고, 2개 뽑을거니 TH
  FROM DUAL;

SELECT SUBSTR('SMITH',2) -- 두 번째 M부터 끝까지 추출하는
  FROM DUAL;

-- 018
-- 문자열의 길이를 출력하기 (LENGTH)

SELECT ename, LENGTH(ename)
  FROM emp;
  
SELECT LENGTH('가나다라마')
  FROM dual;

SELECT LENGTHB('가나다라마') -- LENGHTB : 바이트의 길이를 반환, 한글은 한 글자에 3byte이므로 15를 반환
  FROM dual; 

-- 019
-- 문자에서 특정 철자의 위치 출력하기 (INSTR)

SELECT INSTR('SMITH','M') -- SMITH에서 M은 두 번째니까 2를 출력
  FROM DUAL;

-- INSTR, SUBSTR을 통해 이메일 주소에서 naver.com 추출해보기
SELECT INSTR('abcdefg@naver.com','@')
  FROM DUAL;

SELECT SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com','@')+1) -- SUBSTR('메일주소', 8+1)이 되니 9번째인 n부터 끝까지 출력
  FROM DUAL;

-- naver만 추출해보기
SELECT RTRIM(SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com','@')+1), '.com') -- 예제 22에서 RTRIM 배움
  FROM DUAL;

-- 020
-- 특정 철자를 다른 철자로 변경하기 (REPLACE)

SELECT ename, REPLACE(sal, 0 , '*') -- sal의 0을 *로 바꿔서 출력
  FROM emp;

-- REGEXP_REPLACE 함수는 정규식 함수
SELECT ename, REGEXP_REPLACE(sal, '[0-3]', '*') as SALARY -- sal의 0부터 3까지를 *로 바꿔서 출력
  FROM emp; 

-- 예제를 위해 테이블 생성
CREATE TABLE TEST_ENAME
(ENAME   VARCHAR2(10));

INSERT INTO TEST_ENAME VALUES('김인호');
INSERT INTO TEST_ENAME VALUES('안상수');
INSERT INTO TEST_ENAME VALUES('최영희');
COMMIT;

SELECT REPLACE(ENAME, SUBSTR(ENAME,2,1), '*') as "전광판_이름"
  from test_ename;

-- 021
-- 특정 철자를 N개 만큼 채우기 (LPAD, RPAD)

SELECT ename, LPAD(sal,10,'*') as salary1, RPAD(sal,10,'*') as salary2
  FROM emp; -- LPAD : 왼쪽(L)에 *을 채워서(PAD) 출력 / RPAD : 오른쪽에 *를 채워서 출력

-- 월급 100을 네모(■) 하나로 출력하는 예제
SELECT ename, sal, lpad('■', round(sal/100), '■') as bar_chart
  FROM emp; --     ex) round(sal/100)이 16이라면 전체 16자리 확보 -> 16자리 중 한 자리에 ■를 출력하고, 나머지 15자리에 ■를 채워 총 16개 출력

-- 022
-- 특정 철자 잘라내기 (TRIM, LTRIM, RTRIM)

SELECT 'smith', LTRIM('smith','s'), RTRIM('smith','h'), TRIM('s' from 'smiths')
  FROM dual;

-- LTRIM('smith','s') : 왼쪽 's'를 잘라서 출력
-- RTRIM('smith','h') : 오른쪽 'h'를 잘라서 출력
-- TRIM('s' from 'smiths') : 양쪽 's'를 잘라서 출력

-- emp 테이블에 사원데이터 추가
insert into emp(empno,ename,sal,job,deptno) values(8291, 'JACK  ', 3000, 'SALESMAN', 30);
commit;

SELECT ename, sal
  FROM emp
  WHERE ename='JACK'; -- 레코드가 없다. 위에 INSERT한 data는 JACK 뒤에 ' '공백이 있어서 출력이 안됨
  
SELECT ename, sal
  FROM emp
  WHERE RTRIM(ename) = 'JACK'; -- 이러면 오른쪽 공백을 삭제하고 검색하는 것이므로 데이터가 출력됨

-- 다음 실습을 위해 INSERT한 데이터를 삭제
DELETE FROM EMP WHERE TRIM(ENAME)='JACK';
COMMIT;

-- 023
-- 반올림해서 출력하기 (ROUND)

SELECT '876.567' as 숫자, ROUND(876.567, 1), ROUND(876.567, 2)
  FROM dual; -- 양수일때는 나타내고자 하는 소수점 단위라고 생각하면 됨 / 반올림 해서 소수 첫째자리 / 소수 둘째자리

SELECT '876.567' as 숫자, ROUND(876.567, -1), ROUND(876.567, -2)
  FROM dual; -- 음수 -1이니까 일의 자리, -2니까 십의 자리에서 반올림해서 나타내라

SELECT '876.567' as 숫자, ROUND(876.567), ROUND(876.567, 0)
  FROM dual; -- 0은 소수점 자리이므로 소수점 이후 첫 번째 자리에서 반올림
