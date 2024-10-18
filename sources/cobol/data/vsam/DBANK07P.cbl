      *****************************************************************
      *                                                               *
      * Copyright 2010-2021 Rocket Software, Inc. or its affiliates.  *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Rocket® products, and is otherwise subject to the EULA at     *
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
      * Program:     DBANK07P.CBL                                     *
      * Function:    Write transaction records for audit trail        *
      *              VSAM Version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK07P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK07P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-BNKTXN-RID                         PIC X(26).

       01  WS-BNKTXN-REC.
       COPY CBANKVTX.

       COPY CBANKTXD.

       01  WS-TWOS-COMP.
         05  WS-TWOS-COMP-REQ                      PIC X(1).
           88  WS-TWOS-COMP-REQ-YES                VALUE 'Y'.
           88  WS-TWOS-COMP-REQ-NO                 VALUE 'N'.
         05  WS-TWOS-COMP-LEN                      PIC S9(4) COMP.
         05  WS-TWOS-COMP-INPUT                    PIC X(256).
         05  WS-TWOS-COMP-OUTPUT                   PIC X(256).

       01  WS-COMMAREA.
       COPY CBANKD07.

       COPY CTSTAMPD.

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
           MOVE SPACES TO CD07O-DATA.

      *****************************************************************
      * Insert row/record into the database/file                      *
      *****************************************************************
       COPY CTSTAMPP.
           MOVE WS-TIMESTAMP TO CD07I-TIMESTAMP.
           MOVE SPACES TO BTX-RECORD.
           MOVE '0' TO CD07I-TIMESTAMP (26:1).
           MOVE CD07I-PERSON-PID TO BTX-REC-PID.
           MOVE '2' TO BTX-REC-TYPE.
           MOVE ' ' TO BTX-REC-SUB-TYPE.
           MOVE SPACES TO BTX-REC-ACCNO.
           MOVE CD07I-TIMESTAMP TO BTX-REC-TIMESTAMP.
           MOVE ZERO TO BTX-REC-AMOUNT.
           MOVE CD07I-OLD-DATA TO BTX-REC-DATA-OLD.
           MOVE CD07I-NEW-DATA TO BTX-REC-DATA-NEW.
           MOVE CD07I-TIMESTAMP TO WS-TWOS-COMP-INPUT.
           MOVE LOW-VALUES TO WS-TWOS-COMP-OUTPUT.
           MOVE LENGTH OF CD07I-TIMESTAMP TO WS-TWOS-COMP-LEN.
           CALL 'UTWOSCMP' USING WS-TWOS-COMP-LEN
                                 WS-TWOS-COMP-INPUT
                                 WS-TWOS-COMP-OUTPUT.
           MOVE WS-TWOS-COMP-OUTPUT TO BTX-REC-TIMESTAMP-FF.
           MOVE CD07I-TIMESTAMP TO WS-BNKTXN-RID.
           EXEC CICS WRITE FILE('BNKTXN')
                                FROM(WS-BNKTXN-REC)
                                LENGTH(LENGTH OF WS-BNKTXN-REC)
                                RIDFLD(WS-BNKTXN-RID)
                                KEYLENGTH(LENGTH OF WS-BNKTXN-RID)
                                RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              SET CD07O-UPDATE-FAIL TO TRUE
              MOVE 'Unable to insert contact info audit record'
                TO CD07O-MSG
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
