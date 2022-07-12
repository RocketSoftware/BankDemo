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
      * CBANKD10.CPY                                                  * 
      *---------------------------------------------------------------* 
      * This area is used to pass data between a requesting program   * 
      * and the I/O program (DBANK10P) which retrieves or updates     * 
      * address information.                                          * 
      ***************************************************************** 
         05  CD10-DATA.                                                 
           10  CD10I-DATA.                                              
             15  CD10I-FUNCTION                    PIC X(1).            
               88  CD10I-DELETE                    VALUE 'D'.           
               88  CD10I-READ                      VALUE 'R'.           
               88  CD10I-WRITE                     VALUE 'W'.           
             15  CD10I-TERM                        PIC X(8).            
             15  CD10I-SPA-DATA                    PIC X(6144).         
           10  CD10O-DATA.                                              
             15  CD10O-RESULT                      PIC X(1).            
               88  CD10O-RESULT-OK                 VALUE '0'.           
               88  CD10O-RESULT-NOT-FOUND          VALUE '1'.           
               88  CD10O-RESULT-FAILED             VALUE '2'.           
             15  CD10O-SPA-DATA                    PIC X(6144).         
                                                                        
      * $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     
