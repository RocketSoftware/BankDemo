DROP TABLE BNKCUST;
COMMIT;

CREATE TABLE BNKCUST
(
    BCS_PID                   CHAR(5) NOT NULL,
    BCS_NAME                  CHAR(25) NOT NULL,
    BCS_NAME_FF               CHAR(25) NOT NULL,
    BCS_SIN                   CHAR(9) NOT NULL WITH DEFAULT,
    BCS_ADDR1                 CHAR(25) NOT NULL WITH DEFAULT,
    BCS_ADDR2                 CHAR(25) NOT NULL WITH DEFAULT,
    BCS_STATE                 CHAR(2) NOT NULL WITH DEFAULT,
    BCS_COUNTRY               CHAR(6) NOT NULL WITH DEFAULT,
    BCS_POST_CODE             CHAR(6) NOT NULL WITH DEFAULT,
    BCS_TEL                   CHAR(12) NOT NULL WITH DEFAULT,
    BCS_EMAIL                 CHAR(30) NOT NULL WITH DEFAULT,
    BCS_SEND_MAIL             CHAR(1) NOT NULL WITH DEFAULT,
    BCS_SEND_EMAIL            CHAR(1) NOT NULL WITH DEFAULT,
    BCS_ATM_PIN               CHAR(4) NOT NULL WITH DEFAULT,
    BCS_PRINTER1_NETNAME      CHAR(8) NOT NULL WITH DEFAULT,
    BCS_PRINTER2_NETNAME      CHAR(8) NOT NULL WITH DEFAULT,
    BCS_FILLER                CHAR(58) NOT NULL WITH DEFAULT,
    PRIMARY KEY (BCS_PID)
);
--IN DATABASE DBNASE
--AUDIT NONE
--DATA CAPTURE NONE;

CREATE UNIQUE INDEX BNKCUST_IDX1 ON BNKCUST
(
     BCS_PID
);

CREATE INDEX BNKCUST_IDX2 ON BNKCUST
(
     BCS_NAME
);

CREATE INDEX BNKCUST_IDX3 ON BNKCUST
(
     BCS_NAME_FF
);

INSERT INTO BNKCUST VALUES
  ('BANK ','The Bank                 ',' ',
   '999999999',
   '                         ',
   '                         ',
   '  ',
   '      ',
   '      ',
   '800-555-1212',
   'bank@bankdemo.ca',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0001','Fred Bloggs              ',' ',
   '123456789',
   '722 Parkland Ave         ',
   'Mississauga              ',
   'ON',
   'Canada',
   'L5H3G8',
   '800-555-1234',
   'B0001@bankdemo.ca',
   'N','N','0001',' ',' ',' ');
INSERT INTO BNKCUST VALUES
  ('B0002','Loretta Morden           ',' ',
   '198463794',
   '22 Silver Springs Mews NW',
   'Calgary                  ',
   'AB',
   'Canada',
   'T3B3R3',
   '800-555-3854',
   ' ',
   'N','N','0002',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0003','Eleanor Rigby            ',' ',
   '493768396',
   '5 Folcroft Ave           ',
   'Toronto                  ',
   'ON',
   'Canada',
   'M1N1K7',
   '800-555-3857',
   'B0003@bankdemo.ca',
   'N','N','0003',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0004','Desmond Jones            ',' ',
   '329471287',
   '675 Otter Cres           ',
   'Prince George            ',
   'BC',
   'Canada',
   'V2M5G8',
   '800-555-1029',
   'B0004@bankdemo.ca',
   'N','N','0004','P1','P2',' ');

INSERT INTO BNKCUST VALUES
  ('B0005','Felicity Arkwright       ',' ',
   '918746356',
   '910 Des Pins Rue         ',
   'Mascouche                ',
   'QC',
   'Canada',
   'J7L1J3',
   '800-555-8275',
   ' ',
   'N','N','0005',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0006','James Tiberius Kirk      ',' ',
   '111222333',
   '12057 Pierre Blanchet Av ',
   'Montreal                 ',
   'QC',
   'Canada',
   'H1E3P3',
   '800-555-1701',
   'B0006@bankdemo.ca',
   'N','N','0006',' ',' ',' ');
  
INSERT INTO BNKCUST VALUES
  ('B0007','Mark Thyme               ',' ',
   '837567892',
   '21 Carson Ave            ',
   'St. John"s               ',
   'NF',
   'Canada',
   'A1E1R9',
   '800-555-4434',
   'B0007@bankdemo.ca',
   'N','N','0007',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0008','Timothy Haye             ',' ',
   '910587636',
   '300 Willow St            ',
   'Newcastle                ',
   'NB',
   'Canada',
   'E1V2Z9',
   '800-555-9910',
   ' ',
   'N','N','0008',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0009','Herr Barber              ',' ',
   '987654321',
   '5900 Atlantic St         ',
   'Halifax                  ',
   'NS',
   'Canada',
   'B3H1H2',
   '800-555-8745',
   ' ',
   'N','N','0009',' ',' ',' ');
   
INSERT INTO BNKCUST VALUES
  ('B0010','Barbara Allen            ',' ',
   '758643565',
   '62 Hazlewood Cres        ',
   'Brandon                  ',
   'MB',
   'Canada',
   'R7A2J9',
   '800-555-9637',
   ' ',
   'N','N','0010',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0011','Ben Doone                ',' ',
   '843298706',
   '140 Livingstone St       ',
   'Yorkton                  ',
   'SK',
   'Canada',
   'S3N3A8',
   '800-555-9543',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0012','Molly Malone             ',' ',
   '987456875',
   '730 Nightingale Cres     ',
   'Summerside               ',
   'PE',
   'Canada',
   'C1N4S8',
   '800-555-1625',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0013','Mary Q. Contrary         ',' ',
   '764638765',
   '224 Kirkland Place       ',
   'Roxboro                  ',
   'QC',
   'Canada',
   'H9J2C7',
   '800-555-3474',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0014','Lucy Locket              ',' ',
   '999888777',
   '657 Oak St               ',
   'Collingwood              ',
   'ON',
   'Canada',
   'L9Y2Z7',
   '800-555-9988',
   'B0014@bankdemo.ca',
   'N','N','0014',' ',' ',' ');
   
