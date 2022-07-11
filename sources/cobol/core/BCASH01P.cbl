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
      * Program:     BCASH01P.CBL                                     *
      * Layer:       Business logic                                   *
      * Function:    ATM - obtain list of enabled accounts            *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           BCASH01P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'BCASH01P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB                                PIC 9(3).
       01  WS-CASH-DATA.
       COPY CCASHDAT.

       01  WS-ACCOUNT-DATA.
       COPY CCASHD02.

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
           MOVE SPACES TO CD02-DATA.
           MOVE CASH-USERID TO CD02I-CONTACT-ID.
      * Now go get the data
       COPY CCASHX02.
           MOVE 0 TO WS-SUB.
           PERFORM 5 TIMES
           ADD 1 TO WS-SUB
           MOVE CD02O-ACC-NO(WS-SUB)
             TO CASH-ATM1-ACC(WS-SUB)
           MOVE CD02O-ACC-DESC(WS-SUB)
             TO CASH-ATM1-DSC(WS-SUB)
           MOVE CD02O-ACC-BAL(WS-SUB)
             TO CASH-ATM1-BAL(WS-SUB)
           MOVE CD02O-ACC-DAY-LIMIT(WS-SUB)
             TO CASH-ATM1-DAY-LIMIT(WS-SUB)
           MOVE CD02O-ACC-DATE-USED(WS-SUB)
             TO CASH-ATM1-DATE-USED(WS-SUB)
           MOVE CD02O-ACC-DATE-AMT(WS-SUB)
             TO CASH-ATM1-DATE-AMT(WS-SUB)
           END-PERFORM.

       COMMON-RETURN.
           MOVE WS-CASH-DATA TO DFHCOMMAREA (1:LENGTH OF WS-CASH-DATA).
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
