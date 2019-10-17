 SELECT LPAD(pseudo, (level - 1) * 4 + LENGTH(pseudo)) AS "Droga sluzbowa"
   FROM kocury
CONNECT BY pseudo = PRIOR szef
  START WITH plec = 'M'
    AND MONTHS_BETWEEN(SYSDATE, w_stadku_od) / 12 >= 10
    AND myszy_extra IS NULL;
