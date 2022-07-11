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
      * CBANKD07.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK07P) which retrieves or updates     *
      * address information.                                          *
      *****************************************************************
         05  CD07-DATA.
           10  CD07I-DATA.
             15  CD07I-PERSON-PID                  PIC X(5).
             15  CD07I-TIMESTAMP                   PIC X(26).
             15  CD07I-OLD-DATA                    PIC X(150).
             15  FILLER REDEFINES CD07I-OLD-DATA.
               20  CD07I-OLD-ADDR1                 PIC X(25).
               20  CD07I-OLD-ADDR2                 PIC X(25).
               20  CD07I-OLD-STATE                 PIC X(2).
               20  CD07I-OLD-CNTRY                 PIC X(6).
               20  CD07I-OLD-PSTCDE                PIC X(6).
               20  CD07I-OLD-TELNO                 PIC X(12).
               20  CD07I-OLD-EMAIL                 PIC X(30).
               20  CD07I-OLD-SEND-MAIL             PIC X(1).
               20  CD07I-OLD-SEND-EMAIL            PIC X(1).
             15  CD07I-NEW-DATA                    PIC X(150).
             15  FILLER REDEFINES CD07I-NEW-DATA.
               20  CD07I-NEW-ADDR1                 PIC X(25).
               20  CD07I-NEW-ADDR2                 PIC X(25).
               20  CD07I-NEW-STATE                 PIC X(2).
               20  CD07I-NEW-CNTRY                 PIC X(6).
               20  CD07I-NEW-PSTCDE                PIC X(6).
               20  CD07I-NEW-TELNO                 PIC X(12).
               20  CD07I-NEW-EMAIL                 PIC X(30).
               20  CD07I-NEW-SEND-MAIL             PIC X(1).
               20  CD07I-NEW-SEND-EMAIL            PIC X(1).
           10  CD07O-DATA.
             15  CD07O-RESULT                      PIC X(1).
               88  CD07O-UPDATE-OK                 VALUE '0'.
               88  CD07O-UPDATE-FAIL               VALUE '1'.
             15  CD07O-MSG                         PIC X(62).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
