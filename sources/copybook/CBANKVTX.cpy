      *****************************************************************
      *                                                               *
      * Copyright 2010-2024 Rocket Software, Inc. or its affiliates.  *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Rocket products, and is otherwise subject to the EULA at      *
      * https://www.rocketsoftware.com/company/trust/agreements.      *
      *                                                               *
      * THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED             *
      * WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF               *
      * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,         *
      * SHALL NOT APPLY.                                              *
      * TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL              *
      * ROCKET SOFTWARE HAVE ANY LIABILITY WHATSOEVER IN CONNECTION   *
      * WITH THIS SOFTWARE.                                           *
      *                                                               *
      *****************************************************************

      *****************************************************************
      * CBANKVTX.CPY                                                  *
      *---------------------------------------------------------------*
      * This is the record file record layout for bank transactions   *
      *****************************************************************
         05  BTX-RECORD                            PIC X(400).
         05  FILLER REDEFINES BTX-RECORD.
           10  BTX-REC-PID                         PIC X(5).
           10  BTX-REC-TYPE                        PIC X(1).
           10  BTX-REC-SUB-TYPE                    PIC X(1).
           10  BTX-REC-ALTKEY1.
             15  BTX-REC-ACCNO                     PIC X(9).
             15  BTX-REC-TIMESTAMP                 PIC X(26).
           10  BTX-REC-TIMESTAMP-FF                PIC X(26).
           10  BTX-REC-AMOUNT                      PIC S9(7)V99 COMP-3.
           10  BTX-REC-DATA-OLD                    PIC X(150).
           10  BTX-REC-DATA-NEW                    PIC X(150).
           10  BTX-REC-FILLER                      PIC X(27).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
