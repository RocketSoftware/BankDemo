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
      * CBANKVAT.CPY                                                  *
      *---------------------------------------------------------------*
      * This is the record file record layout for bank account type   *
      *****************************************************************
         05  BAT-RECORD                            PIC X(100).
         05  FILLER REDEFINES BAT-RECORD.
           10  BAT-REC-TYPE                        PIC X(1).
           10  BAT-REC-DESC                        PIC X(15).
           10  BAT-REC-FILLER                      PIC X(84).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
