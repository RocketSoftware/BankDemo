//EXTRACT   PROC HIQUAL1='MFI01',HIQUAL2='MFIDEMO',                     00000100
// SOUT='*',REQUEST='',                                                 00000200
// IMSID=TEST,APARM=ALL,                                                00000300
//* ******************************************************************  00000400
//* PROC TO EXTRACT BANKS STATEMENT DATA FROM DLI FILES              *  00000500
//*   //GO  EXEC YBNKEXTD,REQUEST=?????                              *  00000600
//*   WHERE ????? IS:                                                *  00000700
//*   - NULL (ALL DATA EXTRACTED)                                    *  00000800
//*   - ALL (ALL DATA EXTRACTED)                                     *  00000900
//*   - THE 5 CHARACTER CUSTOMER ID TO EXTRACT DATA FOR              *  00001000
//* ******************************************************************  00001100
//            MBR=ZBNKEXT1,PSB=ZBNKEXT1,IN=,OUT=,                       00001200
//            OPT=N,SPIE=0,TEST=0,DIRCA=000,                            00001300
//            PRLD=,STIMER=,CKPTID=,PARDLI=,                            00001400
//            CPUTIME=,NBA=,OBA=,IMSID=,AGN=,                           00001500
//            SSM=,PREINIT=,RGN=2048K,                                  00001600
//            ALTID=,REQUEST=,LOCKMAX=,IMSPLEX=,                        00001700
//            SOUT='*'                                                  00001800
//*                                                                     00001900
//EXTRACT  EXEC PGM=DFSRRC00,REGION=&RGN,                               00002000
//         PARM=(BMP,&MBR,&PSB,&IN,&OUT,                                00002100
//             &OPT&SPIE&TEST&DIRCA,&PRLD,                              00002200
//             &STIMER,&CKPTID,&PARDLI,&CPUTIME,                        00002300
//             &NBA,&OBA,&IMSID,&AGN,&SSM,                              00002400
//             &PREINIT,&ALTID,                                         00002500
//             '&APARM',&LOCKMAX,,,&IMSPLEX)                            00002600
//STEPLIB  DD DSN=PGMLIB,DISP=SHR                                       00002700
//         DD DSN=IMS.LOADLIB,DISP=SHR                                  00002800
//         DD DSN=IMSVST.RESLIB,DISP=SHR                                00002900
//DFSRESLB DD DSN=IMS.RESLIB,DISP=SHR                                   00003000
//IEFRDER  DD DSN=&&TEMPRDR,DISP=(,PASS),                               00003100
//            SPACE=(TRK,1),UNIT=SYSDA                                  00003200
//SYSOUT   DD SYSOUT=&SOUT                                              00003300
//EXTRACT  DD DSN=&HIQUAL1..&HIQUAL2..BANKEXT1(+1),                     00003400
//            DISP=(NEW,CATLG,DELETE),                                  00003500
//            DCB=(RECFM=VB,LRECL=99,BLKSIZE=990),                      00003600
//            UNIT=SYSDA,SPACE=(TRK,(2,1),RLSE)                         00003700
//*                                                                     00003800
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     00003900
