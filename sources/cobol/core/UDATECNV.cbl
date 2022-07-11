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
      * Program:     UDATECNV.CBL                                     *
      * Function:    Date conversion utility routine                  *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           UDATECNV.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'UDATECNV'.
         05  WS-SAVED-DDI-DATA                     PIC X(20).
         05  WS-MONTH-TABLE.
           10  FILLER          VALUE 'Jan'         PIC X(3).
           10  FILLER          VALUE 'Feb'         PIC X(3).
           10  FILLER          VALUE 'Mar'         PIC X(3).
           10  FILLER          VALUE 'Apr'         PIC X(3).
           10  FILLER          VALUE 'May'         PIC X(3).
           10  FILLER          VALUE 'Jun'         PIC X(3).
           10  FILLER          VALUE 'Jul'         PIC X(3).
           10  FILLER          VALUE 'Aug'         PIC X(3).
           10  FILLER          VALUE 'Sep'         PIC X(3).
           10  FILLER          VALUE 'Oct'         PIC X(3).
           10  FILLER          VALUE 'Nov'         PIC X(3).
           10  FILLER          VALUE 'Dec'         PIC X(3).
         05  WS-MONTH-TABLE-R REDEFINES WS-MONTH-TABLE.
           10  WS-MONTH                            PIC X(3)
               OCCURS 12 TIMES.
         05  WS-DAYS-TABLE.
           10  WS-DAYS-IN-JAN  VALUE 031           PIC 9(3).
           10  WS-DAYS-IN-FEB  VALUE 028           PIC 9(3).
           10  WS-DAYS-IN-MAR  VALUE 031           PIC 9(3).
           10  WS-DAYS-IN-APR  VALUE 030           PIC 9(3).
           10  WS-DAYS-IN-MAY  VALUE 031           PIC 9(3).
           10  WS-DAYS-IN-JUN  VALUE 030           PIC 9(3).
           10  WS-DAYS-IN-JUL  VALUE 031           PIC 9(3).
           10  WS-DAYS-IN-AUG  VALUE 031           PIC 9(3).
           10  WS-DAYS-IN-SEP  VALUE 030           PIC 9(3).
           10  WS-DAYS-IN-OCT  VALUE 031           PIC 9(3).
           10  WS-DAYS-IN-NOV  VALUE 030           PIC 9(3).
           10  WS-DAYS-IN-DEV  VALUE 031           PIC 9(3).
         05  WS-DAYS-TABLE-R REDEFINES WS-DAYS-TABLE.
           10  WS-DAYS-IN-MONTH                    PIC 9(3)
               OCCURS 12 TIMES.
         05  WS-DAYS                               PIC 9(3).
         05  WS-DAYS-R REDEFINES WS-DAYS.
           10  FILLER                              PIC X(1).
           10  WS-DAY-OF-MONTH                     PIC X(2).
         05  WS-WORK-MM                            PIC 9(2).
         05  WS-WORK-DD                            PIC 9(2).
         05  WS-TEMP                               PIC 9(2).
         05  WS-SYSTEM-TIME                        PIC 9(8).
         05  WS-SYSTEM-TIME-R REDEFINES WS-SYSTEM-TIME.
           10  WS-SYSTEM-TIME-HHMMSS               PIC 9(6).
           10  WS-SYSTEM-TIME-DD                   PIC 9(2).
         05  WS-WORK-TIME                          PIC 9(6).
           88  WORK-TIME-INIT                      VALUE 987654.
         05  WS-WORK-TIME-R REDEFINES WS-WORK-TIME.
           10  WS-WORK-TIME-HH                     PIC X(2).
           10  WS-WORK-TIME-MM                     PIC X(2).
           10  WS-WORK-TIME-SS                     PIC X(2).

       COPY CABENDD.

       LINKAGE SECTION.
       01  LK-DATE-WORK-AREA.
       COPY CDATED.

       PROCEDURE DIVISION USING LK-DATE-WORK-AREA.
           PERFORM TIME-CONVERT THRU
                   TIME-CONVERT-EXIT.
           PERFORM DATE-CONVERT THRU
                   DATE-CONVERT-EXIT.
           GOBACK.

       TIME-CONVERT.
           SET WORK-TIME-INIT TO TRUE.
           MOVE SPACES TO DD-TIME-OUTPUT.

           IF DD-TIME-INPUT IS NOT NUMERIC
              GO TO TIME-CONVERT-ERROR
           END-IF.
           IF DD-ENV-CICS
              MOVE DD-TIME-INPUT-N TO WS-WORK-TIME
           END-IF.
           IF DD-ENV-IMS
              DIVIDE 10 INTO DD-TIME-INPUT-N GIVING WS-WORK-TIME
           END-IF.
           IF DD-ENV-NULL OR
              DD-ENV-INET
              ACCEPT WS-SYSTEM-TIME FROM TIME
              MOVE WS-SYSTEM-TIME-HHMMSS TO WS-WORK-TIME
           END-IF.
           IF WORK-TIME-INIT
               GO TO TIME-CONVERT-ERROR
           END-IF.
           MOVE WS-WORK-TIME-HH TO DD-TIME-OUTPUT-HH.
           MOVE ':'             TO DD-TIME-OUTPUT-SEP1.
           MOVE WS-WORK-TIME-MM TO DD-TIME-OUTPUT-MM.
           MOVE ':'             TO DD-TIME-OUTPUT-SEP2.
           MOVE WS-WORK-TIME-SS TO DD-TIME-OUTPUT-SS.
           GO TO TIME-CONVERT-EXIT.

       TIME-CONVERT-ERROR.
           MOVE 'hh:mm:ss' TO DD-TIME-OUTPUT.
       TIME-CONVERT-EXIT.
           EXIT.

       DATE-CONVERT.
           MOVE SPACES TO DDO-DATA.

           IF NOT DDI-ISO AND
              NOT DDI-YYYYMMDD AND
              NOT DDI-YYMMDD AND
              NOT DDI-YYDDD
              MOVE 'ERROR1' TO DDO-DATA
              GO TO DATE-CONVERT-EXIT
           END-IF.
           MOVE DDI-DATA TO WS-SAVED-DDI-DATA.
           IF DDI-ISO
              PERFORM DATE-CONVERT-IP-OPT1 THRU
                      DATE-CONVERT-IP-OPT1-EXIT
           END-IF.
           IF DDI-YYYYMMDD
              PERFORM DATE-CONVERT-IP-OPT2 THRU
                      DATE-CONVERT-IP-OPT2-EXIT
           END-IF.
           IF DDI-YYMMDD
              PERFORM DATE-CONVERT-IP-OPT3 THRU
                      DATE-CONVERT-IP-OPT3-EXIT
           END-IF.
           IF DDI-YYDDD
              PERFORM DATE-CONVERT-IP-OPT4 THRU
                      DATE-CONVERT-IP-OPT4-EXIT
           END-IF.
       DATE-CONVERT-EXIT.
           EXIT.

      * Input option1 - input is ISO (yyyy-mm-dd)
       DATE-CONVERT-IP-OPT1.
           EVALUATE TRUE
             WHEN DDO-DD-MMM-YY
               MOVE DDI-DATA-ISO-DD TO
                    DDO-DATA-DD-MMM-YY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT1
               MOVE WS-MONTH (DDI-DATA-ISO-MM-N) TO
                    DDO-DATA-DD-MMM-YY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT2
               MOVE DDI-DATA-ISO-YYYY (3:2) TO
                    DDO-DATA-DD-MMM-YY-YY
             WHEN DDO-DD-MMM-YYYY
               MOVE DDI-DATA-ISO-DD TO
                    DDO-DATA-DD-MMM-YYYY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT1
               MOVE WS-MONTH (DDI-DATA-ISO-MM-N) TO
                    DDO-DATA-DD-MMM-YYYY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT2
               MOVE DDI-DATA-ISO-YYYY TO
                    DDO-DATA-DD-MMM-YYYY-YYYY
             WHEN OTHER
               MOVE 'ERROR2' TO DDO-DATA
           END-EVALUATE.
       DATE-CONVERT-IP-OPT1-EXIT.
           EXIT.

      * Input option2 - input is yyyymmdd
       DATE-CONVERT-IP-OPT2.
           EVALUATE TRUE
             WHEN DDO-DD-MMM-YY
               MOVE DDI-DATA-YYYYMMDD-DD TO
                    DDO-DATA-DD-MMM-YY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT1
               MOVE WS-MONTH (DDI-DATA-YYYYMMDD-MM-N) TO
                    DDO-DATA-DD-MMM-YY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT2
               MOVE DDI-DATA-YYYYMMDD-YYYY (3:2) TO
                    DDO-DATA-DD-MMM-YY-YY
             WHEN DDO-DD-MMM-YYYY
               MOVE DDI-DATA-YYYYMMDD-DD TO
                    DDO-DATA-DD-MMM-YYYY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT1
               MOVE WS-MONTH (DDI-DATA-YYYYMMDD-MM-N) TO
                    DDO-DATA-DD-MMM-YYYY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT2
               MOVE DDI-DATA-YYYYMMDD-YYYY TO
                    DDO-DATA-DD-MMM-YYYY-YYYY
             WHEN OTHER
               MOVE 'ERROR2' TO DDO-DATA
           END-EVALUATE.
       DATE-CONVERT-IP-OPT2-EXIT.
           EXIT.

      * Input option3 - input is yymmdd
       DATE-CONVERT-IP-OPT3.
           EVALUATE TRUE
             WHEN DDO-DD-MMM-YY
               MOVE DDI-DATA-YYMMDD-DD TO
                    DDO-DATA-DD-MMM-YY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT1
               MOVE WS-MONTH (DDI-DATA-YYMMDD-MM-N) TO
                    DDO-DATA-DD-MMM-YY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT2
               MOVE DDI-DATA-YYMMDD-YY TO
                    DDO-DATA-DD-MMM-YY-YY
             WHEN DDO-DD-MMM-YYYY
               MOVE DDI-DATA-YYMMDD-DD TO
                    DDO-DATA-DD-MMM-YYYY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT1
               MOVE WS-MONTH (DDI-DATA-YYMMDD-MM-N) TO
                    DDO-DATA-DD-MMM-YYYY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT2
               MOVE DDI-DATA-YYMMDD-YY TO
                    DDO-DATA-DD-MMM-YYYY-YYYY (3:2)
               IF DDI-DATA-YYMMDD-YY IS LESS THAN '50'
                  MOVE '20' TO DDO-DATA-DD-MMM-YYYY-YYYY (1:2)
               ELSE
                  MOVE '19' TO DDO-DATA-DD-MMM-YYYY-YYYY (1:2)
               END-IF
             WHEN OTHER
               MOVE 'ERROR2' TO DDO-DATA
           END-EVALUATE.
       DATE-CONVERT-IP-OPT3-EXIT.
           EXIT.

      * Input option4 - input is yyddd
       DATE-CONVERT-IP-OPT4.
           DIVIDE 4 INTO DDI-DATA-YYDDD-YY-N
             GIVING WS-TEMP.
           MULTIPLY WS-TEMP BY 4 GIVING WS-TEMP.
           IF WS-TEMP EQUAL TO DDI-DATA-YYDDD-YY-N
              MOVE 029 TO WS-DAYS-IN-MONTH(2)
           ELSE
              MOVE 028 TO WS-DAYS-IN-MONTH(2)
           END-IF.
           MOVE DDI-DATA-YYDDD-DDD TO WS-DAYS.
           MOVE 01 TO WS-WORK-MM.
       DATE-CONVERT-IP-OPT4-DAYS.
           IF WS-DAYS IS GREATER THAN WS-DAYS-IN-MONTH(WS-WORK-MM)
              SUBTRACT WS-DAYS-IN-MONTH(WS-WORK-MM) FROM WS-DAYS
              ADD 1 TO WS-WORK-MM
              GO TO DATE-CONVERT-IP-OPT4-DAYS.
           EVALUATE TRUE
             WHEN DDO-DD-MMM-YY
               MOVE WS-DAY-OF-MONTH TO
                    DDO-DATA-DD-MMM-YY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT1
               MOVE WS-MONTH (WS-WORK-MM) TO
                    DDO-DATA-DD-MMM-YY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YY-DOT2
               MOVE DDI-DATA-YYDDD-YY TO
                    DDO-DATA-DD-MMM-YY-YY
             WHEN DDO-DD-MMM-YYYY
               MOVE WS-DAY-OF-MONTH TO
                    DDO-DATA-DD-MMM-YYYY-DD
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT1
               MOVE WS-MONTH (WS-WORK-MM) TO
                    DDO-DATA-DD-MMM-YYYY-MMM
               MOVE '.' TO
                    DDO-DATA-DD-MMM-YYYY-DOT2
               MOVE DDI-DATA-YYDDD-YY TO
                    DDO-DATA-DD-MMM-YYYY-YYYY (3:2)
               IF DDI-DATA-YYDDD-YY IS LESS THAN '50'
                  MOVE '20' TO DDO-DATA-DD-MMM-YYYY-YYYY (1:2)
               ELSE
                  MOVE '19' TO DDO-DATA-DD-MMM-YYYY-YYYY (1:2)
               END-IF
             WHEN OTHER
               MOVE 'ERROR2' TO DDO-DATA
           END-EVALUATE.
       DATE-CONVERT-IP-OPT4-EXIT.
           EXIT.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
