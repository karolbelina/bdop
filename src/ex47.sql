DROP TABLE obj_kocury;
DROP TABLE plebs;
DROP TABLE elita;
DROP TABLE konta;
DROP TABLE incydenty;
DROP TYPE BODY KONTO;
DROP TYPE KONTO;
DROP TYPE BODY INCYDENT;
DROP TYPE INCYDENT;
DROP TYPE BODY CZLONEK_ELITY;
DROP TYPE CZLONEK_ELITY;
DROP TYPE BODY CZLONEK_PLEBSU;
DROP TYPE CZLONEK_PLEBSU;
DROP TYPE BODY KOCUR;
DROP TYPE KOCUR;


CREATE OR REPLACE TYPE KOCUR AS OBJECT (
  imie            VARCHAR2(15),
  plec            VARCHAR2(1),
  pseudo          VARCHAR2(15),
  funkcja         VARCHAR2(10),
  szef            REF KOCUR,
  w_stadku_od     DATE,
  przydzial_myszy NUMBER(3),
  myszy_extra     NUMBER(3),
  nr_bandy        NUMBER(3),

  MAP MEMBER FUNCTION porownaj_po_pseudo RETURN VARCHAR2,
  MEMBER FUNCTION nazwa RETURN VARCHAR2,
  MEMBER FUNCTION dochod_myszowy RETURN NUMBER,
  MEMBER FUNCTION ile_miesiecy_w_stadku RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY KOCUR
AS
  MAP MEMBER FUNCTION porownaj_po_pseudo RETURN VARCHAR2
  IS
  BEGIN
    RETURN pseudo;
  END;

  MEMBER FUNCTION nazwa RETURN VARCHAR2
  IS
  BEGIN
    RETURN imie || ' (' || pseudo || ')';
  END;

  MEMBER FUNCTION dochod_myszowy RETURN NUMBER
  IS
  BEGIN
    RETURN NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0);
  END;

  MEMBER FUNCTION ile_miesiecy_w_stadku RETURN NUMBER
  IS
    tmp NUMBER;
  BEGIN
    SELECT EXTRACT(MONTH FROM w_stadku_od) INTO tmp FROM DUAL;
    RETURN tmp;
  END;
END;
/

CREATE TABLE obj_kocury OF KOCUR (
  imie        CONSTRAINT oko_imie_nn NOT NULL,
  plec        CONSTRAINT oko_plec_ch CHECK(plec IN ('M', 'D')),
  pseudo      CONSTRAINT oko_pk PRIMARY KEY,
  funkcja     CONSTRAINT oko_fun_funkcja_fk REFERENCES funkcje(funkcja),
  szef        SCOPE IS obj_kocury,
  w_stadku_od DEFAULT SYSDATE,
  nr_bandy    CONSTRAINT oko_ban_nr_bandy_fk REFERENCES bandy(nr_bandy)
);
/


