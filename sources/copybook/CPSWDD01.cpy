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
      * CPSWDD01.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the "I/O" program (SPSWD01P) which checks the supplied    *
      * usewrid/password against the current security model           *
      *****************************************************************
         05  CPSWDD01-DATA.
           10  CPSWDD01I-DATA.
             15  CPSWDD01I-OPERATION               PIC X(1).
               88  PSWD-NOOP                       VALUE '0'.
               88  PSWD-SIGNON                     VALUE '1'.
               88  PSWD-SIGNOFF                    VALUE '2'.
             15  CPSWDD01I-USERID                  PIC X(8).
             15  CPSWDD01I-PASSWORD                PIC X(8).
           10  CPSWDD01O-DATA.
             15  CPSWDD01O-MESSAGE                 PIC X(75).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
