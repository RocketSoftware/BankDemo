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
      * Program:     DCASH01P.CBL                                     *
      * Function:    Obtain users PIN                                 *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DCASH01P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DCASH01P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-SUB1                               PIC S9(4) COMP.
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-BNKCUST-RID                        PIC X(5).

       01 WS-BNKCUST-REC.
       COPY CBANKVCS.

       01  WS-COMMAREA.
       COPY CCASHD01.

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
           MOVE SPACES TO CD01O-DATA.

      *****************************************************************
      * Now attempt to get the requested record                       *
      *****************************************************************
           MOVE CD01I-CONTACT-ID TO WS-BNKCUST-RID.
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
              MOVE BCS-REC-ATM-PIN TO CD01O-PIN
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE '????' TO CD01O-PIN
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
