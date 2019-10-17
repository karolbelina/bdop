SELECT imie AS "IMIE", funkcja AS "FUNKCJA", w_stadku_od AS "Z NAMI OD"
  FROM kocury
 WHERE plec = 'D'
   AND w_stadku_od BETWEEN '2005-09-01' AND '2007-07-31';
