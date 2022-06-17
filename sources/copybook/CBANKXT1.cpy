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
      * CBANKXT1.CPY                                                  *
      *---------------------------------------------------------------*
      * This is the record file record layout used to extract data    *
      * from the bank file to produce statements.                     *
      *****************************************************************
       01  BANKXT01-REC0.
         10  BANKXT01-0-TYPE                       PIC X(1).
         10  BANKXT01-0-PID                        PIC X(5).
         10  BANKXT01-0-NAME                       PIC X(25).
         10  BANKXT01-0-EMAIL                      PIC X(30).
         10  BANKXT01-0-FILLER                     PIC X(5).
       01  BANKXT01-REC1.
         10  BANKXT01-1-TYPE                       PIC X(1).
         10  BANKXT01-1-PID                        PIC X(5).
         10  BANKXT01-1-NAME                       PIC X(25).
         10  BANKXT01-1-ADDR1                      PIC X(25).
         10  BANKXT01-1-ADDR2                      PIC X(25).
         10  BANKXT01-1-STATE                      PIC X(2).
         10  BANKXT01-1-CNTRY                      PIC X(6).
         10  BANKXT01-1-PST-CDE                    PIC X(6).
       01  BANKXT01-REC2.
         10  BANKXT01-2-TYPE                       PIC X(1).
         10  BANKXT01-2-PID                        PIC X(5).
         10  BANKXT01-2-ACC-NO                     PIC X(9).
         10  BANKXT01-2-ACC-DESC                   PIC X(15).
         10  BANKXT01-2-ACC-CURR-BAL               PIC S9(7)V99 COMP-3.
         10  BANKXT01-2-ACC-LAST-STMT-DTE          PIC X(26).
         10  BANKXT01-2-ACC-LAST-STMT-BAL          PIC S9(7)V99 COMP-3.
       01  BANKXT01-REC3.
         10  BANKXT01-3-TYPE                       PIC X(1).
         10  BANKXT01-3-PID                        PIC X(5).
         10  BANKXT01-3-ACC-NO                     PIC X(9).
         10  BANKXT01-3-TIMESTAMP                  PIC X(26).
         10  BANKXT01-3-AMOUNT                     PIC S9(7)V99 COMP-3.
         10  BANKXT01-3-DESC                       PIC X(30).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
