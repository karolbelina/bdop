SELECT pseudo AS "Pseudonim", COUNT(*) AS "Liczba wrogow"
  FROM wrogowie_kocurow
 GROUP BY pseudo
HAVING COUNT(*) > 1;
