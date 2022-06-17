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
      * CBANKSAT.CPY                                                  * 
      *---------------------------------------------------------------* 
      * Define SQL areas to access Account Type (Descriptions)        * 
      ***************************************************************** 
           EXEC SQL DECLARE USERID.BNKATYP TABLE                        
           (                                                            
              BAT_TYPE                       CHAR (1)                   
                                             NOT NULL,                  
              BAT_DESC                       CHAR (15)                  
                                             NOT NULL,                  
              BAT_FILLER                     CHAR (84)                  
                                             NOT NULL                   
           )                                                            
           END-EXEC.                                                    
                                                                        
       01  DCLATYP.                                                     
           03 DCL-BAT-TYPE                   PIC X(1).                  
           03 DCL-BAT-DESC                   PIC X(15).                 
           03 DCL-BAT-FILLER                 PIC X(84).                 
                                                                        
      * $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     
