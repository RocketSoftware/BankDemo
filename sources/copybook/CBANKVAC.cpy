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
      * CBANKVAC.CPY       ACS-GE                                     *
      *---------------------------------------------------------------*
      * This is the record file record layout for bank account        *
      *****************************************************************
         05  BAC-RECORD                            PIC X(200).
         05  FILLER REDEFINES BAC-RECORD.
           10  BAC-REC-PID                         PIC X(5).
           10  BAC-REC-ACCNO                       PIC X(9).
           10  BAC-REC-TYPE                        PIC X(1).
           10  BAC-REC-BALANCE                     PIC S9(7)V99 COMP-3.
           10  BAC-REC-LAST-STMT-DTE               PIC X(10).
           10  BAC-REC-LAST-STMT-BAL               PIC S9(7)V99 COMP-3.
           10  BAC-REC-ATM-ENABLED                 PIC X(2).
           10  BAC-REC-ATM-DAY-LIMIT               PIC S9(3)V COMP-3.
           10  BAC-REC-ATM-DAY-DTE                 PIC X(10).
           10  BAC-REC-ATM-DAY-AMT                 PIC S9(3)V COMP-3.
           10  BAC-REC-RP1-DAY                     PIC X(2).
           10  BAC-REC-RP1-AMOUNT                  PIC S9(5)V99 COMP-3.
           10  BAC-REC-RP1-PID                     PIC X(5).
           10  BAC-REC-RP1-ACCNO                   PIC X(9).
           10  BAC-REC-RP1-LAST-PAY                PIC X(10).
           10  BAC-REC-RP2-DAY                     PIC X(2).
           10  BAC-REC-RP2-AMOUNT                  PIC S9(5)V99 COMP-3.
           10  BAC-REC-RP2-PID                     PIC X(5).
           10  BAC-REC-RP2-ACCNO                   PIC X(9).
           10  BAC-REC-RP2-LAST-PAY                PIC X(10).
           10  BAC-REC-RP3-DAY                     PIC X(2).
           10  BAC-REC-RP3-AMOUNT                  PIC S9(5)V99 COMP-3.
           10  BAC-REC-RP3-PID                     PIC X(5).
           10  BAC-REC-RP3-ACCNO                   PIC X(9).
           10  BAC-REC-RP3-LAST-PAY                PIC X(10).
           10  BAC-REC-FILLER                      PIC X(59).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
