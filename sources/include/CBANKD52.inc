  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /***************************************************************
  * CD52DATA.INC
  *--------------------------------------------------------------
  * This area is used to pass data between ????????????????????
  * display program and the I/O program (DBANK52P) which
  * retrieves the data requested ????????????????????????????
  ***************************************************************/
     05  CD52_DATA,
       10  CD52I_DATA,
         15  CD52I_PID                         CHAR(5),
           /*  CD52_REQUESTED_ALL              VALUE 'ALL  '*/
       10  CD52O_DATA,
         15  CD52O_PID                         CHAR(5),
         15  CD52O_ACC_NO                      CHAR(9),
         15  CD52O_TIMESTAMP                   CHAR(26),
         15  CD52O_AMOUNT                      FIXED DEC(9,2),
         15  CD52O_DESC                        CHAR(30);
