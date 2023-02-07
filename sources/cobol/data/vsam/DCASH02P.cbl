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
      * Program:     DCASH02P.CBL                                     *
      * Function:    Obtain ATM enabled account details               *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DCASH02P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DCASH02P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-BNKACCT-AIX1-RID                   PIC X(5).
         05  WS-BNKATYP-RID                        PIC X(1).
         05  WS-BNKTXN-AIX1-RID                    PIC X(31).
         05  WS-BNKTXN-AIX1-RID-LEN                PIC X(31).
         05  WS-ACC-BALANCE                        PIC Z,ZZZ,ZZ9.99-.
         05  WS-ACC-BALANCE-X REDEFINES WS-ACC-BALANCE
                                                   PIC X(13).
         05  WS-ATM-DAY-LIMIT-N                    PIC 9(3).
         05  WS-ATM-DAY-AMT-N                      PIC 9(3).

       01  WS-BNKACCT-REC.
       COPY CBANKVAC.

       01  WS-BNKATYP-REC.
       COPY CBANKVAT.

       01  WS-COMMAREA.
       COPY CCASHD02.

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
           MOVE SPACES TO CD02O-DATA.

      *****************************************************************
      * Set up the start position for the browse                      *
      *****************************************************************
           MOVE CD02I-CONTACT-ID TO WS-BNKACCT-AIX1-RID.

      *****************************************************************
      * Start browsing the file                                       *
      *****************************************************************
           EXEC CICS STARTBR FILE('BNKACC1')
                             RIDFLD(WS-BNKACCT-AIX1-RID)
                             GTEQ
           END-EXEC.

      *****************************************************************
      * Now browse the selected recs and move up to 5 into our area   *
      *****************************************************************
           MOVE 0 TO WS-SUB1.
       ACCOUNT-FETCH-LOOP.
           ADD 1 TO WS-SUB1.
           IF WS-SUB1 IS GREATER THAN 5
              GO TO ACCOUNT-FETCH-LOOP-EXIT
           END-IF.
           MOVE SPACES TO WS-BNKACCT-REC.
           EXEC CICS READNEXT FILE('BNKACC1')
                              INTO(WS-BNKACCT-REC)
                              LENGTH(LENGTH OF WS-BNKACCT-REC)
                              RIDFLD(WS-BNKACCT-AIX1-RID)
                              RESP(WS-RESP)
           END-EXEC.
           IF (WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL) AND
               WS-RESP IS NOT EQUAL TO DFHRESP(DUPKEY)) OR
              BAC-REC-PID IS NOT EQUAL TO CD02I-CONTACT-ID OR
              BAC-REC-ATM-ENABLED IS NOT EQUAL TO 'Y'
              GO TO ACCOUNT-FETCH-LOOP-EXIT
           END-IF.

      *****************************************************************
      * We got an account record ok, save no & bal, get description   *
      *****************************************************************
           MOVE BAC-REC-ACCNO TO CD02O-ACC-NO (WS-SUB1).
           MOVE BAC-REC-TYPE TO WS-BNKATYP-RID.
           EXEC CICS READ FILE('BNKATYPE')
                              INTO(WS-BNKATYP-REC)
                              LENGTH(LENGTH OF WS-BNKATYP-REC)
                              RIDFLD(WS-BNKATYP-RID)
                              RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              MOVE BAT-REC-DESC TO CD02O-ACC-DESC (WS-SUB1)
           ELSE
              MOVE 'Unknown' TO CD02O-ACC-DESC (WS-SUB1)
           END-IF.
           MOVE BAC-REC-BALANCE TO WS-ACC-BALANCE.
           MOVE WS-ACC-BALANCE-X TO CD02O-ACC-BAL (WS-SUB1).
           MOVE BAC-REC-ATM-DAY-LIMIT TO WS-ATM-DAY-LIMIT-N.
           MOVE WS-ATM-DAY-LIMIT-N TO CD02O-ACC-DAY-LIMIT (WS-SUB1).
           MOVE BAC-REC-ATM-DAY-DTE TO CD02O-ACC-DATE-USED (WS-SUB1).
           MOVE BAC-REC-ATM-DAY-AMT TO WS-ATM-DAY-AMT-N.
           MOVE WS-ATM-DAY-AMT-N TO CD02O-ACC-DATE-AMT (WS-SUB1).

           GO TO ACCOUNT-FETCH-LOOP.

      *****************************************************************
      * We quit the loop for some reason                              *
      *****************************************************************
       ACCOUNT-FETCH-LOOP-EXIT.
           EXEC CICS ENDBR FILE('BNKACC1')
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
