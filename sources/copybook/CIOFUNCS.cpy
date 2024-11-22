      *****************************************************************
      *                                                               *
      * Copyright 2010-2024 Rocket Software, Inc. or its affiliates.  *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Rocket products, and is otherwise subject to the EULA at      *
      * https://www.rocketsoftware.com/company/trust/agreements.      *
      *                                                               *
      * THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED             *
      * WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF               *
      * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,         *
      * SHALL NOT APPLY.                                              *
      * TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL              *
      * ROCKET SOFTWARE HAVE ANY LIABILITY WHATSOEVER IN CONNECTION   *
      * WITH THIS SOFTWARE.                                           *
      *                                                               *
      *****************************************************************

      *****************************************************************
      * CIOFUNCS.CPY                                                  *
      *---------------------------------------------------------------*
      * I/O Request definitions (request functions and status codes)  *
      *****************************************************************
         05  IO-REQUEST-AREAS.
           10  IO-REQUEST-FUNCTION                 PIC X(8).
             88  IO-REQUEST-FUNCTION-OPEN          VALUE 'OPEN    '.
             88  IO-REQUEST-FUNCTION-READ          VALUE 'READ    '.
             88  IO-REQUEST-FUNCTION-CLOSE         VALUE 'CLOSE   '.
           10  IO-REQUEST-STATUS                   PIC X(8).
             88  IO-REQUEST-STATUS-OK              VALUE 'OK      '.
             88  IO-REQUEST-STATUS-EOF             VALUE 'EOF     '.
             88  IO-REQUEST-STATUS-ERROR           VALUE 'ERROR   '.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
