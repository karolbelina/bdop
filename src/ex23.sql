SELECT imie AS "IMIE", (przydzial_myszy + myszy_extra) * 12 AS "DAWKA ROCZNA", 'powyzej 864' AS "DAWKA"
  FROM kocury
 WHERE (przydzial_myszy + myszy_extra) * 12 > 864
   AND myszy_extra IS NOT NULL
 
 UNION ALL
 
SELECT imie AS "IMIE", (przydzial_myszy + myszy_extra) * 12 AS "DAWKA ROCZNA", '864' AS "DAWKA"
  FROM kocury
 WHERE (przydzial_myszy + myszy_extra) * 12 = 864
   AND myszy_extra IS NOT NULL
 
 UNION ALL
 
SELECT imie AS "IMIE", (przydzial_myszy + myszy_extra) * 12 AS "DAWKA ROCZNA", 'ponizej 864' AS "DAWKA"
  FROM kocury
 WHERE (przydzial_myszy + myszy_extra) * 12 < 864
   AND myszy_extra IS NOT NULL
 ORDER BY "DAWKA ROCZNA" DESC;
