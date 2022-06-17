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
      * Prgram:      ZBNKLOAD.CBL                                     *
      * Function:    Load sequential data into indexed files          *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ZBNKLOAD.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT   SECTION.
         FILE-CONTROL.
           SELECT BNKACC-SEQ
                  ASSIGN       TO SEQACC
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-BNKACC-SEQ-STATUS.

           SELECT BNKATYPE-SEQ
                  ASSIGN       TO SEQATYP
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-BNKATYPE-SEQ-STATUS.

           SELECT BNKCUST-SEQ
                  ASSIGN       TO SEQCUST
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-BNKCUST-SEQ-STATUS.

           SELECT BNKTXN-SEQ
                  ASSIGN       TO SEQTXN
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-BNKTXN-SEQ-STATUS.

           SELECT BNKHELP-SEQ
                  ASSIGN       TO SEQHELP
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-BNKHELP-SEQ-STATUS.

           SELECT BNKACC-NDX
                  ASSIGN       TO NDXACC
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS SEQUENTIAL
                  RECORD KEY   IS BAC-REC-ACCNO
                  ALTERNATE KEY IS BAC-REC-PID WITH DUPLICATES
                  FILE STATUS  IS WS-BNKACC-NDX-STATUS.

           SELECT BNKCUST-NDX
                  ASSIGN       TO NDXCUST
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS RANDOM
                  RECORD KEY   IS BCS-REC-PID
                  ALTERNATE KEY IS BCS-REC-NAME WITH DUPLICATES
                  ALTERNATE KEY IS BCS-REC-NAME-FF WITH DUPLICATES
                  FILE STATUS  IS WS-BNKCUST-NDX-STATUS.

           SELECT BNKATYPE-NDX
                  ASSIGN       TO NDXATYP
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS RANDOM
                  RECORD KEY   IS BAT-REC-TYPE
                  FILE STATUS  IS WS-BNKATYPE-NDX-STATUS.

           SELECT BNKTXN-NDX
                  ASSIGN       TO NDXTXN
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS SEQUENTIAL
                  RECORD KEY   IS BTX-REC-TIMESTAMP
                  ALTERNATE KEY IS BTX-REC-ALTKEY1 WITH DUPLICATES
                  FILE STATUS  IS WS-BNKTXN-NDX-STATUS.

           SELECT BNKHELP-NDX
                  ASSIGN       TO NDXHELP
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS RANDOM
                  RECORD KEY   IS HLP-KEY
                  FILE STATUS  IS WS-BNKHELP-NDX-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  BNKACC-SEQ
           RECORDING MODE IS F
           RECORD CONTAINS 200 CHARACTERS.
       01  BNKACC-SEQ-REC                          PIC X(200).

       FD  BNKATYPE-SEQ
           RECORDING MODE IS F
           RECORD CONTAINS 100 CHARACTERS.
       01  BNKATYPE-SEQ-REC                        PIC X(100).

       FD  BNKCUST-SEQ
           RECORDING MODE IS F
           RECORD CONTAINS 250 CHARACTERS.
       01  BNKCUST-SEQ-REC                         PIC X(250).

       FD  BNKTXN-SEQ
           RECORDING MODE IS F
           RECORD CONTAINS 400 CHARACTERS.
       01  BNKTXN-SEQ-REC                          PIC X(400).

       FD  BNKHELP-SEQ
           RECORDING MODE IS F
           RECORD CONTAINS 83 CHARACTERS.
       01  BNKHELP-SEQ-REC                         PIC X(83).

       FD  BNKACC-NDX.
       01  BNKACC-REC.
       COPY CBANKVAC.

       FD  BNKCUST-NDX.
       01  BNKCUST-REC.
       COPY CBANKVCS.

       FD  BNKATYPE-NDX.
       01  BNKATYPE-REC.
       COPY CBANKVAT.

       FD  BNKTXN-NDX.
       01  BNKTXN-REC.
       COPY CBANKVTX.

       FD  BNKHELP-NDX.
       01  BNKHELP-REC.
       COPY CHELPVSM.

       WORKING-STORAGE SECTION.
       COPY CTIMERD.

       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'ZBNKLOAD'.
         05  WS-BNKACC-SEQ-STATUS                  PIC X(2).
         05  WS-BNKATYPE-SEQ-STATUS                PIC X(2).
         05  WS-BNKCUST-SEQ-STATUS                 PIC X(2).
         05  WS-BNKTXN-SEQ-STATUS                  PIC X(2).
         05  WS-BNKHELP-SEQ-STATUS                 PIC X(2).
         05  WS-BNKACC-NDX-STATUS                  PIC X(2).
         05  WS-BNKATYPE-NDX-STATUS                PIC X(2).
         05  WS-BNKCUST-NDX-STATUS                 PIC X(2).
         05  WS-BNKTXN-NDX-STATUS                  PIC X(2).
         05  WS-BNKHELP-NDX-STATUS                 PIC X(2).

         05  WS-IO-STATUS.
           10  WS-IO-STAT1                         PIC X(1).
           10  WS-IO-STAT2                         PIC X(1).

         05  WS-TWO-BYTES.
           10  WS-TWO-BYTES-LEFT                   PIC X(1).
           10  WS-TWO-BYTES-RIGHT                  PIC X(1).
         05 WS-TWO-BYTES-BINARY REDEFINES WS-TWO-BYTES
                                                   PIC 9(1) COMP.

         05  WS-RECORD-COUNTER1                    PIC 9(5)
             VALUE ZERO.
         05  WS-RECORD-COUNTER2                    PIC 9(5)
             VALUE ZERO.

         05  WS-OPEN-ERROR                         PIC 9(3).
           88  OPEN-OK                             VALUE 0.

         05  WS-FILE                               PIC X(16).


         05  WS-LAST-PID                           PIC X(5)
             VALUE LOW-VALUES.

       01  WS-CONSOLE-MESSAGE                      PIC X(60).

       PROCEDURE DIVISION.
           DISPLAY "sTARTED".
           PERFORM RUN-TIME.
           SET OPEN-OK TO TRUE.

           OPEN INPUT BNKACC-SEQ.
           MOVE WS-BNKACC-SEQ-STATUS TO WS-IO-STATUS.
           MOVE 'BNKACC-SEQ' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN INPUT BNKATYPE-SEQ.
           MOVE WS-BNKATYPE-SEQ-STATUS TO WS-IO-STATUS.
           MOVE 'BNKATYPE-SEQ' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN INPUT BNKCUST-SEQ.
           MOVE WS-BNKCUST-SEQ-STATUS TO WS-IO-STATUS.
           MOVE 'BNKCUST-SEQ' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN INPUT BNKTXN-SEQ.
           MOVE WS-BNKTXN-SEQ-STATUS TO WS-IO-STATUS.
           MOVE 'BNKTXN-SEQ' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN INPUT BNKHELP-SEQ.
           MOVE WS-BNKHELP-SEQ-STATUS TO WS-IO-STATUS.
           MOVE 'BNKHELP-SEQ' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN OUTPUT BNKACC-NDX.
           MOVE WS-BNKACC-NDX-STATUS TO WS-IO-STATUS.
           MOVE 'BNKACC-NDX' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN OUTPUT BNKATYPE-NDX.
           MOVE WS-BNKATYPE-NDX-STATUS TO WS-IO-STATUS.
           MOVE 'BNKATYPE-NDX' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN OUTPUT BNKCUST-NDX.
           MOVE WS-BNKCUST-NDX-STATUS TO WS-IO-STATUS.
           MOVE 'BNKCUST-NDX' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN OUTPUT BNKTXN-NDX.
           MOVE WS-BNKTXN-NDX-STATUS TO WS-IO-STATUS.
           MOVE 'BNKTXN-NDX' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           OPEN OUTPUT BNKHELP-NDX.
           MOVE WS-BNKHELP-NDX-STATUS TO WS-IO-STATUS.
           MOVE 'BNKHELP-NDX' TO WS-FILE.
           PERFORM CHECK-OPEN THRU
                   CHECK-OPEN-EXIT.

           IF WS-OPEN-ERROR IS NOT EQUAL TO ZERO
              MOVE 'Aborting...' TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              GO TO QUICK-EXIT
           END-IF.

       BNKACC-PROCESS.
           MOVE 0 TO WS-RECORD-COUNTER1.
       BNKACC-LOOP.
           READ BNKACC-SEQ INTO BNKACC-REC
             AT END
               GO TO BNKACC-ENDED.
           WRITE BNKACC-REC.
           ADD 1 TO WS-RECORD-COUNTER1.
           GO TO BNKACC-LOOP.
       BNKACC-ENDED.
           MOVE SPACES TO WS-CONSOLE-MESSAGE.
           STRING WS-RECORD-COUNTER1 DELIMITED BY SIZE
                  ' processed from BNKACC' DELIMITED BY SIZE
             INTO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.

       BNKATYPE-PROCESS.
           MOVE 0 TO WS-RECORD-COUNTER1.
       BNKATYPE-LOOP.
           READ BNKATYPE-SEQ INTO BNKATYPE-REC
             AT END
               GO TO BNKATYPE-ENDED.
           WRITE BNKATYPE-REC.
           ADD 1 TO WS-RECORD-COUNTER1.
           GO TO BNKATYPE-LOOP.
       BNKATYPE-ENDED.
           MOVE SPACES TO WS-CONSOLE-MESSAGE.
           STRING WS-RECORD-COUNTER1 DELIMITED BY SIZE
                  ' processed from BNKATYPE' DELIMITED BY SIZE
             INTO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.

       BNKCUST-PROCESS.
           MOVE 0 TO WS-RECORD-COUNTER1.
       BNKCUST-LOOP.
           READ BNKCUST-SEQ INTO BNKCUST-REC
             AT END
               GO TO BNKCUST-ENDED.
           WRITE BNKCUST-REC.
           ADD 1 TO WS-RECORD-COUNTER1.
           GO TO BNKCUST-LOOP.
       BNKCUST-ENDED.
           MOVE SPACES TO WS-CONSOLE-MESSAGE.
           STRING WS-RECORD-COUNTER1 DELIMITED BY SIZE
                  ' processed from BNKCUST' DELIMITED BY SIZE
             INTO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.

       BNKTXN-PROCESS.
           MOVE 0 TO WS-RECORD-COUNTER1.
       BNKTXN-LOOP.
           READ BNKTXN-SEQ INTO BNKTXN-REC
             AT END
               GO TO BNKTXN-ENDED.
           WRITE BNKTXN-REC.
           ADD 1 TO WS-RECORD-COUNTER1.
           GO TO BNKTXN-LOOP.
       BNKTXN-ENDED.
           MOVE SPACES TO WS-CONSOLE-MESSAGE.
           STRING WS-RECORD-COUNTER1 DELIMITED BY SIZE
                  ' processed from BNKTXN' DELIMITED BY SIZE
             INTO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.

       BNKHELP-PROCESS.
           MOVE 0 TO WS-RECORD-COUNTER1.
       BNKHELP-LOOP.
           READ BNKHELP-SEQ INTO BNKHELP-REC
             AT END
               GO TO BNKHELP-ENDED.
           WRITE BNKHELP-REC.
           ADD 1 TO WS-RECORD-COUNTER1.
           GO TO BNKHELP-LOOP.
       BNKHELP-ENDED.
           MOVE SPACES TO WS-CONSOLE-MESSAGE.
           STRING WS-RECORD-COUNTER1 DELIMITED BY SIZE
                  ' processed from BNKHELP' DELIMITED BY SIZE
             INTO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.

           CLOSE BNKACC-SEQ.
           CLOSE BNKATYPE-SEQ.
           CLOSE BNKCUST-SEQ.
           CLOSE BNKTXN-SEQ.
           CLOSE BNKHELP-SEQ.
           CLOSE BNKACC-NDX.
           CLOSE BNKATYPE-NDX.
           CLOSE BNKCUST-NDX.
           CLOSE BNKTXN-NDX.
           CLOSE BNKHELP-NDX.


           PERFORM RUN-TIME.

           MOVE 0 TO RETURN-CODE.
       QUICK-EXIT.
           GOBACK.

      *****************************************************************
      * Check file open OK                                            *
      *****************************************************************
       CHECK-OPEN.
           IF WS-IO-STATUS IS EQUAL TO '00'
              MOVE SPACES TO WS-CONSOLE-MESSAGE
              STRING WS-FILE DELIMITED BY ' '
                     ' opened ok' DELIMITED BY SIZE
                INTO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              MOVE SPACES TO WS-CONSOLE-MESSAGE
              STRING WS-FILE DELIMITED BY ' '
                     ' opened ok' DELIMITED BY SIZE
                INTO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              PERFORM DISPLAY-IO-STATUS
              ADD 1 TO WS-OPEN-ERROR
           END-IF.
       CHECK-OPEN-EXIT.
           EXIT.


      *****************************************************************
      * Display the file status bytes. This routine will display as   *
      * two digits if the full two byte file status is numeric. If    *
      * second byte is non-numeric then it will be treated as a       *
      * binary number.                                                *
      *****************************************************************
       DISPLAY-IO-STATUS.
           IF WS-IO-STATUS NUMERIC
              MOVE SPACE TO WS-CONSOLE-MESSAGE
              STRING 'File status -' DELIMITED BY SIZE
                     WS-IO-STATUS DELIMITED BY SIZE
                INTO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              SUBTRACT WS-TWO-BYTES-BINARY FROM WS-TWO-BYTES-BINARY
              MOVE WS-IO-STAT2 TO WS-TWO-BYTES-RIGHT
              MOVE SPACE TO WS-CONSOLE-MESSAGE
              STRING 'File status -' DELIMITED BY SIZE
                     WS-IO-STAT1 DELIMITED BY SIZE
                     '/' DELIMITED BY SIZE
                     WS-TWO-BYTES DELIMITED BY SIZE
                INTO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           END-IF.

      *****************************************************************
      * 'ABORT' the program.                                          *
      * Post a message to the console and issue a STOP RUN            *
      *****************************************************************
       ABORT-PROGRAM.
           IF WS-CONSOLE-MESSAGE NOT = SPACES
              PERFORM DISPLAY-CONSOLE-MESSAGE
           END-IF.
           MOVE 'Program is abending...'  TO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.
           MOVE 16 TO RETURN-CODE.
           STOP RUN.

      *****************************************************************
      * Display CONSOLE messages...                                   *
      *****************************************************************
       DISPLAY-CONSOLE-MESSAGE.
           DISPLAY WS-PROGRAM-ID ' - ' WS-CONSOLE-MESSAGE.
      *    DISPLAY WS-PROGRAM-ID ' - ' WS-CONSOLE-MESSAGE
      *      UPON CONSOLE.
           MOVE ALL SPACES TO WS-CONSOLE-MESSAGE.

       COPY CTIMERP.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
