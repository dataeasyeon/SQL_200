-- 024
-- 숫자를 버리고 출력하기 (TRUNC)

-- 숫자를 출력하는데, 소수점 두 번째 자리인 6 이후의 숫자를 모두 버리고 출력해보자
SELECT '876.567' as 숫자, TRUNC(876.567,1), TRUNC(876.567,2), TRUNC(876.567,-1), TRUNC(876.567,-2), TRUNC(876.567,0), TRUNC(876.567)
  FROM dual;
  
-- 025
-- 나눈 나머지 값 출력하기 (MOD)

SELECT MOD(10,3)
  FROM DUAL;

SELECT empno, MOD(empno,2)
  FROM emp;

SELECT empno, ename
  FROM emp
  WHERE MOD(empno,2)=0; -- 사원번호가 짝수인 사원들의 사번과 이름을 출력
  
SELECT FLOOR(10/3)
  FROM DUAL; -- FLOOR : 3.3333을 3과 4사이에서 제일 바닥에 해당하는 값인 3을 출력

-- 026
-- 날짜 간 개월 수 출력하기 (MONTHS_BETWEEN)

SELECT ename, MONTHS_BETWEEN(sysdate, hiredate) -- MONTHS_BETWEEN(최신 날, 예전 날짜)로 입력
  FROM emp;

-- MONTHS_BETWEEN을 사용하지 않는다면 아래와 같이 작성
SELECT TO_DATE('2022-07-15','RRRR-MM-DD') - TO_DATE('2018-10-01','RRRR-MM-DD')
  FROM dual;

SELECT ROUND((TO_DATE('2019-06-01','RRRR-MM-DD') - TO_DATE('2018-10-01','RRRR-MM-DD')) /7) AS "총 주수"
  FROM dual;

-- 027
-- 개월 수 더한 날짜 출력하기 (ADD_MONTHS)

-- 2019년 5월 1일부터 100일 후에 돌아오는 날짜를 출력하는 쿼리문
SELECT TO_DATE('2019-05-01','RRRR-MM-DD') + 100
  FROM DUAL;

-- 2019년 5월 1일로부터 100달 뒤의 날짜는 어떻게 될까?
SELECT ADD_MONTHS(TO_DATE('2019-05-01', 'RRRR-MM-DD'), 100)
  FROM DUAL;

-- 이렇게도 가능함(interval 사용)
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '100' month
  FROM DUAL;

-- interval을 사용해 1년 3개월 후 날짜를 출력하는 쿼리
SELECT TO_DATE('2019-05-01','RRRR-MM-DD') + interval '1-3' year(1) to month
  FROM DUAL;

-- interval 사용 시 연도가 한 자리인 경우는 YEAR사용, 연도가 3자리인 경우는 YEAR(3)을 사용
SELECT TO_DATE('2019-05-01','RRRR-MM-DD') + interval '3' year
  FROM DUAL;

SELECT TO_DATE('2019-05-01','RRRR-MM-DD') + interval '12' year(2)
  FROM DUAL;

-- TO_YMINTERVAL 함수를 이용하면 2019년 5월 1일부터 3년 5개월 후의 날짜를 출력할 수 있음
SELECT TO_DATE('2019-05-01','RRRR-MM-DD') + TO_YMINTERVAL('03-05') as 날짜
  FROM dual;

-- 028
-- 특정 날짜 뒤에 오는 요일 날짜 출력하기 (NEXT_DAY)

SELECT '2019/05/22' as 날짜, NEXT_DAY('2019/05/22','월요일')
  FROM dual;
  
-- 오늘 날짜를 출력하는 쿼리
SELECT SYSDATE as 오늘날짜
  FROM DUAL; 

-- 오늘을 기준으로 앞으로 돌아올 화요일의 날짜를 출력
SELECT NEXT_DAY(SYSDATE, '화요일') as "다음 날짜"
  FROM DUAL;
  
-- 2019년 5월 22일 기준으로 100달 뒤에 돌아오는 화요일의 날짜를 출력
SELECT NEXT_DAY(ADD_MONTHS('2019/05/22',100),'화요일') as "다음 날짜"
  FROM DUAL;
  
-- 오늘 기준 100달 뒤에 돌아오는 월요일의 날짜를 출력하는 쿼리
SELECT NEXT_DAY(ADD_MONTHS(sysdate, 100), '월요일') as "다음 날짜"
  FROM DUAL;

-- 029
-- 특정 날짜가 있는 달의 마지막 날짜 출력하기 (LAST_DAY)

SELECT '2019/05/22' as 날짜, LAST_DAY('2019/05/22') as "마지막 날짜"
  FROM DUAL;

-- 오늘부터 이번 달 말일까지 총 며칠 남았는지 출력하는 쿼리
SELECT LAST_DAY(SYSDATE) - SYSDATE as "남은 날짜"
  FROM DUAL;

-- 이름이 KING인 사원의 이름, 입사일, 입사한 달의 마지막 날짜를 출력하는 쿼리
SELECT ename, hiredate, LAST_DAY(hiredate)
  FROM emp
  WHERE ename='KING';