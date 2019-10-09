DROP TABLE wrogowie_kocurow;
DROP TABLE wrogowie;
ALTER TABLE bandy
    DROP CONSTRAINT ban_koc_pseudo_fk;
DROP TABLE kocury;
DROP TABLE bandy;
DROP TABLE funkcje;

CREATE TABLE bandy (
    nr_bandy   NUMBER(2)
               CONSTRAINT ban_pk PRIMARY KEY,
    nazwa      VARCHAR2(20)
               CONSTRAINT ban_nazwa_nn NOT NULL,
    teren      VARCHAR2(15)
               CONSTRAINT ban_nazwa_uq UNIQUE,
    szef_bandy VARCHAR2(15)
               CONSTRAINT ban_szef_bandy_uq UNIQUE
);

CREATE TABLE funkcje (
    funkcja   VARCHAR2(10)
              CONSTRAINT fun_pk PRIMARY KEY,
    min_myszy NUMBER(3)
              CONSTRAINT fun_min_myszy_ch CHECK(min_myszy > 5),
    max_myszy NUMBER(3)
              CONSTRAINT fun_max_myszy_upper_ch CHECK(max_myszy < 200),
    CONSTRAINT fun_max_myszy_lower_ch CHECK(max_myszy >= min_myszy)
);

CREATE TABLE wrogowie (
    imie_wroga       VARCHAR2(15)
                     CONSTRAINT wro_pk PRIMARY KEY,
    stopien_wrogosci NUMBER(2)
                     CONSTRAINT wro_stopien_wrogosci_ch CHECK(stopien_wrogosci BETWEEN 1 AND 10),
    gatunek          VARCHAR2(15),
    lapowka          VARCHAR2(20)
);

CREATE TABLE kocury (
    imie            VARCHAR2(15)
                    CONSTRAINT koc_imie_nn NOT NULL,
    plec            VARCHAR2(1)
                    CONSTRAINT koc_plec_ch CHECK(plec IN ('M', 'D')),
    pseudo          VARCHAR2(15)
                    CONSTRAINT koc_pk PRIMARY KEY,
    funkcja         VARCHAR2(10)
                    CONSTRAINT koc_fun_funkcja_fk REFERENCES funkcje(funkcja),
    szef            VARCHAR2(15)
                    CONSTRAINT koc_koc_pseudo_fk REFERENCES kocury(pseudo),
    w_stadku_od     DATE
                    DEFAULT SYSDATE,
    przydzial_myszy NUMBER(3),
    myszy_extra     NUMBER(3),
    nr_bandy        NUMBER(3)
                    CONSTRAINT koc_ban_nr_bandy_fk REFERENCES bandy(nr_bandy)
);

CREATE TABLE wrogowie_kocurow (
    pseudo         VARCHAR2(15)
                   CONSTRAINT wrk_koc_pseudo_fk REFERENCES kocury(pseudo),
    imie_wroga     VARCHAR2(15)
                   CONSTRAINT wrk_wro_imie_wroga_fk REFERENCES wrogowie(imie_wroga),
    data_incydentu DATE
                   CONSTRAINT wrk_data_incydentu_nn NOT NULL,
    opis_incydentu VARCHAR2(50),
    CONSTRAINT wrk_pk PRIMARY KEY (pseudo, imie_wroga)
);

INSERT ALL
  INTO bandy VALUES (1, 'SZEFOSTWO',       'CALOSC',  'TYGRYS')
  INTO bandy VALUES (2, 'CZARNI RYCERZE',  'POLE',    'LYSY'  )
  INTO bandy VALUES (3, 'BIALI LOWCY',     'SAD',     'ZOMBI' )
  INTO bandy VALUES (4, 'LACIACI MYSLIWI', 'GORKA',   'RAFA'  )
  INTO bandy VALUES (5, 'ROCKERSI',        'ZAGRODA', NULL    )
SELECT * FROM DUAL;

