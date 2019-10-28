SELECT imie AS "IMIE", funkcja AS "FUNKCJA", przydzial_myszy AS "PRZYDZIAL MYSZY"
  FROM kocury
 WHERE przydzial_myszy >= ALL(SELECT przydzial_myszy * 3
                                FROM kocury
                                     JOIN bandy
                                     USING (nr_bandy)
                               WHERE funkcja = 'MILUSIA'
                                 AND teren IN ('SAD', 'CALOSC'));
