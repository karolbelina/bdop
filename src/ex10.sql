SELECT CASE
       WHEN COUNT(*) = 1 THEN pseudo || ' - unikalny'
       ELSE pseudo || ' - nieunikalny'
       END AS "Unikalnosc atr. PSEUDO"
  FROM kocury
 GROUP BY pseudo;

SELECT CASE
       WHEN COUNT(*) = 1 THEN szef || ' - unikalny'
       ELSE szef || ' - nieunikalny'
       END AS "Unikalnosc atr. SZEF"
  FROM kocury
 WHERE szef IS NOT NULL -- szef is nullable
 GROUP BY szef;