INSERT ALL
  INTO funkcje VALUES ('SZEFUNIO', 90, 110)
  INTO funkcje VALUES ('BANDZIOR', 70, 90 )
  INTO funkcje VALUES ('LOWCZY',   60, 70 )
  INTO funkcje VALUES ('LAPACZ',   50, 60 )
  INTO funkcje VALUES ('KOT',      40, 50 )
  INTO funkcje VALUES ('MILUSIA',  20, 30 )
  INTO funkcje VALUES ('DZIELCZY', 45, 55 )
  INTO funkcje VALUES ('HONOROWA', 6,  25 )
SELECT * FROM DUAL;

INSERT ALL
  INTO wrogowie VALUES ('KAZIO',          10, 'CZLOWIEK', 'FLASZKA'      )
  INTO wrogowie VALUES ('GLUPIA ZOSKA',   1,  'CZLOWIEK', 'KORALIK'      )
  INTO wrogowie VALUES ('SWAWOLNY DYZIO', 7,  'CZLOWIEK', 'GUMA DO ZUCIA')
  INTO wrogowie VALUES ('BUREK',          4,  'PIES',     'KOSC'         )
  INTO wrogowie VALUES ('DZIKI BILL',     10, 'PIES',     NULL           )
  INTO wrogowie VALUES ('REKSIO',         2,  'PIES',     'KOSC'         )
  INTO wrogowie VALUES ('BETHOVEN',       1,  'PIES',     'PEDIGRIPALL'  )
  INTO wrogowie VALUES ('CHYTRUSEK',      5,  'LIS',      'KURCZAK'      )
  INTO wrogowie VALUES ('SMUKLA',         1,  'SOSNA',    NULL           )
  INTO wrogowie VALUES ('BAZYLI',         3,  'KOGUT',    'KURA DO STADA')
SELECT * FROM DUAL;

INSERT ALL
  INTO kocury VALUES ('MRUCZEK', 'M', 'TYGRYS',   'SZEFUNIO', NULL,     '2002-01-01', 103, 33,  1)
  INTO kocury VALUES ('BOLEK',   'M', 'LYSY',     'BANDZIOR', 'TYGRYS', '2006-08-15', 72, 21,   2)
  INTO kocury VALUES ('JACEK',   'M', 'PLACEK',   'LOWCZY',   'LYSY',   '2008-12-01', 67, NULL, 2)
  INTO kocury VALUES ('BARI',    'M', 'RURA',     'LAPACZ',   'LYSY',   '2009-09-01', 56, NULL, 2)
  INTO kocury VALUES ('MICKA',   'D', 'LOLA',     'MILUSIA',  'TYGRYS', '2009-10-14', 25, 47,   1)
  INTO kocury VALUES ('KOREK',   'M', 'ZOMBI',    'BANDZIOR', 'TYGRYS', '2004-03-16', 75, 13,   3)
  INTO kocury VALUES ('PUNIA',   'D', 'KURKA',    'LOWCZY',   'ZOMBI',  '2008-01-01', 61, NULL, 3)
  INTO kocury VALUES ('LUCEK',   'M', 'ZERO',     'KOT',      'KURKA',  '2010-03-01', 43, NULL, 3)
  INTO kocury VALUES ('SONIA',   'D', 'PUSZYSTA', 'MILUSIA',  'ZOMBI',  '2010-11-18', 20, 35,   3)
  INTO kocury VALUES ('PUCEK',   'M', 'RAFA',     'LOWCZY',   'TYGRYS', '2006-10-15', 65, NULL, 4)
  INTO kocury VALUES ('LATKA',   'D', 'UCHO',     'KOT',      'RAFA',   '2011-01-01', 40, NULL, 4)
  INTO kocury VALUES ('DUDEK',   'M', 'MALY',     'KOT',      'RAFA',   '2011-05-15', 40, NULL, 4)
  INTO kocury VALUES ('CHYTRY',  'M', 'BOLEK',    'DZIELCZY', 'TYGRYS', '2002-05-05', 50, NULL, 1)
  INTO kocury VALUES ('ZUZIA',   'D', 'SZYBKA',   'LOWCZY',   'LYSY',   '2006-07-21', 65, NULL, 2)
  INTO kocury VALUES ('RUDA',    'D', 'MALA',     'MILUSIA',  'TYGRYS', '2006-09-17', 22, 42,   1)
  INTO kocury VALUES ('BELA',    'D', 'LASKA',    'MILUSIA',  'LYSY',   '2008-02-01', 24, 28,   2)
  INTO kocury VALUES ('KSAWERY', 'M', 'MAN',      'LAPACZ',   'RAFA',   '2008-07-12', 51, NULL, 4)
  INTO kocury VALUES ('MELA',    'D', 'DAMA',     'LAPACZ',   'RAFA',   '2008-11-01', 51, NULL, 4)
