//IMSBMP PROC MBR=PGMNAME,PSB=PSBNAME,IN=,OUT=,                         00000100
//            OPT=N,SPIE=0,TEST=0,DIRCA=000,                            00000200
//            PRLD=,STIMER=,CKPTID=,PARDLI=,                            00000300
//            CPUTIME=,NBA=,OBA=,IMSID=,AGN=,                           00000400
//            SSM=,PREINIT=,RGN=2048K,                                  00000500
//            ALTID=,APARM=,LOCKMAX=,IMSPLEX=,                          00000600
//            SOUT='*'                                                  00000700
//* ******************************************************************  00000800
//* YIMSBMP - STANDARD IMS BMP PROC                                  *  00000900
//* ---------------------------------------------------------------- *  00001000
//* //STEP1 EXEC YIMSBMP,MBR=YOURPGM,PSB=YOURPGM ,APARM=PARM         *  00001100
//* ******************************************************************  00001200
//GO       EXEC PGM=DFSRRC00,REGION=&RGN,                               00001300
//         PARM=(BMP,&MBR,&PSB,&IN,&OUT,                                00001400
//             &OPT&SPIE&TEST&DIRCA,&PRLD,                              00001500
//             &STIMER,&CKPTID,&PARDLI,&CPUTIME,                        00001600
//             &NBA,&OBA,&IMSID,&AGN,&SSM,                              00001700
//             &PREINIT,&ALTID,                                         00001800
//             '&APARM',&LOCKMAX,,,&IMSPLEX)                            00001900
//STEPLIB  DD DSN=PGMLIB,DISP=SHR                                       00002000
//         DD DSN=IMS.LOADLIB,DISP=SHR                                  00002100
//         DD DSN=IMSVST.RESLIB,DISP=SHR                                00002200
//DFSRESLB DD DSN=IMS.RESLIB,DISP=SHR                                   00002300
//IEFRDER  DD DSN=&&TEMPRDR,DISP=(,PASS),                               00002400
//            SPACE=(TRK,1),UNIT=SYSDA                                  00002500
//SYSOUT   DD SYSOUT=&SOUT                                              00002600
//*                                                                     00002700
//* *** $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     00002800
