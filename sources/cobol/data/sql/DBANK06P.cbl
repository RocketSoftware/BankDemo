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
      * Program:     DBANK06P.CBL                                     *
      * Function:    Write transaction records for audit trail        *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK06P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK06P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-SUB2                               PIC S9(4) COMP.
         05  WS-TRANS-COUNT                        PIC S9(9) COMP.

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD06
           END-EXEC.

           EXEC SQL
                BEGIN DECLARE SECTION
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
           MOVE SPACES TO CD06O-DATA.

      *****************************************************************
      * Insert two rows/records into the database/file                *
      *****************************************************************
      *****************************************************************
      * First row/record is for the from-to transaction               *
      *****************************************************************
           MOVE '0' TO CD06I-TIMESTAMP (26:1).
           MOVE CD06I-FROM-DESC TO TXN-T1-OLD-DESC.
           EXEC SQL
                INSERT
                INTO BNKTXN (BTX_PID,
                             BTX_TYPE,
                             BTX_SUB_TYPE,
                             BTX_ACCNO,
                             BTX_TIMESTAMP,
                             BTX_AMOUNT,
                             BTX_DATA_OLD)
                VALUES (:CD06I-FROM-PID,
                        '1',
                        '1',
                        :CD06I-FROM-ACC,
                         CURRENT_TIMESTAMP,
                        :CD06I-FROM-AMOUNT,
                        :TXN-T1-OLD-DESC)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO '00000'
              SET CD06O-UPDATE-FAIL TO TRUE
              MOVE 'Unable to insert FROM transaction record'
                TO CD06O-MSG
           END-IF.

      *****************************************************************
      * Second row/record is for the from-to transaction              *
      *****************************************************************
           MOVE '1' TO CD06I-TIMESTAMP (26:1).
           MOVE CD06I-TO-DESC TO TXN-T1-OLD-DESC.
           EXEC SQL
                INSERT
                INTO BNKTXN (BTX_PID,
                             BTX_TYPE,
                             BTX_SUB_TYPE,
                             BTX_ACCNO,
                             BTX_TIMESTAMP,
                             BTX_AMOUNT,
                             BTX_DATA_OLD)
                VALUES (:CD06I-TO-PID,
                        '1',
                        '2',
                        :CD06I-TO-ACC,
                         CURRENT_TIMESTAMP,
                        :CD06I-TO-AMOUNT,
                        :TXN-T1-OLD-DESC)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO '00000'
              SET CD06O-UPDATE-FAIL TO TRUE
              MOVE 'Unable to insert TO transaction record'
                TO CD06O-MSG
           END-IF.


      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA (1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
