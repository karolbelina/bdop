SELECT k1.imie AS "IMIE", MIN(NVL(k1.przydzial_myszy, 0) + NVL(k1.myszy_extra, 0)) AS "ZJADA",
       k1.nr_bandy AS "NR BANDY", AVG(NVL(k2.przydzial_myszy, 0) + NVL(k2.myszy_extra, 0)) AS "SREDNIA BANDY"
  FROM kocury k1
       JOIN kocury k2
       ON k1.nr_bandy = k2.nr_bandy
 WHERE k1.plec = 'M'
 GROUP BY k1.imie, k1.nr_bandy
HAVING AVG(NVL(k1.przydzial_myszy, 0) + NVL(k1.myszy_extra, 0)) <= AVG(NVL(k2.przydzial_myszy, 0) + NVL(k2.myszy_extra, 0));

SELECT imie AS "IMIE", NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS "ZJADA",
       nr_bandy AS "NR BANDY", srednia AS "SREDNIA BANDY"
  FROM kocury
       JOIN (SELECT nr_bandy, AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) AS srednia
               FROM kocury
              GROUP BY nr_bandy)
       USING (nr_bandy)
 WHERE plec = 'M'
   AND NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) <= srednia;

SELECT imie AS "IMIE", NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS "ZJADA",
       nr_bandy AS "NR BANDY", (SELECT AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
                                  FROM kocury
                                 WHERE k1.nr_bandy = nr_bandy) AS "SREDNIA BANDY"
  FROM kocury k1
 WHERE plec = 'M'
   AND NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) <= (SELECT AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
                                                           FROM kocury
                                                          WHERE k1.nr_bandy = nr_bandy);
