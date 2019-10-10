SELECT imie AS "IMIE", NVL(przydzial_myszy, 0) * 3 AS "MYSZY KWARTALNE",
       NVL(myszy_extra, 0) * 3 AS "KWARTALNE DODATKI"
  FROM kocury
 WHERE NVL(przydzial_myszy, 0) > 2 * NVL(myszy_extra, 0)
   AND przydzial_myszy >= 55;
