//MFIDEMO  JOB MFIDEMO,MFIDEMO,CLASS=A,MSGCLASS=A,NOTIFY=MFIDEMO
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
//* ZBNKPRT1.JCL
//* ******************************************************************
//PRINT    EXEC YBNKPRTZ,P1='H',P2='ELLO'
//*TEPLIB  DD DSN=MFI01.MFIDEMO.LOADLIB,DISP=SHR
//EXTRACT  DD DSN=MFI01.MFIDEMO.BANKSRT1(0),DISP=SHR
//PRINTOUT DD SYSOUT=*
//*RINTOUT DD DSN=ZBNKRT1.PRINTOUT,DISP=(NEW,CATLG),DCB=RECFM=FBA,
//* UNIT=SYSDA,SPACE=(TRK,(1,1))
//*
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm
