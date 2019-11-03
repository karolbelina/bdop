SELECT TO_CHAR(EXTRACT(YEAR FROM w_stadku_od)) AS "ROK", COUNT(*) AS "LICZBA WSTAPIEN"
  FROM kocury
 GROUP BY EXTRACT(YEAR FROM w_stadku_od)
HAVING COUNT(*) IN ((SELECT MIN(COUNT(*))
                       FROM kocury
                      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
                     HAVING COUNT(*) > (SELECT AVG(COUNT(*))
                                          FROM kocury
                                         GROUP BY EXTRACT(YEAR FROM w_stadku_od))),
                    (SELECT MAX(COUNT(*))
                       FROM kocury
                      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
                     HAVING COUNT(*) < (SELECT AVG(COUNT(*))
                                          FROM kocury
                                         GROUP BY EXTRACT(YEAR FROM w_stadku_od))))
 UNION
SELECT 'Srednia' AS "ROK", AVG(COUNT(*)) AS "LICZBA WSTAPIEN"
  FROM kocury
 GROUP BY EXTRACT(YEAR FROM w_stadku_od)
 ORDER BY "LICZBA WSTAPIEN";
