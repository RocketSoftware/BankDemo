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
      * CBANKDAT.CPY                                                  *
      *---------------------------------------------------------------*
      * Common data passed between the major components               *
      *****************************************************************
           10  BANK-EVERYTHING                     PIC X(6144).
      *    10  FILLER REDEFINES BANK-EVERYTHING.
           10  BANK-EVERYTHING-R REDEFINES BANK-EVERYTHING.
             15  BANK-PREFIX                       PIC X(22).
             15  BANK-IMS-PREFIX REDEFINES BANK-PREFIX.
               20  BANK-IMS-SPA-LL                 PIC S9(8) COMP.
               20  BANK-IMS-SPA-ZZ                 PIC X(2).
               20  BANK-IMS-SPA-TRANCODE           PIC X(8).
               20  BANK-IMS-SPA-PASSED-DATA        PIC X(8).
               20  BANK-IMS-SPA-PASSED-DATA-R1 REDEFINES
                   BANK-IMS-SPA-PASSED-DATA.
                 25  BANK-IMS-IO-PCB-DATE          PIC S9(7) COMP-3.
                 25  BANK-IMS-IO-PCB-TIME          PIC S9(7) COMP-3.
               20  BANK-IMS-SPA-PASSED-DATA-R2 REDEFINES
                   BANK-IMS-SPA-PASSED-DATA.
                 25  BANK-IMS-SPA-PASSED-LITERAL   PIC X(7).
                 25  BANK-IMS-SPA-PASSED-COLOUR    PIC X(1).
             15  BANK-CICS-PREFIX REDEFINES BANK-PREFIX.
               20  BANK-CICS-LL                    PIC S9(4) COMP.
               20  FILLER                          PIC X(4).
               20  BANK-CICS-TRANCODE-PLUS4        PIC X(8).
               20  FILLER REDEFINES BANK-CICS-TRANCODE-PLUS4.
                 25  BANK-CICS-TRANCODE            PIC X(4).
                 25  FILLER                        PIC X(4).
             15  BANK-CONTROL-FIELDS.
               20  BANK-ENV                        PIC X(4).
                 88  BANK-ENV-NULL                 VALUE LOW-VALUES.
                 88  BANK-ENV-CICS                 VALUE 'CICS'.
                 88  BANK-ENV-IMS                  VALUE 'IMS '.
                 88  BANK-ENV-INET                 VALUE 'INET'.
               20  BANK-COLOUR-SETTING             PIC X(1).
                 88  COLOUR-ON                     VALUE '1'.
                 88  COLOUR-OFF                    VALUE '0'.
               20  BANK-CONVERSATION               PIC X(1).
                 88  BANK-NO-CONV-IN-PROGRESS      VALUE '0'.
                 88  BANK-CONV-IN-PROGRESS         VALUE '1'.
               20  BANK-TS-QUEUE-NAME              PIC X(8).
               20  BANK-AID                        PIC X(5).
                 88  BANK-AID-ENTER                VALUE 'ENTER'.
                 88  BANK-AID-CLEAR                VALUE 'CLEAR'.
                 88  BANK-AID-PA1                  VALUE 'PA1  '.
                 88  BANK-AID-PA2                  VALUE 'PA2  '.
                 88  BANK-AID-PFK01                VALUE 'PFK01'.
                 88  BANK-AID-PFK02                VALUE 'PFK02'.
                 88  BANK-AID-PFK03                VALUE 'PFK03'.
                 88  BANK-AID-PFK04                VALUE 'PFK04'.
                 88  BANK-AID-PFK05                VALUE 'PFK05'.
                 88  BANK-AID-PFK06                VALUE 'PFK06'.
                 88  BANK-AID-PFK07                VALUE 'PFK07'.
                 88  BANK-AID-PFK08                VALUE 'PFK08'.
                 88  BANK-AID-PFK09                VALUE 'PFK09'.
                 88  BANK-AID-PFK10                VALUE 'PFK10'.
                 88  BANK-AID-PFK11                VALUE 'PFK11'.
                 88  BANK-AID-PFK12                VALUE 'PFK12'.
               20  BANK-LAST-PROG                  PIC X(8).
               20  BANK-NEXT-PROG                  PIC X(8).
               20  BANK-RETURN-TO-PROG             PIC X(8).
               20  BANK-LAST-MAPSET                PIC X(7).
               20  BANK-LAST-MAP                   PIC X(7).
               20  BANK-NEXT-MAPSET                PIC X(7).
               20  BANK-NEXT-MAP                   PIC X(7).
               20  BANK-MAP-FUNCTION               PIC X(3).
                 88  BANK-MAP-FUNCTION-GET         VALUE 'GET'.
                 88  BANK-MAP-FUNCTION-PUT         VALUE 'PUT'.
               20  BANK-HELP-FIELDS.
                 25  BANK-HELP-FLAG                PIC X(4).
                   88  BANK-HELP-ACTIVE            VALUE 'HELP'.
                   88  BANK-HELP-INACTIVE          VALUE LOW-VALUES.
                 25  BANK-HELP-SCREEN              PIC 9(2).
               20  BANK-PAGING-FIELDS.
                 25  BANK-PAGING-STATUS            PIC X(1).
                   88  BANK-PAGING-OFF             VALUE LOW-VALUES.
                   88  BANK-PAGING-FIRST           VALUE '1'.
                   88  BANK-PAGING-MIDDLE          VALUE '2'.
                   88  BANK-PAGING-LAST            VALUE '3'.
                 25  BANK-PAGING-FIRST-ENTRY       PIC X(26).
                 25  BANK-PAGING-LAST-ENTRY        PIC X(26).
               20  BANK-RETURN-FLAG                PIC X(1).
                 88  BANK-RETURN-FLAG-OFF          VALUE LOW-VALUES.
                 88  BANK-RETURN-FLAG-ON           VALUE '1'.
               20  BANK-RETURN-MSG                 PIC X(75).
                 88  BANK-RETURN-MSG-OFF           VALUE LOW-VALUES.
             15  BANK-ERROR-MSG                    PIC X(75).
             15  BANK-USER-DETAILS.
               20  BANK-SIGNON-ID                  PIC X(5).
               20  FILLER REDEFINES BANK-SIGNON-ID.
                 25  BANK-SIGNON-ID-1              PIC X(1).
                   88  PROBLEM-USER                VALUE 'Z'.
                 25  BANK-SIGNON-ID-2-5            PIC X(4).
               20  BANK-USERID                     PIC X(5).
                 88  GUEST                         VALUE 'GUEST'.
               20  BANK-USERID-NAME                PIC X(25).
               20  BANK-PSWD                       PIC X(8).
             15  BANK-HELP-DATA.
               20  BANK-HELP-SCRN                  PIC X(6).
               20  BANK-HELP-STATUS                PIC X(1).
                 88 BANK-HELP-FOUND                VALUE 'Y'.
                 88 BANK-HELP-NOT-FOUND            VALUE 'N'.
               20  BANK-HELP-LINE                  PIC X(75)
                   OCCURS 19 TIMES.
             15  BANK-SCREEN-DATA.
               20  BANK-SCREEN10-DATA.
                 25  FILLER                        PIC X(1).
               20  BANK-SCREEN20-DATA.
                 25  BANK-SCR20-SEL1ID             PIC X(1).
                 25  BANK-SCR20-SEL1IP             PIC X(1).
                 25  BANK-SCR20-SEL1TX             PIC X(40).
                 25  BANK-SCR20-SEL2ID             PIC X(1).
                 25  BANK-SCR20-SEL2IP             PIC X(1).
                 25  BANK-SCR20-SEL2TX             PIC X(40).
                 25  BANK-SCR20-SEL3ID             PIC X(1).
                 25  BANK-SCR20-SEL3IP             PIC X(1).
                 25  BANK-SCR20-SEL3TX             PIC X(40).
                 25  BANK-SCR20-SEL4ID             PIC X(1).
                 25  BANK-SCR20-SEL4IP             PIC X(1).
                 25  BANK-SCR20-SEL4TX             PIC X(40).
                 25  BANK-SCR20-SEL5ID             PIC X(1).
                 25  BANK-SCR20-SEL5IP             PIC X(1).
                 25  BANK-SCR20-SEL5TX             PIC X(40).
                 25  BANK-SCR20-SEL6ID             PIC X(1).
                 25  BANK-SCR20-SEL6IP             PIC X(1).
                 25  BANK-SCR20-SEL6TX             PIC X(40).
                 25  BANK-SCR20-SEL7ID             PIC X(1).
                 25  BANK-SCR20-SEL7IP             PIC X(1).
                 25  BANK-SCR20-SEL7TX             PIC X(40).
               20  BANK-SCREEN20-DATA-R REDEFINES BANK-SCREEN20-DATA.
                 25  BANK-SCREEN20-FIELD           OCCURS 7 TIMES.
                   30  BANK-SCR20-ID               PIC X(1).
                   30  BANK-SCR20-IP               PIC X(1).
                   30  BANK-SCR20-TX               PIC X(40).
               20  BANK-SCREEN30-DATA.
                 25  BANK-SCR30-DET1               PIC X(1).
                 25  BANK-SCR30-ACC1               PIC X(9).
                 25  BANK-SCR30-DSC1               PIC X(15).
                 25  BANK-SCR30-BAL1               PIC X(13).
                 25  BANK-SCR30-SRV1               PIC X(6).
                 25  BANK-SCR30-DTE1               PIC X(11).
                 25  BANK-SCR30-TXN1               PIC X(1).
                 25  BANK-SCR30-DET2               PIC X(1).
                 25  BANK-SCR30-ACC2               PIC X(9).
                 25  BANK-SCR30-DSC2               PIC X(15).
                 25  BANK-SCR30-BAL2               PIC X(13).
                 25  BANK-SCR30-SRV2               PIC X(6).
                 25  BANK-SCR30-DTE2               PIC X(11).
                 25  BANK-SCR30-TXN2               PIC X(1).
                 25  BANK-SCR30-DET3               PIC X(1).
                 25  BANK-SCR30-ACC3               PIC X(9).
                 25  BANK-SCR30-DSC3               PIC X(15).
                 25  BANK-SCR30-BAL3               PIC X(13).
                 25  BANK-SCR30-SRV3               PIC X(6).
                 25  BANK-SCR30-DTE3               PIC X(11).
                 25  BANK-SCR30-TXN3               PIC X(1).
                 25  BANK-SCR30-DET4               PIC X(1).
                 25  BANK-SCR30-ACC4               PIC X(9).
                 25  BANK-SCR30-DSC4               PIC X(15).
                 25  BANK-SCR30-BAL4               PIC X(13).
                 25  BANK-SCR30-SRV4               PIC X(6).
                 25  BANK-SCR30-DTE4               PIC X(11).
                 25  BANK-SCR30-TXN4               PIC X(1).
                 25  BANK-SCR30-DET5               PIC X(1).
                 25  BANK-SCR30-ACC5               PIC X(9).
                 25  BANK-SCR30-DSC5               PIC X(15).
                 25  BANK-SCR30-BAL5               PIC X(13).
                 25  BANK-SCR30-SRV5               PIC X(6).
                 25  BANK-SCR30-DTE5               PIC X(11).
                 25  BANK-SCR30-TXN5               PIC X(1).
                 25  BANK-SCR30-DET6               PIC X(1).
                 25  BANK-SCR30-ACC6               PIC X(9).
                 25  BANK-SCR30-DSC6               PIC X(15).
                 25  BANK-SCR30-BAL6               PIC X(13).
                 25  BANK-SCR30-SRV6               PIC X(6).
                 25  BANK-SCR30-DTE6               PIC X(11).
                 25  BANK-SCR30-TXN6               PIC X(1).
                 25  BANK-SCR30-SRVMSG             PIC X(62).
               20  BANK-SCREEN30-DATA-R REDEFINES BANK-SCREEN30-DATA.
                 25  BANK-SCREEN30-INPUT-DATA.
                   30  BANK-SCREEN30-INPUT         OCCURS 6 TIMES.
                     35  BANK-SCR30-DET            PIC X(1).
                     35  BANK-SCR30-ACC            PIC X(9).
                     35  BANK-SCR30-DSC            PIC X(15).
                     35  BANK-SCR30-BAL            PIC X(13).
                     35  BANK-SCR30-SRV            PIC X(6).
                     35  BANK-SCR30-DTE            PIC X(11).
                     35  BANK-SCR30-TXN            PIC X(1).
                       88  BANK-SCR30-TXN-PRESENT  VALUE '*'.
               20  BANK-SCREEN35-DATA.
                 25  BANK-SCR35-ACC                PIC X(9).
                 25  BANK-SCR35-DSC                PIC X(15).
                 25  BANK-SCR35-BAL                PIC X(13).
                 25  BANK-SCR35-DTE                PIC X(11).
                 25  BANK-SCR35-TRANS              PIC X(5).
                 25  BANK-SCR35-ATM-FIELDS.
                   30  BANK-SCR35-ATM-ENABLED      PIC X(1).
                   30  BANK-SCR35-ATM-LIM          PIC X(3).
                   30  BANK-SCR35-ATM-LDTE         PIC X(11).
                   30  BANK-SCR35-ATM-LAMT         PIC X(3).
                 25  BANK-SCR35-RP-FIELDS.
                   30  BANK-SCR35-RP1-FIELDS.
                     35  BANK-SCR35-RP1DAY         PIC X(2).
                     35  BANK-SCR35-RP1AMT         PIC X(10).
                     35  BANK-SCR35-RP1PID         PIC X(5).
                     35  BANK-SCR35-RP1ACC         PIC X(9).
                     35  BANK-SCR35-RP1DTE         PIC X(11).
                   30  BANK-SCR35-RP2-FIELDS.
                     35  BANK-SCR35-RP2DAY         PIC X(2).
                     35  BANK-SCR35-RP2AMT         PIC X(10).
                     35  BANK-SCR35-RP2PID         PIC X(5).
                     35  BANK-SCR35-RP2ACC         PIC X(9).
                     35  BANK-SCR35-RP2DTE         PIC X(11).
                   30  BANK-SCR35-RP3-FIELDS.
                     35  BANK-SCR35-RP3DAY         PIC X(2).
                     35  BANK-SCR35-RP3AMT         PIC X(10).
                     35  BANK-SCR35-RP3PID         PIC X(5).
                     35  BANK-SCR35-RP3ACC         PIC X(9).
                     35  BANK-SCR35-RP3DTE         PIC X(11).
               20  BANK-SCREEN40-DATA.
                 25  BANK-SCR40-ACC                PIC X(9).
                 25  BANK-SCR40-ACCTYPE            PIC X(15).
                 25  BANK-SCR40-TXN-FIELDS.
                   30  BANK-SCR40-DAT1             PIC X(11).
                   30  BANK-SCR40-TIM1             PIC X(8).
                   30  BANK-SCR40-AMT1             PIC X(13).
                   30  BANK-SCR40-DSC1             PIC X(30).
                   30  BANK-SCR40-DAT2             PIC X(11).
                   30  BANK-SCR40-TIM2             PIC X(8).
                   30  BANK-SCR40-AMT2             PIC X(13).
                   30  BANK-SCR40-DSC2             PIC X(30).
                   30  BANK-SCR40-DAT3             PIC X(11).
                   30  BANK-SCR40-TIM3             PIC X(8).
                   30  BANK-SCR40-AMT3             PIC X(13).
                   30  BANK-SCR40-DSC3             PIC X(30).
                   30  BANK-SCR40-DAT4             PIC X(11).
                   30  BANK-SCR40-TIM4             PIC X(8).
                   30  BANK-SCR40-AMT4             PIC X(13).
                   30  BANK-SCR40-DSC4             PIC X(30).
                   30  BANK-SCR40-DAT5             PIC X(11).
                   30  BANK-SCR40-TIM5             PIC X(8).
                   30  BANK-SCR40-AMT5             PIC X(13).
                   30  BANK-SCR40-DSC5             PIC X(30).
                   30  BANK-SCR40-DAT6             PIC X(11).
                   30  BANK-SCR40-TIM6             PIC X(8).
                   30  BANK-SCR40-AMT6             PIC X(13).
                   30  BANK-SCR40-DSC6             PIC X(30).
                   30  BANK-SCR40-DAT7             PIC X(11).
                   30  BANK-SCR40-TIM7             PIC X(8).
                   30  BANK-SCR40-AMT7             PIC X(13).
                   30  BANK-SCR40-DSC7             PIC X(30).
                   30  BANK-SCR40-DAT8             PIC X(11).
                   30  BANK-SCR40-TIM8             PIC X(8).
                   30  BANK-SCR40-AMT8             PIC X(13).
                   30  BANK-SCR40-DSC8             PIC X(30).
               20  BANK-SCREEN40-DATA-R REDEFINES BANK-SCREEN40-DATA.
                 25  BANK-SCR40-ACC-R              PIC X(9).
                 25  BANK-SCR40-ACCTYPE-R          PIC X(15).
                 25  BANK-SCREEN40-TXNS            OCCURS 8 TIMES.
                   30  BANK-SCR40-DATE             PIC X(11).
                   30  BANK-SCR40-TIME             PIC X(8).
                   30  BANK-SCR40-AMNT             PIC X(13).
                   30  BANK-SCR40-DESC             PIC X(30).
               20  BANK-SCREEN50-DATA.
                 25  BANK-SCR50-XFER               PIC X(8).
                 25  BANK-SCR50-FRM1               PIC X(1).
                 25  BANK-SCR50-TO1                PIC X(1).
                 25  BANK-SCR50-ACC1               PIC X(9).
                 25  BANK-SCR50-DSC1               PIC X(15).
                 25  BANK-SCR50-BAL1               PIC X(13).
                 25  BANK-SCR50-FRM2               PIC X(1).
                 25  BANK-SCR50-TO2                PIC X(1).
                 25  BANK-SCR50-ACC2               PIC X(9).
                 25  BANK-SCR50-DSC2               PIC X(15).
                 25  BANK-SCR50-BAL2               PIC X(13).
                 25  BANK-SCR50-FRM3               PIC X(1).
                 25  BANK-SCR50-TO3                PIC X(1).
                 25  BANK-SCR50-ACC3               PIC X(9).
                 25  BANK-SCR50-DSC3               PIC X(15).
                 25  BANK-SCR50-BAL3               PIC X(13).
                 25  BANK-SCR50-FRM4               PIC X(1).
                 25  BANK-SCR50-TO4                PIC X(1).
                 25  BANK-SCR50-ACC4               PIC X(9).
                 25  BANK-SCR50-DSC4               PIC X(15).
                 25  BANK-SCR50-BAL4               PIC X(13).
                 25  BANK-SCR50-FRM5               PIC X(1).
                 25  BANK-SCR50-TO5                PIC X(1).
                 25  BANK-SCR50-ACC5               PIC X(9).
                 25  BANK-SCR50-DSC5               PIC X(15).
                 25  BANK-SCR50-BAL5               PIC X(13).
                 25  BANK-SCR50-FRM6               PIC X(1).
                 25  BANK-SCR50-TO6                PIC X(1).
                 25  BANK-SCR50-ACC6               PIC X(9).
                 25  BANK-SCR50-DSC6               PIC X(15).
                 25  BANK-SCR50-BAL6               PIC X(13).
                 25  BANK-SCR50-ERRMSG             PIC X(62).
               20  BANK-SCREEN60-DATA.
                 25  BANK-SCR60-RETURN-TO          PIC X(8).
                 25  BANK-SCR60-CONTACT-ID         PIC X(5).
                 25  BANK-SCR60-CONTACT-NAME       PIC X(25).
                 25  BANK-SCR60-CHANGE-ACTION      PIC X(1).
                   88  ADDR-CHANGE-REQUEST         VALUE ' '.
                   88  ADDR-CHANGE-VERIFY          VALUE 'V'.
                   88  ADDR-CHANGE-COMMIT          VALUE 'U'.
                 25  BANK-SCR60-OLD-DETS.
                   30  BANK-SCR60-OLD-ADDR1        PIC X(25).
                   30  BANK-SCR60-OLD-ADDR2        PIC X(25).
                   30  BANK-SCR60-OLD-STATE        PIC X(2).
                   30  BANK-SCR60-OLD-CNTRY        PIC X(6).
                   30  BANK-SCR60-OLD-PSTCDE       PIC X(6).
                   30  BANK-SCR60-OLD-TELNO        PIC X(12).
                   30  BANK-SCR60-OLD-EMAIL        PIC X(30).
                   30  BANK-SCR60-OLD-SEND-MAIL    PIC X(1).
                   30  BANK-SCR60-OLD-SEND-EMAIL   PIC X(1).
                 25  BANK-SCR60-NEW-DETS.
                   30  BANK-SCR60-NEW-ADDR1        PIC X(25).
                   30  BANK-SCR60-NEW-ADDR2        PIC X(25).
                   30  BANK-SCR60-NEW-STATE        PIC X(2).
                   30  BANK-SCR60-NEW-CNTRY        PIC X(6).
                   30  BANK-SCR60-NEW-PSTCDE       PIC X(6).
                   30  BANK-SCR60-NEW-TELNO        PIC X(12).
                   30  BANK-SCR60-NEW-EMAIL        PIC X(30).
                   30  BANK-SCR60-NEW-SEND-MAIL    PIC X(1).
                   30  BANK-SCR60-NEW-SEND-EMAIL   PIC X(1).
               20  BANK-SCREEN70-DATA.
                 25  BANK-SCR70-AMOUNT             PIC X(7).
                 25  BANK-SCR70-RATE               PIC X(7).
                 25  BANK-SCR70-TERM               PIC X(5).
                 25  BANK-SCR70-PAYMENT            PIC X(9).
               20  BANK-SCREEN80-DATA.
                 25  BANK-SCR80-CONTACT-ID         PIC X(5).
                 25  BANK-SCR80-CONTACT-NAME       PIC X(25).
                 25  BANK-SCR80-PRINT-ACTION       PIC X(1).
                   88  PRINT-REQUEST               VALUE ' '.
                   88  PRINT-CONFIRM               VALUE 'C'.
                 25  BANK-SCR80-DETS.
                   30  BANK-SCR80-ADDR1            PIC X(25).
                   30  BANK-SCR80-ADDR2            PIC X(25).
                   30  BANK-SCR80-STATE            PIC X(2).
                   30  BANK-SCR80-CNTRY            PIC X(6).
                   30  BANK-SCR80-PSTCDE           PIC X(6).
                   30  BANK-SCR80-EMAIL            PIC X(30).
                   30  BANK-SCR80-OPT1             PIC X(1).
                   30  BANK-SCR80-OPT2             PIC X(1).
                20  BANK-SCREEN90-DATA.
                 25  BANK-SCR90-SCRN               PIC X(6).
                 25  BANK-SCR90-SCRN-STATUS        PIC X(1).
                 25 BANK-SCR90-LINE                PIC X(75)
                     OCCURS 19 TIMES.
               20  BANK-SCREENZZ-DATA.
                 25  BANK-SCRZZ-SEL1ID             PIC X(1).
                 25  BANK-SCRZZ-SEL1IP             PIC X(1).
                 25  BANK-SCRZZ-SEL1TX             PIC X(40).
                 25  BANK-SCRZZ-SEL2ID             PIC X(1).
                 25  BANK-SCRZZ-SEL2IP             PIC X(1).
                 25  BANK-SCRZZ-SEL2TX             PIC X(40).
                 25  BANK-SCRZZ-SEL3ID             PIC X(1).
                 25  BANK-SCRZZ-SEL3IP             PIC X(1).
                 25  BANK-SCRZZ-SEL3TX             PIC X(40).
                 25  BANK-SCRZZ-SEL4ID             PIC X(1).
                 25  BANK-SCRZZ-SEL4IP             PIC X(1).
                 25  BANK-SCRZZ-SEL4TX             PIC X(40).
                 25  BANK-SCRZZ-SEL5ID             PIC X(1).
                 25  BANK-SCRZZ-SEL5IP             PIC X(1).
                 25  BANK-SCRZZ-SEL5TX             PIC X(40).
                 25  BANK-SCRZZ-SEL6ID             PIC X(1).
                 25  BANK-SCRZZ-SEL6IP             PIC X(1).
                 25  BANK-SCRZZ-SEL6TX             PIC X(40).
                 25  BANK-SCRZZ-SEL7ID             PIC X(1).
                 25  BANK-SCRZZ-SEL7IP             PIC X(1).
                 25  BANK-SCRZZ-SEL7TX             PIC X(40).
                 25  BANK-SCRZZ-SEL8ID             PIC X(1).
                 25  BANK-SCRZZ-SEL8IP             PIC X(1).
                 25  BANK-SCRZZ-SEL8TX             PIC X(40).
               20  BANK-SCREENZZ-DATA-R REDEFINES BANK-SCREENZZ-DATA.
                 25  BANK-SCREENZZ-FIELD           OCCURS 8 TIMES.
                   30  BANK-SCRZZ-ID               PIC X(1).
                   30  BANK-SCRZZ-IP               PIC X(1).
                   30  BANK-SCRZZ-TX               PIC X(40).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
