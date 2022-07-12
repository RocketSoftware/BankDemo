      ******************************************************************
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
      * CBANKSAC.CPY                                                  * 
      *---------------------------------------------------------------* 
      * Define SQL areas to access Bank ACcount table                 * 
      ***************************************************************** 
           EXEC SQL DECLARE USERID.BNKACC TABLE                         
           (                                                            
              BAC_PID                        CHAR (5)                   
                                             NOT NULL,                  
              BAC_ACCNO                      CHAR (9)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_ACCTYPE                    CHAR (1)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_BALANCE                    DECIMAL (9, 2)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_LAST_STMT_DTE              DATE                       
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_LAST_STMT_BAL              DECIMAL (9, 2)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_ATM_ENABLED                CHAR (2)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_ATM_DAY_LIMIT              DECIMAL (3, 0)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_ATM_DAY_DTE                DATE                       
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_ATM_DAY_AMT                DECIMAL (3, 0)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP1_DAY                    CHAR (2)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP1_AMOUNT                 DECIMAL (7, 2)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP1_PID                    CHAR (5)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP1_ACCNO                  CHAR (9)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP1_LAST_PAY               DATE                       
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP2_DAY                    CHAR (2)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP2_AMOUNT                 DECIMAL (7, 2)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP2_PID                    CHAR (5)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP2_ACCNO                  CHAR (9)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP2_LAST_PAY               DATE                       
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP3_DAY                    CHAR (2)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP3_AMOUNT                 DECIMAL (7, 2)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP3_PID                    CHAR (5)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP3_ACCNO                  CHAR (9)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_RP3_LAST_PAY               DATE                       
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BAC_FILLER                     CHAR (59)                  
                                             NOT NULL                   
                                             WITH DEFAULT               
           )                                                            
           END-EXEC
           .                                                            
                                                                        
       01  DCLACC
           .                                                            
           03 DCL-BAC-PID                    PIC X(5)
           .                                                            
           03 DCL-BAC-ACCNO                  PIC X(9)
           .                                                            
           03 DCL-BAC-ACCTYPE                PIC X
           .                                                            
           03 DCL-BAC-BALANCE                PIC S9(7)V9(2) COMP-3
           .                                                            
           03 DCL-BAC-LAST-STMT-DTE          PIC X(10)
           .                                                            
           03 DCL-BAC-LAST-STMT-BAL          PIC S9(7)V9(2) COMP-3
           .                                                            
           03 DCL-BAC-ATM-ENABLED            PIC X(2)
           .                                                            
           03 DCL-BAC-ATM-DAY-LIMIT          PIC S9(3)V COMP-3
           .                                                            
           03 DCL-BAC-ATM-DAY-DTE            PIC X(10)
           .                                                            
           03 DCL-BAC-ATM-DAY-AMT            PIC S9(3)V COMP-3
           .                                                            
           03 DCL-BAC-RP1-DAY                PIC X(2)
           .                                                            
           03 DCL-BAC-RP1-AMOUNT             PIC S9(5)V9(2) COMP-3
           .                                                            
           03 DCL-BAC-RP1-PID                PIC X(5)
           .                                                            
           03 DCL-BAC-RP1-ACCNO              PIC X(9)
           .                                                            
           03 DCL-BAC-RP1-LAST-PAY           PIC X(10)
           .                                                            
           03 DCL-BAC-RP2-DAY                PIC X(2)
           .                                                            
           03 DCL-BAC-RP2-AMOUNT             PIC S9(5)V9(2) COMP-3
           .                                                            
           03 DCL-BAC-RP2-PID                PIC X(5)
           .                                                            
           03 DCL-BAC-RP2-ACCNO              PIC X(9)
           .                                                            
           03 DCL-BAC-RP2-LAST-PAY           PIC X(10)
           .                                                            
           03 DCL-BAC-RP3-DAY                PIC X(2)
           .                                                            
           03 DCL-BAC-RP3-AMOUNT             PIC S9(5)V9(2) COMP-3
           .                                                            
           03 DCL-BAC-RP3-PID                PIC X(5)
           .                                                            
           03 DCL-BAC-RP3-ACCNO              PIC X(9)
           .                                                            
           03 DCL-BAC-RP3-LAST-PAY           PIC X(10)
           .                                                            
           03 DCL-BAC-FILLER                 PIC X(59)
           .                                                            
                                                                        
      * $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     
