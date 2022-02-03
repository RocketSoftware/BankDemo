//PRINT    PROC HIQUAL1='MFI01',HIQUAL2='MFIDEMO',                      00000100
//* SOUT='*',GEN='0',PRM=''                                             00000200
// SOUT='*',GEN='0',P1='',P2='',B='BANK'                                00000300
//* ******************************************************************  00000400
//* PROC TO PRINT BANK STATEMENTS.                                   *  00000500
//*   //GO  EXEC YBNKPRT1,PRM=?????                                  *  00000600
//*   WHERE ????? IS:                                                *  00000700
//*   - ANY DATA (JUST DISPLAYED)                                    *  00000800
//* ******************************************************************  00000900
//PRINT    EXEC PGM=ZBNKPRT1,PARM='&P1.&P2'                             00001000
//*TEPLIB  DD DSN=&HIQUAL1..&HIQUAL2..LOADLIB,DISP=SHR                  00001100
//EXTRACT  DD DSN=&HIQUAL1..&HIQUAL2..&B.SRT1(&GEN),DISP=SHR            00001200
//PRINTOUT DD SYSOUT=&SOUT                                              00001300
//*                                                                     00001400
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     00001500
