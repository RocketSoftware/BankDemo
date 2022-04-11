 /****************************************************************
 *
 *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
 *
 ****************************************************************/

 /****************************************************************
 * CBANKXT1.INC
 *---------------------------------------------------------------
 * This is the record file record layout used to extract data
 * from the bank file to produce statements.
 ****************************************************************/
 DCL 1 BANKXT01_REC0,
    10  BANKXT01_0_TYPE                       CHAR(1),
    10  BANKXT01_0_PID                        CHAR(5),
    10  BANKXT01_0_NAME                       CHAR(25),
    10  BANKXT01_0_EMAIL                      CHAR(30),
    10  BANKXT01_0_FILLER                     CHAR(5);
 DCL 1 BANKXT01_REC1,
    10  BANKXT01_1_TYPE                       CHAR(1),
    10  BANKXT01_1_PID                        CHAR(5),
    10  BANKXT01_1_NAME                       CHAR(25),
    10  BANKXT01_1_ADDR1                      CHAR(25),
    10  BANKXT01_1_ADDR2                      CHAR(25),
    10  BANKXT01_1_STATE                      CHAR(2),
    10  BANKXT01_1_CNTRY                      CHAR(6),
    10  BANKXT01_1_PST_CDE                    CHAR(6);
 DCL 1 BANKXT01_REC2,
    10  BANKXT01_2_TYPE                       CHAR(1),
    10  BANKXT01_2_PID                        CHAR(5),
    10  BANKXT01_2_ACC_NO                     CHAR(9),
    10  BANKXT01_2_ACC_DESC                   CHAR(15),
    10  BANKXT01_2_ACC_CURR_BAL               FIXED DEC(9,2),
    10  BANKXT01_2_ACC_LAST_STMT_DTE          CHAR(26),
    10  BANKXT01_2_ACC_LAST_STMT_BAL          FIXED DEC(9,2);
 DCL 1 BANKXT01_REC3,
    10  BANKXT01_3_TYPE                       CHAR(1),
    10  BANKXT01_3_PID                        CHAR(5),
    10  BANKXT01_3_ACC_NO                     CHAR(9),
    10  BANKXT01_3_TIMESTAMP                  CHAR(26),
    10  BANKXT01_3_AMOUNT                     FIXED DEC(9,2),
    10  BANKXT01_3_DESC                       CHAR(30);

 /* 
    Overlay areas for use by ZBNKPRT1
 */
 DCL BANKREC0 cHAR(STG(BANKXT01_REC0)) BASED(ADDR(BANKXT01_REC0));
 DCL BANKREC1 cHAR(STG(BANKXT01_REC1)) BASED(ADDR(BANKXT01_REC1));
 DCL BANKREC2 cHAR(STG(BANKXT01_REC2)) BASED(ADDR(BANKXT01_REC2));
 DCL BANKREC3 cHAR(STG(BANKXT01_REC3)) BASED(ADDR(BANKXT01_REC3));

