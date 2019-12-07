DECLARE
  i NUMBER := 0;
  BRAK_KOTOW EXCEPTION;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Nr  Psedonim   Zjada');
  DBMS_OUTPUT.PUT_LINE('--------------------');

  FOR kocur IN (SELECT pseudo, NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) zjada
                  FROM kocury
                 ORDER BY zjada DESC)
  LOOP
    i := i + 1;
    DBMS_OUTPUT.PUT_LINE(RPAD(i, 3) || ' ' || RPAD(kocur.pseudo, 9) || ' ' || LPAD(kocur.zjada, 6));
    EXIT WHEN i > 5;
  END LOOP;

  IF i = 0 THEN
    RAISE BRAK_KOTOW;
  END IF;
EXCEPTION
  WHEN BRAK_KOTOW THEN
    DBMS_OUTPUT.PUT_LINE('Brak kotow');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
