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
      * Program:     DBANK08P.CBL                                     *
      * Function:    Obtain count of number of accounts user has      *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK08P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK08P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-BNKACCT-AIX1-RID                   PIC X(5).

       01  WS-BNKACCT-REC.
       COPY CBANKVAC.

       01  WS-COMMAREA.
       COPY CBANKD08.

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
           MOVE SPACES TO CD08O-DATA.

      *****************************************************************
      * Set up the start position for the browse                      *
      *****************************************************************
           MOVE CD08I-CONTACT-ID TO WS-BNKACCT-AIX1-RID.

      *****************************************************************
      * Start browsing the file                                       *
      *****************************************************************
           EXEC CICS STARTBR FILE('BNKACC1')
                             RIDFLD(WS-BNKACCT-AIX1-RID)
                             GTEQ
           END-EXEC.

      *****************************************************************
      * Now browse the selected recs and move up to 5 into our area   *
      *****************************************************************
           MOVE 0 TO CD08O-COUNT.
       ACCOUNT-FETCH-LOOP.
           EXEC CICS READNEXT FILE('BNKACC1')
                              INTO(WS-BNKACCT-REC)
                              LENGTH(LENGTH OF WS-BNKACCT-REC)
                              RIDFLD(WS-BNKACCT-AIX1-RID)
                              RESP(WS-RESP)
           END-EXEC.
           IF (WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL) AND
               WS-RESP IS NOT EQUAL TO DFHRESP(DUPKEY)) OR
              BAC-REC-PID IS NOT EQUAL TO CD08I-CONTACT-ID
              GO TO ACCOUNT-FETCH-LOOP-EXIT
           ELSE
              ADD 1 TO CD08O-COUNT
              GO TO ACCOUNT-FETCH-LOOP
           END-IF.

      *****************************************************************
      * We quit the loop for some reason                              *
      *****************************************************************
       ACCOUNT-FETCH-LOOP-EXIT.
           EXEC CICS ENDBR FILE('BNKACC1')
           END-EXEC.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
