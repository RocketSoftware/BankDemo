      *****************************************************************
      *                                                               *
      * Copyright 2010-2021 Rocket Software, Inc. or its affiliates.  *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Rocket products, and is otherwise subject to the EULA at      *
      * https://www.rocketsoftware.com/company/trust/agreements.      *
      *                                                               *
      * THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED             *
      * WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF               *
      * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,         *
      * SHALL NOT APPLY.                                              *
      * TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL              *
      * ROCKET SOFTWARE HAVE ANY LIABILITY WHATSOEVER IN CONNECTION   *
      * WITH THIS SOFTWARE.                                           *
      *                                                               *
      *****************************************************************

      *****************************************************************
      * Program:     BCASH03P.CBL                                     *
      * Layer:       Business logic                                   *
      * Function:    ATM - cash withdrawal. This is the same as funds *
      *              transfer but to a different person (the bank)    *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           BCASH03P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'BCASH03P'.
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
           MOVE CASH-ATM3-CASH-AMT TO BANK-SCR50-XFER
           MOVE 'X' TO BANK-SCR50-FRM1.
           MOVE CASH-ATM3-FROM-ACC TO BANK-SCR50-ACC1.
           MOVE CASH-ATM3-FROM-BAL TO BANK-SCR50-BAL1.
           MOVE 'X' TO BANK-SCR50-TO2.
           MOVE '999999996' TO BANK-SCR50-ACC2.
           MOVE '0,000,000,00 ' TO BANK-SCR50-BAL2.

           EXEC CICS LINK PROGRAM('BBANK50P')
                          COMMAREA(WS-BANK-DATA)
                          LENGTH(LENGTH OF WS-BANK-DATA)
           END-EXEC.

           MOVE BANK-ERROR-MSG TO CASH-ERROR-MSG.

       COMMON-RETURN.
           MOVE WS-CASH-DATA TO DFHCOMMAREA (1:LENGTH OF WS-CASH-DATA).
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
