  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /****************************************************************
  * CHELPD01.inc
  *---------------------------------------------------------------
  * This area is used to pass data between a requesting program
  * and the I/O program (DHELP01P) which retrieves screen help
  * information.
  ****************************************************************/
     15  HELP01O_DATA,
         20  HELP01I_SCRN                      CHAR(6),
         20  HELP01O_FOUND                     CHAR(1),
         20  HELP01O_LINE(19)                  CHAR(75); 

  /* DCL 1 FILL01 BASED(ADDR(HELP01O_LINE(1))),
         15  HELP01O_INDIVIDUAL_LINES,
           20  HELP01O_L01                     CHAR(75),
           20  HELP01O_L02                     CHAR(75),
           20  HELP01O_L03                     CHAR(75),
           20  HELP01O_L04                     CHAR(75),
           20  HELP01O_L05                     CHAR(75),
           20  HELP01O_L06                     CHAR(75),
           20  HELP01O_L07                     CHAR(75),
           20  HELP01O_L08                     CHAR(75),
           20  HELP01O_L09                     CHAR(75),
           20  HELP01O_L10                     CHAR(75),
           20  HELP01O_L11                     CHAR(75),
           20  HELP01O_L12                     CHAR(75),
           20  HELP01O_L13                     CHAR(75),
           20  HELP01O_L14                     CHAR(75),
           20  HELP01O_L15                     CHAR(75),
           20  HELP01O_L16                     CHAR(75),
           20  HELP01O_L17                     CHAR(75),
           20  HELP01O_L18                     CHAR(75),
           20  HELP01O_L19                     CHAR(75); */
 
  DCL 1 HELP01O_FOUND_SW,
          20 HELP_FOUND                       BIT(1) INIT('0'B),
          20 HELP_NOT_FOUND                   BIT(1) INIT('0'B);
