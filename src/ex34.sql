DECLARE
  wybrana_funkcja funkcje.funkcja%TYPE := '&funkcja';
  liczba NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO liczba
    FROM kocury
   WHERE funkcja = UPPER(wybrana_funkcja);
  
  IF liczba > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Znaleziono kota pelniacego funkcje ' || UPPER(wybrana_funkcja));
  ELSE
    DBMS_OUTPUT.PUT_LINE('Brak kotow');
  END IF;
END;
