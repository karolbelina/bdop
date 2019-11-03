SELECT imie AS "IMIE", w_stadku_od || '     ' AS "WSTAPIL DO STADKA", '' AS " "
  FROM kocury k1
 WHERE w_stadku_od NOT IN ((SELECT MIN(w_stadku_od)
                              FROM kocury
                             WHERE k1.nr_bandy = nr_bandy),
                           (SELECT MAX(w_stadku_od)
                              FROM kocury
                             WHERE k1.nr_bandy = nr_bandy))
 UNION
SELECT imie AS "IMIE", w_stadku_od || ' <---' AS "WSTAPIL DO STADKA",
       'NAJMLODSZY STAZEM W BANDZIE ' || nazwa AS " "
  FROM kocury k1
       JOIN bandy
       ON k1.nr_bandy = bandy.nr_bandy
 WHERE w_stadku_od = (SELECT MAX(w_stadku_od)
                        FROM kocury
                       WHERE k1.nr_bandy = nr_bandy)
 UNION
SELECT imie AS "IMIE", w_stadku_od || ' <---' AS "WSTAPIL DO STADKA",
       'NAJSTARSZY STAZEM W BANDZIE ' || nazwa AS " "
  FROM kocury k1
       JOIN bandy
       ON k1.nr_bandy = bandy.nr_bandy
 WHERE w_stadku_od = (SELECT MIN(w_stadku_od)
                        FROM kocury
                       WHERE k1.nr_bandy = nr_bandy);
