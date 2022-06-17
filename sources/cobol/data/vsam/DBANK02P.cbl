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
      * Program:     DBANK02P.CBL                                     *
      * Function:    Obtain/update address information                *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK02P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK02P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-BNKCUST-RID                        PIC X(5).

       01 WS-BNKCUST-REC.
       COPY CBANKVCS.

       01  WS-COMMAREA.
       COPY CBANKD02.

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
           MOVE SPACES TO CD02O-DATA.

      *****************************************************************
      * See if we have a read or write request and react accordingly  *
      *****************************************************************
           EVALUATE TRUE
             WHEN CD02I-READ
               PERFORM READ-PROCESSING THRU
                       READ-PROCESSING-EXIT
             WHEN CD02I-WRITE
               PERFORM WRITE-PROCESSING THRU
                       WRITE-PROCESSING-EXIT
             WHEN OTHER
               MOVE HIGH-VALUES TO CD02O-CONTACT-ID
               MOVE 'Bad request code' TO CD02O-CONTACT-NAME
           END-EVALUATE.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      *****************************************************************
      * Read request                                                  *
      *****************************************************************
       READ-PROCESSING.

      *****************************************************************
      * Now attempt to get the requested record                       *
      *****************************************************************
           MOVE CD02I-CONTACT-ID TO WS-BNKCUST-RID.
           EXEC CICS READ FILE('BNKCUST')
                          INTO(WS-BNKCUST-REC)
                          LENGTH(LENGTH OF WS-BNKCUST-REC)
                          RIDFLD(WS-BNKCUST-RID)
                          RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              MOVE BCS-REC-PID TO CD02O-CONTACT-ID
              MOVE BCS-REC-NAME TO CD02O-CONTACT-NAME
              MOVE BCS-REC-ADDR1 TO CD02O-CONTACT-ADDR1
              MOVE BCS-REC-ADDR2 TO CD02O-CONTACT-ADDR2
              MOVE BCS-REC-STATE TO CD02O-CONTACT-STATE
              MOVE BCS-REC-CNTRY TO CD02O-CONTACT-CNTRY
              MOVE BCS-REC-POST-CODE TO CD02O-CONTACT-PSTCDE
              MOVE BCS-REC-TEL TO CD02O-CONTACT-TELNO
              MOVE BCS-REC-EMAIL TO CD02O-CONTACT-EMAIL
              MOVE BCS-REC-SEND-MAIL TO CD02O-CONTACT-SEND-MAIL
              MOVE BCS-REC-SEND-EMAIL TO CD02O-CONTACT-SEND-EMAIL
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE SPACES TO CD02O-DATA
              MOVE HIGH-VALUES TO CD02O-CONTACT-ID
              MOVE 'Bad VSAM read' TO CD02O-CONTACT-NAME
           END-IF.

       READ-PROCESSING-EXIT.
           EXIT.

      *****************************************************************
      * Write request                                                 *
      *****************************************************************
       WRITE-PROCESSING.

      *****************************************************************
      * Now attempt to get the requested record for update            *
      *****************************************************************
           MOVE CD02I-CONTACT-ID TO WS-BNKCUST-RID.
           EXEC CICS READ FILE('BNKCUST')
                          UPDATE
                          INTO(WS-BNKCUST-REC)
                          LENGTH(LENGTH OF WS-BNKCUST-REC)
                          RIDFLD(WS-BNKCUST-RID)
                          RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we get the record for update                              *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE SPACES TO CD02O-DATA
              MOVE HIGH-VALUES TO CD02O-CONTACT-ID
              MOVE 'Unable to lock record' TO CD02O-CONTACT-NAME
              GO TO WRITE-PROCESSING-EXIT
           END-IF.

           MOVE CD02I-CONTACT-ADDR1 TO BCS-REC-ADDR1.
           MOVE CD02I-CONTACT-ADDR2 TO BCS-REC-ADDR2.
           MOVE CD02I-CONTACT-STATE TO BCS-REC-STATE.
           MOVE CD02I-CONTACT-CNTRY TO BCS-REC-CNTRY.
           MOVE CD02I-CONTACT-PSTCDE TO BCS-REC-POST-CODE.
           MOVE CD02I-CONTACT-STATE TO BCS-REC-STATE.
           MOVE CD02I-CONTACT-EMAIL TO BCS-REC-EMAIL.
           MOVE CD02I-CONTACT-SEND-MAIL TO BCS-REC-SEND-MAIL.
           MOVE CD02I-CONTACT-SEND-EMAIL TO BCS-REC-SEND-EMAIL.
           EXEC CICS REWRITE FILE('BNKCUST')
                             FROM(WS-BNKCUST-REC)
                             LENGTH(LENGTH OF WS-BNKCUST-REC)
                             RESP(WS-RESP)
           END-EXEC.

      *****************************************************************
      * Did we update the record OK                                   *
      *****************************************************************
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              MOVE HIGH-VALUES TO CD02O-CONTACT-ID
              MOVE 'Update OK' TO CD02O-CONTACT-NAME
           END-IF.

      *****************************************************************
      * The record update failed                                      *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE SPACES TO CD02O-DATA
              MOVE HIGH-VALUES TO CD02O-CONTACT-ID
              MOVE 'Update failed' TO CD02O-CONTACT-NAME
           END-IF.

       WRITE-PROCESSING-EXIT.
           EXIT.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
