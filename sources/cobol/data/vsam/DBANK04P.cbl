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
      * Program:     DBANK04P.CBL                                     *
      * Function:    Update acount balances                           *
      *              VSAM Version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK04P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK04P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-READ-TOKEN-FROM                    PIC S9(8) COMP.
         05  WS-READ-TOKEN-TO                      PIC S9(8) COMP.
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-BNKACC-FROM-RID                    PIC X(9).
         05  WS-BNKACC-TO-RID                      PIC X(9).

       COPY CTSTAMPD.

       01  WS-BNKACC-FROM-REC.
       COPY CBANKVAC.

       01  WS-BNKACC-TO-REC.
       COPY CBANKVAC.

       01  WS-COMMAREA.
       COPY CBANKD04.

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
           MOVE SPACES TO CD04O-DATA.
           SET CD04O-UPDATE-FAIL TO TRUE.
           MOVE '0001-01-01-00.000.00.00000' TO CD04O-TIMESTAMP.

      *****************************************************************
      * Try to the the 'from' account to check the balance            *
      *****************************************************************
           MOVE CD04I-FROM-ACC TO WS-BNKACC-FROM-RID.
           EXEC CICS READ FILE('BNKACC')
                          UPDATE
                          INTO(WS-BNKACC-FROM-REC)
                          LENGTH(LENGTH OF WS-BNKACC-FROM-REC)
                          RIDFLD(WS-BNKACC-FROM-RID)
                          TOKEN(WS-READ-TOKEN-FROM)
                          RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE 'Unable to read FROM account details'
                TO CD04O-MSG
              GO TO DBANK04P-EXIT
           END-IF.
           IF CD04I-FROM-OLD-BAL IS NOT EQUAL TO
                BAC-REC-BALANCE IN WS-BNKACC-FROM-REC
              MOVE 'FROM account balance has changed'
                TO CD04O-MSG
              GO TO DBANK04P-EXIT
           END-IF.

      *****************************************************************
      * Try to the the 'to' account to check the balance              *
      *****************************************************************
           MOVE CD04I-TO-ACC TO WS-BNKACC-TO-RID.
           EXEC CICS READ FILE('BNKACC')
                          UPDATE
                          INTO(WS-BNKACC-TO-REC)
                          LENGTH(LENGTH OF WS-BNKACC-TO-REC)
                          RIDFLD(WS-BNKACC-TO-RID)
                          TOKEN(WS-READ-TOKEN-TO)
                          RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE 'Unable to read TO account details'
                TO CD04O-MSG
              GO TO DBANK04P-EXIT
           END-IF.
           IF CD04I-TO-OLD-BAL IS NOT EQUAL TO
                BAC-REC-BALANCE IN WS-BNKACC-TO-REC
              MOVE 'TO account balance has changed'
                TO CD04O-MSG
              GO TO DBANK04P-EXIT
           END-IF.

      *****************************************************************
      * Try to update the records                                     *
      *****************************************************************
           MOVE CD04I-FROM-NEW-BAL
             TO BAC-REC-BALANCE IN WS-BNKACC-FROM-REC.
           EXEC CICS REWRITE FILE('BNKACC')
                             FROM(WS-BNKACC-FROM-REC)
                             LENGTH(LENGTH OF WS-BNKACC-FROM-REC)
                             TOKEN(WS-READ-TOKEN-FROM)
                             RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE 'Unable to rewrite FROM account details'
                TO CD04O-MSG
              GO TO DBANK04P-EXIT
           END-IF.

           MOVE CD04I-TO-NEW-BAL
             TO BAC-REC-BALANCE IN WS-BNKACC-TO-REC.
           EXEC CICS REWRITE FILE('BNKACC')
                             FROM(WS-BNKACC-TO-REC)
                             LENGTH(LENGTH OF WS-BNKACC-TO-REC)
                             TOKEN(WS-READ-TOKEN-TO)
                             RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE 'Unable to rewrite TO account details'
                TO CD04O-MSG
              GO TO DBANK04P-EXIT
           END-IF.

      *****************************************************************
      * If we got this far then the accounts should have been updated *
      *****************************************************************
      * Simulate SQL TIMESTAMP function
       COPY CTSTAMPP.
           MOVE WS-TIMESTAMP TO CD04O-TIMESTAMP.
           SET CD04O-UPDATE-OK TO TRUE.

       DBANK04P-EXIT.
      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
