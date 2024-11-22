      *****************************************************************
      *                                                               *
      * Copyright 2010-2021 Rocket Software, Inc. or its affiliates.  *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Rocket products, and is otherwise subject to the EULA at      *
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
      * Program:     DBANKIOP.CBL                                     *
      * Function:    Return data access method                        *
      *              VSAM version                                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANKIOP.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANKIOP'.

       LINKAGE SECTION.
       01  LK-PASS-AREA                            PIC X(6).

       PROCEDURE DIVISION USING LK-PASS-AREA.
      *****************************************************************
      * Move the data to the passed area                              *
      *****************************************************************
           MOVE 'VSM   ' TO LK-PASS-AREA.

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
