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
      * CD51DATA.CPY                                                 *
      *--------------------------------------------------------------*
      * This area is used to pass data between ????????????????????  *
      * display program and the I/O program (DBANK51P) which         *
      * retrieves the data requested ????????????????????????????    *
      ****************************************************************
         05  CD51-DATA.
           10  CD51I-DATA.
             15  CD51I-PID                         PIC X(5).
               88  CD51-REQUESTED-ALL              VALUE 'ALL  '.
           10  CD51O-DATA.
             15  CD51O-PID                         PIC X(5).
             15  CD51O-NAME                        PIC X(25).
             15  CD51O-ADDR1                       PIC X(25).
             15  CD51O-ADDR2                       PIC X(25).
             15  CD51O-STATE                       PIC X(2).
             15  CD51O-CNTRY                       PIC X(6).
             15  CD51O-POST-CODE                   PIC X(6).
             15  CD51O-EMAIL                       PIC X(30).
             15  CD51O-ACC-NO                      PIC X(9).
             15  CD51O-ACC-DESC                    PIC X(15).
             15  CD51O-ACC-CURR-BAL                PIC S9(7)V99 COMP-3.
             15  CD51O-ACC-LAST-STMT-DTE           PIC X(10).
             15  CD51O-ACC-LAST-STMT-BAL           PIC S9(7)V99 COMP-3.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
