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
      * CDFSAIB.CPY                                                   *
      *---------------------------------------------------------------*
      * IMS AIB Mask                                                  *
      *****************************************************************
       01  DFSAIB.
         05  AIBID                                 PIC X(8).
         05  AIBLEN                                PIC S9(8) COMP.
         05  AIBSFUNC                              PIC X(8).
         05  AIBRSNM1                              PIC X(8).
         05  AIBRESVD1                             PIC X(16).
         05  AIBAOLEN                              PIC S9(8) COMP.
         05  AIBOAUSE                              PIC S9(8) COMP.
         05  AIBRESVD2                             PIC X(12).
         05  AIBRETRN                              PIC S9(8) COMP.
         05  AIBREASN                              PIC S9(8) COMP.
         05  AIBERRXT                              PIC X(4).
         05  AIBRSA1                               POINTER.
         05  AIBRESVD4                             PIC X(48).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
