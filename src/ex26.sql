SELECT funkcja AS "FUNKCJA",
       ROUND(AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) AS "Srednio najw. i najm. myszy"
  FROM kocury k
 WHERE funkcja != 'SZEFUNIO'
 GROUP BY funkcja
HAVING AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
       > ALL(SELECT AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
               FROM kocury
              WHERE funkcja NOT IN (k.funkcja, 'SZEFUNIO')
              GROUP BY funkcja)
    OR AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
       < ALL(SELECT AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
               FROM kocury
              WHERE funkcja NOT IN (k.funkcja, 'SZEFUNIO')
              GROUP BY funkcja);
