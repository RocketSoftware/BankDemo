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
//* ZBNKINT1
//* ******************************************************************
//* STEP01 - DEFINE REQUIRED GENERATION DATA GROUPS (GDG)
//* ******************************************************************
//STEP01  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE MFI01.MFIDEMO.BANKSRT1            -
         FORCE
  DEFINE GDG (NAME(MFI01.MFIDEMO.BANKSRT1) -
              LIMIT(3)                     -
              SCRATCH)
  DELETE MFI01.MFIDEMO.BANKSRT2            -
         FORCE
  DEFINE GDG (NAME(MFI01.MFIDEMO.BANKSRT2) -
              LIMIT(3)                     -
              SCRATCH)

  DELETE MFI01.MFIDEMO.BANKEXT1            -
         FORCE
  DEFINE GDG (NAME(MFI01.MFIDEMO.BANKEXT1) -
              LIMIT(3)                     -
              SCRATCH)
  DELETE MFI01.MFIDEMO.BANKEXT2            -
          FORCE
  DEFINE GDG (NAME(MFI01.MFIDEMO.BANKEXT2) -
              LIMIT(3)                     -
              SCRATCH)
  SET    MAXCC=0
  LISTC  LVL     (MFI01.MFIDEMO)
//*
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm
