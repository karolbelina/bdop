CREATE VIEW spozycie_w_bandach (nazwa, sre_spoz, max_spoz, min_spoz, koty, koty_z_dod)
    AS
SELECT nazwa, AVG(przydzial_myszy), MAX(przydzial_myszy), MIN(przydzial_myszy), COUNT(*), COUNT(myszy_extra)
  FROM bandy b
       JOIN kocury k
       USING (nr_bandy)
 GROUP BY nazwa;

SELECT pseudo AS "PSEUDONIM", imie AS "IMIE", funkcja AS "FUNKCJA", przydzial_myszy AS "ZJADA",
       'OD ' || min_spoz || ' DO ' || max_spoz AS "GRANICE SPOZYCIA", w_stadku_od AS "LOWI OD"
  FROM kocury
       JOIN bandy
       USING (nr_bandy)
       JOIN spozycie_w_bandach
       USING (nazwa)
 WHERE pseudo = 'PLACEK';

DROP VIEW spozycie_w_bandach;