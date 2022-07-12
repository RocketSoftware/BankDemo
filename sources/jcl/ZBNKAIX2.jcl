//BACPATH  JOB MFIDEMO,MFIDEMO,CLASS=A,MSGCLASS=A
//DEFNAIX EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*                                 
//SYSIN    DD *                                        
   DEFINE AIX (NAME(MFI01V.MFIDEMO.BNKACC.AIX1)     -
   RELATE(MFI01V.MFIDEMO.BNKACC)                  -
   RECORDS(100) -
   KEYS(5,0)                            -
   UNIQUEKEY)                              
