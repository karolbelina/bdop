 SELECT LPAD((level - 1) || LPAD(imie, 16 + LENGTH(imie)),
             (level - 1) * 4 + LENGTH((level - 1) || LPAD(imie, 16 + LENGTH(imie))),
             '===>') AS "Hierarchia",
        NVL(szef, 'Sam sobie panem') AS "Pseudo szefa",
        funkcja AS "Funkcja"
   FROM kocury
  WHERE myszy_extra IS NOT NULL
CONNECT BY PRIOR pseudo = szef
  START WITH szef IS NULL
  ORDER BY level;
