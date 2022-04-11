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
      * CBANKD03.CPY          SHOW HIS TO RRD                         *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK03P) which retrieves information    *
      * regarding customer's accounts                                 *
      *****************************************************************
         05  CD03-DATA.
           10  CD03I-DATA.
             15  CD03I-CONTACT-ID                  PIC X(5).
           10  CD03O-DATA.
             15  CD03O-ACC1                        PIC X(9).
             15  CD03O-DSC1                        PIC X(15).
             15  CD03O-BAL1                        PIC X(9).
             15  CD03O-BAL1N REDEFINES CD03O-BAL1  PIC S9(7)V99.
             15  CD03O-DTE1                        PIC X(10).
             15  CD03O-TXN1                        PIC X(1).
             15  CD03O-ACC2                        PIC X(9).
             15  CD03O-DSC2                        PIC X(15).
             15  CD03O-BAL2                        PIC X(9).
             15  CD03O-BAL2N REDEFINES CD03O-BAL2  PIC S9(7)V99.
             15  CD03O-DTE2                        PIC X(10).
             15  CD03O-TXN2                        PIC X(1).
             15  CD03O-ACC3                        PIC X(9).
             15  CD03O-DSC3                        PIC X(15).
             15  CD03O-BAL3                        PIC X(9).
             15  CD03O-BAL3N REDEFINES CD03O-BAL3  PIC S9(7)V99.
             15  CD03O-DTE3                        PIC X(10).
             15  CD03O-TXN3                        PIC X(1).
             15  CD03O-ACC4                        PIC X(9).
             15  CD03O-DSC4                        PIC X(15).
             15  CD03O-BAL4                        PIC X(9).
             15  CD03O-BAL4N REDEFINES CD03O-BAL4  PIC S9(7)V99.
             15  CD03O-DTE4                        PIC X(10).
             15  CD03O-TXN4                        PIC X(1).
             15  CD03O-ACC5                        PIC X(9).
             15  CD03O-DSC5                        PIC X(15).
             15  CD03O-BAL5                        PIC X(9).
             15  CD03O-BAL5N REDEFINES CD03O-BAL5  PIC S9(7)V99.
             15  CD03O-DTE5                        PIC X(10).
             15  CD03O-TXN5                        PIC X(1).
             15  CD03O-ACC6                        PIC X(9).
             15  CD03O-DSC6                        PIC X(15).
             15  CD03O-BAL6                        PIC X(9).
             15  CD03O-BAL6N REDEFINES CD03O-BAL6  PIC S9(7)V99.
             15  CD03O-DTE6                        PIC X(10).
             15  CD03O-TXN6                        PIC X(1).
           10  CD03O-DATA-R REDEFINES CD03O-DATA.
             15  CD03O-ACC-INFO                    OCCURS 6 TIMES.
               20  CD03O-ACC-NO                    PIC X(9).
               20  CD03O-ACC-DESC                  PIC X(15).
               20  CD03O-ACC-BAL                   PIC X(9).
               20  CD03O-ACC-BAL-N REDEFINES CD03O-ACC-BAL
                                                   PIC S9(7)V99.
               20  CD03O-DTE                       PIC X(10).
               20  CD03O-TXN                       PIC X(1).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
