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
      * CHELPD01.CPY                                                  *
      *---------------------------------------------------------------*
      * This area is used to pass data between a requesting program   *
      * and the I/O program (DHELP01P) which retrieves screen help    *
      * information.                                                  *
      *****************************************************************
         05  HELP01-DATA.
           10  HELPO1I-DATA.
             15  HELP01I-SCRN                      PIC X(6).
           10  HELP01O-DATA.
             15  HELP01O-SCRN                      PIC X(6).
             15  HELP01O-FOUND                     PIC X(1).
               88 HELP-FOUND                       VALUE 'Y'.
               88 HELP-NOT-FOUND                   VALUE 'N'.
             15  HELP01O-INDIVIDUAL-LINES.
               20  HELP01O-L01                     PIC X(75).
               20  HELP01O-L02                     PIC X(75).
               20  HELP01O-L03                     PIC X(75).
               20  HELP01O-L04                     PIC X(75).
               20  HELP01O-L05                     PIC X(75).
               20  HELP01O-L06                     PIC X(75).
               20  HELP01O-L07                     PIC X(75).
               20  HELP01O-L08                     PIC X(75).
               20  HELP01O-L09                     PIC X(75).
               20  HELP01O-L10                     PIC X(75).
               20  HELP01O-L11                     PIC X(75).
               20  HELP01O-L12                     PIC X(75).
               20  HELP01O-L13                     PIC X(75).
               20  HELP01O-L14                     PIC X(75).
               20  HELP01O-L15                     PIC X(75).
               20  HELP01O-L16                     PIC X(75).
               20  HELP01O-L17                     PIC X(75).
               20  HELP01O-L18                     PIC X(75).
               20  HELP01O-L19                     PIC X(75).
             15  FILLER REDEFINES HELP01O-INDIVIDUAL-LINES.
               20  HELP01O-LINE                    PIC X(75)
                   OCCURS 19 TIMES.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
