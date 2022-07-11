  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /***************************************************************
  * CBANKD51.INC
  *--------------------------------------------------------------
  * This area is used to pass data between ????????????????????
  * display program and the I/O program (DBANK51P) which
  * retrieves the data requested ????????????????????????????
  ***************************************************************/
     05  CD51_DATA,
       10  CD51I_DATA,
         15  CD51I_PID                         CHAR(5),
           /*  CD51_REQUESTED_ALL              VALUE 'ALL  '*/
       10  CD51O_DATA,
         15  CD51O_PID                         CHAR(5),
         15  CD51O_NAME                        CHAR(25),
         15  CD51O_ADDR1                       CHAR(25),
         15  CD51O_ADDR2                       CHAR(25),
         15  CD51O_STATE                       CHAR(2),
         15  CD51O_CNTRY                       CHAR(6),
         15  CD51O_POST_CODE                   CHAR(6),
         15  CD51O_EMAIL                       CHAR(30),
         15  CD51O_ACC_NO                      CHAR(9),
         15  CD51O_ACC_DESC                    CHAR(15),
         15  CD51O_ACC_CURR_BAL                FIXED DEC(9,2),
         15  CD51O_ACC_LAST_STMT_DTE           CHAR(10),
         15  CD51O_ACC_LAST_STMT_BAL           FIXED DEC(9,2),
