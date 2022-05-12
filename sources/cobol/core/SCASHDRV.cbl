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

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SCASHDRV.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SCASHDRV'.


       01  WS-CASH-DATA-AREAS.
         05  WS-CASH-DATA.
       COPY CCASHDAT.
         05  WS-CASH-EXT-DATA.
       COPY CCASHEXT.

       COPY CABENDD.


       PROCEDURE DIVISION.
           MOVE SPACES TO WS-CASH-DATA-AREAS.
           SET ATM-FUNC-GET-ACCOUNTS TO TRUE.
           MOVE 'B0004' TO ATM-IP00-USERID.
           MOVE '0004' TO ATM-IP00-PIN.

           EXEC CICS LINK PROGRAM('SCASH00P')
                          COMMAREA(WS-CASH-EXT-DATA)
                          LENGTH(LENGTH OF WS-CASH-EXT-DATA)
           END-EXEC.

      *****************************************************************
      * Now we have to have finished and can return to our invoker.   *
      *****************************************************************
      * Now return to CICS
           EXEC CICS
                RETURN
           END-EXEC.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