CREATE OR REPLACE TYPE CZLONEK_PLEBSU UNDER KOCUR (
  OVERRIDING MEMBER FUNCTION nazwa RETURN VARCHAR2,
  MEMBER FUNCTION czy_bardzo_biedny RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE BODY CZLONEK_PLEBSU
AS
  OVERRIDING MEMBER FUNCTION nazwa RETURN VARCHAR2
  IS
  BEGIN
    RETURN 'Plebejusz ' || (SELF AS KOCUR).nazwa;
  END;

  MEMBER FUNCTION czy_bardzo_biedny RETURN BOOLEAN
  IS
  BEGIN
    RETURN SELF.myszy_extra IS NULL;
  END;
END;
/

CREATE TABLE plebs OF CZLONEK_PLEBSU (
  imie        CONSTRAINT ple_imie_nn NOT NULL,
  plec        CONSTRAINT ple_plec_ch CHECK(plec IN ('M', 'D')),
  pseudo      CONSTRAINT ple_pk PRIMARY KEY,
  funkcja     CONSTRAINT ple_fun_funkcja_fk REFERENCES funkcje(funkcja),
  szef        SCOPE IS obj_kocury,
  w_stadku_od DEFAULT SYSDATE,
  nr_bandy    CONSTRAINT ple_ban_nr_bandy_fk REFERENCES bandy(nr_bandy)
);
/


CREATE OR REPLACE TYPE CZLONEK_ELITY UNDER KOCUR (
  sluga REF CZLONEK_PLEBSU,
  
  OVERRIDING MEMBER FUNCTION nazwa RETURN VARCHAR2,
  MEMBER FUNCTION czy_bardzo_bogaty RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE BODY CZLONEK_ELITY
AS
  OVERRIDING MEMBER FUNCTION nazwa RETURN VARCHAR2
  IS
  BEGIN
    RETURN 'Partycjusz ' || (SELF AS KOCUR).nazwa;
  END;

  MEMBER FUNCTION czy_bardzo_bogaty RETURN BOOLEAN
  IS
  BEGIN
    RETURN SELF.myszy_extra IS NOT NULL;
  END;
END;
/

CREATE TABLE elita OF CZLONEK_ELITY (
  imie        CONSTRAINT eli_imie_nn NOT NULL,
  plec        CONSTRAINT eli_plec_ch CHECK(plec IN ('M', 'D')),
  pseudo      CONSTRAINT eli_pk PRIMARY KEY,
  funkcja     CONSTRAINT eli_fun_funkcja_fk REFERENCES funkcje(funkcja),
  szef        SCOPE IS obj_kocury,
  w_stadku_od DEFAULT SYSDATE,
  nr_bandy    CONSTRAINT eli_ban_nr_bandy_fk REFERENCES bandy(nr_bandy),
  sluga       SCOPE IS plebs
);
/


CREATE OR REPLACE TYPE KONTO AS OBJECT (
  nr_konta             NUMBER(3),
  wlasciciel           REF CZLONEK_ELITY, 
  data_dodania_myszy   DATE, 
  data_usuniecia_myszy DATE,
  
  MEMBER FUNCTION czy_puste RETURN BOOLEAN,
  MEMBER FUNCTION jak_dlugo_zapelnione RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY KONTO
AS
  MEMBER FUNCTION czy_puste RETURN BOOLEAN IS
  BEGIN
    RETURN data_dodania_myszy IS NOT NULL AND data_usuniecia_myszy IS NULL;
  END;

  MEMBER FUNCTION jak_dlugo_zapelnione RETURN NUMBER IS
  BEGIN
    IF data_dodania_myszy IS NOT NULL THEN
      RETURN NVL(data_usuniecia_myszy, SYSDATE) - data_dodania_myszy;
    ELSE
      RETURN 0;
    END IF;
  END;
END;
/

CREATE TABLE konta OF KONTO (
  nr_konta           CONSTRAINT kon_pk PRIMARY KEY,
  wlasciciel         SCOPE IS elita
                     CONSTRAINT kon_wlasciciel_nn NOT NULL,
  data_dodania_myszy CONSTRAINT kon_data_dodania_myszy_nn NOT NULL,
  CONSTRAINT kon_dates_ch CHECK(data_usuniecia_myszy >= data_dodania_myszy)
);
/


CREATE OR REPLACE TYPE INCYDENT AS OBJECT (
  nr_incydentu   NUMBER(3),
  ofiara         REF KOCUR,
  imie_wroga     VARCHAR2(15), 
  data_incydentu DATE,
  opis_incydentu VARCHAR2(50),
  
  MEMBER FUNCTION jak_dawno_popelniony RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY INCYDENT AS
  MEMBER FUNCTION jak_dawno_popelniony RETURN NUMBER
  IS
  BEGIN
    RETURN SYSDATE - data_incydentu;
  END;
END;
/

CREATE TABLE incydenty OF INCYDENT (
  nr_incydentu       CONSTRAINT inc_pk PRIMARY KEY,
  ofiara             SCOPE IS obj_kocury,
  imie_wroga         CONSTRAINT inc_wro_imie_wroga_fk REFERENCES wrogowie(imie_wroga),
  data_incydentu     CONSTRAINT inc_data_incydentu_nn NOT NULL
);
/


CREATE OR REPLACE TRIGGER dodawanie_kocura_z_elity
BEFORE INSERT ON elita
FOR EACH ROW
BEGIN
    INSERT INTO obj_kocury(imie, plec, pseudo, szef, funkcja, w_stadku_od, przydzial_myszy, myszy_extra, nr_bandy)
    VALUES (:NEW.imie, :NEW.plec, :NEW.pseudo, :NEW.szef, :NEW.funkcja, :NEW.w_stadku_od, :NEW.przydzial_myszy, :NEW.myszy_extra, :NEW.nr_bandy);
END;
/

CREATE OR REPLACE TRIGGER modyfikowanie_kocura_z_elity
AFTER UPDATE ON elita
FOR EACH ROW
BEGIN
    UPDATE obj_kocury k
       SET k.imie = :new.imie, k.plec = :new.plec, k.w_stadku_od = :new.w_stadku_od, k.przydzial_myszy = :new.przydzial_myszy,
           myszy_extra = :new.myszy_extra, k.szef = :new.szef, k.funkcja = :new.funkcja, k.nr_bandy = :new.nr_bandy
     WHERE pseudo = :new.pseudo;
END;
/

CREATE OR REPLACE TRIGGER usuwanie_kocura_z_elity
BEFORE DELETE ON elita
FOR EACH ROW
BEGIN
    DELETE FROM obj_kocury k
     WHERE k.pseudo = :old.pseudo;
END;
/

CREATE OR REPLACE TRIGGER dodawanie_kocura_z_plebsu
BEFORE INSERT ON plebs
FOR EACH ROW
BEGIN
    INSERT INTO obj_kocury(imie, plec, pseudo, szef, funkcja, w_stadku_od, przydzial_myszy, myszy_extra, nr_bandy)
    VALUES (:NEW.imie, :NEW.plec, :NEW.pseudo, :NEW.szef, :NEW.funkcja, :NEW.w_stadku_od, :NEW.przydzial_myszy, :NEW.myszy_extra, :NEW.nr_bandy);
END;
/

CREATE OR REPLACE TRIGGER modyfikowanie_kocura_z_plebsu
AFTER UPDATE ON plebs
FOR EACH ROW
BEGIN
    UPDATE obj_kocury k
       SET k.imie = :new.imie, k.plec = :new.plec, k.w_stadku_od = :new.w_stadku_od, k.przydzial_myszy = :new.przydzial_myszy,
           myszy_extra = :new.myszy_extra, k.szef = :new.szef, k.funkcja = :new.funkcja, k.nr_bandy = :new.nr_bandy
     WHERE pseudo = :new.pseudo;
END;
/

CREATE OR REPLACE TRIGGER usuwanie_kocura_z_plebsu
BEFORE DELETE ON plebs
FOR EACH ROW
BEGIN
    DELETE FROM obj_kocury k
     WHERE k.pseudo = :old.pseudo;
END;
/


INSERT ALL
  INTO plebs VALUES (CZLONEK_PLEBSU('ZUZIA',   'D', 'SZYBKA',   'LOWCZY',   (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'LYSY'),   '2006-07-21', 65, NULL, 2))
  INTO plebs VALUES (CZLONEK_PLEBSU('CHYTRY',  'M', 'BOLEK',    'DZIELCZY', (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'), '2002-05-05', 50, NULL, 1))
  INTO plebs VALUES (CZLONEK_PLEBSU('BELA',    'D', 'LASKA',    'MILUSIA',  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'LYSY'),   '2008-02-01', 24, 28,   2))
  INTO plebs VALUES (CZLONEK_PLEBSU('KSAWERY', 'M', 'MAN',      'LAPACZ',   (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'RAFA'),   '2008-07-12', 51, NULL, 4))
  INTO plebs VALUES (CZLONEK_PLEBSU('MELA',    'D', 'DAMA',     'LAPACZ',   (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'RAFA'),   '2008-11-01', 51, NULL, 4))
  INTO plebs VALUES (CZLONEK_PLEBSU('JACEK',   'M', 'PLACEK',   'LOWCZY',   (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'LYSY'),   '2008-12-01', 67, NULL, 2))
  INTO plebs VALUES (CZLONEK_PLEBSU('BARI',    'M', 'RURA',     'LAPACZ',   (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'LYSY'),   '2009-09-01', 56, NULL, 2))
  INTO plebs VALUES (CZLONEK_PLEBSU('LUCEK',   'M', 'ZERO',     'KOT',      (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'KURKA'),  '2010-03-01', 43, NULL, 3))
  INTO plebs VALUES (CZLONEK_PLEBSU('SONIA',   'D', 'PUSZYSTA', 'MILUSIA',  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'ZOMBI'),  '2010-11-18', 20, 35,   3))
  INTO plebs VALUES (CZLONEK_PLEBSU('LATKA',   'D', 'UCHO',     'KOT',      (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'RAFA'),   '2011-01-01', 40, NULL, 4))
  INTO plebs VALUES (CZLONEK_PLEBSU('DUDEK',   'M', 'MALY',     'KOT',      (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'RAFA'),   '2011-05-15', 40, NULL, 4))
  INTO plebs VALUES (CZLONEK_PLEBSU('RUDA',    'D', 'MALA',     'MILUSIA',  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'), '2006-09-17', 22, 42,   1))
SELECT * FROM DUAL;

INSERT ALL
  INTO elita VALUES (CZLONEK_ELITY('MRUCZEK', 'M', 'TYGRYS',   'SZEFUNIO', NULL,                                                        '2002-01-01', 103, 33,  1, (SELECT REF(p) FROM plebs p WHERE p.pseudo = 'DAMA')))
  INTO elita VALUES (CZLONEK_ELITY('MICKA',   'D', 'LOLA',     'MILUSIA',  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'), '2009-10-14', 25, 47,   1, (SELECT REF(p) FROM plebs p WHERE p.pseudo = 'PUSZYSTA')))
  INTO elita VALUES (CZLONEK_ELITY('KOREK',   'M', 'ZOMBI',    'BANDZIOR', (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'), '2004-03-16', 75, 13,   3, (SELECT REF(p) FROM plebs p WHERE p.pseudo = 'MAN')))
  INTO elita VALUES (CZLONEK_ELITY('BOLEK',   'M', 'LYSY',     'BANDZIOR', (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'), '2006-08-15', 72, 21,   2, (SELECT REF(p) FROM plebs p WHERE p.pseudo = 'SZYBKA')))
  INTO elita VALUES (CZLONEK_ELITY('PUNIA',   'D', 'KURKA',    'LOWCZY',   (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'ZOMBI'),  '2008-01-01', 61, NULL, 3, (SELECT REF(p) FROM plebs p WHERE p.pseudo = 'UCHO')))
  INTO elita VALUES (CZLONEK_ELITY('PUCEK',   'M', 'RAFA',     'LOWCZY',   (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'), '2006-10-15', 65, NULL, 4, (SELECT REF(p) FROM plebs p WHERE p.pseudo = 'RURA')))
SELECT * FROM DUAL;

INSERT ALL
  INTO konta VALUES (KONTO(0,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'TYGRYS'), SYSDATE, NULL))
  INTO konta VALUES (KONTO(1,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'LOLA'),   SYSDATE, NULL))
  INTO konta VALUES (KONTO(2,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'ZOMBI'),  SYSDATE, NULL))
  INTO konta VALUES (KONTO(3,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'LYSY'),   SYSDATE, NULL))
  INTO konta VALUES (KONTO(4,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'KURKA'),  SYSDATE, NULL))
  INTO konta VALUES (KONTO(5,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'RAFA'),   SYSDATE, NULL))
  INTO konta VALUES (KONTO(6,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'LOLA'),   SYSDATE, NULL))
  INTO konta VALUES (KONTO(7,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'ZOMBI'),  SYSDATE, NULL))
  INTO konta VALUES (KONTO(8,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'LOLA'),   SYSDATE, NULL))
  INTO konta VALUES (KONTO(9,  (SELECT REF(e) FROM elita e WHERE e.pseudo = 'KURKA'),  SYSDATE, NULL))
  INTO konta VALUES (KONTO(10, (SELECT REF(e) FROM elita e WHERE e.pseudo = 'LOLA'),   SYSDATE, NULL))
SELECT * FROM DUAL;

INSERT ALL
  INTO incydenty VALUES (INCYDENT(0,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'),   'KAZIO',          '2004-10-13', 'USILOWAL NABIC NA WIDLY'                  ))
  INTO incydenty VALUES (INCYDENT(1,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'ZOMBI'),    'SWAWOLNY DYZIO', '2005-03-07', 'WYBIL OKO Z PROCY'                        ))
  INTO incydenty VALUES (INCYDENT(2,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'BOLEK'),    'KAZIO',          '2005-03-29', 'POSZCZUL BURKIEM'                         ))
  INTO incydenty VALUES (INCYDENT(3,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'SZYBKA'),   'GLUPIA ZOSKA',   '2006-09-12', 'UZYLA KOTA JAKO SCIERKI'                  ))
  INTO incydenty VALUES (INCYDENT(4,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'MALA'),     'CHYTRUSEK',      '2007-03-07', 'ZALECAL SIE'                              ))
  INTO incydenty VALUES (INCYDENT(5,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'TYGRYS'),   'DZIKI BILL',     '2007-06-12', 'USILOWAL POZBAWIC ZYCIA'                  ))
  INTO incydenty VALUES (INCYDENT(6,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'BOLEK'),    'DZIKI BILL',     '2007-11-10', 'ODGRYZL UCHO'                             ))
  INTO incydenty VALUES (INCYDENT(7,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'LASKA'),    'DZIKI BILL',     '2008-12-12', 'POGRYZL ZE LEDWO SIE WYLIZALA'            ))
  INTO incydenty VALUES (INCYDENT(8,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'LASKA'),    'KAZIO',          '2009-01-07', 'ZLAPAL ZA OGON I ZROBIL WIATRAK'          ))
  INTO incydenty VALUES (INCYDENT(9,  (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'DAMA'),     'KAZIO',          '2009-02-07', 'CHCIAL OBEDRZEC ZE SKORY'                 ))
  INTO incydenty VALUES (INCYDENT(10, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'MAN'),      'REKSIO',         '2009-04-14', 'WYJATKOWO NIEGRZECZNIE OBSZCZEKAL'        ))
  INTO incydenty VALUES (INCYDENT(11, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'LYSY'),     'BETHOVEN',       '2009-05-11', 'NIE PODZIELIL SIE SWOJA KASZA'            ))
  INTO incydenty VALUES (INCYDENT(12, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'RURA'),     'DZIKI BILL',     '2009-09-03', 'ODGRYZL OGON'                             ))
  INTO incydenty VALUES (INCYDENT(13, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'PLACEK'),   'BAZYLI',         '2010-07-12', 'DZIOBIAC UNIEMOZLIWIL PODEBRANIE KURCZAKA'))
  INTO incydenty VALUES (INCYDENT(14, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'PUSZYSTA'), 'SMUKLA',         '2010-11-19', 'OBRZUCILA SZYSZKAMI'                      ))
  INTO incydenty VALUES (INCYDENT(15, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'KURKA'),    'BUREK',          '2010-12-14', 'POGONIL'                                  ))
  INTO incydenty VALUES (INCYDENT(16, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'MALY'),     'CHYTRUSEK',      '2011-07-13', 'PODEBRAL PODEBRANE JAJKA'                 ))
  INTO incydenty VALUES (INCYDENT(17, (SELECT REF(k) FROM obj_kocury k WHERE k.pseudo = 'UCHO'),     'SWAWOLNY DYZIO', '2011-07-14', 'OBRZUCIL KAMIENIAMI'                      ))
SELECT * FROM DUAL;
