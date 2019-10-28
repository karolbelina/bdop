SELECT imie AS "Imie kotki", nazwa AS "Nazwa bandy",
       imie_wroga AS "Imie wroga", stopien_wrogosci AS "Ocena wroga",
       data_incydentu AS "Data inc."
  FROM kocury
       INNER JOIN bandy
       USING (nr_bandy)
       INNER JOIN wrogowie_kocurow
       USING (pseudo)
       INNER JOIN wrogowie
       USING (imie_wroga)
 WHERE kocury.plec = 'D'
   AND wrogowie_kocurow.data_incydentu > '2007-01-01';
