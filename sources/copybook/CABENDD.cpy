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
      * CABENDD.CPY                                                   *
      *---------------------------------------------------------------*
      * Work areas for abend routine                                  *
      *****************************************************************
       01  ABEND-DATA.
         05  ABEND-CODE                            PIC X(4)
             VALUE SPACES.
         05  ABEND-CULPRIT                         PIC X(8)
             VALUE SPACES.
         05  ABEND-REASON                          PIC X(50)
             VALUE SPACES.
         05  ABEND-MSG                             PIC X(72)
             VALUE SPACES.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
