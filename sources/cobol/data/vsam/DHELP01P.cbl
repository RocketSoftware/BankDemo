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
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DHELP01P.
       DATE-WRITTEN.
           September 2003.
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
         05  WS-RESP                               PIC S9(4) COMP.
         05  WS-HELP-RID                           PIC X(8).
         05  WS-LINE                               PIC X(2).
         05  WS-LINE-N REDEFINES WS-LINE           PIC 9(2).

       01  WS-COMMAREA.
       COPY CHELPD01.

       01  WS-HELP-REC.
       COPY CHELPVSM.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
               OCCURS 1 TO 4096 TIMES
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
      * Set up start position for the browse                          *
      *****************************************************************
           MOVE HELP01I-SCRN TO WS-HELP-RID (1:6).
           MOVE SPACES TO WS-HELP-RID (7:2).
           MOVE HELP01I-SCRN TO HELP01O-SCRN.

      *****************************************************************
      * Start browsing the file                                       *
      *****************************************************************
           EXEC CICS STARTBR FILE('BNKHELP')
                            RIDFLD(WS-HELP-RID)
                            GTEQ
           END-EXEC.

      *****************************************************************
      * Now browse the selected rows are move up to 19 into our area  *
      *****************************************************************
           MOVE 0 TO WS-SUB1.
       TEXT-FETCH-LOOP.
           ADD 1 TO WS-SUB1.
           IF WS-SUB1 IS GREATER THAN 19
              GO TO TEXT-FETCH-LOOP-EXIT.
           EXEC CICS READNEXT FILE('BNKHELP')
                              INTO(WS-HELP-REC)
                              LENGTH(LENGTH OF WS-HELP-REC)
                              RIDFLD(WS-HELP-RID)
                              RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              IF HLP-SCRN IS EQUAL TO HELP01I-SCRN
                 MOVE HLP-LINE TO WS-LINE
                 IF WS-LINE IS NUMERIC
                    IF WS-LINE-N IS GREATER THAN 00 AND
                       WS-LINE-N IS NOT GREATER THAN 19
                       MOVE HLP-TEXT TO HELP01O-LINE (WS-LINE-N)
                    END-IF
                 END-IF
                 GO TO TEXT-FETCH-LOOP
              ELSE
                 IF HELP01O-INDIVIDUAL-LINES IS EQUAL TO SPACES
                    SET HELP-NOT-FOUND TO TRUE
                    MOVE 'No help available'
                      TO HELP01O-LINE (10) (30:17)
                 END-IF
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
           EXEC CICS ENDBR FILE('BNKHELP')
           END-EXEC.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA (1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
