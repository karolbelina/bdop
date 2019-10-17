SELECT imie AS "IMIE",
       CASE
       WHEN (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) * 12 < 660 THEN 'Ponizej 660'
       WHEN (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) * 12 = 660 THEN 'Limit'
       ELSE TO_CHAR((NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) * 12)
       END AS "Zjada rocznie"
  FROM kocury;
