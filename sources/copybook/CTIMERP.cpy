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
      * CTIMERP.CPY                                                   *
      *---------------------------------------------------------------*
      * Procedure code to calculate & display run time                *
      *****************************************************************
      *****************************************************************
      * Establish program run time                                    *
      *****************************************************************
       RUN-TIME.
           IF TIMER-START IS EQUAL TO ZERO
              ACCEPT TIMER-START FROM TIME
              MOVE 'Timer started' TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           ELSE
              ACCEPT TIMER-END FROM TIME
              MOVE 'Timer stopped' TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
              COMPUTE TIMER-ELAPSED =
                        ((TIMER-END-HH * 60 * 60 * 100) +
                         (TIMER-END-MM * 60 * 100) +
                         (TIMER-END-SS * 100) +
                          TIMER-END-DD) -
                        ((TIMER-START-HH * 60 * 60 * 100) +
                         (TIMER-START-MM * 60 * 100) +
                         (TIMER-START-SS * 100) +
                          TIMER-START-DD)
              MOVE TIMER-ELAPSED-R TO TIMER-RUN-TIME-ELAPSED
              MOVE TIMER-RUN-TIME TO WS-CONSOLE-MESSAGE
              PERFORM DISPLAY-CONSOLE-MESSAGE
           END-IF.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
