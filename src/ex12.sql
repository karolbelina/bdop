SELECT 'Liczba kotow=' AS " ", COUNT(*) AS " ", 'lowi jako' AS " ", funkcja AS " ", 'i zjada max.' AS " ",
       MAX(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) AS " ", 'myszy miesiecznie' AS " "
  FROM kocury
 WHERE funkcja != 'SZEFUNIO'
   AND NVL(plec, 'D') = 'D' -- could be plec != 'M', but inequalities should be avoided
 GROUP BY funkcja
HAVING AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) > 50;