SELECT * FROM DUAL;

INSERT ALL
  INTO wrogowie_kocurow VALUES ('TYGRYS',   'KAZIO',          '2004-10-13', 'USILOWAL NABIC NA WIDLY'                  )
  INTO wrogowie_kocurow VALUES ('ZOMBI',    'SWAWOLNY DYZIO', '2005-03-07', 'WYBIL OKO Z PROCY'                        )
  INTO wrogowie_kocurow VALUES ('BOLEK',    'KAZIO',          '2005-03-29', 'POSZCZUL BURKIEM'                         )
  INTO wrogowie_kocurow VALUES ('SZYBKA',   'GLUPIA ZOSKA',   '2006-09-12', 'UZYLA KOTA JAKO SCIERKI'                  )
  INTO wrogowie_kocurow VALUES ('MALA',     'CHYTRUSEK',      '2007-03-07', 'ZALECAL SIE'                              )
  INTO wrogowie_kocurow VALUES ('TYGRYS',   'DZIKI BILL',     '2007-06-12', 'USILOWAL POZBAWIC ZYCIA'                  )
  INTO wrogowie_kocurow VALUES ('BOLEK',    'DZIKI BILL',     '2007-11-10', 'ODGRYZL UCHO'                             )
  INTO wrogowie_kocurow VALUES ('LASKA',    'DZIKI BILL',     '2008-12-12', 'POGRYZL ZE LEDWO SIE WYLIZALA'            )
  INTO wrogowie_kocurow VALUES ('LASKA',    'KAZIO',          '2009-01-07', 'ZLAPAL ZA OGON I ZROBIL WIATRAK'          )
  INTO wrogowie_kocurow VALUES ('DAMA',     'KAZIO',          '2009-02-07', 'CHCIAL OBEDRZEC ZE SKORY'                 )
  INTO wrogowie_kocurow VALUES ('MAN',      'REKSIO',         '2009-04-14', 'WYJATKOWO NIEGRZECZNIE OBSZCZEKAL'        )
  INTO wrogowie_kocurow VALUES ('LYSY',     'BETHOVEN',       '2009-05-11', 'NIE PODZIELIL SIE SWOJA KASZA'            )
  INTO wrogowie_kocurow VALUES ('RURA',     'DZIKI BILL',     '2009-09-03', 'ODGRYZL OGON'                             )
  INTO wrogowie_kocurow VALUES ('PLACEK',   'BAZYLI',         '2010-07-12', 'DZIOBIAC UNIEMOZLIWIL PODEBRANIE KURCZAKA')
  INTO wrogowie_kocurow VALUES ('PUSZYSTA', 'SMUKLA',         '2010-11-19', 'OBRZUCILA SZYSZKAMI'                      )
  INTO wrogowie_kocurow VALUES ('KURKA',    'BUREK',          '2010-12-14', 'POGONIL'                                  )
  INTO wrogowie_kocurow VALUES ('MALY',     'CHYTRUSEK',      '2011-07-13', 'PODEBRAL PODEBRANE JAJKA'                 )
  INTO wrogowie_kocurow VALUES ('UCHO',     'SWAWOLNY DYZIO', '2011-07-14', 'OBRZUCIL KAMIENIAMI'                      )
SELECT * FROM DUAL;

-- circular reference workaround
ALTER TABLE bandy
ADD CONSTRAINT ban_koc_pseudo_fk FOREIGN KEY (szef_bandy) REFERENCES kocury(pseudo);
