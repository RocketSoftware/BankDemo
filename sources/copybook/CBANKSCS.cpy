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
      * CBANKSCS.CPY                                                  * 
      *---------------------------------------------------------------* 
      * Define SQL areas to access CuStomer table                     * 
      ***************************************************************** 
           EXEC SQL DECLARE USERID.BNKCUST TABLE                        
           (                                                            
              BCS_PID                        CHAR (5)                   
                                             NOT NULL,                  
              BCS_NAME                       CHAR (25)                  
                                             NOT NULL,                  
              BCS_NAME_FF                    CHAR (25)                  
                                             NOT NULL,                  
              BCS_SIN                        CHAR (9)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_ADDR1                      CHAR (25)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_ADDR2                      CHAR (25)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_STATE                      CHAR (2)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_COUNTRY                    CHAR (6)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_POST_CODE                  CHAR (6)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_TEL                        CHAR (12)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_EMAIL                      CHAR (30)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_SEND_MAIL                  CHAR (1)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_SEND_EMAIL                 CHAR (1)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_ATM_PIN                    CHAR (4)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_PRINTER1_NETNAME           CHAR (8)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_PRINTER2_NETNAME           CHAR (8)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              BCS_FILLER                     CHAR (58)                  
                                             NOT NULL                   
                                             WITH DEFAULT               
           )                                                            
           END-EXEC.                                                    
                                                                        
       01  DCLCUST.                                                     
           03 DCL-BCS-PID                    PIC X(5).                  
           03 DCL-BCS-NAME                   PIC X(25).                 
           03 DCL-BCS-NAME-FF                PIC X(25).                 
           03 DCL-BCS-SIN                    PIC X(9).                  
           03 DCL-BCS-ADDR1                  PIC X(25).                 
           03 DCL-BCS-ADDR2                  PIC X(25).                 
           03 DCL-BCS-STATE                  PIC X(2).                  
           03 DCL-BCS-COUNTRY                PIC X(6).                  
           03 DCL-BCS-POST-CODE              PIC X(6).                  
           03 DCL-BCS-TEL                    PIC X(12).                 
           03 DCL-BCS-EMAIL                  PIC X(30).                 
           03 DCL-BCS-SEND-MAIL              PIC X(1).                  
           03 DCL-BCS-SEND-EMAIL             PIC X(1).                  
           03 DCL-BCS-ATM-PIN                PIC X(4).                  
           03 DCL-BCS-PRINTER1               PIC X(8).                  
           03 DCL-BCS-PRINTER2               PIC X(8).                  
           03 DCL-BCS-FILLER                 PIC X(58).                 
                                                                        
      * $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     
