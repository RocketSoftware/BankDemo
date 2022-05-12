      *$set dialect(MF) cicsecm()
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
      * Program:     DFHZCSGM.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    CICS "Good Morning" transaction                  *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DFHZCSGM.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DFHZCSGM'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-CICS-JOBNAME                       PIC X(8).
         05  WS-CICS-ASKTIME                       PIC S9(15) COMP-3.
         05  WS-CICS-FORMATTIME-TIME               PIC X(8).
         05  WS-COMMAREA                           PIC X(16).
         05  WS-SEND-MSG                           PIC X(8).
         05  WS-ENV-NAME                           PIC X(16).
         05  WS-ENV-VALUE                          PIC X(4).
         05  WS-RESP                               PIC S9(8) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY DFHZSGM.

       COPY DFHAID.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  FILLER                                PIC X(1)
             OCCURS 1 TO 32000 TIMES DEPENDING ON EIBCALEN.

       PROCEDURE DIVISION.
      *****************************************************************
      * Check to see if this is the first time thru                   *
      *****************************************************************
      *    call 'cbl_debugbreak'
           IF EIBCALEN IS NOT EQUAL TO 0
              IF EIBAID IS NOT EQUAL TO DFHCLEAR
                 EXEC CICS RECEIVE MAP('CSGM')
                                   MAPSET('DFHZSGM')
                 END-EXEC
              END-IF
              MOVE LOW-VALUES TO WS-SEND-MSG
              EXEC CICS SEND
                        CONTROL
      *                 FROM(WS-SEND-MSG)
                        ERASE
                        FREEKB
              END-EXEC
              MOVE DFHCOMMAREA TO WS-TRAN-ID
              IF WS-TRAN-ID IS NOT EQUAL TO SPACES
                 EXEC CICS START TRANSID(WS-TRAN-ID)
                                 TERMID(EIBTRMID)
                 END-EXEC
                 EXEC CICS RETURN
                 END-EXEC
                 GOBACK
              ELSE
                 EXEC CICS RETURN
                 END-EXEC
                 GOBACK
              END-IF
           END-IF.

      *****************************************************************
      * Store our transaction-id                                      *
      *****************************************************************
           MOVE EIBTRNID TO WS-TRAN-ID.

      *****************************************************************
      * This is the main process                                      *
      *****************************************************************
      * Get the name of this CICS system
           EXEC CICS INQUIRE SYSTEM JOBNAME(WS-CICS-JOBNAME)
           END-EXEC.
      * Get the time from CICS
           EXEC CICS ASKTIME ABSTIME(WS-CICS-ASKTIME)
           END-EXEC.
      * Format the time to a readable form
           EXEC CICS FORMATTIME ABSTIME(WS-CICS-ASKTIME)
                                TIME(WS-CICS-FORMATTIME-TIME)
                                TIMESEP(':')
           END-EXEC.

      * Clear the map
           MOVE LOW-VALUE TO MAPAREA.

      * Add CICS name and time to the map
           STRING WS-CICS-JOBNAME DELIMITED BY SPACE
                  ' ' DELIMITED BY SIZE
                  WS-CICS-FORMATTIME-TIME DELIMITED BY SIZE
             INTO VAR01O.

      * Send the map out
           EXEC CICS SEND MAP('CSGM')
                          MAPSET('DFHZSGM')
                          ERASE
                          FREEKB
           END-EXEC.

      * See if we have next tran in the environment space
           MOVE 'CSGM-NEXT-TRAN' TO WS-ENV-NAME.
           MOVE HIGH-VALUES TO WS-ENV-VALUE.
           DISPLAY WS-ENV-NAME UPON ENVIRONMENT-NAME
           ACCEPT WS-ENV-VALUE FROM ENVIRONMENT-VALUE.
           MOVE FUNCTION UPPER-CASE(WS-ENV-VALUE) TO WS-ENV-VALUE.
           EXEC CICS INQUIRE
                     TRANSACTION(WS-ENV-VALUE)
                     RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE SPACES TO WS-COMMAREA
           ELSE
              MOVE WS-ENV-VALUE TO WS-COMMAREA
           END-IF.

      * Now return to CICS
           EXEC CICS
                RETURN
                TRANSID(WS-TRAN-ID)
                COMMAREA(WS-COMMAREA)
                LENGTH(LENGTH OF WS-COMMAREA)
           END-EXEC.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
