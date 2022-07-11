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
      * CBANKD06.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK06P) which inserts transaction      *
      * records to provide an audit trail.                            *
      *****************************************************************
         05  CD06-DATA.
           10  CD06I-DATA.
             15  CD06I-TIMESTAMP                   PIC X(26).
             15  CD06I-FROM-PID                    PIC X(5).
             15  CD06I-FROM-ACC                    PIC X(9).
             15  CD06I-FROM-AMOUNT                 PIC S9(7)V99 COMP-3.
             15  CD06I-FROM-DESC                   PIC X(30).
             15  CD06I-TO-PID                      PIC X(5).
             15  CD06I-TO-ACC                      PIC X(9).
             15  CD06I-TO-AMOUNT                   PIC S9(7)V99 COMP-3.
             15  CD06I-TO-DESC                     PIC X(30).
           10  CD06O-DATA.
             15  CD06O-RESULT                      PIC X(1).
               88  CD06O-UPDATE-OK                 VALUE '0'.
               88  CD06O-UPDATE-FAIL               VALUE '1'.
             15  CD06O-MSG                         PIC X(62).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
