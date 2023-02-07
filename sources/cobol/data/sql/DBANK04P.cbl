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
      * Program:     DBANK04P.CBL                                     *
      * Function:    Update account balances                          *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK04P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK04P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD04
           END-EXEC.

           EXEC SQL
                BEGIN DECLARE SECTION
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSAC
           END-EXEC.
           EXEC SQL
                INCLUDE SQLCA
           END-EXEC.

       COPY CTSTAMPD.

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
           MOVE SPACES TO CD04O-DATA.
           SET CD04O-UPDATE-FAIL TO TRUE.
           MOVE '0001-01-01 00:00:00.000000' TO CD04O-TIMESTAMP.

      *****************************************************************
      * Try to update the 'from' balance                              *
      *****************************************************************
           EXEC SQL
                UPDATE BNKACC
                SET BAC_BALANCE = :CD04I-FROM-NEW-BAL
                WHERE (BAC_PID = :CD04I-FROM-PID AND
                       BAC_ACCNO = :CD04I-FROM-ACC AND
                       BAC_BALANCE = :CD04I-FROM-OLD-BAL)
           END-EXEC.

      *****************************************************************
      * Did we update the record OK                                   *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO '00000'
              MOVE 'Unable to update FROM account details'
                TO CD04O-MSG
           GO TO DBANK04P-EXIT
           END-IF.

      *****************************************************************
      * Try to update the 'to' balance                                *
      *****************************************************************
           EXEC SQL
                UPDATE BNKACC
                SET BAC_BALANCE = :CD04I-TO-NEW-BAL
                WHERE (BAC_PID = :CD04I-TO-PID AND
                       BAC_ACCNO = :CD04I-TO-ACC AND
                       BAC_BALANCE = :CD04I-TO-OLD-BAL)
           END-EXEC.

      *****************************************************************
      * Did we update the record OK                                   *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO '00000'
              MOVE 'Unable to update TO account details'
                TO CD04O-MSG
           GO TO DBANK04P-EXIT
           END-IF.

      *****************************************************************
      * If we got this far then the accounts should have been updated *
      *****************************************************************
       COPY CTSTAMPP.
           MOVE WS-TIMESTAMP TO CD04O-TIMESTAMP
           EXEC SQL
                SET :CD04O-TIMESTAMP = CURRENT_TIMESTAMP
           END-EXEC.
           SET CD04O-UPDATE-OK TO TRUE.

       DBANK04P-EXIT.
      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
