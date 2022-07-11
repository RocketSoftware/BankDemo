  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /****************************************************************
  * CBANKD01.INC
  *---------------------------------------------------------------
  * This area is used to pass data between a requesting program
  * and the I/O program (DBANK01P) which retrieves the customer
  * information.
  ****************************************************************/
     05  CD01_DATA,
       10  CD01I_DATA,
         15  CD01I_PERSON_PID                  CHAR(5),
       10  CD01O_DATA,
         15  CD01O_PERSON_PID                  CHAR(5),
         15  CD01O_PERSON_NAME                 CHAR(25);
