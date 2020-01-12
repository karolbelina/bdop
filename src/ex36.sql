DECLARE
  CURSOR do_zmiany IS SELECT pseudo, przydzial_myszy, kocury.funkcja, max_myszy
                        FROM kocury
                             JOIN funkcje
                             ON funkcje.funkcja = kocury.funkcja
                       ORDER BY przydzial_myszy
  FOR UPDATE OF przydzial_myszy;
  kocur do_zmiany%ROWTYPE;
  liczba_zmian NUMBER := 0;
  suma_przydzialow NUMBER;
  max_przydzial NUMBER;
  podwyzka NUMBER;
BEGIN
  SELECT SUM(przydzial_myszy)
    INTO suma_przydzialow
    FROM kocury;

  <<obieg>>LOOP
    OPEN do_zmiany;
    LOOP
      FETCH do_zmiany INTO kocur;
      EXIT WHEN do_zmiany%NOTFOUND;

      podwyzka := LEAST(ROUND(1.1 * kocur.przydzial_myszy), kocur.max_myszy) - kocur.przydzial_myszy;

      IF podwyzka > 0 THEN -- can be rounded down to zero
        UPDATE kocury
           SET przydzial_myszy = przydzial_myszy + podwyzka
         WHERE pseudo = kocur.pseudo;
         
        liczba_zmian := liczba_zmian + 1;
        suma_przydzialow := suma_przydzialow + podwyzka;

        EXIT obieg WHEN suma_przydzialow > 1050;
      END IF;
    END LOOP;
    CLOSE do_zmiany;
  END LOOP obieg;

  DBMS_OUTPUT.PUT('Calk. przydzial w stadku ' || suma_przydzialow);
  DBMS_OUTPUT.PUT_LINE('  Zmian - ' || liczba_zmian);
END;

SELECT imie AS "IMIE", NVL(przydzial_myszy, 0) AS "Myszki po podwyzce"
  FROM kocury;

ROLLBACK;
