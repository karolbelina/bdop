DECLARE
  CURSOR funkcje IS (SELECT funkcja
                       FROM funkcje);
  dyn_query VARCHAR2(5000);
  TYPE VARCHAR2_TABLE IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
  wiersze VARCHAR2_TABLE;
BEGIN
  DBMS_OUTPUT.PUT(RPAD('NAZWA BANDY', 17) || ' ' || RPAD('PLEC', 6) || ' ' || LPAD('ILE', 4));
  FOR f IN funkcje
  LOOP
    DBMS_OUTPUT.PUT(' ' || LPAD(f.funkcja, 9));
  END LOOP;
  DBMS_OUTPUT.PUT(' ' || LPAD('SUMA', 7));
  DBMS_OUTPUT.NEW_LINE();

  DBMS_OUTPUT.PUT('----------------- ------ ----');
  FOR f IN funkcje
  LOOP
    DBMS_OUTPUT.PUT(' ---------');
  END LOOP;
  DBMS_OUTPUT.PUT(' -------');
  DBMS_OUTPUT.NEW_LINE();

  dyn_query := 'SELECT RPAD(DECODE(plec, ''M'', '' '', nazwa), 17) || '' '' ||
                       RPAD(DECODE(plec, ''D'', ''Kotka'', ''M'', ''Kocur'', plec), 6) || '' '' ||
                       LPAD(ile, 4) || '' '' ||';
  
  FOR f IN funkcje
  LOOP
    dyn_query := dyn_query || 'LPAD(' || LOWER(f.funkcja) || ', 9)' || ' || '' '' ||';
  END LOOP;

  dyn_query := dyn_query || 'LPAD(suma, 7) FROM (SELECT nazwa, plec, TO_CHAR(COUNT(*)) AS ile,';
  
  FOR f IN funkcje
  LOOP
    dyn_query := dyn_query || 'TO_CHAR(SUM(DECODE(funkcja, ''' || f.funkcja || ''', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS ' || LOWER(f.funkcja) || ', ';
  END LOOP;

  dyn_query := dyn_query || 'TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) AS suma
                        FROM kocury
                             JOIN bandy
                             USING (nr_bandy)
                       GROUP BY nazwa, plec
                       
                       UNION ALL

                      SELECT ''Z----------------'' AS nazwa,
                             ''------'' AS plec,
                             ''----'' AS ile,';
  
  FOR f IN funkcje
  LOOP
    dyn_query := dyn_query || '''---------'' AS ' || LOWER(f.funkcja) || ',';
  END LOOP;

  dyn_query := dyn_query || '''-------'' AS suma
                        FROM DUAL

                       UNION ALL

                      SELECT ''ZJADA RAZEM'' AS nazwa,
                             '' '' AS plec,
                             '' '' AS ile,';
  
  FOR f IN funkcje
  LOOP
    dyn_query := dyn_query || 'TO_CHAR(SUM(DECODE(funkcja, ''' || f.funkcja || ''', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) AS ' || LOWER(f.funkcja) || ',';
  END LOOP;

  dyn_query := dyn_query || 'TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) AS suma
                        FROM kocury
                             JOIN bandy
                             USING (nr_bandy)
                       ORDER BY nazwa, plec)';
  
  EXECUTE IMMEDIATE dyn_query BULK COLLECT INTO wiersze;

  FOR i IN 1..wiersze.COUNT
  LOOP
    DBMS_OUTPUT.PUT_LINE(wiersze(i));
  END LOOP;
END;
