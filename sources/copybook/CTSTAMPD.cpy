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
      * CTSTAMPD.CPY                                                  *
      *---------------------------------------------------------------*
      * Work areas for timestamp creation                             *
      *****************************************************************
       01  WS-TIMESTAMP-AREAS.
         05  WS-ACCEPT-DATE                        PIC 9(8).
         05  WS-ACCEPT-TIME                        PIC 9(8).
         05  WS-TIMESTAMP.
           10  WS-TS-DATE.
             15  WS-TS-DATE-YYYY                   PIC X(4).
             15  WS-TS-DATE-DASH1                  PIC X(1).
             15  WS-TS-DATE-MM                     PIC X(2).
             15  WS-TS-DATE-DASH2                  PIC X(1).
             15  WS-TS-DATE-DD                     PIC X(2).
             15  WS-TS-DATE-DASH3                  PIC X(1).
           10  WS-TS-TIME.
             15  WS-TS-TIME-HH                     PIC X(2).
             15  WS-TS-TIME-DOT1                   PIC X(1).
             15  WS-TS-TIME-MM                     PIC X(2).
             15  WS-TS-TIME-DOT2                   PIC X(1).
             15  WS-TS-TIME-SS                     PIC X(2).
             15  WS-TS-TIME-DOT3                   PIC X(1).
             15  WS-TS-TIME-DDDDDD                 PIC X(6).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
