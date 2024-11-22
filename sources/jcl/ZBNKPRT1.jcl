//MFIDEMO  JOB MFIDEMO,MFIDEMO,CLASS=A,MSGCLASS=A,NOTIFY=MFIDEMO
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
//* ZBNKPRT1.JCL
//* ******************************************************************
//PRINT    EXEC PGM=ZBNKPRT1,PARM=''
//*STEPLIB  DD DSN=MFI01.MFIDEMO.LOADLIB,DISP=SHR
//EXTRACT  DD DSN=MFI01.MFIDEMO.BANKSRT1(0),DISP=SHR
//PRINTOUT DD SYSOUT=*
//*
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm
