SELECT pseudo AS "PSEUDO",
       w_stadku_od AS "W STADKU",
       -- NEXT_DAY(LAST_DAY(x) - 7, 3) gets you the last wednesday of the month from the date x
       NEXT_DAY(LAST_DAY(
           CASE
           WHEN EXTRACT(DAY FROM w_stadku_od) <= 15
           -- check if we're getting another wednesday this month
           AND NEXT_DAY(LAST_DAY(SYSDATE) - 7, 3) >= SYSDATE
           THEN SYSDATE
           ELSE ADD_MONTHS(SYSDATE, 1)
           END
       ) - 7, 3) AS "WYPLATA"
  FROM kocury;
