CREATE OR REPLACE PROCEDURE nowa_banda(wybrany_nr_bandy bandy.nr_bandy%TYPE, wybrana_nazwa bandy.nazwa%TYPE, wybrany_teren bandy.teren%TYPE)
IS
  komunikat VARCHAR2(100);
  row_count NUMBER;
  NIEPRAWIDLOWY_NR_BANDY EXCEPTION;
  DUPLIKAT EXCEPTION;
BEGIN
  IF wybrany_nr_bandy <= 0 THEN
    RAISE NIEPRAWIDLOWY_NR_BANDY;
  END IF;

  SELECT COUNT(nr_bandy)
    INTO row_count
    FROM bandy
   WHERE nr_bandy = wybrany_nr_bandy;
  
  IF row_count > 0 THEN
    komunikat := TO_CHAR(wybrany_nr_bandy);
  END IF;

  SELECT COUNT(nazwa)
    INTO row_count
    FROM bandy
   WHERE nazwa = wybrana_nazwa;

  IF row_count > 0 THEN
    komunikat := CASE
      WHEN komunikat IS NULL THEN wybrana_nazwa
      ELSE komunikat || ', ' || wybrana_nazwa
    END;
  END IF;

  SELECT COUNT(teren)
    INTO row_count
    FROM bandy
   WHERE teren = wybrany_teren;

   IF row_count > 0 THEN
    komunikat := CASE
      WHEN komunikat IS NULL THEN wybrany_teren
      ELSE komunikat || ', ' || wybrany_teren
    END;
  END IF;

  IF komunikat IS NOT NULL THEN
    RAISE DUPLIKAT;
  END IF;

  INSERT INTO bandy (nr_bandy, nazwa, teren)
  VALUES (wybrany_nr_bandy, wybrana_nazwa, wybrany_teren);
EXCEPTION
  WHEN NIEPRAWIDLOWY_NR_BANDY THEN
    DBMS_OUTPUT.PUT_LINE('Numer bandy musi byc wiekszy od zera');
  WHEN DUPLIKAT THEN
    DBMS_OUTPUT.PUT_LINE(komunikat || ': juz istnieje');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

BEGIN
    nowa_banda(1, 'SZEFOSTWO', 'SAD');
END;

ROLLBACK;

DROP PROCEDURE nowa_banda;
