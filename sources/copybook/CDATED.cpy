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
      * CDATED.CPY                                                    *
      *---------------------------------------------------------------*
      * Area used to pass data to/from date conversion routine        *
      *****************************************************************
         05  DD-AREAS.
           10  DD-ENV                              PIC X(4).
             88  DD-ENV-NULL                       VALUE LOW-VALUES.
             88  DD-ENV-CICS                       VALUE 'CICS'.
             88  DD-ENV-IMS                        VALUE 'IMS'.
             88  DD-ENV-INET                       VALUE 'INET'.
           10  DD-TIME-AREAS.
             15  DD-TIME-INPUT                     PIC X(7).
             15  DD-TIME-INPUT-N REDEFINES DD-TIME-INPUT
                                                   PIC 9(7).
             15  DD-TIME-OUTPUT.
               20  DD-TIME-OUTPUT-HH               PIC X(2).
               20  DD-TIME-OUTPUT-SEP1             PIC X(1).
               20  DD-TIME-OUTPUT-MM               PIC X(2).
               20  DD-TIME-OUTPUT-SEP2             PIC X(1).
               20  DD-TIME-OUTPUT-SS               PIC X(2).
           10  DD-DATE-AREAS.
             15  DD-INPUT.
               20  DDI-TYPE                        PIC X(1).
                 88  DDI-ISO                       VALUE '0'.
                 88  DDI-YYYYMMDD                  VALUE '1'.
                 88  DDI-YYMMDD                    VALUE '2'.
                 88  DDI-YYDDD                     VALUE '3'.
               20  DDI-DATA                        PIC X(20).
               20  DDI-DATA-ISO REDEFINES DDI-DATA.
                 25  DDI-DATA-ISO-YYYY             PIC X(4).
                 25  DDI-DATA-ISO-YYYY-N REDEFINES
                     DDI-DATA-ISO-YYYY             PIC 9(4).
                 25  DDI-DATA-ISO-DASH1            PIC X(1).
                 25  DDI-DATA-ISO-MM               PIC X(2).
                 25  DDI-DATA-ISO-MM-N REDEFINES
                     DDI-DATA-ISO-MM               PIC 9(2).
                 25  DDI-DATA-ISO-DASH2            PIC X(1).
                 25  DDI-DATA-ISO-DD               PIC X(2).
                 25  DDI-DATA-ISO-DD-N REDEFINES
                     DDI-DATA-ISO-DD               PIC 9(2).
               20  DDI-DATA-YYYYMMDD REDEFINES DDI-DATA.
                 25  DDI-DATA-YYYYMMDD-YYYY        PIC X(4).
                 25  DDI-DATA-YYYYMMDD-YYYY-N REDEFINES
                     DDI-DATA-YYYYMMDD-YYYY        PIC 9(4).
                 25  DDI-DATA-YYYYMMDD-MM          PIC X(2).
                 25  DDI-DATA-YYYYMMDD-MM-N REDEFINES
                     DDI-DATA-YYYYMMDD-MM          PIC 9(2).
                 25  DDI-DATA-YYYYMMDD-DD          PIC X(2).
                 25  DDI-DATA-YYYYMMDD-DD-N REDEFINES
                     DDI-DATA-YYYYMMDD-DD          PIC 9(2).
               20  DDI-DATA-YYMMDD REDEFINES DDI-DATA.
                 25  DDI-DATA-YYMMDD-YY            PIC X(2).
                 25  DDI-DATA-YYMMDD-YY-N REDEFINES
                     DDI-DATA-YYMMDD-YY            PIC 9(2).
                 25  DDI-DATA-YYMMDD-MM            PIC X(2).
                 25  DDI-DATA-YYMMDD-MM-N REDEFINES
                     DDI-DATA-YYMMDD-MM            PIC 9(2).
                 25  DDI-DATA-YYMMDD-DD            PIC X(2).
                 25  DDI-DATA-YYMMDD-DD-N REDEFINES
                     DDI-DATA-YYMMDD-DD            PIC 9(2).
               20  DDI-DATA-YYDDD REDEFINES DDI-DATA.
                 25  DDI-DATA-YYDDD-YYDDD          PIC X(5).
                 25  DDI-DATA-YYDDD-YYDDD-N REDEFINES
                     DDI-DATA-YYDDD-YYDDD          PIC 9(5).
                 25  DDI-DATA-YYDDD-YYDDD-SPLIT REDEFINES
                     DDI-DATA-YYDDD-YYDDD.
                   30  DDI-DATA-YYDDD-YY           PIC X(2).
                   30  DDI-DATA-YYDDD-YY-N REDEFINES
                       DDI-DATA-YYDDD-YY           PIC 9(2).
                   30  DDI-DATA-YYDDD-DDD          PIC X(3).
                   30  DDI-DATA-YYDDD-DDD-N REDEFINES
                       DDI-DATA-YYDDD-DDD          PIC 9(3).

             15  DD-OUTPUT.
               20  DDO-TYPE                        PIC X(1).
                 88  DDO-DD-MMM-YY                 VALUE '1'.
                 88  DDO-DD-MMM-YYYY               VALUE '2'.
               20  DDO-DATA                        PIC X(20).
               20  DDO-DATA-DD-MMM-YY REDEFINES DDO-DATA.
                 25  DDO-DATA-DD-MMM-YY-DD         PIC X(2).
                 25  DDO-DATA-DD-MMM-YY-DOT1       PIC X(1).
                 25  DDO-DATA-DD-MMM-YY-MMM        PIC X(3).
                 25  DDO-DATA-DD-MMM-YY-DOT2       PIC X(1).
                 25  DDO-DATA-DD-MMM-YY-YY         PIC X(2).
               20  DDO-DATA-DD-MMM-YYYY REDEFINES DDO-DATA.
                 25  DDO-DATA-DD-MMM-YYYY-DD       PIC X(2).
                 25  DDO-DATA-DD-MMM-YYYY-DOT1     PIC X(1).
                 25  DDO-DATA-DD-MMM-YYYY-MMM      PIC X(3).
                 25  DDO-DATA-DD-MMM-YYYY-DOT2     PIC X(1).
                 25  DDO-DATA-DD-MMM-YYYY-YYYY     PIC X(4).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
