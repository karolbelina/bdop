DROP TABLE elita;
DROP TABLE plebs;
DROP TABLE konta;

CREATE TABLE plebs (
  imie            VARCHAR2(15)
                  CONSTRAINT ple_imie_nn NOT NULL,
  plec            VARCHAR2(1)
                  CONSTRAINT ple_plec_ch CHECK(plec IN ('M', 'D')),
  pseudo          VARCHAR2(15)
                  CONSTRAINT ple_pk PRIMARY KEY,
  funkcja         VARCHAR2(10)
                  CONSTRAINT ple_fun_funkcja_fk REFERENCES funkcje(funkcja),
  szef            VARCHAR2(15)
                  CONSTRAINT ple_koc_pseudo_fk REFERENCES kocury(pseudo),
  w_stadku_od     DATE
                  DEFAULT SYSDATE,
  przydzial_myszy NUMBER(3),
  myszy_extra     NUMBER(3),
  nr_bandy        NUMBER(3)
                  CONSTRAINT ple_ban_nr_bandy_fk REFERENCES bandy(nr_bandy)
);

CREATE TABLE elita (
  imie            VARCHAR2(15)
                  CONSTRAINT eli_imie_nn NOT NULL,
  plec            VARCHAR2(1)
                  CONSTRAINT eli_plec_ch CHECK(plec IN ('M', 'D')),
  pseudo          VARCHAR2(15)
                  CONSTRAINT eli_pk PRIMARY KEY,
  funkcja         VARCHAR2(10)
                  CONSTRAINT eli_fun_funkcja_fk REFERENCES funkcje(funkcja),
  szef            VARCHAR2(15)
                  CONSTRAINT eli_koc_pseudo_fk REFERENCES kocury(pseudo),
  w_stadku_od     DATE
                  DEFAULT SYSDATE,
  przydzial_myszy NUMBER(3),
  myszy_extra     NUMBER(3),
  nr_bandy        NUMBER(3)
                  CONSTRAINT eli_ban_nr_bandy_fk REFERENCES bandy(nr_bandy),
  sluga           VARCHAR2(15)
                  CONSTRAINT eli_ple_pseudo_fk REFERENCES plebs(pseudo)
);

CREATE TABLE konta (
  nr_konta             NUMBER(3)
                       CONSTRAINT kon_pk PRIMARY KEY,
  wlasciciel           VARCHAR2(15)
                       CONSTRAINT kon_eli_pseudo_fk REFERENCES elita(pseudo)
                       CONSTRAINT kon_wlasciciel_nn NOT NULL,
  data_dodania_myszy   DATE
                       CONSTRAINT kon_data_dodania_myszy_nn NOT NULL,
  data_usuniecia_myszy DATE,
  CONSTRAINT kon_dates_ch CHECK(data_usuniecia_myszy >= data_dodania_myszy)
);

INSERT ALL
  INTO plebs VALUES ('ZUZIA',   'D', 'SZYBKA',   'LOWCZY',   'LYSY',   '2006-07-21', 65,  NULL, 2)
  INTO plebs VALUES ('CHYTRY',  'M', 'BOLEK',    'DZIELCZY', 'TYGRYS', '2002-05-05', 50,  NULL, 1)
  INTO plebs VALUES ('BELA',    'D', 'LASKA',    'MILUSIA',  'LYSY',   '2008-02-01', 24,  28,   2)
  INTO plebs VALUES ('KSAWERY', 'M', 'MAN',      'LAPACZ',   'RAFA',   '2008-07-12', 51,  NULL, 4)
  INTO plebs VALUES ('MELA',    'D', 'DAMA',     'LAPACZ',   'RAFA',   '2008-11-01', 51,  NULL, 4)
  INTO plebs VALUES ('JACEK',   'M', 'PLACEK',   'LOWCZY',   'LYSY',   '2008-12-01', 67,  NULL, 2)
  INTO plebs VALUES ('BARI',    'M', 'RURA',     'LAPACZ',   'LYSY',   '2009-09-01', 56,  NULL, 2)
  INTO plebs VALUES ('LUCEK',   'M', 'ZERO',     'KOT',      'KURKA',  '2010-03-01', 43,  NULL, 3)
  INTO plebs VALUES ('SONIA',   'D', 'PUSZYSTA', 'MILUSIA',  'ZOMBI',  '2010-11-18', 20,  35,   3)
  INTO plebs VALUES ('LATKA',   'D', 'UCHO',     'KOT',      'RAFA',   '2011-01-01', 40,  NULL, 4)
  INTO plebs VALUES ('DUDEK',   'M', 'MALY',     'KOT',      'RAFA',   '2011-05-15', 40,  NULL, 4)
  INTO plebs VALUES ('RUDA',    'D', 'MALA',     'MILUSIA',  'TYGRYS', '2006-09-17', 22,  42,   1)
