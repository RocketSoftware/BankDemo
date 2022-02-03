//EXTRACT   PROC HIQUAL1='MFI01',HIQUAL2='MFIDEMO',                     00000100
// SOUT='*',REQUEST=''                                                  00000200
//* ******************************************************************  00000300
//* PROC TO EXTRACT BANKS STATEMENT DATA FROM VSAM FILES             *  00000400
//*   //GO  EXEC YBNKEXTV,REQUEST=?????                              *  00000500
//*   WHERE ????? IS:                                                *  00000600
//*   - NULL (ALL DATA EXTRACTED)                                    *  00000700
//*   - ALL (ALL DATA EXTRACTED)                                     *  00000800
//*   - THE 5 CHARACTER CUSTOMER ID TO EXTRACT DATA FOR              *  00000900
//* ******************************************************************  00001000
//EXTRACT  EXEC PGM=ZBNKEXT1,PARM=&REQUEST                              00001100
//*TEPLIB  DD DSN=&HIQUAL1..&HIQUAL2..LOADLIB,DISP=SHR                  00001200
//SYSOUT   DD SYSOUT=&SOUT                                              00001300
//EXTRACT  DD DSN=&HIQUAL1..&HIQUAL2..BANKEXT1(+1),                     00001400
//            DISP=(NEW,CATLG,DELETE),                                  00001500
//            DCB=(RECFM=VB,LRECL=99,BLKSIZE=990),                      00001600
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)                         00001700
//BNKACC   DD DSN=&HIQUAL1.V.&HIQUAL2..BNKACC,DISP=SHR                  00001800
//BNKATYP  DD DSN=&HIQUAL1.V.&HIQUAL2..BNKATYPE,DISP=SHR                00001900
//BNKCUST  DD DSN=&HIQUAL1.V.&HIQUAL2..BNKCUST,DISP=SHR                 00002000
//BNKTXN   DD DSN=&HIQUAL1.V.&HIQUAL2..BNKTXN,DISP=SHR                  00002100
//*                                                                     00002200
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     00002300
