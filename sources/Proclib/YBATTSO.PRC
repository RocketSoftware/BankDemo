//* ******************************************************************  00000100
//*                                                                     00000200
//* Copyright (C) 2010-2021 Micro Focus.  All Rights Reserved           00000300
//* This software may be used, modified, and distributed                00000400
//* (provided this notice is included without modification)             00000500
//* solely for internal demonstration purposes with other               00000600
//* Micro Focus software, and is otherwise subject to the EULA at       00000700
//* https://www.microfocus.com/en-us/legal/software-licensing.          00000800
//*                                                                     00000900
//* THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED                   00001000
//* WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF                     00001100
//* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,               00001200
//* SHALL NOT APPLY.                                                    00001300
//* TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL                    00001400
//* MICRO FOCUS HAVE ANY LIABILITY WHATSOEVER IN CONNECTION             00001500
//* WITH THIS SOFTWARE.                                                 00001600
//*                                                                     00001700
//* ******************************************************************  00001800
//BATCHTSO PROC                                                         00001900
//TSO      EXEC PGM=IKJEFT01,DYNAMNBR=40,REGION=2M                      00002000
//STEPLIB  DD DSN=DB2.DSNLOAD,DISP=SHR                                  00002100
//DBRMLIB  DD DUMMY                                                     00002200
//*YSPRINT DD SYSOUT=*                                                  00002300
//SYSTSPRT DD SYSOUT=*                                                  00002400
//SYSUDUMP DD SYSOUT=*                                                  00002500
//SYSOUT   DD SYSOUT=*                                                  00002600
//SYSTSIN  DD DDNAME=SYSIN                                              00002700
//*YSTERM  DD SYSOUT=*                                                  00002800
//SYSOPT   DD SYSOUT=*                                                  00002900
//*                                                                     00003000
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     00003100
