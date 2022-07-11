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
      * Simulate SQL TIMESTAMP function
      *****************************************************************
           ACCEPT WS-ACCEPT-DATE FROM DATE YYYYMMDD.
           ACCEPT WS-ACCEPT-TIME FROM TIME.
           MOVE WS-ACCEPT-DATE (1:4) TO WS-TS-DATE-YYYY.
           MOVE '-' TO WS-TS-DATE-DASH1.
           MOVE WS-ACCEPT-DATE (5:2) TO WS-TS-DATE-MM.
           MOVE '-' TO WS-TS-DATE-DASH2.
           MOVE WS-ACCEPT-DATE (7:2) TO WS-TS-DATE-DD.
           MOVE '-' TO WS-TS-DATE-DASH3.
           MOVE WS-ACCEPT-TIME (1:2) TO WS-TS-TIME-HH.
           MOVE '.' TO WS-TS-TIME-DOT1.
           MOVE WS-ACCEPT-TIME (3:2) TO WS-TS-TIME-MM.
           MOVE '.' TO WS-TS-TIME-DOT2.
           MOVE WS-ACCEPT-TIME (5:2) TO WS-TS-TIME-SS.
           MOVE '.' TO WS-TS-TIME-DOT3.
           MOVE WS-ACCEPT-TIME (7:2) TO WS-TS-TIME-DDDDDD (1:2).
           MOVE '0000' TO WS-TS-TIME-DDDDDD (3:4).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
