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
      * Program:     BCASH00P.CBL                                     *
      * Layer:       Business logic                                   *
      * Function:    ATM - entry point and sign-0n validation         *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           BCASH00P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'BCASH00P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-BUSINESS-PROGRAM                   PIC X(8)
             VALUE 'BCASH0?P'.

       01  WS-CASH-DATA.
       COPY CCASHDAT.

       01  WS-PERSON-DATA.
       COPY CCASHD01.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(6144).

       COPY CENTRY.
      *****************************************************************
      * Make ourselves re-entrant                                     *
      *****************************************************************

      *****************************************************************
      * Move the passed area to our area                              *
      *****************************************************************
           MOVE DFHCOMMAREA (1:LENGTH OF WS-CASH-DATA) TO WS-CASH-DATA.

      *****************************************************************
      * Ensure error message is cleared                               *
      *****************************************************************
           MOVE SPACES TO CASH-ERROR-MSG.

      *****************************************************************
      * This is the main process                                      *
      *****************************************************************
           MOVE SPACES TO CD01-DATA.
           MOVE CASH-USERID TO CD01I-CONTACT-ID.
      * Now go get the data
       COPY CCASHX01.
           SET CASH-PIN-STATUS-UNKNOWN TO TRUE.
           EVALUATE TRUE
             WHEN CD01O-PIN IS EQUAL TO '????'
               SET CASH-PIN-STATUS-NO-USER TO TRUE
               MOVE 'Unknow user' TO CASH-ERROR-MSG
             WHEN CD01O-PIN IS EQUAL TO '    '
               SET CASH-PIN-STATUS-NO-PIN TO TRUE
               MOVE 'No PIN on file for user' TO CASH-ERROR-MSG
             WHEN CD01O-PIN IS EQUAL TO CASH-PIN
               SET CASH-PIN-STATUS-OK TO TRUE
               MOVE SPACES TO CASH-ERROR-MSG
             WHEN OTHER
               SET CASH-PIN-STATUS-INVALID TO TRUE
               MOVE 'PIN invalid' TO CASH-ERROR-MSG
           END-EVALUATE.
           IF NOT CASH-PIN-STATUS-OK
              GO TO COMMON-RETURN
           END-IF.
           MOVE CASH-REQUEST-CODE TO WS-BUSINESS-PROGRAM(7:1)
           EXEC CICS LINK PROGRAM(WS-BUSINESS-PROGRAM)
                          COMMAREA(WS-CASH-DATA)
                          LENGTH(LENGTH OF WS-CASH-DATA)
           END-EXEC.

       COMMON-RETURN.
           MOVE WS-CASH-DATA TO DFHCOMMAREA (1:LENGTH OF WS-CASH-DATA).
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
