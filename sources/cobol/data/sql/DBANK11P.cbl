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
      * Program:     DBANK11P.CBL                                     *
      * Function:    Obtain Bank Account Details (Extended)           *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK11P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK11P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-TRANS-COUNT                        PIC S9(10) COMP-3.
         05  WS-TRANS-EDIT                                            
                                                   PIC Z(6)9.       
         05  WS-TRANS-EDIT-X REDEFINES WS-TRANS-EDIT
                                                   PIC X(7).

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD11
           END-EXEC.

           EXEC SQL
                BEGIN DECLARE SECTION
           END-EXEC.
      *    EXEC SQL
      *         INCLUDE CBANKSCS
      *    END-EXEC.
           EXEC SQL
                INCLUDE CBANKSAC
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSAT
           END-EXEC.
           EXEC SQL
                INCLUDE SQLCA
           END-EXEC.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
             OCCURS 1 TO 6144 TIMES
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
           MOVE SPACES TO CD11O-DATA.

      *****************************************************************
      * Get the data for the requested account                        *
      *****************************************************************
           EXEC SQL
                SELECT BAC.BAC_ACCNO,
                       BAC.BAC_BALANCE,
                       BAC.BAC_LAST_STMT_DTE,
                       BAC.BAC_LAST_STMT_BAL,
                       BAC.BAC_ATM_ENABLED,
                       BAC.BAC_ATM_DAY_LIMIT,
                       BAC.BAC_ATM_DAY_DTE,
                       BAC.BAC_ATM_DAY_AMT,
                       BAC.BAC_RP1_DAY,
                       BAC.BAC_RP1_AMOUNT,
                       BAC.BAC_RP1_PID,
                       BAC.BAC_RP1_ACCNO,
                       BAC.BAC_RP1_LAST_PAY,
                       BAC.BAC_RP2_DAY,
                       BAC.BAC_RP2_AMOUNT,
                       BAC.BAC_RP2_PID,
                       BAC.BAC_RP2_ACCNO,
                       BAC.BAC_RP2_LAST_PAY,
                       BAC.BAC_RP3_DAY,
                       BAC.BAC_RP3_AMOUNT,
                       BAC.BAC_RP3_PID,
                       BAC.BAC_RP3_ACCNO,
                       BAC.BAC_RP3_LAST_PAY
                INTO :DCL-BAC-ACCNO,
                     :DCL-BAC-BALANCE,
                     :DCL-BAC-LAST-STMT-DTE,
                     :DCL-BAC-LAST-STMT-BAL,
                     :DCL-BAC-ATM-ENABLED,
                     :DCL-BAC-ATM-DAY-LIMIT,
                     :DCL-BAC-ATM-DAY-DTE,
                     :DCL-BAC-ATM-DAY-AMT,
                     :DCL-BAC-RP1-DAY,
                     :DCL-BAC-RP1-AMOUNT,
                     :DCL-BAC-RP1-PID,
                     :DCL-BAC-RP1-ACCNO,
                     :DCL-BAC-RP1-LAST-PAY,
                     :DCL-BAC-RP2-DAY,
                     :DCL-BAC-RP2-AMOUNT,
                     :DCL-BAC-RP2-PID,
                     :DCL-BAC-RP2-ACCNO,
                     :DCL-BAC-RP2-LAST-PAY,
                     :DCL-BAC-RP3-DAY,
                     :DCL-BAC-RP3-AMOUNT,
                     :DCL-BAC-RP3-PID,
                     :DCL-BAC-RP3-ACCNO,
                     :DCL-BAC-RP3-LAST-PAY
                FROM BNKACC BAC
                WHERE (BAC.BAC_ACCNO = :CD11I-ACCNO)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              MOVE DCL-BAC-ACCNO TO CD11O-ACCNO
              MOVE DCL-BAT-DESC TO CD11O-DESC
              MOVE DCL-BAC-BALANCE TO CD11O-BAL-N
              MOVE DCL-BAC-LAST-STMT-DTE TO CD11O-DTE
              MOVE 'No' TO CD11O-TRANS
              MOVE DCL-BAC-ATM-ENABLED TO CD11O-ATM-ENABLED
              MOVE DCL-BAC-ATM-DAY-LIMIT TO CD11O-ATM-LIM-N
              MOVE DCL-BAC-ATM-DAY-DTE TO CD11O-ATM-LDTE
              MOVE DCL-BAC-ATM-DAY-AMT TO CD11O-ATM-LAMT-N
              MOVE DCL-BAC-RP1-DAY TO CD11O-RP1DAY
              MOVE DCL-BAC-RP1-AMOUNT TO CD11O-RP1AMT-N
              MOVE DCL-BAC-RP1-PID TO CD11O-RP1PID
              MOVE DCL-BAC-RP1-ACCNO TO CD11O-RP1ACC
              MOVE DCL-BAC-RP1-LAST-PAY TO CD11O-RP1DTE
              MOVE DCL-BAC-RP2-DAY TO CD11O-RP2DAY
              MOVE DCL-BAC-RP2-AMOUNT TO CD11O-RP2AMT-N
              MOVE DCL-BAC-RP2-PID TO CD11O-RP2PID
              MOVE DCL-BAC-RP2-ACCNO TO CD11O-RP2ACC
              MOVE DCL-BAC-RP2-LAST-PAY TO CD11O-RP2DTE
              MOVE DCL-BAC-RP3-DAY TO CD11O-RP3DAY
              MOVE DCL-BAC-RP3-AMOUNT TO CD11O-RP3AMT-N
              MOVE DCL-BAC-RP3-PID TO CD11O-RP3PID
              MOVE DCL-BAC-RP3-ACCNO TO CD11O-RP3ACC
              MOVE DCL-BAC-RP3-LAST-PAY TO CD11O-RP3DTE
              EXEC SQL                                          
                   SELECT COUNT(*)                                      
                   INTO :WS-TRANS-COUNT                              
                   FROM BNKTXN                                           
                   WHERE (BTX_ACCNO = :DCL-BAC-ACCNO)                    
              END-EXEC

              IF SQLSTATE IS EQUAL TO '00000'
                  IF WS-TRANS-COUNT IS EQUAL TO 0
                      MOVE 'No' TO CD11O-TRANS
                  ELSE
                      MOVE WS-TRANS-COUNT TO WS-TRANS-EDIT
                      PERFORM TRANS-LEFT-JUST
                      MOVE WS-TRANS-EDIT-X TO CD11O-TRANS
                  END-IF
              END-IF
           ELSE
               MOVE SPACES TO CD11O-ACCNO
           END-IF.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

       TRANS-LEFT-JUST.
           IF WS-TRANS-EDIT-X(1:1) IS EQUAL TO SPACE
               MOVE WS-TRANS-EDIT-X(2:LENGTH OF WS-TRANS-EDIT-X - 1)
                 TO WS-TRANS-EDIT-X(1:LENGTH OF WS-TRANS-EDIT-X - 1)
               MOVE SPACE
                 TO WS-TRANS-EDIT-X(LENGTH OF WS-TRANS-EDIT-X:1)
               GO TO TRANS-LEFT-JUST.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
