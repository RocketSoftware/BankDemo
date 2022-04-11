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
      * Program:     SCUSTOMP.CBL                                     *
      * Layer:       Screen handling                                  *
      * Function:    Populate screen titles                           *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SCUSTOMP.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *****************************************************************
      * Headings for screens                                          *
      *---------------------------------------------------------------*
      * The screens have space for two titles, one on the top line,   *
      * one on the second line. Each is 50 bytes long and is centered *
      * on the line.                                                  *
      *****************************************************************
       01  SCREEN-TITLES.
         05  SCREEN-TITLE1                         PIC X(50)
             VALUE '        Enterprise Developer Demonstration        '.
      *             00000000011111111112222222222333333333344444444445'.
      *      VALUE '12345678901234567890123456789012345678901234567890'.
         05  SCREEN-TITLE2                         PIC X(50)
             VALUE '        **********************************        '.
      *             00000000011111111112222222222333333333344444444445'.
      *      VALUE '12345678901234567890123456789012345678901234567890'.

       LINKAGE SECTION.
       01  LK-SCREEN-TITLES.
         05  LK-SCREEN-TITLE1                      PIC X(50).
         05  LK-SCREEN-TITLE2                      PIC X(50).

       PROCEDURE DIVISION USING LK-SCREEN-TITLES.
      *****************************************************************
      * Move the titles from our area to the passed area              *
      *****************************************************************
           MOVE SCREEN-TITLES TO LK-SCREEN-TITLES.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
