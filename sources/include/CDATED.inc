 /****************************************************************
 *
 *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
 *
 ****************************************************************/

 /****************************************************************
 * CDATED.INC
 *---------------------------------------------------------------
 * Area used to pass data to/from date conversion routine
 ****************************************************************/
    05  DD_AREAS,
      10  DD_ENV                              CHAR(4),
        /*  DD_ENV_NULL                       VALUE LOW_VALUES.
        88  DD_ENV_CICS                       VALUE 'CICS'.
        88  DD_ENV_IMS                        VALUE 'IMS'.
        88  DD_ENV_INET                       VALUE 'INET'.*/
      10  DD_TIME_AREAS,
        15  DD_TIME_INPUT                     CHAR(7),
        15  DD_TIME_OUTPUT,
          20  DD_TIME_OUTPUT_HH               CHAR(2),
          20  DD_TIME_OUTPUT_SEP1             CHAR(1),
          20  DD_TIME_OUTPUT_MM               CHAR(2),
          20  DD_TIME_OUTPUT_SEP2             CHAR(1),
          20  DD_TIME_OUTPUT_SS               CHAR(2),
      10  DD_DATE_AREAS,
        15  DD_INPUT,
          20  DDI_TYPE                        CHAR(1),
            /*  DDI_ISO                       VALUE '0'.
            88  DDI_YYYYMMDD                  VALUE '1'.
            88  DDI_YYMMDD                    VALUE '2'.
            88  DDI_YYDDD                     VALUE '3'.*/
          20  DDI_DATA                        CHAR(20),

        15  DD_OUTPUT,
          20  DDO_TYPE                        CHAR(1),
            /*  DDO_DD_MMM_YY                 VALUE '1'.
            88  DDO_DD_MMM_YYYY               VALUE '2'.*/
          20  DDO_DATA                        CHAR(20);

 DCL 1 DD_TIME_INPUT_N BASED(ADDR(DD_TIME_INPUT))
                                              PIC'(7)9';
 DCL 1 DDI_DATA_ISO  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_ISO_YYYY             CHAR(4),
            25  DDI_DATA_ISO_DASH1            CHAR(1),
            25  DDI_DATA_ISO_MM               CHAR(2),
            25  DDI_DATA_ISO_DASH2            CHAR(1),
            25  DDI_DATA_ISO_DD               CHAR(2);
 DCL 1 DDI_DATA_ISO_N  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_ISO_YYYY_N           PIC'9999',
            25  DDI_DATA_ISO_DASH1_N          CHAR(1),
            25  DDI_DATA_ISO_MM_N             PIC'99',
            25  DDI_DATA_ISO_DASH2_N          CHAR(1),
            25  DDI_DATA_ISO_DD_N             PIC'99';
 DCL 1 DDI_DATA_YYYYMMDD  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_YYYYMMDD_YYYY        CHAR(4),
            25  DDI_DATA_YYYYMMDD_MM          CHAR(2),
            25  DDI_DATA_YYYYMMDD_DD          CHAR(2);
 DCL 1 DDI_DATA_YYYYMMDD_N  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_YYYYMMDD_YYYY_N      PIC'9999',
            25  DDI_DATA_YYYYMMDD_MM_N        PIC'99',
            25  DDI_DATA_YYYYMMDD_DD_N        PIC'99';
 DCL 1 DDI_DATA_YYMMDD  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_YYMMDD_YY            CHAR(2),
            25  DDI_DATA_YYMMDD_MM            CHAR(2),
            25  DDI_DATA_YYMMDD_DD            CHAR(2);
 DCL 1 DDI_DATA_YYMMDD_N  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_YYMMDD_YY_N          PIC'99',
            25  DDI_DATA_YYMMDD_MM_N          PIC'99',
            25  DDI_DATA_YYMMDD_DD_N          PIC'99';
 DCL 1 DDI_DATA_YYDDD  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_YYDDD_YYDDD          CHAR(5);
 DCL 1 DDI_DATA_YYDDD_N  BASED(ADDR(DDI_DATA)),
            25  DDI_DATA_YYDDD_YYDDD_N        PIC'99999';
 DCL 1 DDI_DATA_YYDDD_SPLIT  BASED(ADDR(DDI_DATA)),
              30  DDI_DATA_YYDDD_YY           CHAR(2),
              30  DDI_DATA_YYDDD_DDD          CHAR(3);
 DCL 1 DDI_DATA_YYDDD_SPLIT_N  BASED(ADDR(DDI_DATA)),
              30  DDI_DATA_YYDDD_YY_N         PIC'99',
              30  DDI_DATA_YYDDD_DDD_N        PIC'999';
 DCL 1 DDO_DATA_DD_MMM_YY  BASED(ADDR(DDO_DATA)),
            25  DDO_DATA_DD_MMM_YY_DD         CHAR(2),
            25  DDO_DATA_DD_MMM_YY_DOT1       CHAR(1),
            25  DDO_DATA_DD_MMM_YY_MMM        CHAR(3),
            25  DDO_DATA_DD_MMM_YY_DOT2       CHAR(1),
            25  DDO_DATA_DD_MMM_YY_YY         CHAR(2);
 DCL 1 DDO_DATA_DD_MMM_YYYY  BASED(ADDR(DDO_DATA)),
            25  DDO_DATA_DD_MMM_YYYY_DD       CHAR(2),
            25  DDO_DATA_DD_MMM_YYYY_DOT1     CHAR(1),
            25  DDO_DATA_DD_MMM_YYYY_MMM      CHAR(3),
            25  DDO_DATA_DD_MMM_YYYY_DOT2     CHAR(1),
            25  DDO_DATA_DD_MMM_YYYY_YYYY     CHAR(4);

 /*
    Constants to replace Cobol 88 levels
 */

 DCL 1 DD_ENV_NULL                            CHAR(4) INIT('');
 DCL 1 DD_ENV_CICS                            CHAR(4) INIT('CICS');
 DCL 1 DD_ENV_IMS                             CHAR(4) INIT('IMS');
 DCL 1 DD_ENV_INET                            CHAR(4) INIT('INET');

 DCL 1 DDI_ISO                                CHAR(1) INIT('0');
 DCL 1 DDI_YYYYMMDD                           CHAR(1) INIT('1');
 DCL 1 DDI_YYMMDD                             CHAR(1) INIT('2');
 DCL 1 DDI_YYDDD                              CHAR(1) INIT('3');

 DCL 1 DDO_DD_MMM_YY                          CHAR(1) INIT('1');
 DCL 1 DDO_DD_MMM_YYYY                        CHAR(1) INIT('2');

