 /****************************************************************
 *
 *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
 *
 ****************************************************************/

 /****************************************************************
 * CSTATESD.INC
 *---------------------------------------------------------------
 * Look_up table of countr, state/provence codes & long form
 ****************************************************************/
 DCL 1 STATE_PROV_DATA_AREAS,
    05  STATE_PROV_TABLE,
      10  FILL01                              CHAR(28)
          INIT('USA AK Alaska               '),
      10  FILL02                              CHAR(28)
          INIT('USA AL Alabama              '),
      10  FILL03                              CHAR(28)
          INIT('USA AR Arkansas             '),
      10  FILL04                              CHAR(28)
          INIT('USA AZ Arizona              '),
      10  FILL05                              CHAR(28)
          INIT('USA CA California           '),
      10  FILL06                              CHAR(28)
          INIT('USA CO Colorado             '),
      10  FILL07                              CHAR(28)
          INIT('USA CT Connecticut          '),
      10  FILL08                              CHAR(28)
          INIT('USA DC Washington D.C.      '),
      10  FILL09                              CHAR(28)
          INIT('USA DE Delaware             '),
      10  FILL10                              CHAR(28)
          INIT('USA FL Florida              '),
      10  FILL11                              CHAR(28)
          INIT('USA GA Georgia              '),
      10  FILL12                              CHAR(28)
          INIT('USA HI Hawaii               '),
      10  FILL13                              CHAR(28)
          INIT('USA ID Idaho                '),
      10  FILL14                              CHAR(28)
          INIT('USA IL Illinois             '),
      10  FILL15                              CHAR(28)
          INIT('USA IN Indiana              '),
      10  FILL16                              CHAR(28)
          INIT('USA IA Iowa                 '),
      10  FILL17                              CHAR(28)
          INIT('USA KS Kansas               '),
      10  FILL18                              CHAR(28)
          INIT('USA KY Kentucky             '),
      10  FILL19                              CHAR(28)
          INIT('USA LA Louisiana            '),
      10  FILL20                              CHAR(28)
          INIT('USA MA Massachusetts        '),
      10  FILL21                              CHAR(28)
          INIT('USA MD Maryland             '),
      10  FILL22                              CHAR(28)
          INIT('USA ME Maine                '),
      10  FILL23                              CHAR(28)
          INIT('USA MI Michigan             '),
      10  FILL24                              CHAR(28)
          INIT('USA MN Minnesota            '),
      10  FILL25                              CHAR(28)
          INIT('USA MO Missouri             '),
      10  FILL26                              CHAR(28)
          INIT('USA MS Mississippi          '),
      10  FILL27                              CHAR(28)
          INIT('USA MT Montana              '),
      10  FILL28                              CHAR(28)
          INIT('USA NC North Carolina       '),
      10  FILL29                              CHAR(28)
          INIT('USA ND North Dakota         '),
      10  FILL30                              CHAR(28)
          INIT('USA NE Nebraska             '),
      10  FILL31                              CHAR(28)
          INIT('USA NH New Hampshire        '),
      10  FILL32                              CHAR(28)
          INIT('USA NJ New Jersey           '),
      10  FILL33                              CHAR(28)
          INIT('USA NM New Mexico           '),
      10  FILL34                              CHAR(28)
          INIT('USA NV Nevada               '),
      10  FILL35                              CHAR(28)
          INIT('USA NY New York             '),
      10  FILL36                              CHAR(28)
          INIT('USA OH Ohio                 '),
      10  FILL37                              CHAR(28)
          INIT('USA OK Oklahoma             '),
      10  FILL38                              CHAR(28)
          INIT('USA OR Oregon               '),
      10  FILL39                              CHAR(28)
          INIT('USA PA Pennsylvania         '),
      10  FILL40                              CHAR(28)
          INIT('USA RI Rhode Island         '),
      10  FILL41                              CHAR(28)
          INIT('USA SC South Carolina       '),
      10  FILL42                              CHAR(28)
          INIT('USA SD South Dakota         '),
      10  FILL43                              CHAR(28)
          INIT('USA TN Tennessee            '),
      10  FILL44                              CHAR(28)
          INIT('USA TX Texas                '),
      10  FILL45                              CHAR(28)
          INIT('USA UT Utah                 '),
      10  FILL46                              CHAR(28)
          INIT('USA VA Virginia             '),
      10  FILL47                              CHAR(28)
          INIT('USA VT Vermont              '),
      10  FILL48                              CHAR(28)
          INIT('USA WA Washington           '),
      10  FILL49                              CHAR(28)
          INIT('USA WI Wisconsin            '),
      10  FILL50                              CHAR(28)
          INIT('USA WV West Virginia        '),
      10  FILL51                              CHAR(28)
          INIT('USA WY Wyoming              '),
      10  FILL52                              CHAR(28)
          INIT('USA PR Puerto Rico          '),
      10  FILL53                              CHAR(28)
          INIT('CDN AB Alberta              '),
      10  FILL54                              CHAR(28)
          INIT('CDN BC British Columbia     '),
      10  FILL55                              CHAR(28)
          INIT('CDN MB Manitoba             '),
      10  FILL56                              CHAR(28)
          INIT('CDN NB New Brunswick        '),
      10  FILL57                              CHAR(28)
          INIT('CDN NF Newfoundland         '),
      10  FILL58                              CHAR(28)
          INIT('CDN NS Nova Scotia          '),
      10  FILL59                              CHAR(28)
          INIT('CDN NU Nunavut Territory    '),
      10  FILL60                              CHAR(28)
          INIT('CDN NT Northwest Territories'),
      10  FILL61                              CHAR(28)
          INIT('CDN ON Ontario              '),
      10  FILL62                              CHAR(28)
          INIT('CDN PE Prince Edward Island '),
      10  FILL63                              CHAR(28)
          INIT('CDN QC Quebec               '),
      10  FILL64                              CHAR(28)
          INIT('CDN SK Saskatchewan         '),
      10  FILL65                              CHAR(28)
          INIT('CDN YT Yukon Territory      '),
    05  STATE_PROV_COUNT                      PIC '99',
    05  STATE_PROV_SUB                        PIC '99',
    05  STATE_PROV_WK_CNTRY                   CHAR(3),
    05  STATE_PROV_TMP_CNTRY                  CHAR(6),
    05  STATE_PROV_WK_CODE                    CHAR(20),
    05  STATE_PROV_WK_NAME                    CHAR(20);

 DCL 1 STATE_PROV_TABLE_R BASED(ADDR(STATE_PROV_DATA_AREAS)),
      10  STATE_PROV_DATA(65),
        15  STATE_PROV_CNTRY                  CHAR(3),
        15  FILL01                            CHAR(1),
        15  STATE_PROV_CODE                   CHAR(2),
        15  FILL02                            CHAR(1),
        15  STATE_PROV_NAME                   CHAR(21);


