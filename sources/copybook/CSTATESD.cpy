      *****************************************************************
      *                                                               *
      * Copyright (C) 2010-2021 Micro Focus.  All Rights Reserved     *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Micro Focus software, and is otherwise subject to the EULA at *
      * https://www.microfocus.com/en-us/legal/software-licensing.    *
      *                                                               *
      * THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED             *
      * WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF               *
      * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,         *
      * SHALL NOT APPLY.                                              *
      * TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL              *
      * MICRO FOCUS HAVE ANY LIABILITY WHATSOEVER IN CONNECTION       *
      * WITH THIS SOFTWARE.                                           *
      *                                                               *
      *****************************************************************

      *****************************************************************
      * CSTATESD.CPY                                                  *
      *---------------------------------------------------------------*
      * Look-up table of countr, state/provence codes & long form     *
      *****************************************************************
       01  STATE-PROV-DATA-AREAS.
         05  STATE-PROV-TABLE.
           10  FILLER                              PIC X(28)
               VALUE 'USA AK Alaska               '.
           10  FILLER                              PIC X(28)
               VALUE 'USA AL Alabama              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA AR Arkansas             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA AZ Arizona              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA CA California           '.
           10  FILLER                              PIC X(28)
               VALUE 'USA CO Colorado             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA CT Connecticut          '.
           10  FILLER                              PIC X(28)
               VALUE 'USA DC Washington D.C.      '.
           10  FILLER                              PIC X(28)
               VALUE 'USA DE Delaware             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA FL Florida              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA GA Georgia              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA HI Hawaii               '.
           10  FILLER                              PIC X(28)
               VALUE 'USA ID Idaho                '.
           10  FILLER                              PIC X(28)
               VALUE 'USA IL Illinois             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA IN Indiana              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA IA Iowa                 '.
           10  FILLER                              PIC X(28)
               VALUE 'USA KS Kansas               '.
           10  FILLER                              PIC X(28)
               VALUE 'USA KY Kentucky             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA LA Louisiana            '.
           10  FILLER                              PIC X(28)
               VALUE 'USA MA Massachusetts        '.
           10  FILLER                              PIC X(28)
               VALUE 'USA MD Maryland             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA ME Maine                '.
           10  FILLER                              PIC X(28)
               VALUE 'USA MI Michigan             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA MN Minnesota            '.
           10  FILLER                              PIC X(28)
               VALUE 'USA MO Missouri             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA MS Mississippi          '.
           10  FILLER                              PIC X(28)
               VALUE 'USA MT Montana              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA NC North Carolina       '.
           10  FILLER                              PIC X(28)
               VALUE 'USA ND North Dakota         '.
           10  FILLER                              PIC X(28)
               VALUE 'USA NE Nebraska             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA NH New Hampshire        '.
           10  FILLER                              PIC X(28)
               VALUE 'USA NJ New Jersey           '.
           10  FILLER                              PIC X(28)
               VALUE 'USA NM New Mexico           '.
           10  FILLER                              PIC X(28)
               VALUE 'USA NV Nevada               '.
           10  FILLER                              PIC X(28)
               VALUE 'USA NY New York             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA OH Ohio                 '.
           10  FILLER                              PIC X(28)
               VALUE 'USA OK Oklahoma             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA OR Oregon               '.
           10  FILLER                              PIC X(28)
               VALUE 'USA PA Pennsylvania         '.
           10  FILLER                              PIC X(28)
               VALUE 'USA RI Rhode Island         '.
           10  FILLER                              PIC X(28)
               VALUE 'USA SC South Carolina       '.
           10  FILLER                              PIC X(28)
               VALUE 'USA SD South Dakota         '.
           10  FILLER                              PIC X(28)
               VALUE 'USA TN Tennessee            '.
           10  FILLER                              PIC X(28)
               VALUE 'USA TX Texas                '.
           10  FILLER                              PIC X(28)
               VALUE 'USA UT Utah                 '.
           10  FILLER                              PIC X(28)
               VALUE 'USA VA Virginia             '.
           10  FILLER                              PIC X(28)
               VALUE 'USA VT Vermont              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA WA Washington           '.
           10  FILLER                              PIC X(28)
               VALUE 'USA WI Wisconsin            '.
           10  FILLER                              PIC X(28)
               VALUE 'USA WV West Virginia        '.
           10  FILLER                              PIC X(28)
               VALUE 'USA WY Wyoming              '.
           10  FILLER                              PIC X(28)
               VALUE 'USA PR Puerto Rico          '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN AB Alberta              '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN BC British Columbia     '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN MB Manitoba             '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN NB New Brunswick        '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN NF Newfoundland         '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN NS Nova Scotia          '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN NU Nunavut Territory    '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN NT Northwest Territories'.
           10  FILLER                              PIC X(28)
               VALUE 'CDN ON Ontario              '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN PE Prince Edward Island '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN QC Quebec               '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN SK Saskatchewan         '.
           10  FILLER                              PIC X(28)
               VALUE 'CDN YT Yukon Territory      '.
         05  STATE-PROV-TABLE-R REDEFINES STATE-PROV-TABLE.
           10  STATE-PROV-DATA                     OCCURS 65 TIMES.
             15  STATE-PROV-CNTRY                  PIC X(3).
             15  FILLER                            PIC X(1).
             15  STATE-PROV-CODE                   PIC X(2).
             15  FILLER                            PIC X(1).
             15  STATE-PROV-NAME                   PIC X(21).
         05  STATE-PROV-COUNT                      PIC 9(2).
         05  STATE-PROV-SUB                        PIC 9(2).
         05  STATE-PROV-WK-CNTRY                   PIC X(3).
         05  STATE-PROV-TMP-CNTRY                  PIC X(6).
         05  STATE-PROV-WK-CODE                    PIC X(20).
         05  STATE-PROV-WK-NAME                    PIC X(20).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
