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
      * Program:     DBANK09P.CBL                                     *
      * Function:    Obtain contact information for statements        *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK09P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK09P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-BNKCUST-RID                        PIC X(5).

       01 WS-BNKCUST-REC.
       COPY CBANKVCS.

       01  WS-COMMAREA.
       COPY CBANKD09.

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
           MOVE SPACES TO CD09O-DATA.

      *****************************************************************
      * Now attempt to get the requested record                       *
      *****************************************************************
           MOVE CD09I-CONTACT-ID TO WS-BNKCUST-RID.
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
              MOVE BCS-REC-PID TO CD09O-CONTACT-ID
              MOVE BCS-REC-NAME TO CD09O-CONTACT-NAME
              MOVE BCS-REC-ADDR1 TO CD09O-CONTACT-ADDR1
              MOVE BCS-REC-ADDR2 TO CD09O-CONTACT-ADDR2
              MOVE BCS-REC-STATE TO CD09O-CONTACT-STATE
              MOVE BCS-REC-CNTRY TO CD09O-CONTACT-CNTRY
              MOVE BCS-REC-POST-CODE TO CD09O-CONTACT-PSTCDE
              MOVE BCS-REC-EMAIL TO CD09O-CONTACT-EMAIL
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE SPACES TO CD09O-DATA
              MOVE HIGH-VALUES TO CD09O-CONTACT-ID
              MOVE 'Bad VSAM read' TO CD09O-CONTACT-NAME
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
