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
      * Function:    Sequential read of bank data for batch job       *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK52P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT   SECTION.
         FILE-CONTROL.
           SELECT BNKTXN-FILE
                  ASSIGN       TO BNKTXN
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS SEQUENTIAL
                  RECORD KEY   IS BTX-REC-TIMESTAMP
                  ALTERNATE KEY IS BTX-REC-ALTKEY1 WITH DUPLICATES
                  FILE STATUS  IS WS-BNKTXN-STATUS.

       DATA DIVISION.

       FILE SECTION.
       FD  BNKTXN-FILE.
       01  BNKTXN-REC.
       COPY CBANKVTX.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK52P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.

         05  WS-BNKTXN-STATUS.
           10  WS-BNKTXN-STAT1                     PIC X(1).
           10  WS-BNKTXN-STAT2                     PIC X(1).

       01  WS-COMMAREA.
       COPY CIOFUNCS.
       COPY CBANKD51.
       COPY CBANKD52.

       COPY CBANKTXD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
               OCCURS 1 TO 4096 TIMES
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
              PERFORM OPEN-FILE THRU
                      OPEN-FILE-EXIT
             WHEN IO-REQUEST-FUNCTION-READ
              PERFORM READ-FILE THRU
                      READ-FILE-EXIT
             WHEN IO-REQUEST-FUNCTION-CLOSE
              PERFORM CLOSE-FILE THRU
                      CLOSE-FILE-EXIT
             WHEN OTHER
              SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-EVALUATE.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA  (1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
           GOBACK.


      *****************************************************************
      * Open the file so we can read TXN sequentially                 *
      *****************************************************************
       OPEN-FILE.
           OPEN INPUT BNKTXN-FILE.
           IF WS-BNKTXN-STATUS = '00'
              SET IO-REQUEST-STATUS-OK TO TRUE
           ELSE
              SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-IF.
       OPEN-FILE-EXIT.
           EXIT.

      *****************************************************************
      * Read sequentially through the transaction file                *
      *****************************************************************
       READ-FILE.
           READ BNKTXN-FILE.
      * Was read ok?
           IF WS-BNKTXN-STATUS IS EQUAL TO '00'
              SET IO-REQUEST-STATUS-OK TO TRUE
           END-IF.
      * Was read at end-of-file?
           IF WS-BNKTXN-STATUS IS EQUAL TO '10'
              SET IO-REQUEST-STATUS-EOF TO TRUE
           END-IF.
           IF WS-BNKTXN-STATUS IS NOT EQUAL TO '00' AND
              WS-BNKTXN-STATUS IS NOT EQUAL TO '10'
              SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-IF.
           IF WS-BNKTXN-STATUS IS EQUAL TO '00'
              IF BTX-REC-TYPE IS EQUAL TO '1' AND
                 (BTX-REC-PID IS EQUAL TO CD52I-PID OR
                  CD52-REQUESTED-ALL)
                 MOVE BTX-REC-PID TO CD52O-PID
                 MOVE BTX-REC-ACCNO TO CD52O-ACC-NO
                 MOVE BTX-REC-TIMESTAMP TO CD52O-TIMESTAMP
                 MOVE BTX-REC-AMOUNT TO CD52O-AMOUNT
                 MOVE BTX-REC-DATA-OLD TO TXN-DATA-OLD
                 MOVE TXN-T1-OLD-DESC TO CD52O-DESC
              ELSE
                 GO TO READ-FILE
              END-IF
           END-IF.
       READ-FILE-EXIT.
           EXIT.

      *****************************************************************
      * Close the file                                                *
      *****************************************************************
       CLOSE-FILE.
           CLOSE BNKTXN-FILE.
           IF WS-BNKTXN-STATUS = '00'
              SET IO-REQUEST-STATUS-OK TO TRUE
           ELSE
             SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-IF.
       CLOSE-FILE-EXIT.
           EXIT.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
