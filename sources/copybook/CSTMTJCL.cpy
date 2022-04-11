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
      * CSTMTJCL.CPY                                                  *
      *---------------------------------------------------------------*
      * This is JCL to print statements from VSAM data                *
      *****************************************************************
       01  WS-JCL-CARD-COUNT                       PIC 9(3).
       01  WS-JCL-CARDS.
         05  WS-JCL-CARD01                         PIC X(80)
             VALUE '//MFIDEMO  JOB MFIDEMO,MFIDEMO,CLASS=A,'.
         05  WS-JCL-CARD02                         PIC X(80)
             VALUE '//  MSGCLASS=A,MSGLEVEL=(1,1)          '.
         05  WS-JCL-CARD03                         PIC X(80)
             VALUE '//* USER=DUMMY,PASSWORD=DUMMY           '.
         05  WS-JCL-CARD04                         PIC X(80)
             VALUE '//* NOTIFY=DUMMY                        '.
         05  WS-JCL-CARD05                         PIC X(80)
             VALUE '//EXTRACT  EXEC YBNKEXTV,               '.
         05  WS-JCL-CARD-06                        PIC X(80)
             VALUE '//  REQUEST=%%%%%                       '.
         05  WS-JCL-CARD07                         PIC X(80)
             VALUE '//EXTRACT.SYSOUT DD DUMMY               '.
         05  WS-JCL-CARD08                         PIC X(80)
             VALUE '//SORT     EXEC YBNKSRT1,GEN=''+1''     '.
         05  WS-JCL-CARD09                         PIC X(80)
             VALUE '//SORT.SYSOUT DD DUMMY                  '.
         05  WS-JCL-CARD10                         PIC X(80)
             VALUE '//PRINT    EXEC YBNKPRT1,GEN=''+1''     '.
         05  WS-JCL-CARD11                         PIC X(80)
             VALUE '//                                      '.
         05  WS-JCL-CARD12                         PIC X(80)
             VALUE '/*EOF                                   '.
       01  WS-JCL-CARD-TABLE REDEFINES WS-JCL-CARDS.
         05  WS-JCL-CARD                           PIC X(80)
             OCCURS 12 TIMES.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
