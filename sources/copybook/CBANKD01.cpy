      *****************************************************************
      *                                                               *
      * Copyright 2010-2021 Rocket Software, Inc. or its affiliates.  *
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
      * CBANKD01.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DBANK01P) which retrieves the customer   *
      * information.                                                  *
      *****************************************************************
         05  CD01-DATA.
           10  CD01I-DATA.
             15  CD01I-PERSON-PID                  PIC X(5).
           10  CD01O-DATA.
             15  CD01O-PERSON-PID                  PIC X(5).
             15  CD01O-PERSON-NAME                 PIC X(25).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
