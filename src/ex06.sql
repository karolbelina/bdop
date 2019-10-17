SELECT imie AS "IMIE", w_stadku_od AS "W stadku",
       FLOOR(przydzial_myszy / 1.1) AS "Zjadal",
       ADD_MONTHS(w_stadku_od, 6) AS "Podwyzka",
       przydzial_myszy AS "Zjada"
  FROM kocury
 WHERE MONTHS_BETWEEN(SYSDATE, w_stadku_od) / 12 >= 10
   AND EXTRACT(MONTH FROM w_stadku_od) BETWEEN 3 AND 9;
