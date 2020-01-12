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
  SZEF            REF KOCUR,
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
  kocur          REF CZLONEK_ELITY,
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
  imie_wroga         CONSTRAINT inc_wro_imie_wroga_fk REFERENCES wrogowie(imie_wroga),
  data_incydentu     CONSTRAINT inc_data_incydentu_nn NOT NULL
);
/
