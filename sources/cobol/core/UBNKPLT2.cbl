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
      * Program:     UBNKPLT2.CBL (CICS Version)                      *
      * Layer:       System level                                     *
      * Function:    PLTI Processing (ES/MTO Startup)                 *
      *---------------------------------------------------------------*
      * PLT Initialisation (PLTI) can run one or more programs once   *
      * at system startup or at the initialisation of every SEP.      *
      * This is a dummy process to illustrate the "run in each SEP"   *
      * scenario                                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           UBNKPLT2.
       DATE-WRITTEN.
           September 2003.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'UBNKPLT2'.
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

       LINKAGE SECTION.

       PROCEDURE DIVISION.
      *****************************************************************
      * Display the msg                                               *
      *****************************************************************
           MOVE z'UBNKPLT2 Complete' TO WS-WTO-DATA.
           EXEC CICS WRITE
                     OPERATOR
                     TEXT(WS-WTO-DATA)
                     TEXTLENGTH(LENGTH OF WS-WTO-DATA)
           END-EXEC.

           EXEC CICS WRITEQ TD
                     QUEUE('CSMT')
                     FROM(WS-WTO-DATA)
                     LENGTH(LENGTH OF WS-WTO-DATA)
           END-EXEC.

      *****************************************************************
      * Now we have to have finished and can return to our invoker.   *
      *****************************************************************
           EXEC CICS
                RETURN
           END-EXEC.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
