//MFIDEMO  JOB MFIDEMO,MFIDEMO,CLASS=1,MSGCLASS=O,NOTIFY=MFIDEMO
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
//* ******************************************************************
//* ZBNKBAT1.JCL
//* ******************************************************************
//EXTRACT  EXEC YBATTSO
//*TSO.SYSTSIN DD DSN=MFI01.MFIDEMO.CTLCARDS(KBNKTSO1),DISP=SHR
//TSO.SYSTSIN DD *
 DSN SYSTEM(DB10)
     RUN PROGRAM(ZBNKEXT1) +
         PLAN(MYPLAN) +
         LIB('MFI01.MFIDEMO.LOADLIB') +
         PARMS('ALL')
 END
//EXTRACT  DD DSN=MFI01.MFIDEMO.BANKEXT1(+1),DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,LRECL=99,BLKSIZE=990),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//* ******************************************************************
//SORT     EXEC PGM=SORT
//EXITLIB  DD DSN=MFI01.MFIDEMO.LOADLIB,DISP=SHR
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=MFI01.MFIDEMO.BANKEXT1(+1),DISP=SHR
//SORTOUT  DD DSN=MFI01.MFIDEMO.BANKSRT1(+1),DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,LRECL=99,BLKSIZE=990),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SYSIN    DD DSN=MFI01.MFIDEMO.CTLCARDS(KBNKSRT1),DISP=SHR
//* ******************************************************************
//PRINT    EXEC YBNKPRT1,GEN='+1',PRM='HELLO WORLD'
//*RINT    EXEC YBNKPRT1,GEN='+1',PRM='EMAIL'
//*
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm
