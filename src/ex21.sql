SELECT bandy.nazwa AS "Nazwa bandy", COUNT(DISTINCT pseudo) AS "Koty z wrogami"
  FROM kocury
       JOIN bandy
       USING (nr_bandy)
       JOIN wrogowie_kocurow
       USING (pseudo)
 GROUP BY bandy.nazwa;
