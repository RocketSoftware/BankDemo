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
      * CBANKD04.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK04P) which updates account          *
      * information.                                                  *
      *****************************************************************
         05  CD04-DATA.
           10  CD04I-DATA.
             15  CD04I-FROM-PID                    PIC X(5).
             15  CD04I-FROM-ACC                    PIC X(9).
             15  CD04I-FROM-OLD-BAL                PIC S9(7)V99 COMP-3.
             15  CD04I-FROM-NEW-BAL                PIC S9(7)V99 COMP-3.
             15  CD04I-TO-PID                      PIC X(5).
             15  CD04I-TO-ACC                      PIC X(9).
             15  CD04I-TO-OLD-BAL                  PIC S9(7)V99 COMP-3.
             15  CD04I-TO-NEW-BAL                  PIC S9(7)V99 COMP-3.
           10  CD04O-DATA.
             15  CD04O-RESULT                      PIC X(1).
               88  CD04O-UPDATE-OK                 VALUE '0'.
               88  CD04O-UPDATE-FAIL               VALUE '1'.
             15  CD04O-TIMESTAMP                   PIC X(26).
             15  CD04O-TIMESTAMP-R REDEFINES CD04O-TIMESTAMP.
               20  CD04O-DATE                      PIC X(10).
               20  CD040-FIL1                      PIC X(1).
               20  CD04O-TIME                      PIC X(8).
               20  CD040-FIL2                      PIC X(1).
               20  CD040-MSEC                      PIC X(6).
             15  CD04O-MSG                         PIC X(62).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
