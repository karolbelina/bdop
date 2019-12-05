SELECT nr_bandy AS "NR BANDY", nazwa AS "NAZWA", teren AS "TEREN"
  FROM bandy
       LEFT JOIN kocury
       USING (nr_bandy)
 WHERE pseudo IS NULL;

SELECT nr_bandy AS "NR BANDY", nazwa AS "NAZWA", teren AS "TEREN"
  FROM bandy
       RIGHT JOIN (SELECT nr_bandy
                     FROM bandy

                    MINUS
                    
                   SELECT nr_bandy
                     FROM kocury)
       USING (nr_bandy);
