DECLARE
  liczba_poziomow NUMBER := '&liczba_szefow';
  max_poziom NUMBER;
  dyn_query VARCHAR2(1000);
  TYPE VARCHAR2_TABLE IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
  wybrane_kocury VARCHAR2_TABLE;
BEGIN
   SELECT MAX(level) - 1
     INTO max_poziom
     FROM kocury
  CONNECT BY PRIOR pseudo = szef
    START WITH szef IS NULL;
  
  liczba_poziomow := LEAST(liczba_poziomow, max_poziom);

  DBMS_OUTPUT.PUT(RPAD('Imie', 13));
  FOR i IN 1..liczba_poziomow
  LOOP
    DBMS_OUTPUT.PUT('  |  ' || RPAD('Szef ' || i, 13));
  END LOOP;
  DBMS_OUTPUT.NEW_LINE();

  DBMS_OUTPUT.PUT('-------------');
  FOR i IN 1..liczba_poziomow
  LOOP
    DBMS_OUTPUT.PUT(' --- -------------');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE();

  dyn_query := 'SELECT RPAD(k0.imie, 13) ';
  FOR i IN 1..liczba_poziomow
  LOOP
    dyn_query := dyn_query || '|| ''  |  '' || RPAD(NVL(k' || i || '.imie, '' ''), 13) ';
  END LOOP;
  dyn_query := dyn_query || ' FROM kocury k0 ';
  FOR i IN 1..liczba_poziomow
  LOOP
    dyn_query := dyn_query || 'LEFT JOIN kocury k' || i
                 || ' ON k' || (i - 1) || '.szef = k' || i || '.pseudo ';
  END LOOP;
  dyn_query := dyn_query || 'WHERE k0.funkcja IN (''KOT'', ''MILUSIA'')';

  EXECUTE IMMEDIATE dyn_query BULK COLLECT INTO wybrane_kocury;

  FOR i IN 1..wybrane_kocury.COUNT
  LOOP
    DBMS_OUTPUT.PUT_LINE(wybrane_kocury(i));
  END LOOP;
END;
