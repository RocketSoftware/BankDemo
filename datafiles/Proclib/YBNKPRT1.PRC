//PRINT    PROC HIQUAL1='MFI01',HIQUAL2='MFIDEMO',                      00000100
// SOUT='*',GEN='0',PRM=''                                              00000200
//* ******************************************************************  00000300
//* PROC TO PRINT BANK STATEMENTS.                                   *  00000400
//*   //GO  EXEC YBNKPRT1,PRM=?????                                  *  00000500
//*   WHERE ????? IS:                                                *  00000600
//*   - ANY DATA (JUST DISPLAYED)                                    *  00000700
//* ******************************************************************  00000800
//PRINT    EXEC PGM=ZBNKPRT1,PARM='&PRM'                                00000900
//*TEPLIB  DD DSN=&HIQUAL1..&HIQUAL2..LOADLIB,DISP=SHR                  00001000
//EXTRACT  DD DSN=&HIQUAL1..&HIQUAL2..BANKSRT1(&GEN),DISP=SHR           00001100
//PRINTOUT DD SYSOUT=&SOUT                                              00001200
//*                                                                     00001300
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     00001400
