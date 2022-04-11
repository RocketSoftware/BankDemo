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
      * CBANKSTX.CPY                                                  * 
      *---------------------------------------------------------------* 
      * Define SQL areas to access bank Transaction table             * 
      ***************************************************************** 
           EXEC SQL DECLARE USERID.BNKTXN TABLE                         
           (                                                            
              BTX_PID                        CHAR (5)                   
                                             NOT NULL,                  
              BTX_TYPE                       CHAR (1)                   
                                             NOT NULL,                  
              BTX_SUB_TYPE                   CHAR (1)                   
                                             NOT NULL,                  
              BTX_ACCNO                      CHAR (9)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BXT_TIMESTAMP                  TIMESTAMP                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BTX_TIMESTAMP_FF               CHAR (26)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BTX_AMOUNT                     DECIMAL (9,2)              
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BTX_DATA_OLD                   CHAR (150)                 
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BTX_DATA_NEW                   CHAR (150)                 
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BTX_FILLER                     CHAR (27)                  
                                             NOT NULL                   
                                             WITH DEFAULT               
           )                                                            
           END-EXEC.                                                    
                                                                        
       01  DCLTXN.                                                      
           03 DCL-BTX-PID                    PIC X(5).                  
           03 DCL-BTX-TYPE                   PIC X(1).                  
           03 DCL-BTX-SUB-TYPE               PIC X(1).                  
           03 DCL-BTX-ACCNO                  PIC X(9).                  
           03 DCL-BTX-TIMESTAMP              PIC X(26).                 
           03 DCL-BTX-TIMESTAMP-FF           PIC X(26).                 
           03 DCL-BTX-AMOUNT                 PIC S9(7)V99 COMP-3.       
           03 DCL-BTX-DATA-OLD               PIC X(150).                
           03 DCL-BTX-DATA-NEW               PIC X(150).                
           03 DCL-BTX-FILLER                 PIC X(27).                 
                                                                        
       01  DCLTXN-NULL.                                                 
           03 DCL-BTX-ACCNO-NULL             PIC S9(4) COMP.            
                                                                        
      * $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     
