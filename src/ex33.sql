SELECT DECODE(plec, 'M', ' ', nazwa) AS "NAZWA BANDY",
       DECODE(plec, 'D', 'Kotka', 'M', 'Kocur', plec) AS "PLEC",
       ile AS "ILE",
       szefunio AS "SZEFUNIO",
       bandzior AS "BANDZIOR",
       lowczy   AS "LOWCZY",
       lapacz   AS "LAPACZ",
       kot      AS "KOT",
       milusia  AS "MILUSIA",
       dzielczy AS "DZIELCZY",
       suma AS "SUMA"
  FROM (SELECT nazwa,
               plec,
               TO_CHAR(COUNT(*)) AS ile,
               TO_CHAR(SUM(DECODE(funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS szefunio,
               TO_CHAR(SUM(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS bandzior,
               TO_CHAR(SUM(DECODE(funkcja, 'LOWCZY',   NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS lowczy,
               TO_CHAR(SUM(DECODE(funkcja, 'LAPACZ',   NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS lapacz,
               TO_CHAR(SUM(DECODE(funkcja, 'KOT',      NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS kot,
               TO_CHAR(SUM(DECODE(funkcja, 'MILUSIA',  NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS milusia,
               TO_CHAR(SUM(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS dzielczy,
               TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) AS suma
          FROM kocury
               JOIN bandy
               USING (nr_bandy)
         GROUP BY nazwa, plec
         UNION
        SELECT 'Z----------------' AS nazwa,
               '------' AS plec,
               '----' AS ile,
               '---------' AS szefunio,
               '---------' AS bandzior,
               '---------' AS lowczy,
               '---------' AS lapacz,
               '---------' AS kot,
               '---------' AS milusia,
               '---------' AS dzielczy,
               '-------' AS suma
          FROM DUAL
         UNION
        SELECT 'ZJADA RAZEM' AS nazwa,
               '' AS plec,
               '' AS ile,
               TO_CHAR(SUM(DECODE(funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS szefunio,
               TO_CHAR(SUM(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS bandzior,
               TO_CHAR(SUM(DECODE(funkcja, 'LOWCZY',   NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS lowczy,
               TO_CHAR(SUM(DECODE(funkcja, 'LAPACZ',   NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS lapacz,
               TO_CHAR(SUM(DECODE(funkcja, 'KOT',      NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS kot,
               TO_CHAR(SUM(DECODE(funkcja, 'MILUSIA',  NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS milusia,
               TO_CHAR(SUM(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS dzielczy,
               TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) AS suma
          FROM kocury
               JOIN bandy
               USING (nr_bandy)
         ORDER BY nazwa, plec);

SELECT DECODE(plec, 'M', ' ', nazwa) AS "NAZWA BANDY",
       DECODE(plec, 'D', 'Kotka', 'M', 'Kocur', plec) AS "PLEC",
       ile AS "ILE",
       TO_CHAR(NVL(szefunio, 0)) AS "SZEFUNIO",
       TO_CHAR(NVL(bandzior, 0)) AS "BANDZIOR",
       TO_CHAR(NVL(lowczy, 0))   AS "LOWCZY",
       TO_CHAR(NVL(lapacz, 0))   AS "LAPACZ",
       TO_CHAR(NVL(kot, 0))      AS "KOT",
       TO_CHAR(NVL(milusia, 0))  AS "MILUSIA",
       TO_CHAR(NVL(dzielczy, 0)) AS "DZIELCZY",
       TO_CHAR(NVL(suma, 0)) AS "SUMA"
  FROM (SELECT nazwa, plec, ile,
               TO_CHAR(NVL(szefunio, 0)) AS szefunio,
               TO_CHAR(NVL(bandzior, 0)) AS bandzior,
               TO_CHAR(NVL(lowczy, 0))   AS lowczy,
               TO_CHAR(NVL(lapacz, 0))   AS lapacz,
               TO_CHAR(NVL(kot, 0))      AS kot,
               TO_CHAR(NVL(milusia, 0))  AS milusia,
               TO_CHAR(NVL(dzielczy, 0)) AS dzielczy,
               TO_CHAR(NVL(suma, 0)) AS suma
          FROM (SELECT nazwa, plec, funkcja,
                       NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS przydzial
                  FROM kocury
                       JOIN bandy
                       USING (nr_bandy)
                 UNION
                SELECT nazwa, plec, 'SUMA' AS funkcja,
                       SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) AS przydzial
                  FROM kocury
                       JOIN bandy
                       USING (nr_bandy)
                 GROUP BY nazwa, plec)
               JOIN (SELECT nazwa, plec, TO_CHAR(COUNT(*)) AS ile
                       FROM kocury
                            JOIN bandy
                            USING (nr_bandy)
                      GROUP BY nazwa, plec)
               USING (nazwa, plec)
         PIVOT (SUM(przydzial)
                FOR funkcja IN ('SZEFUNIO' AS szefunio,
                                'BANDZIOR' AS bandzior,
                                'LOWCZY'   AS lowczy,
                                'LAPACZ'   AS lapacz,
                                'KOT'      AS kot,
                                'MILUSIA'  AS milusia,
                                'DZIELCZY' AS dzielczy,
                                'SUMA' AS suma))
         UNION
        SELECT 'Z----------------' AS nazwa,
                '------' AS plec,
                '----' AS ile,
                '---------' AS szefunio,
                '---------' AS bandzior,
                '---------' AS lowczy,
                '---------' AS lapacz,
                '---------' AS kot,
                '---------' AS milusia,
                '---------' AS dzielczy,
                '-------' AS suma
            FROM DUAL
         UNION
        SELECT nazwa, plec, ile,
               TO_CHAR(NVL(szefunio, 0)) AS szefunio,
               TO_CHAR(NVL(bandzior, 0)) AS bandzior,
               TO_CHAR(NVL(lowczy, 0))   AS lowczy,
               TO_CHAR(NVL(lapacz, 0))   AS lapacz,
               TO_CHAR(NVL(kot, 0))      AS kot,
               TO_CHAR(NVL(milusia, 0))  AS milusia,
               TO_CHAR(NVL(dzielczy, 0)) AS dzielczy,
               TO_CHAR(NVL(suma, 0)) AS suma
          FROM (SELECT 'ZJADA RAZEM' AS nazwa, '' AS plec, '' AS ile, funkcja,
                       NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) AS przydzial
                  FROM kocury
                 UNION
                SELECT 'ZJADA RAZEM' AS nazwa, '' AS plec, '' AS ile, 'SUMA' AS funkcja,
                       SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) AS przydzial
                  FROM kocury)
         PIVOT (SUM(przydzial)
                FOR funkcja IN ('SZEFUNIO' AS szefunio,
                                'BANDZIOR' AS bandzior,
                                'LOWCZY'   AS lowczy,
                                'LAPACZ'   AS lapacz,
                                'KOT'      AS kot,
                                'MILUSIA'  AS milusia,
                                'DZIELCZY' AS dzielczy,
                                'SUMA' AS suma))
         ORDER BY nazwa, plec);
