//MFIDEMO  JOB MFIDEMO,MFIDEMO,CLASS=1,MSGCLASS=A,NOTIFY=MFIDEMO
//* ******************************************************************
//*
//* Copyright 2010 – 2024 Rocket Software, Inc. or its affiliates.
//* This software may be used, modified, and distributed
//* (provided this notice is included without modification)
//* solely for internal demonstration purposes with other
//* Rocket products, and is otherwise subject to the EULA at
//* https://www.rocketsoftware.com/company/trust/agreements. 
//*
//* THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED
//* WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF
//* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,
//* SHALL NOT APPLY.
//* TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL
//* ROCKET SOFTWARE HAVE ANY LIABILITY WHATSOEVER IN CONNECTION
//* WITH THIS SOFTWARE.
//*
//* ******************************************************************
//* ******************************************************************
//* ZBNKEXT1.JCL
//* ******************************************************************
//BATCHTSO EXEC YBATTSO
//TSO.SYSTSIN DD DSN=MFI01.MFIDEMO.CTLCARDS(KBNKTSO1),DISP=SHR
//EXTRACT  DD DSN=MFI01.MFIDEMO.BANKEXT1(+1),DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,LRECL=99,BLKSIZE=990),
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)
//*
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm
