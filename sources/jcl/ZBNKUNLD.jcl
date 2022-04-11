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
//* ZBNKUNLD.JCL
//* ******************************************************************
//DEL      EXEC PGM=IEFBR14
//SBNKACC  DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKACC,
//            DISP=(MOD,DELETE,DELETE),
//            DCB=(RECFM=FB,LRECL=200,BLKSIZE=200),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKATYP DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKATYPE,
//            DISP=(MOD,DELETE,DELETE),
//            DCB=(RECFM=FB,LRECL=100,BLKSIZE=100),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKCUST DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKCUST,
//            DISP=(MOD,DELETE,DELETE),
//            DCB=(RECFM=FB,LRECL=250,BLKSIZE=250),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKTXN  DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKTXN,
//            DISP=(MOD,DELETE,DELETE),
//            DCB=(RECFM=FB,LRECL=400,BLKSIZE=400),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKHELP DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKHELP,
//            DISP=(MOD,DELETE,DELETE),
//            DCB=(RECFM=FB,LRECL=83,BLKSIZE=83),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//* ******************************************************************
//UNLOAD   EXEC PGM=IKJEFT01,DYNAMNBR=40,REGION=2M
//*UNLOAD EXEC PGM=ZBANKULP
//*TEPLIB  DD DSN=DB2.DSNLOAD,DISP=SHR
//DBRMLIB  DD DUMMY
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSOPT   DD SYSOUT=*
//SYSTSIN  DD *
  DSN SYSTEM(XDBD)
      RUN PROGRAM(ZBANKULP) +
          PLAN(MYPLAN) +
          LIB('MFI01.MFIDEMO.LOADLIB') +
          PARMS('PASSED')
  END
//SBNKACC  DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKACC,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=FB,LRECL=200,BLKSIZE=200),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKATYP DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKATYPE,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=FB,LRECL=100,BLKSIZE=100),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKCUST DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKCUST,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=FB,LRECL=250,BLKSIZE=250),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKTXN  DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKTXN,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=FB,LRECL=400,BLKSIZE=400),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//SBNKHELP DD DSN=MFI01.MFIDEMO.UNLOADED.SQL.BNKHELP,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=FB,LRECL=83,BLKSIZE=83),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//*
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm
