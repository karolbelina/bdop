SELECT pseudo AS "PSEUDO", NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS "ZJADA"
  FROM kocury k
 WHERE (SELECT COUNT(DISTINCT NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
          FROM kocury
         WHERE NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)
               > NVL(k.przydzial_myszy, 0) + NVL(k.myszy_extra, 0)) < 7; -- using 7 as an example
