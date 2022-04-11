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
      * CCASHD02.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DCASHD02) which retrieves information    *
      * regarding customer's accounts                                 *
      *****************************************************************
         05  CD02-DATA.
           10  CD02I-DATA.
             15  CD02I-CONTACT-ID                  PIC X(5).
           10  CD02O-DATA.
             15  CD02O-DET1.
               20  CD02O-ACC1                      PIC X(9).
               20  CD02O-DSC1                      PIC X(15).
               20  CD02O-BAL1                      PIC X(13).
               20  CD02O-DAY-LIMIT1                PIC X(3).
               20  CD02O-DATE-USED1                PIC X(10).
               20  CD02O-DATE-AMT1                 PIC X(3).
             15  CD02O-DET2.
               20  CD02O-ACC2                      PIC X(9).
               20  CD02O-DSC2                      PIC X(15).
               20  CD02O-BAL2                      PIC X(13).
               20  CD02O-DAY-LIMIT2                PIC X(3).
               20  CD02O-DATE-USED2                PIC X(10).
               20  CD02O-DATE-AMT2                 PIC X(3).
             15  CD02O-DET3.
               20  CD02O-ACC3                      PIC X(9).
               20  CD02O-DSC3                      PIC X(15).
               20  CD02O-BAL3                      PIC X(13).
               20  CD02O-DAY-LIMIT3                PIC X(3).
               20  CD02O-DATE-USED3                PIC X(10).
               20  CD02O-DATE-AMT3                 PIC X(3).
             15  CD02O-DET4.
               20  CD02O-ACC4                      PIC X(9).
               20  CD02O-DSC4                      PIC X(15).
               20  CD02O-BAL4                      PIC X(13).
               20  CD02O-DAY-LIMIT4                PIC X(3).
               20  CD02O-DATE-USED4                PIC X(10).
               20  CD02O-DATE-AMT4                 PIC X(3).
             15  CD02O-DET5.
               20  CD02O-ACC5                      PIC X(9).
               20  CD02O-DSC5                      PIC X(15).
               20  CD02O-BAL5                      PIC X(13).
               20  CD02O-DAY-LIMIT5                PIC X(3).
               20  CD02O-DATE-USED5                PIC X(10).
               20  CD02O-DATE-AMT5                 PIC X(3).
           10  CD02O-DATA-R REDEFINES CD02O-DATA.
             15  CD02O-ACC-INFO                    OCCURS 5 TIMES.
               20  CD02O-ACC-NO                    PIC X(9).
               20  CD02O-ACC-DESC                  PIC X(15).
               20  CD02O-ACC-BAL                   PIC X(13).
               20  CD02O-ACC-DAY-LIMIT             PIC X(3).
               20  CD02O-ACC-DATE-USED             PIC X(10).
               20  CD02O-ACC-DATE-AMT              PIC X(3).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
