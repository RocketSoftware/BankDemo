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
      * CSTMTD01.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the "I/O" program (SSTMT01P) which retrieves contact      *
      * information to send printed statements                        *
      *****************************************************************
         05  CSTMTD01-DATA.
           10  CSTMTD01I-DATA.
             15  CSTMTD01I-CONTACT-ID              PIC X(5).
             15  CSTMTD01I-OPTION                  PIC X(1).
               88  CSTMTD01I-POST                  VALUE '1'.
               88  CSTMTD01I-EMAIL                 VALUE '2'.
                 10  CSTMTD01O-DATA.
             15  CSTMTD01O-CONTACT-ID              PIC X(5).
               88  CSTMTD01O-OK                    VALUES SPACES.
               88  CSTMTD01O-ERROR                 VALUES 'ERROR'.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
