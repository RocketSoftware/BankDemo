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
      * CD05DATA.CPY       *                                          *
      *---------------------------------------------------------------*
      * This area is used to pass data between the transaction list   *
      * display program and the I/O program (DBANK05P) which          *
      * retrieves the data requested (a series of transactions for a  *
      * specified account).                                           *
      *****************************************************************
         05  CD05-DATA.
           10  CD05I-DATA.
             15  CD05I-ACC                         PIC X(9).
             15  CD05I-START-ID                    PIC X(26).
             15  CD05I-START-ID-R REDEFINES CD05I-START-ID.
               20  CD05I-START-DATE                PIC X(10).
               20  CD05I-START-FILL1               PIC X(1).
               20  CD05I-START-TIME                PIC X(8).
               20  CD05I-START-FILL2               PIC X(1).
               20  CD05I-START-MICROSECS           PIC X(6).
             15  CD05I-SEARCH-CRITERIA             PIC X(5).
               88  CD05-START-EQUAL                VALUE 'ENTER'.
               88  CD05-START-LOW                  VALUE 'PFK07'.
               88  CD05-START-HIGH                 VALUE 'PFK08'.
           10  CD05O-DATA.
             15  CD05-DATA-STATUS                  PIC X(1).
               88  CD05-NO-DATA                    VALUE '0'.
               88  CD05-IS-DATA                    VALUE '1'.
               88  CD05-IS-MORE-DATA               VALUE '2'.
               88  CD05-NO-MORE-DATA               VALUE '3'.
             15  CD05O-TXN-DETAILS.
               20  CD05O-TXN1.
                 25  CD05O-ID1.
                   30  CD05O-DAT1                  PIC X(10).
                   30  CD05O-FIL1A                 PIC X(1).
                   30  CD05O-TIM1                  PIC X(8).
                   30  CD05O-FIL1B                 PIC X(1).
                   30  CD05O-FIL1C                 PIC X(6).
                 25  CD05O-AMT1                    PIC X(9).
                 25  CD05O-AMT1-N REDEFINES CD05O-AMT1
                                                   PIC S9(7)V99.
                 25  CD05O-DSC1                    PIC X(30).
               20  CD05O-TXN2.
                 25  CD05O-ID2.
                   30  CD05O-DAT2                  PIC X(10).
                   30  CD05O-FIL2A                 PIC X(1).
                   30  CD05O-TIM2                  PIC X(8).
                   30  CD05O-FIL2B                 PIC X(1).
                   30  CD05O-FIL2C                 PIC X(6).
                 25  CD05O-AMT2                    PIC X(9).
                 25  CD05O-AMT2-N REDEFINES CD05O-AMT2
                                                   PIC S9(7)V99.
                 25  CD05O-DSC2                    PIC X(30).
               20  CD05O-TXN3.
                 25  CD05O-ID3.
                   30  CD05O-DAT3                  PIC X(10).
                   30  CD05O-FIL3A                 PIC X(1).
                   30  CD05O-TIM3                  PIC X(8).
                   30  CD05O-FIL3B                 PIC X(1).
                   30  CD05O-FIL3C                 PIC X(6).
                 25  CD05O-AMT3                    PIC X(9).
                 25  CD05O-AMT3-N REDEFINES CD05O-AMT3
                                                   PIC S9(7)V99.
                 25  CD05O-DSC3                    PIC X(30).
               20  CD05O-TXN4.
                 25  CD05O-ID4.
                   30  CD05O-DAT4                  PIC X(10).
                   30  CD05O-FIL4A                 PIC X(1).
                   30  CD05O-TIM4                  PIC X(8).
                   30  CD05O-FIL4B                 PIC X(1).
                   30  CD05O-FIL4C                 PIC X(6).
                 25  CD05O-AMT4                    PIC X(9).
                 25  CD05O-AMT4-N REDEFINES CD05O-AMT4
                                                   PIC S9(7)V99.
                 25  CD05O-DSC4                    PIC X(30).
               20  CD05O-TXN5.
                 25  CD05O-ID5.
                   30  CD05O-DAT5                  PIC X(10).
                   30  CD05O-FIL5A                 PIC X(1).
                   30  CD05O-TIM5                  PIC X(8).
                   30  CD05O-FIL5B                 PIC X(1).
                   30  CD05O-FIL5C                 PIC X(6).
                 25  CD05O-AMT5                    PIC X(9).
                 25  CD05O-AMT5-N REDEFINES CD05O-AMT5
                                                   PIC S9(7)V99.
                 25  CD05O-DSC5                    PIC X(30).
               20  CD05O-TXN6.
                 25  CD05O-ID6.
                   30  CD05O-DAT6                  PIC X(10).
                   30  CD05O-FIL6A                 PIC X(1).
                   30  CD05O-TIM6                  PIC X(8).
                   30  CD05O-FIL6B                 PIC X(1).
                   30  CD05O-FIL6C                 PIC X(6).
                 25  CD05O-AMT6                    PIC X(9).
                 25  CD05O-AMT6-N REDEFINES CD05O-AMT6
                                                   PIC S9(7)V99.
                 25  CD05O-DSC6                    PIC X(30).
               20  CD05O-TXN7.
                 25  CD05O-ID7.
                   30  CD05O-DAT7                  PIC X(10).
                   30  CD05O-FIL7A                 PIC X(1).
                   30  CD05O-TIM7                  PIC X(8).
                   30  CD05O-FIL7B                 PIC X(1).
                   30  CD05O-FIL7C                 PIC X(6).
                 25  CD05O-AMT7                    PIC X(9).
                 25  CD05O-AMT7-N REDEFINES CD05O-AMT7
                                                   PIC S9(7)V99.
                 25  CD05O-DSC7                    PIC X(30).
               20  CD05O-TXN8.
                 25  CD05O-ID8.
                   30  CD05O-DAT8                  PIC X(10).
                   30  CD05O-FIL8A                 PIC X(1).
                   30  CD05O-TIM8                  PIC X(8).
                   30  CD05O-FIL8B                 PIC X(1).
                   30  CD05O-FIL8C                 PIC X(6).
                 25  CD05O-AMT8                    PIC X(9).
                 25  CD05O-AMT8-N REDEFINES CD05O-AMT8
                                                   PIC S9(7)V99.
                 25  CD05O-DSC8                    PIC X(30).
               20  CD05O-TXN9.
                 25  CD05O-ID9.
                   30  CD05O-DAT9                  PIC X(10).
                   30  CD05O-FIL9A                 PIC X(1).
                   30  CD05O-TIM9                  PIC X(8).
                   30  CD05O-FIL9B                 PIC X(1).
                   30  CD05O-FIL9C                 PIC X(6).
                 25  CD05O-AMT9                    PIC X(9).
                 25  CD05O-AMT9-N REDEFINES CD05O-AMT9
                                                   PIC S9(7)V99.
                 25  CD05O-DSC9                    PIC X(30).
             15  CD05O-TXN-DETAILS-R REDEFINES CD05O-TXN-DETAILS.
               20  CD05O-TXN-DATA OCCURS 9 TIMES.
                 25  CD05O-ID.
                   30  CD05O-DATE                  PIC X(10).
                   30  CD05O-FILLER1               PIC X(1).
                   30  CD05O-TIME                  PIC X(8).
                   30  CD05O-FILLER2               PIC X(1).
                   30  CD05O-MICROSEC              PIC X(6).
                 25  CD05O-AMT                     PIC X(9).
                 25  CD05O-AMT-N REDEFINES CD05O-AMT
                                                   PIC S9(7)V99.
                 25  CD05O-DESC                    PIC X(30).

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
