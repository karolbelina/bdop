DECLARE
  wybrany_pseudonim kocury.pseudo%TYPE := '&pseudonim';
  imie kocury.imie%TYPE;
  przydzial_myszy NUMBER;
  miesiac NUMBER;
BEGIN
  SELECT imie, (NVL(przydzial_myszy, 0) + nvl(myszy_extra, 0)) * 12, EXTRACT(MONTH FROM w_stadku_od)
    INTO imie, przydzial_myszy, miesiac
    FROM kocury
   WHERE pseudo = UPPER(wybrany_pseudonim);

  IF przydzial_myszy > 700 THEN
    DBMS_OUTPUT.PUT_LINE(imie || ' calkowity roczny przydzial myszy > 700');
  ELSIF imie LIKE '%A%' THEN
    DBMS_OUTPUT.PUT_LINE(imie || ' imie zawiera litere A');
  ELSIF miesiac = 1 THEN
    DBMS_OUTPUT.PUT_LINE(imie || ' styczen jest miesiacem przystapienia do stada');
  ELSE
    DBMS_OUTPUT.PUT_LINE(imie || ' nie odpowiada kryteriom');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nie znaleziono takiego kota');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
