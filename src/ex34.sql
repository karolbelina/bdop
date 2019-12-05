DECLARE
  nazwa_funkcji funkcje.funkcja%TYPE := '&funkcja';
  liczba NUMBER;
BEGIN
  SELECT COUNT(*) INTO liczba
    FROM kocury
   WHERE funkcja = UPPER(nazwa_funkcji);
  
  IF liczba > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Znaleziono kota pelniacego funkcje ' || UPPER(nazwa_funkcji));
  ELSE
    DBMS_OUTPUT.PUT_LINE('Brak kotow');
  END IF;
END;
