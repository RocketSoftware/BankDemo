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
      * Program:     ZBNKPRT1.CBL                                     *
      * Function:    Print the bank statements                        *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ZBNKPRT1.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT   SECTION.
         FILE-CONTROL.
           SELECT EXTRACT-FILE
                  ASSIGN       TO EXTRACT
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-EXTRACT-STATUS.
           SELECT PRINTOUT-FILE
                  ASSIGN       TO PRINTOUT
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-PRINTOUT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  EXTRACT-FILE
           RECORDING MODE IS V
           RECORD CONTAINS 66 TO 95 CHARACTERS.
       COPY CBANKXT1.

       FD  PRINTOUT-FILE.
       01  PRINTOUT-REC                            PIC X(121).

       WORKING-STORAGE SECTION.
       COPY CTIMERD.

       01  WS-DATE-WORK-AREA.
       COPY CDATED.

       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'ZBNKPRT1'.
         05  WS-EXTRACT-STATUS.
           10  WS-EXTRACT-STAT1                    PIC X(1).
           10  WS-EXTRACT-STAT2                    PIC X(1).

         05  WS-PRINTOUT-STATUS.
           10  WS-PRINTOUT-STAT1                   PIC X(1).
           10  WS-PRINOUTY-STAT2                   PIC X(1).

         05  WS-IO-STATUS.
           10  WS-IO-STAT1                         PIC X(1).
           10  WS-IO-STAT2                         PIC X(1).

         05  WS-TWO-BYTES.
           10  WS-TWO-BYTES-LEFT                   PIC X(1).
           10  WS-TWO-BYTES-RIGHT                  PIC X(1).
         05 WS-TWO-BYTES-BINARY REDEFINES WS-TWO-BYTES
                                                   PIC 9(1) COMP.

         05  WS-SAVED-EMAIL                        PIC X(30).
         05  WS-EMAIL-INDICATOR                    PIC X(1).
           88  EMAIL-REQUIRED                      VALUE 'Y'.
           88  EMAIL-NOT-REQUIRED                  VALUE 'N'.

         05  WS-FIRST-REC                          PIC X(3)
             VALUE 'YES'.

         05  WS-END-OF-FILE                        PIC X(3)
             VALUE 'NO '.

         05  WS-RECORDS-READ                       PIC 9(5)
             VALUE ZERO.

         05  WS-TXNS-FLAG                          PIC X(1).
           88  TXNS-PRINTED                        VALUE '1'.
           88  NO-TXNS-PRINTED                     VALUE '0'.

         05  WS-SUB1                               PIC 9(3).
         05  WS-SYS-DATE                           PIC 9(5).
         05  WS-SYS-TIME                           PIC 9(8).
         05  WS-PRINTED.
           10  WS-PRINTED-DATE.
             15  FILLER                            PIC X(9)
                 VALUE 'Printed: '.
             15  WS-PRINT-DATE                     PIC X(11)
                 VALUE 'dd mmm yyyy'.
           10  WS-PRINTED-TIME.
             15  FILLER                            PIC X(12)
                 VALUE SPACES.
             15  WS-PRINT-TIME.
               20  WS-PRINT-TIME-HH                PIC X(2).
               20  WS-PRINT-TIME-DOT1              PIC X(1).
               20  WS-PRINT-TIME-MM                PIC X(2).
               20  WS-PRINT-TIME-DOT2              PIC X(1).
               20  WS-PRINT-TIME-SS                PIC X(2).
         05  WS-TOTAL-TXNS                         PIC S9(7)V99 COMP-3.
         05  WS-TOTAL-ASSETS                       PIC S9(7)V99 COMP-3.


       01  WS-PRINT-LINES.
         05  WS-LINE1.
           10  WS-LINE1-CC                         PIC X(1)
               VALUE '1'.
           10  FILLER                              PIC X(40)
               VALUE SPACES.
           10  WS-LINE1-HEAD                       PIC X(21)
               VALUE 'Micro Focus Demo Bank'.

         05  WS-LINE2.
           10  WS-LINE2-CC                         PIC X(1)
               VALUE ' '.
           10  FILLER                              PIC X(40)
               VALUE SPACES.
           10  WS-LINE1-HEAD                       PIC X(20)
               VALUE 'Statement of Account'.

         05  WS-LINE3.
           10  WS-LINE3-CC                         PIC X(1)
               VALUE '0'.
           10  WS-LINE3-NAME-ADDR                  PIC X(23)
               VALUE SPACES.
           10  FILLER                              PIC X(55)
               VALUE SPACES.
           10  WS-LINE3-DATE                       PIC X(20)
               VALUE SPACES.

         05  WS-LINE4.
           10  WS-LINE4-CC                         PIC X(1)
               VALUE '0'.
           10  FILLER                              PIC X(14)
               VALUE 'Account No.'.
           10  FILLER                              PIC X(38)
               VALUE 'Description '.
           10  FILLER                              PIC X(15)
               VALUE '    Date  '.
           10  FILLER                              PIC X(18)
               VALUE '      Amount '.
           10  FILLER                              PIC X(18)
               VALUE '     Balance '.

         05  WS-LINE5.
           10  WS-LINE5-CC                         PIC X(1).
           10  WS-LINE5-ACC-NO                     PIC X(9).
           10  FILLER                              PIC X(5).
           10  WS-LINE5-DESC.
             15  WS-LINE5-DESC-PT1                 PIC X(15).
             15  WS-LINE5-DESC-PT2                 PIC X(18).
           10  FILLER                              PIC X(5).
           10  WS-LINE5-DATE                       PIC X(11).
           10  FILLER                              PIC X(4).
           10  WS-LINE5-AMOUNT-DASH                PIC X(13).
           10  WS-LINE5-AMOUNT REDEFINES WS-LINE5-AMOUNT-DASH
                                                   PIC Z,ZZZ,ZZ9.99-.
           10  FILLER                              PIC X(5).
           10  WS-LINE5-BALANCE-DASH               PIC X(13).
           10  WS-LINE5-BALANCE REDEFINES WS-LINE5-BALANCE-DASH
                                                   PIC Z,ZZZ,ZZZ.99-.

       01  WS-CONSOLE-MESSAGE                      PIC X(48).

       01  WS-EXEC-PARM.
         05  WS-EXEC-PARM-LL                       PIC S9(4) COMP.
         05  WS-EXEC-PARM-DATA                     PIC X(12).

       COPY CSTATESD.

       COPY CABENDD.

       01  WS-PARM-PTR                             POINTER.
       01  WS-PARM-PTR-NUM REDEFINES WS-PARM-PTR   PIC 9(4) COMP.

       01  WS-LE-AREAS.
         05  WS-CEE3DMP-AREAS.
           10  WS-CEE3DMP-DMP-TITLE                PIC X(80)
               VALUE 'CEEDUMP FROM HANDLER ROUTINE'.
           10  WS-CEE3DMP-DMP-OPTIONS              PIC X(255)
               VALUE 'TRACE FILE VAR STOR'.
           10  WS-CEE3DMP-FEEDBACK.
            15 WS-CEE3DMP-FB-SEV                   PIC S9(4) COMP.
            15 WS-CEE3DMP-FB-MSGNO                 PIC S9(4) COMP.
            15 WS-CEE3DMP-FB-CASE-SEV              PIC X(1).
            15 WS-CEE3DMP-FB-FAC-ID                PIC X(3).
            15 WS-CEE3DMP-FB-ISINFO                PIC S9(8) COMP.
         05  WS-CEELOCT-AREAS.
           10  WS-CEELOCT-DATE-LILIAN              PIC S9(9) BINARY.
           10  WS-CEELOCT-SECS-LILIAN              PIC S9(9) COMP.
           10  WS-CEELOCT-TIME-GREGORIAN           PIC X(17).
           10  WS-CEELOCT-FEEDBACK.
            15 WS-CEELOCT-FB-SEV                   PIC S9(4) COMP.
            15 WS-CEELOCT-FB-MSGNO                 PIC S9(4) COMP.
            15 WS-CEELOCT-FB-CASE-SEV              PIC X(1).
            15 WS-CEELOCT-FB-FAC-ID                PIC X(3).
            15 WS-CEELOCTRFB-ISINFO                PIC S9(8) COMP.

       LINKAGE SECTION.
       01  LK-EXEC-PARM.
         05  LK-EXEC-PARM-LL                       PIC S9(4) COMP.
         05  LK-EXEC-PARM-DATA                     PIC X(12).

       PROCEDURE DIVISION USING LK-EXEC-PARM.

           PERFORM RUN-TIME.

           MOVE ZEROES TO WS-EXEC-PARM-LL.
           MOVE SPACES TO WS-EXEC-PARM-DATA.

           SET WS-PARM-PTR TO ADDRESS OF LK-EXEC-PARM.
           IF WS-PARM-PTR-NUM IS NOT EQUAL TO ZEROS
              MOVE LK-EXEC-PARM-LL TO WS-EXEC-PARM-LL
              IF WS-EXEC-PARM-LL IS GREATER THAN
                   LENGTH OF WS-EXEC-PARM-DATA
                 MOVE LENGTH OF WS-EXEC-PARM-DATA TO WS-EXEC-PARM-LL
              END-IF
              IF WS-EXEC-PARM-LL IS GREATER THAN ZERO
                 MOVE LK-EXEC-PARM-DATA (1:WS-EXEC-PARM-LL)
                   TO WS-EXEC-PARM-DATA (1:WS-EXEC-PARM-LL)
              END-IF
           END-IF.

           SET EMAIL-NOT-REQUIRED TO TRUE.
           IF WS-EXEC-PARM-LL IS EQUAL TO ZERO
              MOVE 'No exec card parm present'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
             MOVE SPACES TO WS-CONSOLE-MESSAGE
             STRING 'Exec parm is "' DELIMITED BY SIZE
                    WS-EXEC-PARM-DATA (1:WS-EXEC-PARM-LL)
                      DELIMITED BY SIZE
                    '"' DELIMITED BY SIZE
               INTO WS-CONSOLE-MESSAGE
             PERFORM DISPLAY-CONSOLE-MESSAGE
           END-IF.

           IF FUNCTION UPPER-CASE(WS-EXEC-PARM-DATA) IS EQUAL TO 'EMAIL'
              SET EMAIL-REQUIRED TO TRUE
           END-IF.

           ACCEPT WS-SYS-DATE FROM DAY.
           SET DD-ENV-NULL TO TRUE.
           SET DDI-YYDDD TO TRUE.
           MOVE WS-SYS-DATE TO DDI-DATA.
           SET DDO-DD-MMM-YYYY TO TRUE.
           CALL 'UDATECNV' USING WS-DATE-WORK-AREA.
           MOVE FUNCTION LOWER-CASE(DDO-DATA-DD-MMM-YYYY-MMM(2:2))
             TO DDO-DATA-DD-MMM-YYYY-MMM(2:2).
           MOVE DDO-DATA TO WS-PRINT-DATE.

           PERFORM EXTRACT-OPEN.
           PERFORM PRINTOUT-OPEN.

           PERFORM UNTIL WS-END-OF-FILE = 'YES'
             IF WS-END-OF-FILE = 'NO '
                PERFORM EXTRACT-GET
                IF WS-END-OF-FILE = 'NO '
                   ADD 1 TO WS-RECORDS-READ
      *            IF WS-RECORDS-READ IS LESS THAN 6
      *               DISPLAY BANKXT01-REC1 UPON CONSOLE
      *            ELSE
      *               IF WS-RECORDS-READ IS EQUAL TO 6
      *                  MOVE 'Suppressing record display...'
      *                     TO WS-CONSOLE-MESSAGE
      *                  PERFORM DISPLAY-CONSOLE-MESSAGE
      *               END-IF
      *            END-IF
                   PERFORM FORMAT-AND-PRINT
                ELSE
                   PERFORM PRINT-TOTAL-TXNS
                   PERFORM PRINT-TOTAL-ASSETS
                END-IF
             END-IF
           END-PERFORM.

           PERFORM EXTRACT-CLOSE.
           PERFORM PRINTOUT-CLOSE.

      *    PERFORM DISPLAY-CONSOLE-MESSAGE.
           MOVE 'End Of Job'
             TO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.

           PERFORM RUN-TIME.

           MOVE 0 TO RETURN-CODE.

           GOBACK.

      *****************************************************************
      * Format print lines                                            *
      *****************************************************************
       FORMAT-AND-PRINT.
           IF BANKXT01-1-TYPE IS EQUAL TO '0'
              MOVE BANKXT01-0-EMAIL TO WS-SAVED-EMAIL
           END-IF.
           IF BANKXT01-1-TYPE IS EQUAL TO '1'
              PERFORM PRINT-TOTAL-TXNS
              PERFORM PRINT-TOTAL-ASSETS
              IF EMAIL-REQUIRED
                 MOVE SPACES TO PRINTOUT-REC
                 STRING 'SENDTO: ' DELIMITED BY SIZE
                        WS-SAVED-EMAIL DELIMITED BY SPACE
                   INTO PRINTOUT-REC
                 PERFORM PRINTOUT-PUT
              END-IF
              MOVE WS-LINE1 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE WS-LINE2 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE '0' TO WS-LINE3-CC
              MOVE BANKXT01-1-NAME TO WS-LINE3-NAME-ADDR
              MOVE WS-PRINTED-DATE TO WS-LINE3-DATE
              MOVE WS-LINE3 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE ' ' TO WS-LINE3-CC
              MOVE BANKXT01-1-ADDR1 TO WS-LINE3-NAME-ADDR
              ACCEPT WS-SYS-TIME FROM TIME
              MOVE WS-SYS-TIME (1:2) TO WS-PRINT-TIME-HH
              MOVE ':' TO WS-PRINT-TIME-DOT1
              MOVE WS-SYS-TIME (3:2) TO WS-PRINT-TIME-MM
              MOVE ':' TO WS-PRINT-TIME-DOT2
              MOVE WS-SYS-TIME (5:2) TO WS-PRINT-TIME-SS
              MOVE WS-PRINTED-TIME TO WS-LINE3-DATE
              MOVE WS-LINE3 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE ' ' TO WS-LINE3-CC
              MOVE BANKXT01-1-ADDR2 TO WS-LINE3-NAME-ADDR
              MOVE SPACES TO WS-LINE3-DATE
              MOVE WS-LINE3 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE ' ' TO WS-LINE3-CC
              MOVE BANKXT01-1-STATE TO STATE-PROV-WK-CODE
              PERFORM EXPAND-STATE-PROV THRU
                      EXPAND-STATE-PROV-EXIT
              MOVE STATE-PROV-WK-NAME TO WS-LINE3-NAME-ADDR
              MOVE SPACES TO WS-LINE3-DATE
              MOVE WS-LINE3 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE ' ' TO WS-LINE3-CC
              MOVE BANKXT01-1-CNTRY TO WS-LINE3-NAME-ADDR
              MOVE SPACES TO WS-LINE3-DATE
              MOVE WS-LINE3 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE ' ' TO WS-LINE3-CC
              MOVE BANKXT01-1-PST-CDE TO WS-LINE3-NAME-ADDR
              MOVE SPACES TO WS-LINE3-DATE
              MOVE WS-LINE3 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE WS-LINE4 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE ZERO TO WS-TOTAL-TXNS
              MOVE ZERO TO WS-TOTAL-ASSETS
           END-IF.
           IF BANKXT01-2-TYPE IS EQUAL TO '2'
              PERFORM PRINT-TOTAL-TXNS
              MOVE SPACES TO WS-LINE5
              MOVE BANKXT01-2-ACC-NO TO WS-LINE5-ACC-NO
              MOVE 'Last statement' TO WS-LINE5-DESC-PT1
              MOVE BANKXT01-2-ACC-DESC TO WS-LINE5-DESC-PT2
              MOVE BANKXT01-2-ACC-LAST-STMT-DTE TO DDI-DATA
              SET DD-ENV-NULL TO TRUE
              SET DDI-ISO TO TRUE
              SET DDO-DD-MMM-YYYY TO TRUE
              CALL 'UDATECNV' USING WS-DATE-WORK-AREA
              MOVE DDO-DATA TO WS-LINE5-DATE
              MOVE BANKXT01-2-ACC-CURR-BAL TO WS-LINE5-BALANCE
              ADD BANKXT01-2-ACC-CURR-BAL TO WS-TOTAL-ASSETS
              MOVE WS-LINE5 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
           END-IF.
           IF BANKXT01-3-TYPE IS EQUAL TO '3'
              MOVE SPACES TO WS-LINE5
              MOVE BANKXT01-3-DESC TO WS-LINE5-DESC (4:30)
              MOVE BANKXT01-3-TIMESTAMP (1:10) TO DDI-DATA
              SET DD-ENV-NULL TO TRUE
              SET DDI-ISO TO TRUE
              SET DDO-DD-MMM-YYYY TO TRUE
              CALL 'UDATECNV' USING WS-DATE-WORK-AREA
              MOVE DDO-DATA TO WS-LINE5-DATE
              MOVE BANKXT01-3-AMOUNT TO WS-LINE5-AMOUNT
              ADD BANKXT01-3-AMOUNT TO WS-TOTAL-TXNS
              SET TXNS-PRINTED TO TRUE
              MOVE WS-LINE5 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
           END-IF.

      *****************************************************************
      * Format and print transaction totals                           *
      *****************************************************************
       PRINT-TOTAL-TXNS.
           IF TXNS-PRINTED
              MOVE SPACES TO WS-LINE5
              MOVE '------------' TO WS-LINE5-AMOUNT-DASH
              MOVE WS-LINE5 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE SPACES TO WS-LINE5-DESC
              MOVE 'Total transactions' TO WS-LINE5-DESC (4:30)
              MOVE WS-TOTAL-TXNS TO WS-LINE5-AMOUNT
              MOVE ZERO TO WS-TOTAL-TXNS
              SET NO-TXNS-PRINTED TO TRUE
              MOVE WS-LINE5 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
           END-IF.


      *****************************************************************
      * Format and print "page" totals                                *
      *****************************************************************
       PRINT-TOTAL-ASSETS.
           IF WS-FIRST-REC IS EQUAL TO 'YES'
              MOVE 'NO' TO WS-FIRST-REC
              SET NO-TXNS-PRINTED TO TRUE
           ELSE
              MOVE SPACES TO WS-LINE5
              MOVE '------------' TO WS-LINE5-BALANCE-DASH
              MOVE WS-LINE5 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
              MOVE SPACES TO WS-LINE5
              MOVE 'Total Assets' TO WS-LINE5-DESC
              MOVE WS-TOTAL-ASSETS TO WS-LINE5-BALANCE
              MOVE WS-LINE5 TO PRINTOUT-REC
              PERFORM PRINTOUT-PUT
           END-IF.

      *****************************************************************
      * Open the EXTRACTed data file                                 *
      *****************************************************************
       EXTRACT-OPEN.
           OPEN INPUT EXTRACT-FILE.
           IF WS-EXTRACT-STATUS = '00'
              MOVE 'EXTRACT file opened OK'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              MOVE 'EXTRACT file open failure...'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              MOVE WS-EXTRACT-STATUS TO WS-IO-STATUS
              PERFORM DISPLAY-IO-STATUS
              PERFORM ABORT-PROGRAM
              END-IF.

      *****************************************************************
      * Read a record from the EXTRACTed data file                    *
      *****************************************************************
       EXTRACT-GET.
           READ EXTRACT-FILE.
           IF WS-EXTRACT-STATUS NOT = '00'
              IF WS-EXTRACT-STATUS = '10'
                 MOVE 'YES' TO WS-END-OF-FILE
              ELSE
                 MOVE 'EXTRACT Error readng file ...'
                   TO WS-CONSOLE-MESSAGE
                  PERFORM DISPLAY-CONSOLE-MESSAGE
                  MOVE WS-EXTRACT-STATUS TO WS-IO-STATUS
                  PERFORM DISPLAY-IO-STATUS
                  PERFORM ABORT-PROGRAM
              END-IF
           END-IF.

      *****************************************************************
      * Close the EXTRACTed data file                                 *
      *****************************************************************
       EXTRACT-CLOSE.
           CLOSE EXTRACT-FILE.
           IF WS-EXTRACT-STATUS = '00'
              MOVE 'EXTRACT file closed OK'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              MOVE 'EXTRACT file close failure...'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              MOVE WS-EXTRACT-STATUS TO WS-IO-STATUS
              PERFORM DISPLAY-IO-STATUS
              PERFORM ABORT-PROGRAM
           END-IF.

      *****************************************************************
      * Open the seqential print file                                 *
      *****************************************************************
       PRINTOUT-OPEN.
           OPEN OUTPUT PRINTOUT-FILE.
           IF WS-PRINTOUT-STATUS = '00'
              MOVE 'PRINTOUT file opened OK'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              MOVE 'PRINTOUT file open failure...'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              MOVE WS-PRINTOUT-STATUS TO WS-IO-STATUS
              PERFORM DISPLAY-IO-STATUS
              PERFORM ABORT-PROGRAM
              END-IF.

      *****************************************************************
      * Write a record to the squential file                          *
      *****************************************************************
       PRINTOUT-PUT.
           IF PRINTOUT-REC IS NOT EQUAL TO SPACES
              WRITE PRINTOUT-REC
              IF WS-PRINTOUT-STATUS NOT = '00'
                 MOVE 'PRINTOUT Error Writing file ...'
                   TO WS-CONSOLE-MESSAGE
                 PERFORM DISPLAY-CONSOLE-MESSAGE
                 MOVE WS-PRINTOUT-STATUS TO WS-IO-STATUS
                 PERFORM DISPLAY-IO-STATUS
                 PERFORM ABORT-PROGRAM
              END-IF
           END-IF.

      *****************************************************************
      * Close the seqential print file                                *
      *****************************************************************
       PRINTOUT-CLOSE.
           CLOSE PRINTOUT-FILE.
           IF WS-PRINTOUT-STATUS = '00'
              MOVE 'PRINTOUT file closed OK'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              MOVE 'PRINTOUT file close failure...'
                TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              MOVE WS-PRINTOUT-STATUS TO WS-IO-STATUS
              PERFORM DISPLAY-IO-STATUS
              PERFORM ABORT-PROGRAM
           END-IF.

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
      * Expand the 2 character state/prove code to its full text      *
      *****************************************************************
       EXPAND-STATE-PROV.
           MOVE 0 TO STATE-PROV-SUB.
           DIVIDE LENGTH OF STATE-PROV-DATA (1) INTO
             LENGTH OF STATE-PROV-TABLE
               GIVING STATE-PROV-COUNT.
           MOVE STATE-PROV-WK-CODE TO STATE-PROV-WK-NAME.
       EXPAND-STATE-PROV-LOOP.
           ADD 1 TO STATE-PROV-SUB.
           IF STATE-PROV-SUB IS GREATER THAN STATE-PROV-COUNT
              GO TO EXPAND-STATE-PROV-EXIT
           END-IF.
           IF STATE-PROV-WK-CODE IS EQUAL TO
                STATE-PROV-CODE (STATE-PROV-SUB)
              MOVE STATE-PROV-NAME (STATE-PROV-SUB) TO
                STATE-PROV-WK-NAME
              GO TO EXPAND-STATE-PROV-EXIT
           END-IF.
           GO TO EXPAND-STATE-PROV-LOOP.
       EXPAND-STATE-PROV-EXIT.
           EXIT.

      *****************************************************************
      * 'ABORT' the program.                                          *
      * Post a message to the console and issue a goback              *
      *****************************************************************
       ABORT-PROGRAM.
           IF WS-CONSOLE-MESSAGE NOT = SPACES
              PERFORM DISPLAY-CONSOLE-MESSAGE
           END-IF.
           MOVE 'Program is abending...'  TO WS-CONSOLE-MESSAGE.
           PERFORM DISPLAY-CONSOLE-MESSAGE.
      * Add some LE routines to identify but dont execute them
           IF RETURN-CODE IS NOT EQUAL TO RETURN-CODE
              CALL 'CEE3DMP' USING WS-CEE3DMP-DMP-TITLE
                                   WS-CEE3DMP-DMP-OPTIONS
                                   WS-CEE3DMP-FEEDBACK
              CALL 'CEELOCT' USING WS-CEELOCT-DATE-LILIAN
                                   WS-CEELOCT-SECS-LILIAN
                                   WS-CEELOCT-TIME-GREGORIAN
                                   WS-CEELOCT-FEEDBACK
           END-IF.
           MOVE 16 TO RETURN-CODE.
           GOBACK.

      *****************************************************************
      * Display CONSOLE messages...                                   *
      *****************************************************************
       DISPLAY-CONSOLE-MESSAGE.
           DISPLAY 'ZBNKPRT1 - ' WS-CONSOLE-MESSAGE
             UPON CONSOLE.
           MOVE ALL SPACES TO WS-CONSOLE-MESSAGE.

      * COPY CTIMERP.
       RUN-TIME.
           IF TIMER-START IS EQUAL TO ZERO
              ACCEPT TIMER-START FROM TIME
              MOVE 'Timer started' TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              ACCEPT TIMER-END FROM TIME
              MOVE 'Timer stopped' TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              COMPUTE TIMER-ELAPSED =
                        ((TIMER-END-HH * 60 * 60 * 100) +
                         (TIMER-END-MM * 60 * 100) +
                         (TIMER-END-SS * 100) +
                          TIMER-END-DD) -
                        ((TIMER-START-HH * 60 * 60 * 100) +
                         (TIMER-START-MM * 60 * 100) +
                         (TIMER-START-SS * 100) +
                          TIMER-START-DD)
              MOVE TIMER-ELAPSED-R TO TIMER-RUN-TIME-ELAPSED
              MOVE TIMER-RUN-TIME TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           END-IF.


      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
