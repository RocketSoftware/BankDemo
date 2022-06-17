      *****************************************************************
      *                                                               *
      * Copyright (C) 2010-2021 Micro Focus.  All Rights Reserved     *
      * This software may be used, modified, and distributed          *
      * (provided this notice is included without modification)       *
      * solely for internal demonstration purposes with other         *
      * Micro Focus software, and is otherwise subject to the EULA at *
      * https://www.microfocus.com/en-us/legal/software-licensing.    *
      *                                                               *
      * THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED             *
      * WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF               *
      * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,         *
      * SHALL NOT APPLY.                                              *
      * TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL              *
      * MICRO FOCUS HAVE ANY LIABILITY WHATSOEVER IN CONNECTION       *
      * WITH THIS SOFTWARE.                                           *
      *                                                               *
      *****************************************************************

      *****************************************************************
      * CABENDP.CPY                                                   *
      *---------------------------------------------------------------*
      * Invoke abend processing                                       *
      * This copybook is used to provide an abend invocation routine  *
      * that is appropriate to the environment.                       *
      * There are different versions for BATCH, CICS and IMS.         *
      *****************************************************************
           MOVE SPACES TO ABEND-MSG
           STRING ABEND-CULPRIT DELIMITED BY SIZE
                  ' Abend ' DELIMITED BY SIZE
                  ABEND-CODE DELIMITED BY SIZE
                  ' - ' DELIMITED BY SIZE
                  ABEND-REASON DELIMITED BY SIZE
             INTO ABEND-MSG
           EXEC CICS WRITE
                     OPERATOR
                     TEXT(ABEND-MSG)
                     TEXTLENGTH(LENGTH OF ABEND-MSG)
           END-EXEC
           EXEC CICS ABEND
                     ABCODE(ABEND-CODE)
           END-EXEC
           GOBACK

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