SELECT * FROM DUAL;

INSERT ALL
  INTO elita VALUES ('MRUCZEK', 'M', 'TYGRYS',   'SZEFUNIO', NULL,     '2002-01-01', 103, 33,   1, 'DAMA'    )
  INTO elita VALUES ('MICKA',   'D', 'LOLA',     'MILUSIA',  'TYGRYS', '2009-10-14', 25,  47,   1, 'PUSZYSTA')
  INTO elita VALUES ('KOREK',   'M', 'ZOMBI',    'BANDZIOR', 'TYGRYS', '2004-03-16', 75,  13,   3, 'MAN'     )
  INTO elita VALUES ('BOLEK',   'M', 'LYSY',     'BANDZIOR', 'TYGRYS', '2006-08-15', 72,  21,   2, 'SZYBKA'  )
  INTO elita VALUES ('PUNIA',   'D', 'KURKA',    'LOWCZY',   'ZOMBI',  '2008-01-01', 61,  NULL, 3, 'UCHO'    )
  INTO elita VALUES ('PUCEK',   'M', 'RAFA',     'LOWCZY',   'TYGRYS', '2006-10-15', 65,  NULL, 4, 'RURA'    )
SELECT * FROM DUAL;

INSERT ALL
  INTO konta VALUES (0,  'TYGRYS', SYSDATE, NULL)
  INTO konta VALUES (1,  'LOLA',   SYSDATE, NULL)
  INTO konta VALUES (2,  'ZOMBI',  SYSDATE, NULL)
  INTO konta VALUES (3,  'LYSY',   SYSDATE, NULL)
  INTO konta VALUES (4,  'KURKA',  SYSDATE, NULL)
  INTO konta VALUES (5,  'RAFA',   SYSDATE, NULL)
  INTO konta VALUES (6,  'LOLA',   SYSDATE, NULL)
  INTO konta VALUES (7,  'ZOMBI',  SYSDATE, NULL)
  INTO konta VALUES (8,  'LOLA',   SYSDATE, NULL)
  INTO konta VALUES (9,  'KURKA',  SYSDATE, NULL)
  INTO konta VALUES (10, 'LOLA',   SYSDATE, NULL)
SELECT * FROM DUAL;


CREATE OR REPLACE FORCE VIEW oid_kocury OF KOCUR
  WITH OBJECT IDENTIFIER (pseudo) AS
SELECT imie,
       plec,
       pseudo,
       funkcja,
       MAKE_REF(oid_kocury, szef) szef,
       w_stadku_od,
       przydzial_myszy,
       myszy_extra,
       nr_bandy
  FROM kocury;

CREATE OR REPLACE FORCE VIEW oid_plebs OF CZLONEK_PLEBSU
  WITH OBJECT IDENTIFIER (pseudo) AS
SELECT imie,
       plec,
       pseudo,
       funkcja,
       MAKE_REF(oid_kocury, szef) szef,
       w_stadku_od,
       przydzial_myszy,
       myszy_extra,
       nr_bandy
  FROM plebs;

CREATE OR REPLACE FORCE VIEW oid_elita OF CZLONEK_ELITY
  WITH OBJECT IDENTIFIER (pseudo) AS
