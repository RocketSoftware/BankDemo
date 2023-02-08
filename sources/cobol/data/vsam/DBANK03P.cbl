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
      * Program:     DBANK03P.CBL                                     *
      * Function:    Obtain Bank Account balances                     *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK03P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK03P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-SUB2                               PIC S9(4) COMP.
         05  WS-COUNT                              PIC S9(4) COMP.
         05  WS-REC-TYPE                           PIC X(1).
         05  WS-REC-TYPE-N REDEFINES WS-REC-TYPE   PIC 9(1).
         05  WS-MOVED-FLAG                         PIC X(1).
           88  ENTRY-MOVED-TRUE                    VALUE '1'.
           88  ENTRY-MOVED-FALSE                   VALUE '0'.
         05  WS-BNKACCT-AIX1-RID                   PIC X(5).
         05  WS-BNKATYP-RID                        PIC X(1).
         05  WS-BNKTXN-AIX1-RID                    PIC X(31).
         05  WS-BNKTXN-AIX1-RID-LEN                PIC X(31).

       01  WS-BNKACCT-REC.
       COPY CBANKVAC.

       01  WS-BNKATYP-REC.
       COPY CBANKVAT.

       01  WS-BNKTXN-REC.
       COPY CBANKVTX.

       01  WS-COMMAREA.
       COPY CBANKD03.

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
           MOVE SPACES TO CD03O-DATA.

      *****************************************************************
      * Set up the start position for the browse                      *
      *****************************************************************
           MOVE CD03I-CONTACT-ID TO WS-BNKACCT-AIX1-RID.

      *****************************************************************
      * Start browsing the file                                       *
      *****************************************************************
           EXEC CICS STARTBR FILE('BNKACC1')
                             RIDFLD(WS-BNKACCT-AIX1-RID)
                             GTEQ
           END-EXEC.

      *****************************************************************
      * Now browse the selected recs and move into our area           *
      *****************************************************************
           DIVIDE LENGTH OF CD03O-ACC-INFO(1) INTO LENGTH OF CD03O-DATA
             GIVING WS-COUNT.
           MOVE 0 TO WS-SUB1.
       ACCOUNT-FETCH-LOOP.
           ADD 1 TO WS-SUB1.
           IF WS-SUB1 IS GREATER THAN WS-COUNT
              GO TO ACCOUNT-FETCH-LOOP-EXIT
           END-IF.
           EXEC CICS READNEXT FILE('BNKACC1')
                              INTO(WS-BNKACCT-REC)
                              LENGTH(LENGTH OF WS-BNKACCT-REC)
                              RIDFLD(WS-BNKACCT-AIX1-RID)
                              RESP(WS-RESP)
           END-EXEC.
           IF (WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL) AND
               WS-RESP IS NOT EQUAL TO DFHRESP(DUPKEY)) OR
              BAC-REC-PID IS NOT EQUAL TO CD03I-CONTACT-ID
              GO TO ACCOUNT-FETCH-LOOP-EXIT
           END-IF

      *****************************************************************
      * We got an account record ok, save no & bal, get description   *
      * Note: We wnat the account in type order but as the files do   *
      *       not accomodate this, we put them in the "entry" in the  *
      *       output area based on type. Once all records have been   *
      *       obtained we examine the output area to move entries up  *
      *       if necessary to eliminate any embedded blank entries.   *
      *****************************************************************
           MOVE BAC-REC-TYPE TO WS-REC-TYPE.
           MOVE WS-REC-TYPE-N TO WS-SUB2.
           MOVE BAC-REC-ACCNO TO CD03O-ACC-NO (WS-SUB2).
           MOVE BAC-REC-BALANCE TO CD03O-ACC-BAL-N (WS-SUB2).
           MOVE BAC-REC-LAST-STMT-DTE TO CD03O-DTE (WS-SUB2).
           MOVE BAC-REC-TYPE TO WS-BNKATYP-RID.
           EXEC CICS READ FILE('BNKATYPE')
                              INTO(WS-BNKATYP-REC)
                              LENGTH(LENGTH OF WS-BNKATYP-REC)
                              RIDFLD(WS-BNKATYP-RID)
                              RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              MOVE BAT-REC-DESC TO CD03O-ACC-DESC (WS-SUB2)
           ELSE
              MOVE 'Unknown' TO CD03O-ACC-DESC (WS-SUB2)
           END-IF.

      *****************************************************************
      * Now see if there are any transactions for this account        *
      *****************************************************************
           MOVE BAC-REC-ACCNO TO WS-BNKTXN-AIX1-RID.
           EXEC CICS READ FILE('BNKTXN1')
                              INTO(WS-BNKTXN-REC)
                              LENGTH(LENGTH OF WS-BNKTXN-REC)
                              RIDFLD(WS-BNKTXN-AIX1-RID)
                              KEYLENGTH(9)
                              GENERIC
                              RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              MOVE '*' TO CD03O-TXN (WS-SUB2)
           ELSE
              MOVE ' ' TO CD03O-TXN (WS-SUB2)
           END-IF.
           GO TO ACCOUNT-FETCH-LOOP.

      *****************************************************************
      * We quit the loop for some reason                              *
      *****************************************************************
       ACCOUNT-FETCH-LOOP-EXIT.
           EXEC CICS ENDBR FILE('BNKACC1')
           END-EXEC.

      *****************************************************************
      * We examine the output area an move entries as required so as  *
      * to eliminate any embedded blank entries                       *
      *****************************************************************
       COMPRESS-000.
           MOVE 1 TO WS-SUB1.
           MOVE 1 TO WS-SUB2.
           SET ENTRY-MOVED-FALSE TO TRUE.
       COMPRESS-100.
      * Check to see if we have done it all
           IF WS-SUB1 IS EQUAL WS-COUNT
              GO TO COMPRESS-200
           END-IF.
           ADD 1 TO WS-SUB2
           IF CD03O-ACC-INFO(WS-SUB1) IS EQUAL TO SPACES AND
              WS-SUB2 IS NOT GREATER THAN WS-COUNT
              IF CD03O-ACC-INFO(WS-SUB2) IS NOT EQUAL TO SPACES
                 MOVE CD03O-ACC-INFO(WS-SUB2) TO CD03O-ACC-INFO(WS-SUB1)
                 MOVE SPACES TO CD03O-ACC-INFO(WS-SUB2)
                 ADD 1 TO WS-SUB1
                 MOVE WS-SUB1 TO WS-SUB2
                 SET ENTRY-MOVED-TRUE TO TRUE
                 GO TO COMPRESS-000
              END-IF
           ELSE
             ADD 1 TO WS-SUB1
             GO TO COMPRESS-100
           END-IF.
           GO TO COMPRESS-100.
       COMPRESS-200.
           IF ENTRY-MOVED-TRUE
              GO TO COMPRESS-000
           END-IF.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
