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
      *
      ***************************************************************** 
      * CBANKSDT.CPY                                                  * 
      *---------------------------------------------------------------* 
      * Define SQL areas to access bank DeTails view                  * 
      ***************************************************************** 
           EXEC SQL DECLARE USERID.VBNKDETS TABLE                       
           (                                                            
              VPID                           CHAR (5)                   
                                             NOT NULL,                  
              VNAME                          CHAR (25)                  
                                             NOT NULL,                  
              VADDR1                         CHAR (25)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VADDR2                         CHAR (25)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VSTATE                         CHAR (2)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VCNTRY                         CHAR (6)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VPSTCDE                        CHAR (6)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VEMAIL                         CHAR (30)                  
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VACCNO                         CHAR (9)                   
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VDESC                          CHAR (15)                  
                                             NOT NULL,                  
              VCURRBAL                       DECIMAL (9, 2)             
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VLASTSTMTDTE                   DATE                       
                                             NOT NULL                   
                                             WITH DEFAULT,              
              VLASTSTMTBAL                   DECIMAL (9, 2)             
                                             NOT NULL                   
                                             WITH DEFAULT               
           )                                                            
           END-EXEC.                                                    
                                                                        
                                                                        
       01  DCLVBNKDETS.                                                 
           03 VPID                           PIC X(5).                  
           03 VNAME                          PIC X(25).                 
           03 VADDR1                         PIC X(25).                 
           03 VADDR2                         PIC X(25).                 
           03 VSTATE                         PIC X(2).                  
           03 VCNTRY                         PIC X(6).                  
           03 VPSTCDE                        PIC X(6).                  
           03 VEMAIL                         PIC X(30).                 
           03 VACCNO                         PIC X(9).                  
           03 VDESC                          PIC X(15).                 
           03 VCURRBAL                       PIC S9(7)V9(2) COMP-3.     
           03 VLASTSTMTDTE                   PIC X(10).                 
           03 VLASTSTMTBAL                   PIC S9(7)V9(2) COMP-3.     
                                                                        
      * $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     
