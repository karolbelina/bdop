SELECT k1.imie AS "IMIE", k1.w_stadku_od AS "POLUJE OD"
  FROM kocury k1
       JOIN kocury k2
         ON k2.imie = 'JACEK'
        AND k1.w_stadku_od < k2.w_stadku_od
 ORDER BY k1.w_stadku_od DESC;
