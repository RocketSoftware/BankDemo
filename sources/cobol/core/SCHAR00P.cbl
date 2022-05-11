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
      * Program:     SCHAR00P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Determine charcater set (EBCDIC/ASCII)           *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SCHAR00P.
       DATE-WRITTEN.
           September 2003.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SCHAR00P'.

      *COPY CABENDD.


       01  ws-msg.
         05  filler                                pic x(20)
             value 'SCHAR00P - EIBCALEN='.
         05  ws-msg-calen                          pic 9(5).
         05  filler                                pic x(12)
             value ', EIBTRNID=<'.
         05  ws-msg-tran                           pic x(4).
         05  filler                                pic x(1)
             value '>'.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-CHARSET-SPACES                     PIC X(1)
             OCCURS 1 TO 32000 TIMES DEPENDING ON EIBCALEN.

       PROCEDURE DIVISION.
      *****************************************************************
      * Move spaces to COMMAREA. This will be tested elsewhere to     *
      * determine if we are in EBCDIC or ASCII. Spaces are x'40' in   *
      * EBCDIC and x'20' in ASCII.                                    *
      *****************************************************************
           move eibcalen to ws-msg-calen.
           move eibtrnid to ws-msg-tran.
      *    exec cics write operator
      *                    text(ws-msg)
      *                    textlength(length of ws-msg)
      *    end-exec.

           IF EIBCALEN IS NOT EQUAL TO 0
              MOVE SPACES TO DFHCOMMAREA(1:EIBCALEN)
           END-IF.

      *****************************************************************
      * Now we have to have finished and can return to our invoker.   *
      *****************************************************************
           EXEC CICS
                RETURN
           END-EXEC.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
