  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /****************************************************************
  * CBANKVCS.INC
  *---------------------------------------------------------------
  * This is the record file record layout for bank customers
  ****************************************************************/
     05  BCS_RECORD                            CHAR(250);

 DCL 01  FILLBCS BASED(ADDR(BCS_RECORD)),
       10  BCS_REC_PID                         CHAR(5),
       10  BCS_REC_NAME                        CHAR(25),
       10  BCS_REC_NAME_FF                     CHAR(25),
       10  BCS_REC_SIN                         CHAR(9),
       10  BCS_REC_ADDR1                       CHAR(25),
       10  BCS_REC_ADDR2                       CHAR(25),
       10  BCS_REC_STATE                       CHAR(2),
       10  BCS_REC_CNTRY                       CHAR(6),
       10  BCS_REC_POST_CODE                   CHAR(6),
       10  BCS_REC_TEL                         CHAR(12),
       10  BCS_REC_EMAIL                       CHAR(30),
       10  BCS_REC_SEND_MAIL                   CHAR(1),
       10  BCS_REC_SEND_EMAIL                  CHAR(1),
       10  BCS_REC_ATM_PIN                     CHAR(4),
       10  BCS_REC_FILLER                      CHAR(74);