SELECT imie,
       plec,
       pseudo,
       funkcja,
       MAKE_REF(oid_kocury, szef) szef,
       w_stadku_od,
       przydzial_myszy,
       myszy_extra,
       nr_bandy,
       MAKE_REF(oid_plebs, sluga) sluga
  FROM elita;

CREATE OR REPLACE VIEW oid_konta OF KONTO
  WITH OBJECT IDENTIFIER (nr_konta) AS
SELECT nr_konta,
       MAKE_REF(oid_elita, wlasciciel) wlasciciel,
       data_dodania_myszy,
       data_usuniecia_myszy
  FROM konta;

CREATE OR REPLACE VIEW oid_incydenty OF INCYDENT
  WITH OBJECT IDENTIFIER (nr_incydentu) AS
SELECT ROW_NUMBER() OVER (ORDER BY data_incydentu) nr_incydentu,
       MAKE_REF(oid_kocury, pseudo) ofiara,
       imie_wroga,
       data_incydentu,
       opis_incydentu
  FROM wrogowie_kocurow;


SELECT DEREF(k.wlasciciel).nazwa() "Kocur", COUNT(*) "Myszy na koncie"
  FROM oid_konta k
 WHERE k.data_usuniecia_myszy IS NULL
 GROUP BY DEREF(k.wlasciciel).nazwa()
 ORDER BY COUNT(*) DESC;

SELECT k.imie "IMIE"
  FROM oid_kocury k
 WHERE k.przydzial_myszy > (SELECT AVG(k2.przydzial_myszy)
                              FROM oid_kocury k2);

-- ex18.sql
SELECT k.imie "IMIE", k.w_stadku_od "POLUJE OD"
  FROM oid_kocury k, oid_kocury k2
 WHERE k2.imie = 'JACEK'
   AND k.w_stadku_od < k2.w_stadku_od
 ORDER BY k.w_stadku_od DESC;

-- ex23.sql
SELECT imie AS "IMIE", k.zjada_razem() * 12 AS "DAWKA ROCZNA", 'powyzej 864' AS "DAWKA"
  FROM oid_kocury k
 WHERE k.zjada_razem() * 12 > 864
   AND k.myszy_extra IS NOT NULL
 
 UNION ALL
 
SELECT imie AS "IMIE", k.zjada_razem() * 12 AS "DAWKA ROCZNA", '864' AS "DAWKA"
  FROM oid_kocury k
 WHERE k.zjada_razem() * 12 = 864
   AND myszy_extra IS NOT NULL
 
 UNION ALL
 
SELECT imie AS "IMIE", k.zjada_razem() * 12 AS "DAWKA ROCZNA", 'ponizej 864' AS "DAWKA"
  FROM oid_kocury k
 WHERE k.zjada_razem() * 12 < 864
   AND myszy_extra IS NOT NULL
 ORDER BY "DAWKA ROCZNA" DESC;

-- ex35.sql
DECLARE
  wybrany_pseudonim kocury.pseudo%TYPE := '&pseudonim';
  imie kocury.imie%TYPE;
  przydzial_myszy NUMBER;
  miesiac NUMBER;
BEGIN
  SELECT k.imie, k.zjada_razem() * 12, EXTRACT(MONTH FROM w_stadku_od)
    INTO imie, przydzial_myszy, miesiac
    FROM oid_kocury k
   WHERE k.pseudo = UPPER(wybrany_pseudonim);

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

-- ex37.sql
DECLARE
  i NUMBER := 0;
  BRAK_KOTOW EXCEPTION;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Nr  Psedonim   Zjada');
  DBMS_OUTPUT.PUT_LINE('--------------------');

  FOR kocur IN (SELECT k.pseudo, k.zjada_razem() zjada
                  FROM oid_kocury k
                 ORDER BY zjada DESC)
  LOOP
    i := i + 1;
    DBMS_OUTPUT.PUT_LINE(RPAD(i, 3) || ' ' || RPAD(kocur.pseudo, 9) || ' ' || LPAD(kocur.zjada, 6));
    EXIT WHEN i >= 5;
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
