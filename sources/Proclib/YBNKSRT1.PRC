//SORT    PROC HIQUAL1='MFI01',HIQUAL2='MFIDEMO',                       00000100
// SOUT='*',GEN='0',MBR=KBNKSRT1                                        00000200
//* ******************************************************************  00000300
//* PROC TO SORT BANK STATEMENT DATA                                 *  00000400
//*   //GO  EXEC YBNKSRT1                                            *  00000500
//* ******************************************************************  00000600
//SORT     EXEC PGM=SORT                                                00000700
//EXITLIB  DD DSN=&HIQUAL1..&HIQUAL2..LOADLIB,DISP=SHR                  00000800
//SYSOUT   DD SYSOUT=&SOUT                                              00000900
//SORTIN   DD DSN=&HIQUAL1..&HIQUAL2..BANKEXT1(&GEN),DISP=SHR           00001000
//SORTOUT  DD DSN=&HIQUAL1..&HIQUAL2..BANKSRT1(+1),                     00001100
//*   - NULL (ALL DATA EXTRACTED)                                    *  00001200
//            DISP=(NEW,CATLG,DELETE),                                  00001300
//            DCB=(RECFM=VB,LRECL=99,BLKSIZE=990),                      00001400
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)                         00001500
//SYSIN    DD DSN=&HIQUAL1..&HIQUAL2..CTLCARDS(&MBR),DISP=SHR           00001600
//*                                                                     00001700
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     00001800
