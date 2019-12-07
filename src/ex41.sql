CREATE OR REPLACE TRIGGER auto_nr_bandy
BEFORE INSERT ON bandy
FOR EACH ROW
DECLARE
  next_number NUMBER;
BEGIN
  SELECT MAX(nr_bandy) + 1
    INTO next_number
    FROM BANDY;
  
  :NEW.nr_bandy := next_number;
END;

BEGIN
  nowa_banda(10, 'nazwa2', 'teren2');
END;

ROLLBACK;

DROP TRIGGER auto_nr_bandy;
