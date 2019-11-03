SELECT pseudo AS "Pseudonim", plec AS "Plec",
       NVL(przydzial_myszy, 0) AS "Myszy przed podw.", NVL(myszy_extra, 0) AS "Extra przed podw."
  FROM kocury
 WHERE pseudo IN (SELECT pseudo
                    FROM (SELECT pseudo
                            FROM kocury k
                                 JOIN bandy
                                 USING (nr_bandy)
                           WHERE nazwa = 'LACIACI MYSLIWI'
                           ORDER BY w_stadku_od)
                   WHERE ROWNUM <= 3
                   UNION
                  SELECT pseudo
                    FROM (SELECT pseudo
                            FROM kocury k
                                 JOIN bandy
                                 USING (nr_bandy)
                           WHERE nazwa = 'CZARNI RYCERZE'
                           ORDER BY w_stadku_od)
                   WHERE ROWNUM <= 3);

UPDATE kocury k1
   SET przydzial_myszy = CASE plec
                         WHEN 'M' THEN NVL(przydzial_myszy, 0) + 10
                         ELSE NVL(przydzial_myszy, 0) + (SELECT MIN(NVL(przydzial_myszy, 0))
                                                           FROM kocury) * 0.1
                         END,
       myszy_extra = NVL(myszy_extra, 0) + (SELECT AVG(NVL(myszy_extra, 0))
                                              FROM kocury k2
                                             WHERE k1.nr_bandy = k2.nr_bandy) * 0.15
 WHERE pseudo IN (SELECT pseudo
                    FROM (SELECT pseudo
                            FROM kocury k
                                 JOIN bandy
                                 USING (nr_bandy)
                           WHERE nazwa = 'LACIACI MYSLIWI'
                           ORDER BY w_stadku_od)
                   WHERE ROWNUM <= 3
                   UNION
                  SELECT pseudo
                    FROM (SELECT pseudo
                            FROM kocury k
                                 JOIN bandy
                                 USING (nr_bandy)
                           WHERE nazwa = 'CZARNI RYCERZE'
                           ORDER BY w_stadku_od)
                   WHERE ROWNUM <= 3);

SELECT pseudo AS "Pseudonim", plec AS "Plec",
       NVL(przydzial_myszy, 0) AS "Myszy po podw.", NVL(myszy_extra, 0) AS "Extra po podw."
  FROM kocury
 WHERE pseudo IN (SELECT pseudo
                    FROM (SELECT pseudo
                            FROM kocury k
                                 JOIN bandy
                                 USING (nr_bandy)
                           WHERE nazwa = 'LACIACI MYSLIWI'
                           ORDER BY w_stadku_od)
                   WHERE ROWNUM <= 3
                   UNION
                  SELECT pseudo
                    FROM (SELECT pseudo
                            FROM kocury k
                                 JOIN bandy
                                 USING (nr_bandy)
                           WHERE nazwa = 'CZARNI RYCERZE'
                           ORDER BY w_stadku_od)
                   WHERE ROWNUM <= 3);

ROLLBACK;
