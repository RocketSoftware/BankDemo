  /****************************************************************
  *
  *  Copyright(C) 1998_2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /****************************************************************
  * CBANKVAC.INC       ACS_GE
  *---------------------------------------------------------------
  * This is the record file record layout for bank account
  ****************************************************************/
     05  BAC_RECORD,
       10  BAC_REC_PID                         CHAR(5),
       10  BAC_REC_ACCNO                       CHAR(9),
       10  BAC_REC_TYPE                        CHAR(1),
       10  BAC_REC_BALANCE                     FIXED DEC(9,2),
       10  BAC_REC_LAST_STMT_DTE               CHAR(10),
       10  BAC_REC_LAST_STMT_BAL               FIXED DEC(9,2),
       10  BAC_REC_ATM_ENABLED                 CHAR(2),
       10  BAC_REC_ATM_DAY_LIMIT               FIXED DEC(3),
       10  BAC_REC_ATM_DAY_DTE                 CHAR(10),
       10  BAC_REC_ATM_DAY_AMT                 FIXED DEC(3),
       10  BAC_REC_RP1_DAY                     CHAR(2),
       10  BAC_REC_RP1_AMOUNT                  FIXED DEC(7,2),
       10  BAC_REC_RP1_PID                     CHAR(5),
       10  BAC_REC_RP1_ACCNO                   CHAR(9),
       10  BAC_REC_RP1_LAST_PAY                CHAR(10),
       10  BAC_REC_RP2_DAY                     CHAR(2),
       10  BAC_REC_RP2_AMOUNT                  FIXED DEC(7,2),
       10  BAC_REC_RP2_PID                     CHAR(5),
       10  BAC_REC_RP2_ACCNO                   CHAR(9),
       10  BAC_REC_RP2_LAST_PAY                CHAR(10),
       10  BAC_REC_RP3_DAY                     CHAR(2),
       10  BAC_REC_RP3_AMOUNT                  FIXED DEC(7,2),
       10  BAC_REC_RP3_PID                     CHAR(5),
       10  BAC_REC_RP3_ACCNO                   CHAR(9),
       10  BAC_REC_RP3_LAST_PAY                CHAR(10),
       10  BAC_REC_FILLER                      CHAR(59);
