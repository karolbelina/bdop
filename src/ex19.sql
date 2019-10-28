SELECT k1.imie AS "Imie", ' | ' AS " ", k1.funkcja AS "Funkcja", ' | ' AS " ",
       k2.imie AS "Szef 1", ' | ' AS " ", k3.imie AS "Szef 2", ' | ' AS " ", k4.imie AS "Szef 3"
  FROM kocury k1
       LEFT JOIN kocury k2
              ON k1.szef = k2.pseudo
       LEFT JOIN kocury k3
              ON k2.szef = k3.pseudo
       LEFT JOIN kocury k4
              ON k3.szef = k4.pseudo
 WHERE k1.funkcja IN ('KOT', 'MILUSIA');

SELECT imie_kota AS "Imie", ' | ' AS " ", funkcja AS "Funkcja", ' | ' AS " ",
       szef_1 AS "Szef 1", ' | ' AS " ", szef_2 AS "Szef 2", ' | ' AS " ", szef_3 AS "Szef 3"
  FROM ( SELECT level - 1 AS nr_szefa, CONNECT_BY_ROOT imie AS imie_kota,
                CONNECT_BY_ROOT funkcja AS funkcja, imie AS imie_szefa
           FROM kocury
          WHERE imie != CONNECT_BY_ROOT imie
        CONNECT BY pseudo = PRIOR szef
          START WITH funkcja IN ('KOT', 'MILUSIA'))
 PIVOT (LISTAGG(imie_szefa, ', ') WITHIN GROUP (ORDER BY NULL)
        FOR nr_szefa IN (1 AS szef_1, 2 AS szef_2, 3 AS szef_3));

 SELECT CONNECT_BY_ROOT imie AS imie_kota, ' | ' AS " ", CONNECT_BY_ROOT funkcja AS funkcja,
        -- SUBSTR gets rid of the root
        SUBSTR(SYS_CONNECT_BY_PATH(RPAD(imie, 13), ' | '), 17) AS "Imiona kolejnych szefów"
   FROM kocury
  WHERE szef IS NULL
CONNECT BY pseudo = PRIOR szef
  START WITH funkcja IN ('KOT', 'MILUSIA');
