 SELECT LPAD(level || LPAD(imie, 16 + LENGTH(imie)),
             (level - 1) * 4 + LENGTH(level || LPAD(imie, 16 + LENGTH(imie))),
             '===>') AS "Hierarchia",
        CASE
        WHEN szef IS NULL THEN 'Sam sobie panem'
        ELSE szef
        END AS "Pseudo szefa",
        funkcja AS "Funkcja"
   FROM kocury
  WHERE myszy_extra IS NOT NULL
CONNECT BY PRIOR pseudo = szef
  START WITH szef IS NULL
  ORDER BY level;
