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
      * Program:     DBANK52P.CBL                                     *
      * Function:    Sequential read of bank transaction data for     *
      *              batch job                                        *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK52P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK52P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-TXN-TYPE                           PIC X(1)
             VALUE '1'.

       01  WS-COMMAREA.
       COPY CIOFUNCS.

           EXEC SQL
                BEGIN DECLARE SECTION
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKD51
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKD52
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

      *DENNY
               EXEC SQL
                   DECLARE TXNS_CSR_ALL CURSOR FOR
                   SELECT BTX_PID,
                          BTX_ACCNO,
                          BTX_TIMESTAMP,
                          BTX_AMOUNT,
                          BTX_DATA_OLD
                   FROM BNKTXN
                   WHERE BTX_TYPE = :WS-TXN-TYPE
                   FOR FETCH ONLY
              END-EXEC.

               EXEC SQL
                   DECLARE TXNS_CSR_SEL CURSOR FOR
                   SELECT BTX_PID,
                          BTX_ACCNO,
                          BTX_TIMESTAMP,
                          BTX_AMOUNT,
                          BTX_DATA_OLD
                   FROM BNKTXN
                   WHERE (BTX_TYPE = :WS-TXN-TYPE AND
                          BTX_PID = :CD52I-PID)
                   FOR FETCH ONLY
              END-EXEC.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
               OCCURS 1 TO 6144 TIMES
                 DEPENDING ON WS-COMMAREA-LENGTH.

       PROCEDURE DIVISION USING DFHCOMMAREA.
      *****************************************************************
      * Move the passed data to our area                              *
      *****************************************************************
           MOVE LENGTH OF WS-COMMAREA TO WS-COMMAREA-LENGTH.
           MOVE DFHCOMMAREA TO WS-COMMAREA.

      *****************************************************************
      * Initialize our output area                                    *
      *****************************************************************
           MOVE SPACES TO CD52O-DATA.

      *****************************************************************
      * Check what is required                                        *
      *****************************************************************
           EVALUATE TRUE
             WHEN IO-REQUEST-FUNCTION-OPEN
              PERFORM OPEN-CURSOR THRU
                      OPEN-CURSOR-EXIT
             WHEN IO-REQUEST-FUNCTION-READ
              PERFORM READ-CURSOR THRU
                      READ-CURSOR-EXIT
             WHEN IO-REQUEST-FUNCTION-CLOSE
              PERFORM CLOSE-CURSOR THRU
                      CLOSE-CURSOR-EXIT
             WHEN OTHER
              SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-EVALUATE.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA (1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
           GOBACK.


      *****************************************************************
      * Set up CURSORs so we can browse thru selected data            *
      *****************************************************************
       OPEN-CURSOR.
      *DENNY - MOVED DECLARE CURSOR UP TO WORKING STORAGE
      *    IF SQLCODE IS EQUAL TO ZERO
              IF CD52-REQUESTED-ALL
                 EXEC SQL
                      OPEN TXNS_CSR_ALL
                 END-EXEC
              ELSE
                 EXEC SQL
                      OPEN TXNS_CSR_SEL
                 END-EXEC
              END-IF
              IF SQLSTATE IS EQUAL TO '00000'
                 SET IO-REQUEST-STATUS-OK TO TRUE
              ELSE
                 SET IO-REQUEST-STATUS-ERROR TO TRUE
              END-IF.
      *    ELSE
      *       SET IO-REQUEST-STATUS-ERROR TO TRUE
      *    END-IF.
       OPEN-CURSOR-EXIT.
           EXIT.

      *****************************************************************
      * Now browse the selected rows and move to our area 1 at a time *
      *****************************************************************
       READ-CURSOR.
           IF CD52-REQUESTED-ALL
              EXEC SQL
                   FETCH TXNS_CSR_ALL
                   INTO :CD52O-PID,
                        :CD52O-ACC-NO,
                        :CD52O-TIMESTAMP,
                        :CD52O-AMOUNT,
                        :TXN-DATA-OLD
              END-EXEC
           ELSE
              EXEC SQL
                   FETCH TXNS_CSR_SEL
                   INTO :CD52O-PID,
                        :CD52O-ACC-NO,
                        :CD52O-TIMESTAMP,
                        :CD52O-AMOUNT,
                        :TXN-DATA-OLD
              END-EXEC
           END-IF.
           MOVE TXN-T1-OLD-DESC TO CD52O-DESC.
           IF SQLSTATE IS EQUAL TO '00000'
              SET IO-REQUEST-STATUS-OK TO TRUE
           END-IF.
           IF SQLSTATE IS EQUAL TO '02000'
              SET IO-REQUEST-STATUS-EOF TO TRUE
           END-IF.
           IF SQLSTATE IS NOT EQUAL TO '00000' AND
              SQLSTATE IS NOT EQUAL TO '02000'
              SET IO-REQUEST-STATUS-ERROR TO TRUE
              MOVE SPACES TO CD52O-DATA
           END-IF.
       READ-CURSOR-EXIT.
           EXIT.

      *****************************************************************
      * Close the cursor                                              *
      *****************************************************************
       CLOSE-CURSOR.
           IF CD52-REQUESTED-ALL
              EXEC SQL
                   CLOSE TXNS_CSR_ALL
              END-EXEC
           ELSE
              EXEC SQL
                   CLOSE TXNS_CSR_SEL
              END-EXEC
           END-IF.
           IF SQLSTATE IS EQUAL TO ZERO
              SET IO-REQUEST-STATUS-OK TO TRUE
           ELSE
             SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-IF.
       CLOSE-CURSOR-EXIT.
           EXIT.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
