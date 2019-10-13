SELECT pseudo AS "PSEUDO", w_stadku_od AS "W STADKU",
       CASE
         WHEN EXTRACT(DAY FROM w_stadku_od) <= 15
         -- check if we're getting another wednesday this month
         /* we do if (x + 4) mod 7 < d, where x is a weekday of the last day
            of the month (values between 1 and 7), and d is the absolute difference
            in days between the target day and the last day of the month */
         -- the last day of the month can be obtained through the LAST_DAY function */
         -- to get the weekday of some day x, type TO_CHAR(x, 'DAY', 'NLS_DATE_LANGUAGE=''numeric date language''') */
         AND MOD(TO_CHAR(LAST_DAY(SYSDATE), 'DAY', 'NLS_DATE_LANGUAGE=''numeric date language''') + 4, 7) < LAST_DAY(SYSDATE) - SYSDATE THEN
         /* the function for the last wednesday of the current month is 
            x - (x + 4) mod 7, where x is the last day of the month */
         LAST_DAY(SYSDATE) - MOD(TO_CHAR(LAST_DAY(SYSDATE), 'DAY', 'NLS_DATE_LANGUAGE=''numeric date language''') + 4, 7)
       ELSE
         /* to get the last wednesday of the next month just pass the
            LAST_DAY of the LAST_DAY + 1 to the function mentioned above */
         LAST_DAY(LAST_DAY(SYSDATE) + 1) - MOD(TO_CHAR(LAST_DAY(LAST_DAY(SYSDATE) + 1), 'DAY', 'NLS_DATE_LANGUAGE=''numeric date language''') + 4, 7)
       END "WYPLATA"
  FROM kocury;
