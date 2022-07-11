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
      * Program:     UTWOSCMP.CBL                                     *
      * Function:    ??conversion utility routine                     *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           UTWOSCMP.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'UTWOSCMP'.
         05  WS-LEN                                PIC 9(4) COMP.

         05  WS-WORK-INPUT.
           10  WS-WORK-INPUT-N                     PIC 9(4) COMP.
         05  FILLER REDEFINES WS-WORK-INPUT.
           10  WS-WORK-INPUT-BYTE-1                PIC X(1).
           10  WS-WORK-INPUT-BYTE-2                PIC X(1).

         05  WS-WORK-OUTPUT.
           10  WS-WORK-OUTPUT-N                    PIC 9(4) COMP.
         05  FILLER REDEFINES WS-WORK-OUTPUT.
           10  WS-WORK-OUTPUT-BYTE-1               PIC X(1).
           10  WS-WORK-OUTPUT-BYTE-2               PIC X(1).

       LINKAGE SECTION.
       01  LK-TWOS-CMP-LEN                         PIC S9(4) COMP.
       01  LK-TWOS-CMP-INPUT                       PIC X(256).
       01  LK-TWOS-CMP-OUTPUT                      PIC X(256).

       PROCEDURE DIVISION USING LK-TWOS-CMP-LEN
                                LK-TWOS-CMP-INPUT
                                LK-TWOS-CMP-OUTPUT.
           PERFORM VARYING WS-LEN FROM 1 BY 1
             UNTIL WS-LEN > LK-TWOS-CMP-LEN
             MOVE 0 TO WS-WORK-INPUT-N
             MOVE LK-TWOS-CMP-INPUT(WS-LEN:1) TO WS-WORK-INPUT-BYTE-2
             MOVE 255 TO WS-WORK-OUTPUT-N
             SUBTRACT WS-WORK-INPUT-N FROM WS-WORK-OUTPUT-N
             MOVE WS-WORK-OUTPUT-BYTE-2 TO LK-TWOS-CMP-OUTPUT(WS-LEN:1)
           END-PERFORM.

           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
