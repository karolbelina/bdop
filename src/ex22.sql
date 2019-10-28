SELECT funkcja AS "Funkcja", pseudo AS "Pseudonim kota",
       COUNT(*) AS "Liczba wrogow"
  FROM kocury
       JOIN wrogowie_kocurow
       USING (pseudo)
 GROUP BY funkcja, pseudo
HAVING COUNT(*) > 1;
