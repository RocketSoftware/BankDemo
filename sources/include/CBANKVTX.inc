    /****************************************************************
    *
    *  Copyright(C) 1998_-010 Micro Focus. All Rights Reserved.
    *
    ****************************************************************/

    /****************************************************************
    * CBANKVTX.CPY
    *---------------------------------------------------------------
    * This is the record file record layout for bank transactions
    ****************************************************************/
       05  BTX_RECORD,
         10  BTX_REC_PID                         CHAR(5),
         10  BTX_REC_TYPE                        CHAR(1),
         10  BTX_REC_SUB_TYPE                    CHAR(1),
         10  BTX_REC_ALTKEY1,
           15  BTX_REC_ACCNO                     CHAR(9),
           15  BTX_REC_TIMESTAMP                 CHAR(26),
         10  BTX_REC_TIMESTAMP_FF                CHAR(26),
         10  BTX_REC_AMOUNT                      FIXED DEC(9,2),
         10  BTX_REC_DATA_OLD                    CHAR(150),
         10  BTX_REC_DATA_NEW                    CHAR(150),
         10  BTX_REC_FILLER                      CHAR(27);
