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
      * Program:     DBANK05P.CBL                                     *
      * Function:    Obtain list of transactions for an account       *
      *              VSAM Version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK05P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK05P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-SUB2                               PIC S9(4) COMP.
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-WORK1                              PIC S9(15) COMP-3.
         05  WS-WORK2                              PIC S9(15) COMP-3.
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

       01  WS-BNKTXN-REC.
       COPY CBANKVTX.

       COPY CBANKTXD.

       01  WS-TWOS-COMP.
         05  WS-TWOS-COMP-REQ                      PIC X(1).
           88  WS-TWOS-COMP-REQ-YES                VALUE 'Y'.
           88  WS-TWOS-COMP-REQ-NO                 VALUE 'N'.
         05  WS-TWOS-COMP-LEN                      PIC S9(4) COMP.
         05  WS-TWOS-COMP-INPUT                    PIC X(256).
         05  WS-TWOS-COMP-OUTPUT                   PIC X(256).

       01  WS-COMMAREA.
       COPY CBANKD05.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
             OCCURS 1 TO 4096 TIMES
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
           MOVE SPACES TO CD05O-DATA.

      *****************************************************************
      * Setup the start position for the browse                       *
      *****************************************************************
           MOVE CD05I-ACC TO WS-BNKTXN-AIX1-RID-ACC.
           MOVE CD05I-START-ID TO WS-BNKTXN-AIX1-RID-STAMP.
      * We can't do a GT or LT, only GTEQ, as we can with DL1 or SQL.
      * Thus we will 'fix' the search key by adjusting the time stamp
      * up by 1 if we are going GT.
      * We will convert the time part the timestamp (hh:mm:ss.dddddd)
      * to a single nunber be the number of milli-sec. We then add or
      * subtract 1 as appropriate and then convert it back. This should
      * work for any time that doesen't show as 23:59:59.999999 as this
      * will cause a change in the date.
           IF CD05-START-HIGH
              COMPUTE WS-WORK1 =
                      (WS-BNKTXN-AIX1-RID-HH * 60 * 60 * 1000000) +
                      (WS-BNKTXN-AIX1-RID-MM * 60 * 1000000) +
                      (WS-BNKTXN-AIX1-RID-SS * 1000000) +
                      WS-BNKTXN-AIX1-RID-DEC
              ADD 1 TO WS-WORK1
              DIVIDE 1000000 INTO WS-WORK1
                GIVING WS-WORK2
                  REMAINDER WS-BNKTXN-AIX1-RID-DEC
              MOVE WS-WORK2 TO WS-WORK1
              DIVIDE 60 INTO WS-WORK1
                GIVING WS-WORK2
                  REMAINDER WS-BNKTXN-AIX1-RID-SS
              MOVE WS-WORK2 TO WS-WORK1
              DIVIDE 60 INTO WS-WORK1
                GIVING WS-WORK2
                  REMAINDER WS-BNKTXN-AIX1-RID-MM
              MOVE WS-WORK2 TO WS-WORK1
              MOVE WS-WORK1 TO WS-BNKTXN-AIX1-RID-HH
           END-IF.
           EXEC CICS STARTBR FILE('BNKTXN1')
                             RIDFLD(WS-BNKTXN-AIX1-RID)
                             GTEQ
           END-EXEC.

           MOVE 0 TO WS-SUB1.

      *****************************************************************
      * Now attempt to get the requested records                      *
      *****************************************************************
       TRANSACTION-FETCH-LOOP.
           ADD 1 TO WS-SUB1.
           IF WS-SUB1 IS GREATER THAN 9
              SET CD05-IS-MORE-DATA TO TRUE
              GO TO TRANSACTION-FETCH-LOOP-EXIT
           END-IF.
           IF CD05-START-EQUAL OR
              CD05-START-HIGH
              EXEC CICS READNEXT FILE('BNKTXN1')
                                 INTO(WS-BNKTXN-REC)
                                 LENGTH(LENGTH OF WS-BNKTXN-REC)
                                 RIDFLD(WS-BNKTXN-AIX1-RID)
                                 RESP(WS-RESP)
              END-EXEC
           END-IF.
      * If we are reading 'low' then we need to read backwards. This is
      * OK except we want the record prior to the on with the provided
      * key so we throw away the 1st record.
           IF CD05-START-LOW
              EXEC CICS READPREV FILE('BNKTXN1')
                                 INTO(WS-BNKTXN-REC)
                                 LENGTH(LENGTH OF WS-BNKTXN-REC)
                                 RIDFLD(WS-BNKTXN-AIX1-RID)
                                 RESP(WS-RESP)
              END-EXEC
              IF WS-SUB1 IS EQUAL TO 1
                 EXEC CICS READPREV FILE('BNKTXN1')
                                    INTO(WS-BNKTXN-REC)
                                    LENGTH(LENGTH OF WS-BNKTXN-REC)
                                    RIDFLD(WS-BNKTXN-AIX1-RID)
                                    RESP(WS-RESP)
                 END-EXEC
              END-IF
           END-IF.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF CD05-START-LOW
              IF WS-SUB1 IS GREATER THAN 8
                 MOVE WS-SUB1 TO WS-SUB2
              ELSE
                 SUBTRACT WS-SUB1 FROM 9 GIVING WS-SUB2
              END-IF
           ELSE
              MOVE WS-SUB1 TO WS-SUB2
           END-IF.
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              IF CD05I-ACC IS EQUAL TO BTX-REC-ACCNO
                 SET CD05-IS-DATA TO TRUE
                 MOVE BTX-REC-TIMESTAMP TO CD05O-ID (WS-SUB2)
                 MOVE BTX-REC-AMOUNT TO CD05O-AMT-N (WS-SUB2)
                 MOVE BTX-REC-DATA-OLD TO TXN-T1-OLD
                 MOVE TXN-T1-OLD-DESC TO CD05O-DESC (WS-SUB2)
                 GO TO TRANSACTION-FETCH-LOOP
              ELSE
                 SET CD05-NO-MORE-DATA TO TRUE
                 GO TO TRANSACTION-FETCH-LOOP-EXIT
              END-IF
           ELSE
              SET CD05-NO-MORE-DATA TO TRUE
              GO TO TRANSACTION-FETCH-LOOP-EXIT
           END-IF.

       TRANSACTION-FETCH-LOOP-EXIT.
           EXEC CICS ENDBR FILE('BNKTXN1')
           END-EXEC.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
