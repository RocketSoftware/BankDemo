  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.
  *
  ****************************************************************/

  /****************************************************************
  * CIOFUNCS.INC
  *---------------------------------------------------------------
  * I/O Request definitions (request functions and status codes)
  ****************************************************************/
     05  IO_REQUEST_AREAS,
       10  IO_REQUEST_FUNCTION                 CHAR(8),
         /*  IO_REQUEST-FUNCTION-OPEN          VALUE 'OPEN    '.
         88  IO_REQUEST-FUNCTION-READ          VALUE 'READ    '.
         88  IO_REQUEST-FUNCTION-CLOSE         VALUE 'CLOSE   '*/
       10  IO_REQUEST_STATUS                   CHAR(8),
         /*  IO_REQUEST-STATUS-OK              VALUE 'OK      '.
         88  IO_REQUEST-STATUS-EOF             VALUE 'EOF     '.
         88  IO_REQUEST-STATUS-ERROR           VALUE 'ERROR   '*/
