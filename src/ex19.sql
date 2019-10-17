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
