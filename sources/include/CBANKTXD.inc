  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /****************************************************************
  * CBANKTXD.INC
  *---------------------------------------------------------------
  * This area is used to pass data between a requesting program
  * and the I/O program (DBANK01P) which retrieves the customer
  * information.
  ****************************************************************/
  DCL 01  TXN_DATA,
     05  TXN_TYPE                              CHAR(1),
       /*  TXN_TRANSFER_MONEY                  VALUE '1',
       88  TXN_CHANGE_CONTACT_INFO             VALUE '2'*/
     05  TXN_SUB_TYPE                          CHAR(1),
       /*  TXN_TRANSFER_MONEY_FROM             VALUE '1',
       88  TXN_TRANSFER_MONEY_TO               VALUE '2'*/
     05  TXN_DATA_OLD                          CHAR(150),
     05  TXN_DATA_NEW                          CHAR(150);

   DCL 01  TXN_T1_OLD BASED(ADDR(TXN_DATA_OLD)),
       15  TXN_T1_OLD_DESC                     CHAR(30);

   DCL 01  TXN_T2_OLD BASED(ADDR(TXN_DATA_OLD)),
       15  TXN_T2_OLD_ADDR1                    CHAR(25),
       15  TXN_T2_OLD_ADDR2                    CHAR(25),
       15  TXN_T2_OLD_STATE                    CHAR(2),
       15  TXN_T2_OLD_CNTRY                    CHAR(6),
       15  TXN_T2_OLD_PSTCDE                   CHAR(6),
       15  TXN_T2_OLD_TELNO                    CHAR(12),
       15  TXN_T2_OLD_EMAIL                    CHAR(30),
       15  TXN_T2_OLD_SEND_MAIL                CHAR(1),
       15  TXN_T2_OLD_SEND_EMAIL               CHAR(1);

   DCL 01  TXN_T2_NEW BASED(ADDR(TXN_DATA_NEW)),
       15  TXN_T2_NEW_ADDR1                    CHAR(25),
       15  TXN_T2_NEW_ADDR2                    CHAR(25),
       15  TXN_T2_NEW_STATE                    CHAR(2),
       15  TXN_T2_NEW_CNTRY                    CHAR(6),
       15  TXN_T2_NEW_PSTCDE                   CHAR(6),
       15  TXN_T2_NEW_TELNO                    CHAR(12),
       15  TXN_T2_NEW_EMAIL                    CHAR(30),
       15  TXN_T2_NEW_SEND_MAIL                CHAR(1),
       15  TXN_T2_NEW_SEND_EMAIL               CHAR(1);