INSERT INTO BNKCUST VALUES
  ('B0015','Kitty Fisher             ',' ',
   '778657766',
   '401 Coronation Ave       ',
   'Duncan                   ',
   'BC',
   'Canada',
   'V9L2T4',
   '888-555-7745',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0016','Simon Templar            ',' ',
   '792846734',
   '796 Pinegrove Cres       ',
   'Pembroke                 ',
   'ON',
   'Canada',
   'K8A7E5',
   '888-555-0192',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0017','Ben Casey                ',' ',
   '992887655',
   '25 Middle Camp Cres      ',
   'Yellowknife              ',
   'NT',
   'Canada',
   'X1A3C3',
   '888-555-9946',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0018','Quentin Jergens          ',' ',
   '886775663',
   '8 Pinsent Drive          ',
   'Grand Falls              ',
   'NF',
   'Canada',
   '2A22R6',
   '888-555-3366',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0019','Chester Field            ',' ',
   '118877645',
   '242 Oliver Ave           ',
   'Selkirk                  ',
   'MB',
   'Canada',
   'R1A1H5',
   '888-555-7456',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0020','Michelle Mabelle         ',' ',
   '775564355',
   '190 Queen St S           ',
   'Renfrew                  ',
   'ON',
   'Canada',
   'K7V2B2',
   '888-555-1653',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0021','Casey Jones              ',' ',
   '774553668',
   '4 Eriskay Place          ',
   'Rothesay                 ',
   'NB',
   'Canada',
   'E2E3H5',
   '877-555-7734',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0022','Mary Jane Lucas          ',' ',
   '798781594',
   '125 Shawglen Rd SW       ',
   'Calgary                  ',
   'AB',
   'Canada',
   'T2Y1X6',
   '877-555-3857',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0023','Florence Bland          ',' ',
   '197630586',
   '4491 South Crescent      ',
   'Port Alberni             ',
   'BC',
   'Canada',
   'V9Y1L8',
   '877-555-1728',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0024','Michael Waterhole        ',' ',
   '876459273',
   '21 Binscarth Rd          ',
   'Toronto                  ',
   'ON',
   'Canada',
   'M4W1Y2',
   '877-555-3927',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0025','Robin Zegg               ',' ',
   '640298644',
   '37 Rockwood St           ',
   'Ottawa                   ',
   'ON',
   'Canada',
   'K1N8L8',
   '877-555-2956',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0026','Fred Bear                ',' ',
   '294856372',
   '27 Hess St N             ',
   'Hamilton                 ',
   'ON',
   'Canada',
   'L8R2S5',
   '877-555-0012',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0027','Mavis Hatty              ',' ',
   '847364821',
   '17 Fort Sackville Rd     ',
   'Bedford                  ',
   'NS',
   'Canada',
   'B4A2G6',
   '877-555-7739',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0028','Malcolm Beamish          ',' ',
   '384508237',
   'Des Pins Rue             ',
   'Beloeil                  ',
   'QC',
   'Canada',
   'J3G3E9',
   '877-555-9822',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0029','John Jacob Schmidt       ',' ',
   '592759291',
   '29 Graham Ave            ',
   'St Albert                ',
   'AB',
   'Canada',
   'T8N1T4',
   '877-555-9337',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0030','Adam Firstman            ',' ',
   '887464820',
   '189 Short St             ',
   'Simcoe                   ',
   'ON',
   'Canada',
   'N3Y3E1',
   '877-555-5592',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0031','John Smith               ',' ',
   '337566986',
   '52 Forrest St            ',
   'Sydney Mines             ',
   'NS',
   'Canada',
   'B1V2B5',
   '877-555-8846',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0032','Mary Ann Jones           ',' ',
   '773554266',
   '1205 Fir St              ',
   'Whitehorse               ',
   'YT',
   'Canada',
   'Y1A4C3',
   '877-555-9952',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0033','James Fraser             ',' ',
   '448669567',
   '770 Elm Rue E            ',
   'Farnham                  ',
   'QC',
   'Canada',
   'J2N1E6',
   '877-555-3385',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0034','Gordon MacKenzie         ',' ',
   '559843326',
   '6775 Eagles Drive        ',
   'Vancouver                ',
   'BC',
   'Canada',
   'V5E4C1',
   '877-555-7777',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0035','Susan Patel              ',' ',
   '005438876',
   '1302 Rex St              ',
   'Sarnia                   ',
   'ON',
   'Canada',
   'N7V3N3',
   '877-555-5566',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('B0036','James Coleburn           ',' ',
   '483948347',
   '85 Spruce Ave            ',
   'Shawinigan               ',
   'QC',
   'Canada',
   'G9N1P9',
   '877-555-8327',
   ' ',
   'N','N',' ',' ',' ',' ');

INSERT INTO BNKCUST VALUES
  ('T0001','Desmond Jones            ',' ',
   '111111111',
   '675 Otter Cres           ',
   'Prince George            ',
   'BC',
   'Canada',
   'V2M5G8',
   '800-555-1029',
   ' ',
   'N','N',' ',' ',' ',' ');

COMMIT;

