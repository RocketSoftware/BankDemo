  /****************************************************************
  *
  *  Copyright(C) 1998_2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /****************************************************************
  * CPSWDD01.CPY
  *---------------------------------------------------------------
  * This area is used to pass data between a requesting program
  * and the "I/O" program (SPSWD01P) which checks the supplied
  * usewrid/password against the current security model
  ****************************************************************/
     05  CPSWDD01_DATA,
       10  CPSWDD01I_DATA,
         15  CPSWDD01I_OPERATION,
           20  PSWD_NOOP                       BIT(1) INIT('0'B),
           20  PSWD_SIGNON                     BIT(1) INIT('0'B),
           20  PSWD_SIGNOFF                    BIT(1) INIT('0'B),
         15  CPSWDD01I_USERID                  CHAR(8),
         15  CPSWDD01I_PASSWORD                CHAR(8),
       10  CPSWDD01O_DATA,
         15  CPSWDD01O_MESSAGE                 CHAR(75);
