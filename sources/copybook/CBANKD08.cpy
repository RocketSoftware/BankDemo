      *****************************************************************
      *                                                               *
      * Copyright 2010-2024 Rocket Software, Inc. or its affiliates.  *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Rocket products, and is otherwise subject to the EULA at      *
      * https://www.rocketsoftware.com/company/trust/agreements.      *
      *                                                               *
      * THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED             *
      * WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF               *
      * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,         *
      * SHALL NOT APPLY.                                              *
      * TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL              *
      * ROCKET SOFTWARE HAVE ANY LIABILITY WHATSOEVER IN CONNECTION   *
      * WITH THIS SOFTWARE.                                           *
      *                                                               *
      *****************************************************************

      *****************************************************************
      * CBANKD08.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK03P) which retrieves information    *
      * regarding customer's accounts                                 *
      *****************************************************************
         05  CD08-DATA.
           10  CD08I-DATA.
             15  CD08I-CONTACT-ID                  PIC X(5).
           10  CD08O-DATA.
             15  CD08O-COUNT                       PIC 9(3).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
