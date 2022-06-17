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
      * CBANKD09.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK09P) which retrieves contact        *
      * information to send printed statements                        *
      *****************************************************************
         05  CD09-DATA.
           10  CD09I-DATA.
             15  CD09I-CONTACT-ID                  PIC X(5).
           10  CD09O-DATA.
             15  CD09O-CONTACT-ID                  PIC X(5).
             15  CD09O-CONTACT-NAME                PIC X(25).
             15  CD09O-CONTACT-ADDR1               PIC X(25).
             15  CD09O-CONTACT-ADDR2               PIC X(25).
             15  CD09O-CONTACT-STATE               PIC X(2).
             15  CD09O-CONTACT-CNTRY               PIC X(6).
             15  CD09O-CONTACT-PSTCDE              PIC X(6).
             15  CD09O-CONTACT-EMAIL               PIC X(30).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
