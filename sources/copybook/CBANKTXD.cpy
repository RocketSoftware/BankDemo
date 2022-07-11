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
      * CBANKTXD.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK01P) which retrieves the customer   *
      * information.                                                  *
      *****************************************************************
       01  TXN-DATA.
         05  TXN-TYPE                              PIC X(1).
           88  TXN-TRANSFER-MONEY                  VALUE '1'.
           88  TXN-CHANGE-CONTACT-INFO             VALUE '2'.
         05  TXN-SUB-TYPE                          PIC X(1).
           88  TXN-TRANSFER-MONEY-FROM             VALUE '1'.
           88  TXN-TRANSFER-MONEY-TO               VALUE '2'.
         05  TXN-DATA-OLD                          PIC X(150).
         05  TXN-T1-OLD REDEFINES TXN-DATA-OLD.
           15  TXN-T1-OLD-DESC                     PIC X(30).
         05  TXN-T2-OLD REDEFINES TXN-DATA-OLD.
           15  TXN-T2-OLD-ADDR1                    PIC X(25).
           15  TXN-T2-OLD-ADDR2                    PIC X(25).
           15  TXN-T2-OLD-STATE                    PIC X(2).
           15  TXN-T2-OLD-CNTRY                    PIC X(6).
           15  TXN-T2-OLD-PSTCDE                   PIC X(6).
           15  TXN-T2-OLD-TELNO                    PIC X(12).
           15  TXN-T2-OLD-EMAIL                    PIC X(30).
           15  TXN-T2-OLD-SEND-MAIL                PIC X(1).
           15  TXN-T2-OLD-SEND-EMAIL               PIC X(1).
         05  TXN-DATA-NEW                          PIC X(150).
         05  TXN-T2-NEW REDEFINES TXN-DATA-NEW.
           15  TXN-T2-NEW-ADDR1                    PIC X(25).
           15  TXN-T2-NEW-ADDR2                    PIC X(25).
           15  TXN-T2-NEW-STATE                    PIC X(2).
           15  TXN-T2-NEW-CNTRY                    PIC X(6).
           15  TXN-T2-NEW-PSTCDE                   PIC X(6).
           15  TXN-T2-NEW-TELNO                    PIC X(12).
           15  TXN-T2-NEW-EMAIL                    PIC X(30).
           15  TXN-T2-NEW-SEND-MAIL                PIC X(1).
           15  TXN-T2-NEW-SEND-EMAIL               PIC X(1).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
