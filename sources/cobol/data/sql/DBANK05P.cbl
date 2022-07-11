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
      *              SQL version                                      *
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
         05  WS-TRANS-COUNT                        PIC S9(9) COMP.
         05  WS-TXN-TYPE                           PIC X(1)
             VALUE '1'.

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD05
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
           EXEC SQL
                DECLARE TXN_CSR_EQUAL CURSOR FOR
                SELECT TX.BTX_TIMESTAMP,
                       TX.BTX_AMOUNT,
                       TX.BTX_DATA_OLD
                FROM BNKTXN TX
                WHERE (TX.BTX_ACCNO = :CD05I-ACC) AND
                      (TX.BTX_TYPE = :WS-TXN-TYPE) AND
                      (TX.BTX_TIMESTAMP>= :CD05I-START-ID)
                ORDER BY TX.BTX_TIMESTAMP ASC
                FOR FETCH ONLY
           END-EXEC.
           EXEC SQL
                DECLARE TXN_CSR_HIGH CURSOR FOR
                SELECT TX.BTX_TIMESTAMP,
                       TX.BTX_AMOUNT,
                       TX.BTX_DATA_OLD
                FROM BNKTXN TX
                WHERE (TX.BTX_ACCNO = :CD05I-ACC) AND
                      (TX.BTX_TYPE = :WS-TXN-TYPE) AND
                      (TX.BTX_TIMESTAMP > :CD05I-START-ID)
                ORDER BY TX.BTX_TIMESTAMP ASC
                FOR FETCH ONLY
           END-EXEC.
           EXEC SQL
                DECLARE TXN_CSR_LOW CURSOR FOR
                SELECT TX.BTX_TIMESTAMP,
                       TX.BTX_AMOUNT,
                       TX.BTX_DATA_OLD
                FROM BNKTXN TX
                WHERE (TX.BTX_ACCNO = :CD05I-ACC) AND
                      (TX.BTX_TYPE = :WS-TXN-TYPE) AND
                      (TX.BTX_TIMESTAMP < :CD05I-START-ID)
                ORDER BY TX.BTX_TIMESTAMP DESC
                FOR FETCH ONLY
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
           MOVE SPACES TO CD05O-DATA.

      *****************************************************************
      * Start by settting flag to say there is no data                *
      *****************************************************************
           SET CD05-NO-DATA TO TRUE.

      *****************************************************************
      * Now open the cursor so we can browse the selected rows        *
      *****************************************************************
           EVALUATE TRUE
             WHEN CD05-START-EQUAL
               EXEC SQL
                    OPEN TXN_CSR_EQUAL
               END-EXEC
             WHEN CD05-START-HIGH
               EXEC SQL
                    OPEN TXN_CSR_HIGH
               END-EXEC
             WHEN CD05-START-LOW
               EXEC SQL
                    OPEN TXN_CSR_LOW
               END-EXEC
           END-EVALUATE.

      *****************************************************************
      * Now browse the selected rows are move up to 8 into our area   *
      *****************************************************************
           MOVE 0 TO WS-SUB1.
       TRANSACTION-FETCH-LOOP.
           ADD 1 TO WS-SUB1.
           IF WS-SUB1 IS GREATER THAN 9
              SET CD05-IS-MORE-DATA TO TRUE
              GO TO TRANSACTION-FETCH-LOOP-EXIT.
           EVALUATE TRUE
             WHEN CD05-START-EQUAL
               EXEC SQL
                    FETCH TXN_CSR_EQUAL
                    INTO :DCL-BTX-TIMESTAMP,
                         :DCL-BTX-AMOUNT,
                         :DCL-BTX-DATA-OLD
               END-EXEC
             WHEN CD05-START-HIGH
               EXEC SQL
                    FETCH TXN_CSR_HIGH
                    INTO :DCL-BTX-TIMESTAMP,
                         :DCL-BTX-AMOUNT,
                         :DCL-BTX-DATA-OLD
               END-EXEC
             WHEN CD05-START-LOW
               EXEC SQL
                    FETCH TXN_CSR_LOW
                    INTO :DCL-BTX-TIMESTAMP,
                         :DCL-BTX-AMOUNT,
                         :DCL-BTX-DATA-OLD
               END-EXEC
           END-EVALUATE.

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
           IF SQLSTATE IS EQUAL TO '00000'
              SET CD05-IS-DATA TO TRUE
              MOVE DCL-BTX-TIMESTAMP TO CD05O-ID (WS-SUB2)
              MOVE DCL-BTX-AMOUNT TO CD05O-AMT-N (WS-SUB2)
              MOVE DCL-BTX-DATA-OLD TO TXN-T1-OLD
              MOVE TXN-T1-OLD-DESC TO CD05O-DESC (WS-SUB2)
              GO TO TRANSACTION-FETCH-LOOP
           ELSE
              SET CD05-NO-MORE-DATA TO TRUE
              GO TO TRANSACTION-FETCH-LOOP-EXIT
           END-IF.

      *****************************************************************
      * We quit the loop for some reason                              *
      *****************************************************************
       TRANSACTION-FETCH-LOOP-EXIT.
           EVALUATE TRUE
             WHEN CD05-START-EQUAL
               EXEC SQL
                    CLOSE TXN_CSR_EQUAL
               END-EXEC
             WHEN CD05-START-HIGH
               EXEC SQL
                    CLOSE TXN_CSR_HIGH
               END-EXEC
             WHEN CD05-START-LOW
               EXEC SQL
                    CLOSE TXN_CSR_LOW
               END-EXEC
           END-EVALUATE.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA (1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
