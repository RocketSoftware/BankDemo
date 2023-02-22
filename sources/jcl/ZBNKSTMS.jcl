//MFIDEMO  JOB MFIDEMO,MFIDEMO,CLASS=A,MSGCLASS=A,MSGLEVEL=(2,0),
//* ******************************************************************
//*
//* Copyright (C) 2010-2021 Micro Focus.  All Rights Reserved
//* This software may be used, modified, and distributed
//* (provided this notice is included without modification)
//* solely for internal demonstration purposes with other
//* Micro Focus software, and is otherwise subject to the EULA at
//* https://www.microfocus.com/en-us/legal/software-licensing.
//*
//* THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED
//* WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF
//* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,
//* SHALL NOT APPLY.
//* TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL
//* MICRO FOCUS HAVE ANY LIABILITY WHATSOEVER IN CONNECTION
//* WITH THIS SOFTWARE.
//*
//* ******************************************************************
//  NOTIFY=MFIDEMO
//EXTRACT  EXEC YBATTSO
//TSO.SYSTSIN DD DSN=MFI01.MFIDEMO.CTLCARDS(KBNKTSO1),DISP=SHR 
//SYSOUT   DD SYSOUT=*                                             
//SYSPRINT DD SYSOUT=*                                             
//EXTRACT  DD DSN=MFI01.MFIDEMO.BANKEXT1(+1),                      
//            DISP=(NEW,CATLG,DELETE),                                   
//            DCB=(RECFM=VB,LRECL=99,BLKSIZE=990),                     
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)  
//*
//SORT     EXEC YBNKSRT1,GEN='+1'
//*
//PRINT    EXEC YBNKPRT1,GEN='+1',SOUT=A
//*
//* *** $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
