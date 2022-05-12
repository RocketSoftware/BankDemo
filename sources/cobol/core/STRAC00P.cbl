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
      * Program:     STRAC00P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Display activity on system log                   *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           STRAC00P.
       DATE-WRITTEN.
           September 2007.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'STRAC00P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-TRACE-LEVEL                        PIC X(1)
             VALUE '1'.
           88  TRACE-LEVEL-0                       VALUE '0'.
           88  TRACE-LEVEL-1                       VALUE '1'.
           88  TRACE-LEVEL-2                       VALUE '2'.
         05  WS-WTO-DATA.
           10  FILLER                              PIC X(4)
               VALUE 'INT '.
           10  FILLER                              PIC X(7)
               VALUE 'Termid:'.
           10  WS-WTO-TERM                         PIC X(4).
           10  FILLER                              PIC X(9)
               VALUE ', Tranid:'.
           10  WS-WTO-TRAN                         PIC X(4).
           10  FILLER                              PIC X(10)
               VALUE ', Program:'.
           10  WS-WTO-PROG                         PIC X(8).

       COPY DFHAID.

       COPY DFHBMSCA.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-CALLING-RTN                        PIC X(8).

       PROCEDURE DIVISION.
      *****************************************************************
      * Store our transaction-id in msg                               *
      *****************************************************************
           MOVE EIBTRNID TO WS-WTO-TRAN.

      *****************************************************************
      * Store our terminal id in msg                                  *
      *****************************************************************
           MOVE EIBTRMID TO WS-WTO-TERM

      *****************************************************************
      * Store any passed data in msg                                  *
      *****************************************************************
           IF EIBCALEN IS EQUAL TO 0
              MOVE 'Unknown' TO WS-WTO-PROG
           ELSE
              MOVE LK-CALLING-RTN(1:EIBCALEN) TO WS-WTO-PROG
           END-IF.

      *****************************************************************
      * Display the msg                                               *
      *****************************************************************
           IF NOT TRACE-LEVEL-0
              IF EIBTRMID IS NOT EQUAL TO SPACES
                 EXEC CICS WRITE
                           OPERATOR
                           TEXT(WS-WTO-DATA)
                           TEXTLENGTH(LENGTH OF WS-WTO-DATA)
                 END-EXEC

                 EXEC CICS WRITEQ TD
                           QUEUE('CSMT')
                           FROM(WS-WTO-DATA)
                           LENGTH(LENGTH OF WS-WTO-DATA)
                 END-EXEC

              END-IF
           END-IF.

      *****************************************************************
      * Now we have to have finished and can return to our invoker.   *
      *****************************************************************
           EXEC CICS
                RETURN
           END-EXEC.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
