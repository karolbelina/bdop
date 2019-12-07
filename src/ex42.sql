-- solution a
CREATE OR REPLACE PACKAGE pamiec AS
  przydzial_tygr NUMBER;
  nagroda NUMBER := 0;
  strata NUMBER := 0;
END;

CREATE OR REPLACE TRIGGER przydzial_tygrysa
BEFORE UPDATE ON kocury
BEGIN
  SELECT przydzial_myszy
    INTO pamiec.przydzial_tygr
    FROM kocury
   WHERE pseudo = 'TYGRYS';
END;

CREATE OR REPLACE TRIGGER zmiany
BEFORE UPDATE ON kocury
FOR EACH ROW
DECLARE
  roznica NUMBER;
BEGIN
  IF :NEW.funkcja = 'MILUSIA' THEN
    IF :NEW.przydzial_myszy <= :OLD.przydzial_myszy then
      DBMS_OUTPUT.PUT_LINE('Nie mozna zmienić przydziału ' || :OLD.pseudo || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
      :NEW.przydzial_myszy := :OLD.przydzial_myszy;
    ELSE
      roznica := :NEW.przydzial_myszy - :OLD.przydzial_myszy;

      IF roznica < 0.1 * pamiec.przydzial_tygr THEN
        DBMS_OUTPUT.PUT_LINE('Kara za zmiane '|| :OLD.pseudo || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
        pamiec.strata := pamiec.strata + 1;
        :NEW.przydzial_myszy := :NEW.przydzial_myszy + 0.1 * pamiec.przydzial_tygr;
        :NEW.myszy_extra := :NEW.myszy_extra + 5;
      ELSIF roznica > 0.1 * pamiec.przydzial_tygr THEN
        pamiec.nagroda := pamiec.nagroda + 1;
        DBMS_OUTPUT.PUT_LINE('Nagroda za zmiane ' || :OLD.pseudo || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
      END IF;
    END IF;
  END IF;
END;

CREATE OR REPLACE TRIGGER zmiany_tygrysa
AFTER UPDATE ON kocury
DECLARE
  temp NUMBER;
BEGIN
  IF pamiec.strata > 0 THEN
    temp := pamiec.strata;
    pamiec.strata := 0;

    UPDATE kocury
       SET przydzial_myszy = FLOOR(przydzial_myszy - przydzial_myszy * 0.1 * temp)
     WHERE pseudo = 'TYGRYS';

    DBMS_OUTPUT.PUT_LINE('Zabrano ' || FLOOR(pamiec.przydzial_tygr * 0.1 * temp) || ' przydzialu myszy Tygrysowi.');
  END IF;
  IF pamiec.nagroda > 0 THEN
    temp := pamiec.nagroda;
    pamiec.nagroda := 0;

    UPDATE kocury
       SET myszy_extra = myszy_extra + 5 * temp
     WHERE PSEUDO = 'TYGRYS';

    DBMS_OUTPUT.PUT_LINE('Dodano ' || 5 * temp || ' myszy extra Tygrysowi');
  END IF;
END;

DROP TRIGGER przydzial_tygrysa;
DROP TRIGGER zmiany;
DROP TRIGGER zmiany_tygrysa;
DROP PACKAGE pamiec;

-- solution b
CREATE OR REPLACE TRIGGER wirus
FOR UPDATE ON kocury
COMPOUND TRIGGER
  przydzial_tygr NUMBER;
  nagroda NUMBER := 0;
  strata NUMBER := 0;
  roznica NUMBER;
  temp NUMBER;

  BEFORE STATEMENT IS
  BEGIN
      SELECT przydzial_myszy
        INTO przydzial_tygr
        FROM kocury
       WHERE pseudo = 'TYGRYS';
  END BEFORE STATEMENT;

  BEFORE EACH ROW IS
  BEGIN
    if :NEW.funkcja = 'MILUSIA' THEN
      IF :NEW.przydzial_myszy <= :OLD.przydzial_myszy THEN
        DBMS_OUTPUT.PUT_LINE('Nie mozna zmienić przydziału ' || :OLD.pseudo || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
        :NEW.przydzial_myszy := :OLD.przydzial_myszy;
      ELSE
        roznica := :NEW.przydzial_myszy - :OLD.przydzial_myszy;

        IF roznica < 0.1 * przydzial_tygr THEN
          DBMS_OUTPUT.PUT_LINE('Kara za zmiane '|| :OLD.pseudo || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
          strata := strata + 1;
          :NEW.przydzial_myszy := :NEW.przydzial_myszy + 0.1 * przydzial_tygr;
          :NEW.myszy_extra := :NEW.myszy_extra + 5;
        ELSIF roznica > 0.1 * przydzial_tygr THEN
          nagroda := nagroda + 1;
          DBMS_OUTPUT.PUT_LINE('Nagroda za zmiane ' || :OLD.pseudo || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
        END IF;
      END IF;
    END IF;
  END BEFORE EACH ROW;

  AFTER STATEMENT IS
  BEGIN
    IF strata > 0 THEN
      temp := strata;
      strata := 0;

      UPDATE kocury
        SET przydzial_myszy = FLOOR(przydzial_myszy - przydzial_myszy * 0.1 * temp)
      WHERE pseudo = 'TYGRYS';

      DBMS_OUTPUT.PUT_LINE('Zabrano ' || FLOOR(przydzial_tygr * 0.1 * temp) || ' przydzialu myszy Tygrysowi.');
    END IF;
    IF nagroda > 0 THEN
      temp := nagroda;
      nagroda := 0;

      UPDATE kocury
        SET myszy_extra = myszy_extra + 5 * temp
      WHERE PSEUDO = 'TYGRYS';

      DBMS_OUTPUT.PUT_LINE('Dodano ' || 5 * temp || ' myszy extra Tygrysowi');
    END IF;
  END AFTER STATEMENT;
END;

DROP TRIGGER wirus;

SELECT *
  FROM kocury;

UPDATE kocury
   SET przydzial_myszy = (przydzial_myszy + 19)
 WHERE funkcja = 'MILUSIA';

ROLLBACK;
