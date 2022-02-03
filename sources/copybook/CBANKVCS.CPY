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
      * CBANKVCS.CPY                                                  *
      *---------------------------------------------------------------*
      * This is the record file record layout for bank customers      *
      *****************************************************************
         05  BCS-RECORD                            PIC X(250).
         05  FILLER REDEFINES BCS-RECORD.
           10  BCS-REC-PID                         PIC X(5).
           10  BCS-REC-NAME                        PIC X(25).
           10  BCS-REC-NAME-FF                     PIC X(25).
           10  BCS-REC-SIN                         PIC X(9).
           10  BCS-REC-ADDR1                       PIC X(25).
           10  BCS-REC-ADDR2                       PIC X(25).
           10  BCS-REC-STATE                       PIC X(2).
           10  BCS-REC-CNTRY                       PIC X(6).
           10  BCS-REC-POST-CODE                   PIC X(6).
           10  BCS-REC-TEL                         PIC X(12).
           10  BCS-REC-EMAIL                       PIC X(30).
           10  BCS-REC-SEND-MAIL                   PIC X(1).
           10  BCS-REC-SEND-EMAIL                  PIC X(1).
           10  BCS-REC-ATM-PIN                     PIC X(4).
           10  BCS-REC-FILLER                      PIC X(74).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
