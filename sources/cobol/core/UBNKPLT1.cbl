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
      * Program:     UBNKPLT1.CBL (CICS Version)                      *
      * Layer:       System level                                     *
      * Function:    PLTI Processing (ES/MTO Startup)                 *
      *---------------------------------------------------------------*
      * PLT Initialisation (PLTI) can run one or more programs once   *
      * at system startup or at the initialisation of every SEP.      *
      * This is a dummy process to illustrate the "run once" scenario *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           UBNKPLT1.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'UBNKPLT1'.
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
           MOVE z'UBNKPLT1 Complete' TO WS-WTO-DATA.
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
