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
      * Program:     ZBNKE35.CBL                                      *
      * Function:    Demonstrate E35 capability.                      *
      *****************************************************************
      *MFJSORT provides a standard linkage area to the E15 and E35    *
      *exit program. It is compatible with the mainframe utility      *
      *and should be defined as follows:                              *
      *                                                               *
      *COBOL statement      PIC        Value                          *
      * RECORD-FLAGS        9(8)COMP   0 - first record passed        *
      *                                4 - subsequent records passed  *
      *                                8 - last record passed         *
      * ENTRY-BUFFER        X(n)       Contents of the input record.  *
      *                                Do not change this area.       *
      * EXIT-BUFFER         X(n)       Contents of the new or altered *
      *                                  record provided by the exit. *
      * UNUSED-ENTRY        9(8)COMP   Not used                       *
      *                                                               *
      * UNUSED-ENTRY        9(8)COMP   Not used                       *
      *                                                               *
      * ENTRY-RECORD-LENGTH 9(8)COMP   Length of the input record.    *
      * EXIT-RECORD-LENGTH  9(8)COMP   Length of the new or altered   *
      *                                  record provided by the exit. *
      * UNUSED-ENTRY        9(8)COMP   Not used                       *
      * EXIT-AREA-LENGTH    9(4)COMP   Length of the exit area        *
      *                                  scratchpad.                  *
      *                                Do not change this field.      *
      * EXIT-AREA           X(n)       Exit area scratchpad used by   *
      *                                  the exit to maintain         *
      *                                  variables between calls to   *
      *                                  the exit program.            *
      *                                                               *
      * Return Code         Meaning                                   *
      *   0                 No action required                        *
      *   4                 Delete the current record.                *
      *                       For E15, the record is not sorted.      *
      *                       For E35, the record is not written to   *
      *                         the output dataset                    *
      *   8                 Do not call this exit again;              *
      *                       exit processing is no longer required   *
      *   12                Insert the current record.                *
      *                       For E15, the record is inserted for     *
      *                         sorting.                              *
      *                       For E35, the record is written to the   *
      *                         output dataset                        *
      *   16                Terminate. The job step is terminated     *
      *                       with the condition code set to 16       *
      *   20                Alter the current record.                 *
      *                       For E15, the altered record is passed   *
      *                         to the sort.                          *
      *                       For E35, the altered record is written  *
      *                         to the output dataset                 *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ZBNKE35.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.
       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'ZBNKE35 '.
         05  WS-REC-COUNT-READ                     PIC 9(5).
         05  WS-REC-COUNT-WRITTEN                  PIC 9(5).
         05  WS-REC-COUNT-DELETED                  PIC 9(5).
         05  WS-SAVED-TYPE-AND-PID.
           10  WS-SAVED-TYPE                       PIC X(1).
           10  WS-SAVED-PID                        PIC X(5).

       01  WS-CONSOLE-MESSAGE                      PIC X(48).

       COPY CABENDD.

       LINKAGE SECTION.
       01  LK-EXIT-RECORD-FLAGS                    PIC 9(8) COMP.
         88  FIRST-RECORD                          VALUE 0.
         88  SUBSEQUENT-RECORD                     VALUE 4.
         88  LAST-RECORD                           VALUE 8.

       01  LK-EXIT-ENTRY-BUFFER                    PIC X(116).

       01  LK-EXIT-EXIT-BUFFER                     PIC X(116).

       01  LK-EXIT-UNUSED-1                        PIC 9(8) COMP.

       01  LK-EXIT-UNUSED-2                        PIC 9(8) COMP.

       01  LK-EXIT-ENTRY-REC-LEN                   PIC 9(8) COMP.

       01  LK-EXIT-EXIT-REC-LEN                    PIC 9(8) COMP.

       01  LK-EXIT-SPA-LEN                         PIC 9(4) COMP.

       01  LK-EXIT-SPA.
         05  LK-EXIT-SPA-BYTE                      PIC X(1)
             OCCURS 1 TO 9999 TIMES DEPENDING ON LK-EXIT-SPA-LEN.

       PROCEDURE DIVISION USING LK-EXIT-RECORD-FLAGS
                                LK-EXIT-ENTRY-BUFFER
                                LK-EXIT-EXIT-BUFFER
                                LK-EXIT-UNUSED-1
                                LK-EXIT-UNUSED-2
                                LK-EXIT-ENTRY-REC-LEN
                                LK-EXIT-EXIT-REC-LEN
                                LK-EXIT-SPA-LEN
                                LK-EXIT-SPA.


           IF FIRST-RECORD
              MOVE 'E35 exit invoked' TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              MOVE 0 TO WS-REC-COUNT-READ
              MOVE 0 TO WS-REC-COUNT-WRITTEN
              MOVE 0 TO WS-REC-COUNT-DELETED
              MOVE LOW-VALUES TO WS-SAVED-PID
           END-IF.

           IF FIRST-RECORD OR
              SUBSEQUENT-RECORD
              ADD 1 TO WS-REC-COUNT-READ
              IF LK-EXIT-ENTRY-BUFFER (5:1) IS NOT EQUAL TO '0' AND
                 LK-EXIT-ENTRY-BUFFER (5:1) IS NOT EQUAL TO '1'
                 ADD 1 TO WS-REC-COUNT-WRITTEN
                 MOVE 0 TO RETURN-CODE
              ELSE
                 IF LK-EXIT-ENTRY-BUFFER (5:6) IS EQUAL TO
                      WS-SAVED-TYPE-AND-PID
                    ADD 1 TO WS-REC-COUNT-DELETED
                    MOVE 4 TO RETURN-CODE
                 ELSE
                    MOVE LK-EXIT-ENTRY-BUFFER (5:6)
                      TO WS-SAVED-TYPE-AND-PID
                    ADD 1 TO WS-REC-COUNT-WRITTEN
                    MOVE 0 TO RETURN-CODE
                 END-IF
              END-IF
           ELSE
              MOVE 'E35 exit terminating at EOF' TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              STRING 'E35 exit: records read......: 'DELIMITED BY SIZE
                     WS-REC-COUNT-READ DELIMITED BY SIZE
                INTO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              STRING 'E35 exit: records deleted...: ' DELIMITED BY SIZE
                     WS-REC-COUNT-DELETED DELIMITED BY SIZE
                INTO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              STRING 'E35 exit: records written...: ' DELIMITED BY SIZE
                     WS-REC-COUNT-WRITTEN DELIMITED BY SIZE
                INTO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              MOVE 8 TO RETURN-CODE
           END-IF.

           GOBACK.


      *****************************************************************
      * Display CONSOLE messages...                                   *
      *****************************************************************
       DISPLAY-CONSOLE-MESSAGE.
           DISPLAY WS-PROGRAM-ID ' - ' WS-CONSOLE-MESSAGE
             UPON CONSOLE.
           MOVE ALL SPACES TO WS-CONSOLE-MESSAGE.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
