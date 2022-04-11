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
      * CHELPVSM.CPY                                                  *
      *---------------------------------------------------------------*
      * This is the record file record layout for help records        *
      *****************************************************************
         05  HLP-RECORD                            PIC X(83).
         05  FILLER REDEFINES HLP-RECORD.
           10  HLP-KEY.
             15  HLP-SCRN                          PIC X(6).
             15  HLP-LINE                          PIC X(2).
           10  HLP-TEXT                            PIC X(75).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
