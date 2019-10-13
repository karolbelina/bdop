 SELECT level AS "Poziom", pseudo AS "Pseudonim",
        funkcja AS "Funkcja", nr_bandy AS "Nr bandy"
   FROM kocury
  WHERE plec = 'M'
CONNECT BY PRIOR pseudo = szef
  START WITH funkcja = 'BANDZIOR'
  ORDER BY level;
