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
      * CBANKD11.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK11P) which retrieves information    *
      * regarding customer's accounts                                 *
      *****************************************************************
         05  CD11-DATA.
           10  CD11I-DATA.
             15  CD11I-ACCNO                       PIC X(9).
           10  CD11O-DATA.
             15  CD11O-ACCNO                       PIC X(9).
             15  CD11O-DESC                        PIC X(15).
             15  CD11O-BAL                         PIC X(9).
             15  CD11O-BAL-N REDEFINES CD11O-BAL   PIC S9(7)V99.
             15  CD11O-DTE                         PIC X(10).
             15  CD11O-TRANS                       PIC X(5).
             15  CD11O-ATM-ENABLED                 PIC X(1).
             15  CD11O-ATM-LIM                     PIC X(3).
             15  CD11O-ATM-LIM-N REDEFINES CD11O-ATM-LIM
                                                   PIC 9(3).
             15  CD11O-ATM-LDTE                    PIC X(10).
             15  CD11O-ATM-LAMT                    PIC X(3).
             15  CD11O-ATM-LAMT-N REDEFINES CD11O-ATM-LAMT
                                                   PIC 9(3).
             15  CD11O-RP1DAY                      PIC X(2).
             15  CD11O-RP1AMT                      PIC X(7).
             15  CD11O-RP1AMT-N REDEFINES CD11O-RP1AMT
                                                   PIC S9(5)V99.
             15  CD11O-RP1PID                      PIC X(5).
             15  CD11O-RP1ACC                      PIC X(9).
             15  CD11O-RP1DTE                      PIC X(10).
             15  CD11O-RP2DAY                      PIC X(2).
             15  CD11O-RP2AMT                      PIC X(7).
             15  CD11O-RP2AMT-N REDEFINES CD11O-RP2AMT
                                                   PIC S9(5)V99.
             15  CD11O-RP2PID                      PIC X(5).
             15  CD11O-RP2ACC                      PIC X(9).
             15  CD11O-RP2DTE                      PIC X(10).
             15  CD11O-RP3DAY                      PIC X(2).
             15  CD11O-RP3AMT                      PIC X(7).
             15  CD11O-RP3AMT-N REDEFINES CD11O-RP3AMT
                                                   PIC S9(5)V99.
             15  CD11O-RP3PID                      PIC X(5).
             15  CD11O-RP3ACC                      PIC X(9).
             15  CD11O-RP3DTE                      PIC X(10).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
