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
      * Program:     DBANK51P.CBL                                     *
      * Function:    Sequential read of bank data for batch job       *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK51P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT   SECTION.
         FILE-CONTROL.
           SELECT BNKACC-FILE
                  ASSIGN       TO BNKACC
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS SEQUENTIAL
                  RECORD KEY   IS BAC-REC-ACCNO
                  ALTERNATE KEY IS BAC-REC-PID WITH DUPLICATES
                  FILE STATUS  IS WS-BNKACC-STATUS.

           SELECT BNKCUST-FILE
                  ASSIGN       TO BNKCUST
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS RANDOM
                  RECORD KEY   IS BCS-REC-PID
                  ALTERNATE KEY IS BCS-REC-NAME
                    WITH DUPLICATES
                  ALTERNATE KEY IS BCS-REC-NAME-FF
                    WITH DUPLICATES
                  FILE STATUS  IS WS-BNKCUST-STATUS.

           SELECT BNKATYP-FILE
                  ASSIGN       TO BNKATYP
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS RANDOM
                  RECORD KEY   IS BAT-REC-TYPE
                  FILE STATUS  IS WS-BNKATYP-STATUS.

       DATA DIVISION.

       FILE SECTION.
       FD  BNKACC-FILE.
       01  BNKACC-REC.
       COPY CBANKVAC.

       FD  BNKCUST-FILE.
       01  BNKCUST-REC.
       COPY CBANKVCS.

       FD  BNKATYP-FILE.
       01  BNKATYP-REC.
       COPY CBANKVAT.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK51P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.

         05  WS-BNKACC-STATUS.
           10  WS-BNKACC-STAT1                     PIC X(1).
           10  WS-BNKACC-STAT2                     PIC X(1).

         05  WS-BNKCUST-STATUS.
           10  WS-BNKCUST-STAT1                    PIC X(1).
           10  WS-BNKCUST-STAT2                    PIC X(1).

         05  WS-BNKATYP-STATUS.
           10  WS-BNKATYP-STAT1                    PIC X(1).
           10  WS-BNKATYP-STAT2                    PIC X(1).

       01  WS-COMMAREA.
       COPY CIOFUNCS.
       COPY CBANKD51.

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
           MOVE SPACES TO CD51O-DATA.

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
      * Open the file so we can read ACC sequentially, others randomly*
      *****************************************************************
       OPEN-FILE.
           OPEN INPUT BNKACC-FILE.
           OPEN INPUT BNKCUST-FILE.
           OPEN INPUT BNKATYP-FILE.
           IF CD51-REQUESTED-ALL
              MOVE LOW-VALUES TO BAC-REC-PID
              START BNKACC-FILE KEY GREATER THAN BAC-REC-PID
           ELSE
              MOVE CD51I-PID TO BAC-REC-PID
              START BNKACC-FILE KEY EQUAL BAC-REC-PID
           END-IF
           IF WS-BNKACC-STATUS = '00' AND
              WS-BNKCUST-STATUS = '00' AND
              WS-BNKATYP-STATUS = '00'
              SET IO-REQUEST-STATUS-OK TO TRUE
           ELSE
              SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-IF.
       OPEN-FILE-EXIT.
           EXIT.

      *****************************************************************
      * Read sequentially through the customer file                   *
      *****************************************************************
       READ-FILE.
           READ BNKACC-FILE.
      * If key is greater than the one we want, fake end-of-file
           IF NOT CD51-REQUESTED-ALL AND
              BAC-REC-PID IS NOT EQUAL TO CD51I-PID
              MOVE '10' TO WS-BNKACC-STATUS
           END-IF.
      * Was read ok?
           IF WS-BNKACC-STATUS IS EQUAL TO '00'
              SET IO-REQUEST-STATUS-OK TO TRUE
           END-IF.
      * Was read a duplicate key?
           IF WS-BNKACC-STATUS IS EQUAL TO '02'
              MOVE '00' TO WS-BNKACC-STATUS
              SET IO-REQUEST-STATUS-OK TO TRUE
           END-IF.
      * Was read at end-of-file?
           IF WS-BNKACC-STATUS IS EQUAL TO '10'
              SET IO-REQUEST-STATUS-EOF TO TRUE
           END-IF.
           IF WS-BNKACC-STATUS IS NOT EQUAL TO '00' AND
              WS-BNKACC-STATUS IS NOT EQUAL TO '10'
              SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-IF.
           IF WS-BNKACC-STATUS IS EQUAL TO '00'
              MOVE BAC-REC-PID TO CD51O-PID
              MOVE BAC-REC-ACCNO TO CD51O-ACC-NO
              MOVE BAC-REC-BALANCE TO CD51O-ACC-CURR-BAL
              MOVE BAC-REC-LAST-STMT-DTE TO CD51O-ACC-LAST-STMT-DTE
              MOVE BAC-REC-LAST-STMT-BAL TO CD51O-ACC-LAST-STMT-BAL
              IF BAC-REC-PID IS NOT EQUAL TO BCS-REC-PID
                 MOVE BAC-REC-PID TO BCS-REC-PID
                 READ BNKCUST-FILE
                 IF WS-BNKCUST-STATUS IS NOT EQUAL TO '00'
                    MOVE SPACES TO BCS-RECORD
                    MOVE 'Customer name unavailable' TO BCS-REC-NAME
                 END-IF
              END-IF

              MOVE BCS-REC-NAME TO CD51O-NAME
              MOVE BCS-REC-ADDR1 TO CD51O-ADDR1
              MOVE BCS-REC-ADDR2 TO CD51O-ADDR2
              MOVE BCS-REC-STATE TO CD51O-STATE
              MOVE BCS-REC-CNTRY TO CD51O-CNTRY
              MOVE BCS-REC-POST-CODE TO CD51O-POST-CODE
              MOVE BCS-REC-EMAIL TO CD51O-EMAIL

              MOVE BAC-REC-TYPE TO BAT-REC-TYPE
              READ BNKATYP-FILE
              IF WS-BNKATYP-STATUS IS NOT EQUAL TO '00'
                 MOVE 'A/C description unavailable' TO CD51O-ACC-DESC
              ELSE
                 MOVE BAT-REC-DESC TO CD51O-ACC-DESC
              END-IF
           END-IF.
       READ-FILE-EXIT.
           EXIT.

      *****************************************************************
      * Close the file                                                *
      *****************************************************************
       CLOSE-FILE.
           CLOSE BNKCUST-FILE.
           CLOSE BNKACC-FILE.
           CLOSE BNKATYP-FILE.
           IF WS-BNKCUST-STATUS = '00' AND
              WS-BNKACC-STATUS = '00' AND
              WS-BNKATYP-STATUS = '00'
              SET IO-REQUEST-STATUS-OK TO TRUE
           ELSE
             SET IO-REQUEST-STATUS-ERROR TO TRUE
           END-IF.
       CLOSE-FILE-EXIT.
           EXIT.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
