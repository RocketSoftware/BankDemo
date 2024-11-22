      *****************************************************************
      *                                                               *
      * Copyright 2010-2021 Rocket Software, Inc. or its affiliates.  *
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

       identification division.
       program-id. OPENFIL.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 WS-MSG pic x(80).
       procedure division.
           EXEC CICS SET FILE('BNKACC') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKACC1') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKATYPE') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKCUST') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKCUST1') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKCUST2') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKHELP') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKTXN') OPEN
           END-EXEC
           EXEC CICS SET FILE('BNKTXN1') OPEN
           END-EXEC
           MOVE 'ALL BANK FILES OPEN' TO WS-MSG
           EXEC CICS SEND
               FROM (WS-MSG)
               LENGTH(LENGTH OF WS-MSG)
               ERASE
           END-EXEC

           EXEC CICS RETURN
           END-EXEC

           .
      
       end program OPENFIL.