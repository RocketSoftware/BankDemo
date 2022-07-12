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
      * CBANKSSP.CPY                                                  * 
      *---------------------------------------------------------------* 
      * Define SQL areas to access SPA table                          * 
      ***************************************************************** 
           EXEC SQL DECLARE USERID.BNKSPA TABLE                         
           (                                                            
              BSP_TERM                       CHAR (8)                   
                                             NOT NULL,                  
              BSP_SPA_DATA                   VARCHAR (6144)             
                                             NOT NULL                   
           )                                                            
           END-EXEC.                                                    
                                                                        
       01  DCLSPA.                                                      
           03 DCL-BSP-TERM                   PIC X(8).                  
           03 DCL-BSP-SPA-DATA.                                         
             49 DCL-BSP-SPA-DATA-LEN         PIC S9(4) COMP.            
             49 DCL-BSP-SPA-DATA-DATA        PIC X(6144).               
                                                                        
      * $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     
