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
      * CBANKD02.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK02P) which retrieves or updates     *
      * address information.                                          *
      *****************************************************************
         05  CD02-DATA.
           10  CD02I-DATA.
             15  CD02I-FUNCTION                    PIC X(1).
               88  CD02I-READ                      VALUE 'R'.
               88  CD02I-WRITE                     VALUE 'W'.
             15  CD02I-CONTACT-ID                  PIC X(5).
             15  CD02I-CONTACT-NAME                PIC X(25).
             15  CD02I-CONTACT-ADDR1               PIC X(25).
             15  CD02I-CONTACT-ADDR2               PIC X(25).
             15  CD02I-CONTACT-STATE               PIC X(2).
             15  CD02I-CONTACT-CNTRY               PIC X(6).
             15  CD02I-CONTACT-PSTCDE              PIC X(6).
             15  CD02I-CONTACT-TELNO               PIC X(12).
             15  CD02I-CONTACT-EMAIL               PIC X(30).
             15  CD02I-CONTACT-SEND-MAIL           PIC X(1).
             15  CD02I-CONTACT-SEND-EMAIL          PIC X(1).
           10  CD02O-DATA.
             15  CD02O-CONTACT-ID                  PIC X(5).
             15  CD02O-CONTACT-NAME                PIC X(25).
             15  CD02O-CONTACT-ADDR1               PIC X(25).
             15  CD02O-CONTACT-ADDR2               PIC X(25).
             15  CD02O-CONTACT-STATE               PIC X(2).
             15  CD02O-CONTACT-CNTRY               PIC X(6).
             15  CD02O-CONTACT-PSTCDE              PIC X(6).
             15  CD02O-CONTACT-TELNO               PIC X(12).
             15  CD02O-CONTACT-EMAIL               PIC X(30).
             15  CD02O-CONTACT-SEND-MAIL           PIC X(1).
             15  CD02O-CONTACT-SEND-EMAIL          PIC X(1).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
