SELECT MIN(funkcja) AS "Funkcja", pseudo AS "Pseudonim kota",
       COUNT(*) AS "Liczba wrogow"
  FROM kocury
       JOIN wrogowie_kocurow
       USING (pseudo)
 GROUP BY pseudo
HAVING COUNT(*) > 1;
