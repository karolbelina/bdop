SELECT pseudo AS "POLUJE W POLU", przydzial_myszy AS "PRZYDZIAL MYSZY",
       nazwa AS "BANDA"
  FROM kocury
       JOIN bandy
         ON kocury.nr_bandy = bandy.nr_bandy
 WHERE teren IN ('POLE', 'CALOSC')
   AND przydzial_myszy > 50;
