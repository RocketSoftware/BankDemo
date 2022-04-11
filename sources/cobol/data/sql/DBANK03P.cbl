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
      * Program:     DBANK03P.CBL                                     *
      * Function:    Obtain Bank Account balances                     *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK03P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK03P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-COUNT                              PIC S9(10) COMP-3.
         05  WS-TXN-TYPE                           PIC X(1)
             VALUE '1'.

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD03
           END-EXEC.

           EXEC SQL
                BEGIN DECLARE SECTION
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSCS
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSAC
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSAT
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSTX
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKTXD
           END-EXEC.
           EXEC SQL
                INCLUDE SQLCA
           END-EXEC.

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
           MOVE SPACES TO CD03O-DATA.

      *****************************************************************
      * Set up the cursor so we can get all our data                  *
      *****************************************************************
           EXEC SQL
                DECLARE BAL_CSR CURSOR FOR
                SELECT BAC.BAC_ACCNO,
                       BAT.BAT_DESC,
                       BAC.BAC_BALANCE,
                       BAC.BAC_LAST_STMT_DTE,
                       BAC.BAC_LAST_STMT_BAL
                FROM BNKACC BAC,
                     BNKATYPE BAT
                WHERE ((BAC.BAC_ACCTYPE = BAT.BAT_TYPE) AND
                       (BAC.BAC_PID = :CD03I-CONTACT-ID))
                ORDER BY BAT.BAT_DESC ASC
                FOR FETCH ONLY
           END-EXEC.

           EXEC SQL
                OPEN BAL_CSR
           END-EXEC

      *****************************************************************
      * Now browse the selected rows and move up to 5 into our area   *
      *****************************************************************
           MOVE 0 TO WS-SUB1.
       ACCOUNT-FETCH-LOOP.
           ADD 1 TO WS-SUB1.
           IF WS-SUB1 IS GREATER THAN 5
              GO TO ACCOUNT-FETCH-LOOP-EXIT
           END-IF.
           EXEC SQL
                FETCH BAL_CSR
                INTO :DCL-BAC-ACCNO,
                     :DCL-BAT-DESC,
                     :DCL-BAC-BALANCE,
                     :DCL-BAC-LAST-STMT-DTE,
                     :DCL-BAC-LAST-STMT-BAL
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              MOVE DCL-BAC-ACCNO TO CD03O-ACC-NO (WS-SUB1)
              MOVE DCL-BAT-DESC TO CD03O-ACC-DESC (WS-SUB1)
              MOVE DCL-BAC-BALANCE TO CD03O-ACC-BAL-N (WS-SUB1)
              MOVE DCL-BAC-LAST-STMT-DTE TO CD03O-DTE (WS-SUB1)
              EXEC SQL
                   SELECT COUNT(*)
                   INTO :WS-COUNT
                   FROM BNKTXN
                   WHERE (BTX_ACCNO = :DCL-BAC-ACCNO) AND
                         (BTX_TYPE = :WS-TXN-TYPE)
              END-EXEC
              IF WS-COUNT IS EQUAL TO ZERO
                 MOVE SPACE TO CD03O-TXN (WS-SUB1)
              ELSE
                 MOVE '*' TO CD03O-TXN (WS-SUB1)
              END-IF
              GO TO ACCOUNT-FETCH-LOOP
           ELSE
              GO TO ACCOUNT-FETCH-LOOP-EXIT
           END-IF.

      *****************************************************************
      * We quit the loop for some reason                              *
      *****************************************************************
       ACCOUNT-FETCH-LOOP-EXIT.
           EXEC SQL
                CLOSE BAL_CSR
           END-EXEC.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
