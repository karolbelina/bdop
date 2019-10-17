SELECT imie_wroga AS "WROG", opis_incydentu AS "PRZEWINA"
  FROM wrogowie_kocurow
 WHERE EXTRACT(YEAR FROM data_incydentu) = 2009;
