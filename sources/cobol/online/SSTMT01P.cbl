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
      * Program:     SSTMT01P.CBL (CICS Version)                      *
      * Layer:       Transaction manager specific                     *
      * Function:    Create statement print request                   *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SSTMT01P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SSTMT01P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.

       01  WS-COMMAREA.
       COPY CSTMTD01.

       01  WS-PRINT-MSG-AREA.
         05  FILLER                                PIC X(28)
             VALUE 'Accepted print request for: '.
         05  WS-PRINT-MSG-UID                      PIC X(5).
         05  FILLER                                PIC X(10)
             VALUE '. Send by '.
         05  WS-PRINT-MSG-METHOD                   PIC X(13).

       01  WS-INTRDR-QUEUE                         PIC X(4)
           VALUE 'IRDR'.

       01  WS-PERFORM-COUNTER                      PIC 9(3).

       COPY CSTMTJCL.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
             OCCURS 1 TO 4096 TIMES
               DEPENDING ON WS-COMMAREA-LENGTH.

       COPY CENTRY.
      *****************************************************************
      * Move the passed data to our area                              *
      *****************************************************************
           MOVE LENGTH OF WS-COMMAREA TO WS-COMMAREA-LENGTH.
           MOVE DFHCOMMAREA TO WS-COMMAREA.

      *****************************************************************
      * Initialize our output area                                    *
      *****************************************************************
           MOVE SPACES TO CSTMTD01O-DATA.

      *****************************************************************
      * Set up message to go to log                                   *
      *****************************************************************
           MOVE CSTMTD01I-CONTACT-ID TO WS-PRINT-MSG-UID.
           IF CSTMTD01I-POST
              MOVE Z'regular mail' TO WS-PRINT-MSG-METHOD
           END-IF.
           IF CSTMTD01I-EMAIL
              MOVE Z'E-Mail' TO WS-PRINT-MSG-METHOD
           END-IF.

      *****************************************************************
      * Write the log message                                         *
      *****************************************************************
           EXEC CICS WRITE
                     OPERATOR
                     TEXT(WS-PRINT-MSG-AREA)
                     TEXTLENGTH(LENGTH OF WS-PRINT-MSG-AREA)
           END-EXEC.

      *****************************************************************
      * Set up the JCL to run the job                                 *
      *****************************************************************
           INSPECT WS-JCL-CARD-TABLE
             REPLACING ALL '%%%%%' BY CSTMTD01I-CONTACT-ID.

           DIVIDE LENGTH OF WS-JCL-CARD(1) INTO
             LENGTH OF WS-JCL-CARD-TABLE GIVING WS-JCL-CARD-COUNT.

      *****************************************************************
      * Write the JCL to the internal reader TD queue                 *
      *****************************************************************
           EXEC CICS ENQ
                RESOURCE(WS-INTRDR-QUEUE)
                LENGTH(LENGTH OF WS-INTRDR-QUEUE)
                RESP(WS-RESP)
           END-EXEC.

           PERFORM VARYING WS-PERFORM-COUNTER FROM 1 BY 1
             UNTIL WS-PERFORM-COUNTER IS GREATER THAN WS-JCL-CARD-COUNT
               EXEC CICS WRITEQ TD
                    QUEUE(WS-INTRDR-QUEUE)
                    FROM(WS-JCL-CARD(WS-PERFORM-COUNTER))
                    RESP(WS-RESP)
               END-EXEC
           END-PERFORM.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
