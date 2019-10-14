SELECT nr_bandy AS "Nr bandy", plec as "Plec",
       MIN(przydzial_myszy) AS "Minimalny przydzial"
  FROM kocury
 GROUP BY plec, nr_bandy;
