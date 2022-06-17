//BACPATH  JOB MFIDEMO,MFIDEMO,CLASS=A,MSGCLASS=A
//STEP1    EXEC   PGM=IDCAMS
//SYSPRINT DD     SYSOUT=A
//SYSIN    DD     *
    DEFINE CLUSTER -
           (NAME(VWX.MYDATA) -
           VOLUMES(VSER02) -
           RECORDS(1000 500)) -
         DATA -
           (NAME(VWX.KSDATA) -
           KEYS(15 0) -
           RECORDSIZE(250 250) -
           FREESPACE(20 10) -
           BUFFERSPACE(25000)  ) -
         INDEX -
           (NAME(VWX.KSINDEX))
//DEFNAIX EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*                                 
//SYSIN    DD *                                        
   DEFINE AIX (NAME(VWX.MYDATA.AIX)     -
   RELATE(VWX.MYDATA)                  -
   RECORDS(10) -
   KEYS(32,25)                            -
   NONUNIQUEKEY)                              
