SELECT imie_wroga AS "IMIE", gatunek AS "GATUNEK", stopien_wrogosci AS "STOPIEN WROGOSCI"
  FROM wrogowie
 WHERE lapowka IS NULL
 ORDER BY stopien_wrogosci;
