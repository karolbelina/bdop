SELECT 'Liczba kotow=' AS " ", COUNT(*) AS " ", 'lowi jako' AS " ", funkcja AS " ", 'i zjada max.' AS " ",
       MAX(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) AS " ", 'myszy miesiecznie' AS " "
  FROM kocury
 WHERE funkcja != 'SZEFUNIO'
   AND plec != 'M'
 GROUP BY funkcja
HAVING AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) > 50;
