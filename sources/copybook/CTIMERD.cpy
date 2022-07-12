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
      * CTIMERD.CPY                                                   *
      *---------------------------------------------------------------*
      * Work areas for run timer                                      *
      *****************************************************************
       01  TIMER-DATA.
         05  TIMER-START                           PIC 9(8)
             VALUE ZERO.
         05  FILLER REDEFINES TIMER-START.
           10  TIMER-START-HH                      PIC 9(2).
           10  TIMER-START-MM                      PIC 9(2).
           10  TIMER-START-SS                      PIC 9(2).
           10  TIMER-START-DD                      PIC 9(2).
         05  TIMER-END                             PIC 9(8)
             VALUE ZERO.
         05  FILLER REDEFINES TIMER-END.
           10  TIMER-END-HH                        PIC 9(2).
           10  TIMER-END-MM                        PIC 9(2).
           10  TIMER-END-SS                        PIC 9(2).
           10  TIMER-END-DD                        PIC 9(2).
         05  TIMER-ELAPSED                         PIC 9(8).
         05  TIMER-ELAPSED-R REDEFINES TIMER-ELAPSED
                                                   PIC 9(6)V9(2).
         05  TIMER-RUN-TIME.
           10  FILLER                              PIC X(17)
               VALUE 'Elaped run time: '.
           10  TIMER-RUN-TIME-ELAPSED              PIC Z(5)9.99.
           10  FILLER                              PIC X(8)
               VALUE ' seconds'.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
