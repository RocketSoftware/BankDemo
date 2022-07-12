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
      * Program:     DBANK11P.CBL                                     *
      * Function:    Obtain Bank Account Details (Extended)           *
      *              VSAM Version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK11P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK11P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-BNKACC-RID                         PIC X(9).
         05  WS-BNKTXN-AIX1-RID                    PIC X(35).
         05  WS-BNKTXN-AIX1-RID-R REDEFINES WS-BNKTXN-AIX1-RID.
           10  WS-BNKTXN-AIX1-RID-ACC              PIC X(9).
           10  WS-BNKTXN-AIX1-RID-STAMP.
             15  WS-BNKTXN-AIX1-RID-DATE           PIC X(10).
             15  WS-BNKTXN-AIX1-RID-DOT1           PIC X(1).
             15  WS-BNKTXN-AIX1-RID-TIME           PIC X(15).
             15  WS-BNKTXN-AIX1-RID-TIME-R REDEFINES
                   WS-BNKTXN-AIX1-RID-TIME.
               20  WS-BNKTXN-AIX1-RID-HH           PIC 9(2).
               20  WS-BNKTXN-AIX1-RID-DOT2         PIC X(1).
               20  WS-BNKTXN-AIX1-RID-MM           PIC 9(2).
               20  WS-BNKTXN-AIX1-RID-DOT3         PIC X(1).
               20  WS-BNKTXN-AIX1-RID-SS           PIC 9(2).
               20  WS-BNKTXN-AIX1-RID-DOT4         PIC X(1).
               20  WS-BNKTXN-AIX1-RID-DEC          PIC 9(6).
         05  WS-TRANS-COUNT                        PIC S9(10) COMP-3.
         05  WS-TRANS-EDIT                         PIC Z(6)9.
         05  WS-TRANS-EDIT-X REDEFINES WS-TRANS-EDIT
                                                   PIC X(7).

       COPY CTSTAMPD.

       01  WS-BNKACC-REC.
       COPY CBANKVAC.

       01  WS-BNKTXN-REC.
       COPY CBANKVTX.

       01  WS-COMMAREA.
       COPY CBANKD11.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
             OCCURS 1 TO 6144 TIMES
               DEPENDING ON WS-COMMAREA-LENGTH.

       COPY CENTRY.
      *****************************************************************
      * Move the passed data to our area                              *
      *****************************************************************
           MOVE LENGTH OF WS-COMMAREA TO WS-COMMAREA-LENGTH.
           MOVE DFHCOMMAREA TO WS-COMMAREA.

      *****************************************************************
      * Initialize our output area                                    *
      *****************************************************************
           MOVE SPACES TO CD11O-DATA.

      *****************************************************************
      * Now attempt to get the requested record                       *
      *****************************************************************
           MOVE CD11I-ACCNO TO WS-BNKACC-RID.
           EXEC CICS READ FILE('BNKACC')
                          INTO(WS-BNKACC-REC)
                          LENGTH(LENGTH OF WS-BNKACC-REC)
                          RIDFLD(WS-BNKACC-RID)
                          RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE SPACES TO CD11O-ACCNO
              GO TO FINISH
           END-IF.

      *****************************************************************
      * We got the record OK                                          *
      *****************************************************************
           MOVE BAC-REC-ACCNO TO CD11O-ACCNO.
           MOVE ALL '?' TO CD11O-DESC.
           MOVE BAC-REC-BALANCE TO CD11O-BAL-N.
           MOVE BAC-REC-LAST-STMT-DTE TO CD11O-DTE.
           MOVE 'No' TO CD11O-TRANS.
           MOVE BAC-REC-ATM-ENABLED TO CD11O-ATM-ENABLED.
           MOVE BAC-REC-ATM-DAY-LIMIT TO CD11O-ATM-LIM-N.
           MOVE BAC-REC-ATM-DAY-DTE TO CD11O-ATM-LDTE.
           MOVE BAC-REC-ATM-DAY-AMT TO CD11O-ATM-LAMT-N.
           MOVE BAC-REC-RP1-DAY TO CD11O-RP1DAY.
           MOVE BAC-REC-RP1-AMOUNT TO CD11O-RP1AMT-N.
           MOVE BAC-REC-RP1-PID TO CD11O-RP1PID.
           MOVE BAC-REC-RP1-ACCNO TO CD11O-RP1ACC.
           MOVE BAC-REC-RP1-LAST-PAY TO CD11O-RP1DTE.
           MOVE BAC-REC-RP2-DAY TO CD11O-RP2DAY.
           MOVE BAC-REC-RP2-AMOUNT TO CD11O-RP2AMT-N.
           MOVE BAC-REC-RP2-PID TO CD11O-RP2PID.
           MOVE BAC-REC-RP2-ACCNO TO CD11O-RP2ACC.
           MOVE BAC-REC-RP2-LAST-PAY TO CD11O-RP2DTE.
           MOVE BAC-REC-RP3-DAY TO CD11O-RP3DAY.
           MOVE BAC-REC-RP3-AMOUNT TO CD11O-RP3AMT-N.
           MOVE BAC-REC-RP3-PID TO CD11O-RP3PID.
           MOVE BAC-REC-RP3-ACCNO TO CD11O-RP3ACC.
           MOVE BAC-REC-RP3-LAST-PAY TO CD11O-RP3DTE.

      *****************************************************************
      * Check for transactions                                        *
      *****************************************************************
       BROWSE-START.
           MOVE 0 TO WS-TRANS-COUNT.
           MOVE LOW-VALUES TO WS-BNKTXN-AIX1-RID.
           MOVE CD11I-ACCNO TO WS-BNKTXN-AIX1-RID-ACC.
           EXEC CICS STARTBR FILE('BNKTXN1')
                             RIDFLD(WS-BNKTXN-AIX1-RID)
                             GTEQ
           END-EXEC.
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              GO TO BROWSE-STOP
           END-IF.
       BROWSE-LOOP.
           EXEC CICS READNEXT FILE('BNKTXN1')
                              INTO(WS-BNKTXN-REC)
                              LENGTH(LENGTH OF WS-BNKTXN-REC)
                              RIDFLD(WS-BNKTXN-AIX1-RID)
                              RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              IF CD11I-ACCNO IS EQUAL TO BTX-REC-ACCNO
                 ADD 1 TO WS-TRANS-COUNT
                 GO TO BROWSE-LOOP
              END-IF
           END-IF.

       BROWSE-STOP.
           EXEC CICS ENDBR FILE('BNKTXN1')
           END-EXEC.

           IF WS-TRANS-COUNT IS EQUAL TO 0
              MOVE 'No' TO CD11O-TRANS
           ELSE
              MOVE WS-TRANS-COUNT TO WS-TRANS-EDIT
              PERFORM TRANS-LEFT-JUST
              MOVE WS-TRANS-EDIT-X TO CD11O-TRANS
           END-IF.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       FINISH.
       COPY CRETURN.

       TRANS-LEFT-JUST.
           IF WS-TRANS-EDIT-X(1:1) IS EQUAL TO SPACE
              MOVE WS-TRANS-EDIT-X(2:LENGTH OF WS-TRANS-EDIT-X - 1)
                TO WS-TRANS-EDIT-X(1:LENGTH OF WS-TRANS-EDIT-X - 1)
              MOVE SPACE
                TO WS-TRANS-EDIT-X(LENGTH OF WS-TRANS-EDIT-X:1)
              GO TO TRANS-LEFT-JUST.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
