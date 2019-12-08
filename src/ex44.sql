CREATE OR REPLACE FUNCTION podatek (pseudonim kocury.pseudo%TYPE) RETURN NUMBER
IS
  podatek NUMBER;
  ile NUMBER;
  data DATE;
BEGIN
  SELECT CEIL(0.05 * (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)))
    INTO podatek
    FROM kocury
   WHERE pseudo = pseudonim;

  SELECT COUNT(pseudo)
    INTO ile
    FROM kocury
   WHERE szef = pseudonim;
  
  IF ile = 0 THEN
    podatek := podatek + 2;
  END IF;

  SELECT COUNT(pseudo)
    INTO ile
    FROM wrogowie_kocurow
   WHERE pseudo = pseudonim;
  
  IF ile = 0 THEN
    podatek := podatek + 1;
  END IF;

  SELECT w_stadku_od
    INTO data
    FROM kocury
   WHERE pseudo = pseudonim;
  
  IF EXTRACT(YEAR FROM data) > 2016 THEN
    podatek := podatek + 3;
  END IF;

  RETURN podatek;
END;

CREATE OR REPLACE PACKAGE podatek_package
AS
  FUNCTION podatek(pseudonim kocury.pseudo%TYPE) RETURN NUMBER;
  PROCEDURE nowa_banda(wybrany_nr_bandy bandy.nr_bandy%TYPE, wybrana_nazwa bandy.nazwa%TYPE, wybrany_teren bandy.teren%TYPE);
END podatek_package;

CREATE OR REPLACE PACKAGE BODY podatek_package
AS
  FUNCTION podatek (pseudonim kocury.pseudo%TYPE) RETURN NUMBER
  IS
    podatek NUMBER;
    ile NUMBER;
    data DATE;
  BEGIN
    SELECT CEIL(0.05 * (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)))
      INTO podatek
      FROM kocury
    WHERE pseudo = pseudonim;

    SELECT COUNT(pseudo)
      INTO ile
      FROM kocury
    WHERE szef = pseudonim;
    
    IF ile = 0 THEN
      podatek := podatek + 2;
    END IF;

    SELECT COUNT(pseudo)
      INTO ile
      FROM wrogowie_kocurow
    WHERE pseudo = pseudonim;
    
    IF ile = 0 THEN
      podatek := podatek + 1;
    END IF;

    SELECT w_stadku_od
      INTO data
      FROM kocury
    WHERE pseudo = pseudonim;
    
    IF EXTRACT(YEAR FROM data) > 2016 THEN
      podatek := podatek + 3;
    END IF;

    RETURN podatek;
  END;

  PROCEDURE nowa_banda(wybrany_nr_bandy bandy.nr_bandy%TYPE, wybrana_nazwa bandy.nazwa%TYPE, wybrany_teren bandy.teren%TYPE)
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
END;

BEGIN
  FOR kocur IN (SELECT pseudo
                  FROM kocury)
  LOOP
    DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' - ' || podatek_package.podatek(kocur.pseudo));
  END LOOP;
END;

DROP FUNCTION podatek;
DROP PACKAGE podatek_package;
