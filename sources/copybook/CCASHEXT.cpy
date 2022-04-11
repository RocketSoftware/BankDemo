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
      * CBANKEXT.CPY                                                  *
      *---------------------------------------------------------------*
      *****************************************************************
           10  ATM-DATA                            PIC X(256).

           10  ATM-IP-DATA REDEFINES ATM-DATA.
             15  ATM-IP-COMMON-AREA.
               20  ATM-IP00-FUNCTION               PIC X(2).
                 88  ATM-FUNC-VALID                VALUE '10'
                                                         '20'.
                 88  ATM-FUNC-VALIDATE-PIN         VALUE '10'.
                 88  ATM-FUNC-GET-ACCOUNTS         VALUE '20'.
               20  ATM-IP00-USERID                 PIC X(5).
               20  ATM-IP00-PIN                    PIC X(4).
             15  ATM-IP-SHARED-AREA                PIC X(128).
             15  ATM-IP10-DATA REDEFINES ATM-IP-SHARED-AREA.
               20  ATM-IP10-USERID                 PIC X(5).
               20  ATM-IP10-PIN                    PIC X(4).
             15  ATM-IP20-DATA REDEFINES ATM-IP-SHARED-AREA.
               20  ATM-IP20-USERID                 PIC X(5).
             15  ATM-IP30-DATA REDEFINES ATM-IP-SHARED-AREA.
               20  ATM-IP30-DET1                   PIC X(1).
               20  ATM-IP30-TXS1                   PIC X(1).
             15  ATM-IP50-DATA REDEFINES ATM-IP-SHARED-AREA.
               20  ATM-IP50-XFER                   PIC X(8).
               20  ATM-IP50-FRM1                   PIC X(1).
               20  ATM-IP50-TO1                    PIC X(1).
             15  ATM-IP60-DATA REDEFINES ATM-IP-SHARED-AREA.
               20  ATM-IP60-NADDR1                 PIC X(25).
               20  ATM-IP60-NADDR2                 PIC X(25).
               20  ATM-IP60-NSTATE                 PIC X(2).
               20  ATM-IP60-NCNTRY                 PIC X(6).
               20  ATM-IP60-NPSTCDE                PIC X(6).
               20  ATM-IP60-NTELNO                 PIC X(12).
               20  ATM-IP60-NEMAIL                 PIC X(30).
               20  ATM-IP60-NSMAIL                 PIC X(1).
               20  ATM-IP60-NSEMAIL                PIC X(1).
             15  ATM-IP70-DATA REDEFINES ATM-IP-SHARED-AREA.
               20  ATM-IP70-AMOUNT                 PIC X(7).
               20  ATM-IP70-RATE                   PIC X(5).
               20  ATM-IP70-TERM                   PIC X(5).
             15  ATM-IP80-DATA REDEFINES ATM-IP-SHARED-AREA.
               20  ATM-IP80-OPT1                   PIC X(1).
               20  ATM-IP80-OPT2                   PIC X(1).

           10  ATM-OP-DATA REDEFINES ATM-DATA.
             15  ATM-OP-ERR-MSG                    PIC X(80).
             15  ATM-OP-USERID                     PIC X(5).
             15  ATM-OP-PIN-STATUS                 PIC X(2).
               88  ATM-PIN-VALID                   VALUE '10'.
               88  ATM-PIN-UNKNOWN-USER            VALUE '11'.
               88  ATM-PIN-INVALID                 VALUE '12'.
               88  ATM-PIN-MISSING                 VALUE '13'.
             15  ATM-OP-SHARED-AREA                PIC X(169).
             15  ATM-OP20-DATA REDEFINES ATM-OP-SHARED-AREA.
               20  ATM-OP20-ACC1                   PIC X(9).
               20  ATM-OP20-DSC1                   PIC X(15).
               20  ATM-OP20-ACC2                   PIC X(9).
               20  ATM-OP20-DSC2                   PIC X(15).
               20  ATM-OP20-ACC3                   PIC X(9).
               20  ATM-OP20-DSC3                   PIC X(15).
               20  ATM-OP20-ACC4                   PIC X(9).
               20  ATM-OP20-DSC4                   PIC X(15).
               20  ATM-OP20-ACC5                   PIC X(9).
               20  ATM-OP20-DSC5                   PIC X(15).
      *      15  ATM-OP35-DATA REDEFINES ATM-OP-SHARED-AREA.
      *        20  ATM-OP35-ACCNO                  PIC X(9).
      *        20  ATM-OP35-ACCTYPE                PIC X(15).
      *        20  ATM-OP35-BALANCE                PIC X(13).
      *        20  ATM-OP35-STMT-DATE              PIC X(11).
      *        20  ATM-OP35-ATM-DETAILS.
      *          25  ATM-OP35-ATM-VIS              PIC X(1).
      *          25  ATM-OP35-ATM-LIM              PIC X(3).
      *          25  ATM-OP35-ATM-LDTE             PIC X(11).
      *          25  ATM-OP35-ATM-LAMT             PIC X(3).
      *        20  ATM-OP35-RP-DETAILS             OCCURS 3 TIMES.
      *          25  ATM-OP35-RP-DAY               PIC X(2).
      *          25  ATM-OP35-RP-AMT               PIC X(8).
      *          25  ATM-OP35-RP-PID               PIC X(5).
      *          25  ATM-OP35-RP-ACC               PIC X(9).
      *          25  ATM-OP35-RP-DTE               PIC X(11).
             15  ATM-OP50-DATA REDEFINES ATM-OP-SHARED-AREA.
               20  ATM-OP50-XFER                   PIC X(9).
               20  ATM-OP50-FRM1                   PIC X(1).
               20  ATM-OP50-TO1                    PIC X(1).
               20  ATM-OP50-ACC1                   PIC X(9).
               20  ATM-OP50-DSC1                   PIC X(15).
               20  ATM-OP50-FRM2                   PIC X(1).
               20  ATM-OP50-TO2                    PIC X(1).
               20  ATM-OP50-ACC2                   PIC X(9).
               20  ATM-OP50-DSC2                   PIC X(15).
      *      15  ATM-OP60-DATA REDEFINES ATM-OP-SHARED-AREA.
      *        20  ATM-OP60-OADDR1                 PIC X(25).
      *        20  ATM-OP60-OADDR2                 PIC X(25).
      *        20  ATM-OP60-OSTATE                 PIC X(2).
      *        20  ATM-OP60-OCNTRY                 PIC X(6).
      *        20  ATM-OP60-OPSTCDE                PIC X(6).
      *        20  ATM-OP60-OTELNO                 PIC X(12).
      *        20  ATM-OP60-NADDR1                 PIC X(25).
      *        20  ATM-OP60-NADDR2                 PIC X(25).
      *        20  ATM-OP60-NSTATE                 PIC X(2).
      *        20  ATM-OP60-NCNTRY                 PIC X(6).
      *        20  ATM-OP60-NPSTCDE                PIC X(6).
      *        20  ATM-OP60-NTELNO                 PIC X(12).
      *        20  ATM-OP60-NEMAIL                 PIC X(30).
      *        20  ATM-OP60-NSMAIL                 PIC X(1).
      *        20  ATM-OP60-NSEMAIL                PIC X(1).
             15  ATM-OP70-DATA REDEFINES ATM-OP-SHARED-AREA.
               20  ATM-OP70-AMOUNT                 PIC X(7).
               20  ATM-OP70-RATE                   PIC X(7).
               20  ATM-OP70-TERM                   PIC X(5).
               20  ATM-OP70-PAYMENT                PIC X(9).
             15  ATM-OP80-DATA REDEFINES ATM-OP-SHARED-AREA.
               20  ATM-OP80-ADDR1                 PIC X(25).
               20  ATM-OP80-ADDR2                 PIC X(25).
               20  ATM-OP80-STATE                 PIC X(2).
               20  ATM-OP80-CNTRY                 PIC X(6).
               20  ATM-OP80-PSTCDE                PIC X(6).
               20  ATM-OP80-EMAIL                 PIC X(30).
               20  ATM-OP80-OPT1                  PIC X(1).
               20  ATM-OP80-OPT2                  PIC X(1).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
