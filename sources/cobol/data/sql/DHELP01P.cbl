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
      * Program:     DHELP01P.CBL                                     *
      * Function:    Obtain screen help information                   *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DHELP01P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DHELP01P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-LINE                               PIC X(2).
         05  WS-LINE-N REDEFINES WS-LINE           PIC 9(2).

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CHELPD01
           END-EXEC.

           EXEC SQL
                BEGIN DECLARE SECTION
           END-EXEC.
           EXEC SQL
                INCLUDE CHELPSQL
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
           MOVE SPACES TO HELP01O-DATA.
           MOVE HELP01I-SCRN TO HELP01O-SCRN.
           SET HELP-FOUND TO TRUE.

      *****************************************************************
      * Set up CURSOR so we can browse thru selected data             *
      *****************************************************************
           EXEC SQL
                DECLARE BHP_CSR CURSOR FOR
                SELECT BHP.BHP_LINE,
                       BHP.BHP_TEXT
                FROM BNKHELP BHP
                WHERE BHP.BHP_SCRN = :HELP01I-SCRN
                ORDER BY BHP.BHP_LINE ASC
                FOR FETCH ONLY
           END-EXEC.

      *****************************************************************
      * Now open the cursor so we can browse the selected rows        *
      *****************************************************************
           EXEC SQL
                OPEN BHP_CSR
           END-EXEC.

      *****************************************************************
      * Now browse the selected rows are move up to 19 into our area  *
      *****************************************************************
           MOVE 0 TO WS-SUB1.
       TEXT-FETCH-LOOP.
           ADD 1 TO WS-SUB1.
           IF WS-SUB1 IS GREATER THAN 19
              GO TO TEXT-FETCH-LOOP-EXIT.
           EXEC SQL
                FETCH BHP_CSR
                INTO :DCL-BHP-LINE,
                     :DCL-BHP-TEXT
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              MOVE DCL-BHP-LINE TO WS-LINE
              IF WS-LINE IS NUMERIC
                 IF WS-LINE-N IS GREATER THAN 00 AND
                    WS-LINE-N IS NOT GREATER THAN 19
                    MOVE DCL-BHP-TEXT TO HELP01O-LINE (WS-LINE-N)
                 END-IF
              END-IF
              GO TO TEXT-FETCH-LOOP
           ELSE
              IF HELP01O-INDIVIDUAL-LINES IS EQUAL TO SPACES
                 SET HELP-NOT-FOUND TO TRUE
                 MOVE 'No help available' TO HELP01O-LINE (10) (30:17)
              END-IF
              GO TO TEXT-FETCH-LOOP-EXIT
           END-IF.

      *****************************************************************
      * We quit the loop for some reason                              *
      *****************************************************************
       TEXT-FETCH-LOOP-EXIT.
           EXEC SQL
                CLOSE BHP_CSR
           END-EXEC.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA (1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
