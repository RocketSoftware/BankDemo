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
      *
      *****************************************************************
      * CCASHDAT.CPY                                                  *
      *---------------------------------------------------------------*
      * Common data passed between the major components               *
      *****************************************************************
      *    10  CASH-EVERYTHING.
           10  CASH-EVERYTHING                     PIC X(1024).
           10  FILLER REDEFINES CASH-EVERYTHING.
             15  CASH-REQUEST-CODE                 PIC X(1).
               88  CASH-REQUEST-DETAILS            VALUE '1'.
               88  CASH-REQUEST-XFER               VALUE '2'.
               88  CASH-REQUEST-CASH               VALUE '3'.
      *      15  CASH-CONTROL-FIELDS.
      *        20  CASH-ENV                        PIC X(4).
      *          88  CASH-ENV-NULL                 VALUE LOW-VALUES.
      *          88  CASH-ENV-CICS                 VALUE 'CICS'.
      *          88  CASH-ENV-IMS                  VALUE 'IMS '.
      *          88  CASH-ENV-INET                 VALUE 'INET'.
      *        20  CASH-TS-QUEUE-NAME              PIC X(8).
      *        20  CASH-RETURN-MSG                 PIC X(75).
      *          88  CASH-RETURN-MSG-OFF           VALUE LOW-VALUES.
             15  CASH-USER-DETAILS.
      *        20  CASH-SIGNON-ID                  PIC X(5).
      *        20  FILLER REDEFINES CASH-SIGNON-ID.
      *          25  CASH-SIGNON-ID-1              PIC X(1).
      *            88  PROBLEM-USER                VALUE 'Z'.
      *          25  CASH-SIGNON-ID-2-5            PIC X(4).
               20  CASH-USERID                     PIC X(5).
                 88  GUEST                         VALUE 'GUEST'.
               20  CASH-PIN                        PIC X(4).
               20  CASH-PIN-STATUS                 PIC X(2).
                 88  CASH-PIN-STATUS-UNKNOWN       VALUE '  '.
                 88  CASH-PIN-STATUS-OK            VALUE '10'.
                 88  CASH-PIN-STATUS-NO-USER       VALUE '11'.
                 88  CASH-PIN-STATUS-INVALID       VALUE '12'.
                 88  CASH-PIN-STATUS-NO-PIN        VALUE '13'.
             15  CASH-ERROR-MSG                    PIC X(75).
             15  CASH-ATM-DATA.
               20  CASH-ATM1-DATA.
                 25  CASH-ATM1-ACC-DET1.
                   30  CASH-ATM1-ACC1              PIC X(9).
                   30  CASH-ATM1-DSC1              PIC X(15).
                   30  CASH-ATM1-BAL1              PIC X(13).
                   30  CASH-ATM1-DAY-LIMIT1        PIC X(3).
                   30  CASH-ATM1-DATE-USED1        PIC X(10).
                   30  CASH-ATM1-DATE-AMT1         PIC X(3).
                 25  CASH-ATM1-ACC-DET2.
                   30  CASH-ATM1-ACC2              PIC X(9).
                   30  CASH-ATM1-DSC2              PIC X(15).
                   30  CASH-ATM1-BAL2              PIC X(13).
                   30  CASH-ATM1-DAY-LIMIT2        PIC X(3).
                   30  CASH-ATM1-DATE-USED2        PIC X(10).
                   30  CASH-ATM1-DATE-AMT2         PIC X(3).
                 25  CASH-ATM1-ACC-DET3.
                   30  CASH-ATM1-ACC3              PIC X(9).
                   30  CASH-ATM1-DSC3              PIC X(15).
                   30  CASH-ATM1-BAL3              PIC X(13).
                   30  CASH-ATM1-DAY-LIMIT3        PIC X(3).
                   30  CASH-ATM1-DATE-USED3        PIC X(10).
                   30  CASH-ATM1-DATE-AMT3         PIC X(3).
                 25  CASH-ATM1-ACC-DET4.
                   30  CASH-ATM1-ACC4              PIC X(9).
                   30  CASH-ATM1-DSC4              PIC X(15).
                   30  CASH-ATM1-BAL4              PIC X(13).
                   30  CASH-ATM1-DAY-LIMIT4        PIC X(3).
                   30  CASH-ATM1-DATE-USED4        PIC X(10).
                   30  CASH-ATM1-DATE-AMT4         PIC X(3).
                 25  CASH-ATM1-ACC-DET5.
                   30  CASH-ATM1-ACC5              PIC X(9).
                   30  CASH-ATM1-DSC5              PIC X(15).
                   30  CASH-ATM1-BAL5              PIC X(13).
                   30  CASH-ATM1-DAY-LIMIT5        PIC X(3).
                   30  CASH-ATM1-DATE-USED5        PIC X(10).
                   30  CASH-ATM1-DATE-AMT5         PIC X(3).
               20  CASH-ATM1-DATA-R REDEFINES CASH-ATM1-DATA.
                 25  CASH-ATM1-ACC-DET OCCURS 5 TIMES.
                   30  CASH-ATM1-ACC               PIC X(9).
                   30  CASH-ATM1-DSC               PIC X(15).
                   30  CASH-ATM1-BAL               PIC X(13).
                   30  CASH-ATM1-DAY-LIMIT         PIC X(3).
                   30  CASH-ATM1-DATE-USED         PIC X(10).
                   30  CASH-ATM1-DATE-AMT          PIC X(3).
               20  CASH-ATM2-DATA-R REDEFINES CASH-ATM1-DATA.
                 25  CASH-ATM2-XFER-AMT            PIC X(8).
                 25  CASH-ATM2-FROM-ACC            PIC X(9).
                 25  CASH-ATM2-FROM-BAL            PIC X(13).
                 25  CASH-ATM2-TO-ACC              PIC X(9).
                 25  CASH-ATM2-TO-BAL              PIC X(13).
               20  CASH-ATM3-DATA-R REDEFINES CASH-ATM1-DATA.
                 25  CASH-ATM3-CASH-AMT            PIC X(8).
                 25  CASH-ATM3-FROM-ACC            PIC X(9).
                 25  CASH-ATM3-FROM-BAL            PIC X(13).
      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
