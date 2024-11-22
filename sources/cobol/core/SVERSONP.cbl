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
      * Program:     SVERSONP.CBL                                     *
      * Layer:       Screen handling                                  *
      * Function:    Populate screen titles                           *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SVERSONP.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *****************************************************************
      * Version to show on screens                                    *
      *****************************************************************
       01  WS-VERSION                              PIC X(7)
           VALUE ' V5.99c'.

       LINKAGE SECTION.
       01  LK-VERSION                              PIC X(7).

       PROCEDURE DIVISION USING LK-VERSION.
      *****************************************************************
      * Move the version from our area to the passed area             *
      *****************************************************************
           MOVE WS-VERSION TO LK-VERSION.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm

