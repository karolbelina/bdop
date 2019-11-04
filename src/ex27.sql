SELECT pseudo AS "PSEUDO", NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS "ZJADA"
  FROM kocury k
 WHERE (SELECT COUNT(DISTINCT NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
          FROM kocury
         WHERE NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)
               > NVL(k.przydzial_myszy, 0) + NVL(k.myszy_extra, 0)) < 7 /* n */;

SELECT pseudo AS "PSEUDO", NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS "ZJADA"
  FROM kocury
 WHERE NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)
    IN (SELECT *
          FROM (SELECT DISTINCT NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS przydzial
                  FROM kocury
                 ORDER BY przydzial DESC)
         WHERE ROWNUM <= 7 /* n */);

SELECT k1.pseudo AS "PSEUDO", MIN(NVL(k1.przydzial_myszy, 0) + NVL(k1.myszy_extra, 0)) AS "ZJADA"
  FROM kocury k1
       JOIN kocury k2
       ON NVL(k1.przydzial_myszy, 0) + NVL(k1.myszy_extra, 0) <= NVL(k2.przydzial_myszy, 0) + NVL(k2.myszy_extra, 0)
 GROUP BY k1.pseudo
HAVING COUNT(DISTINCT NVL(k2.przydzial_myszy, 0) + NVL(k2.myszy_extra, 0)) <= 7 /* n */;

SELECT pseudo AS "PSEUDO", przydzial AS "ZJADA"
  FROM (SELECT pseudo, NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS przydzial,
               DENSE_RANK() OVER (ORDER BY NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) DESC) AS pozycja
          FROM kocury)
 WHERE pozycja <= 7 /* n */;
