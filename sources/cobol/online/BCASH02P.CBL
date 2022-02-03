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
      * Program:     BCASH02P.CBL                                     *
      * Layer:       Business logic                                   *
      * Function:    ATM - tranfer funds between accounts             *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           BCASH02P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'BCASH02P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB                                PIC 9(3).
       01  WS-CASH-DATA.
       COPY CCASHDAT.

       01  WS-BANK-DATA.
       COPY CBANKDAT.
      *
      *01  WS-ACCOUNT-DATA.
      *COPY CCASHD02.

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
           MOVE LOW-VALUES TO WS-BANK-DATA.
           SET BANK-AID-ENTER TO TRUE.
           MOVE 'MBANK50' TO BANK-LAST-MAPSET.
           MOVE CASH-USERID TO BANK-USERID.


           MOVE CASH-ATM2-XFER-AMT TO BANK-SCR50-XFER
           MOVE 'X' TO BANK-SCR50-FRM1.
           MOVE CASH-ATM2-FROM-ACC TO BANK-SCR50-ACC1.
           MOVE CASH-ATM2-FROM-BAL TO BANK-SCR50-BAL1.
           MOVE 'X' TO BANK-SCR50-TO2.
           MOVE CASH-ATM2-TO-ACC TO BANK-SCR50-ACC2.
           MOVE CASH-ATM2-TO-BAL TO BANK-SCR50-BAL2.

           EXEC CICS LINK PROGRAM('BBANK50P')
                          COMMAREA(WS-BANK-DATA)
                          LENGTH(LENGTH OF WS-BANK-DATA)
           END-EXEC.

           MOVE BANK-ERROR-MSG TO CASH-ERROR-MSG.

       COMMON-RETURN.
           MOVE WS-CASH-DATA TO DFHCOMMAREA (1:LENGTH OF WS-CASH-DATA).
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
