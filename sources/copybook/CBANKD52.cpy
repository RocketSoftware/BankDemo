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

      ****************************************************************
      * CD52DATA.CPY                                                 *
      *--------------------------------------------------------------*
      * This area is used to pass data between ????????????????????  *
      * display program and the I/O program (DBANK52P) which         *
      * retrieves the data requested ????????????????????????????    *
      ****************************************************************
         05  CD52-DATA.
           10  CD52I-DATA.
             15  CD52I-PID                         PIC X(5).
               88  CD52-REQUESTED-ALL              VALUE 'ALL  '.
           10  CD52O-DATA.
             15  CD52O-PID                         PIC X(5).
             15  CD52O-ACC-NO                      PIC X(9).
             15  CD52O-TIMESTAMP                   PIC X(26).
             15  CD52O-AMOUNT                      PIC S9(7)V99 COMP-3.
             15  CD52O-DESC                        PIC X(30).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
