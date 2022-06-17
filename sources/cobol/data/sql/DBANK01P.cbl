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
      * Program:     DBANK01P.CBL                                     *
      * Function:    Obtain User details                              *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK01P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK01P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  SQLCODE-DISP                          PIC 9(5).

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD01
           END-EXEC.

           EXEC SQL
                BEGIN DECLARE SECTION
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSCS
           END-EXEC.
           EXEC SQL
                INCLUDE SQLCA
           END-EXEC.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
             OCCURS 1 TO 6144 TIMES
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
           MOVE SPACES TO CD01O-DATA.

      *****************************************************************
      * Now attempt to get the requested record                       *
      *****************************************************************
           EXEC SQL
                SELECT CS.BCS_PID,
                       CS.BCS_NAME
                INTO :DCL-BCS-PID,
                     :DCL-BCS-NAME
                FROM BNKCUST CS
                WHERE CS.BCS_PID = :CD01I-PERSON-PID
           END-EXEC.

      *****************************************************************
      * Check the result of the select                                *
      *****************************************************************
           EVALUATE SQLSTATE
      * Did we get the record OK?
              WHEN '00000'
                   MOVE DCL-BCS-PID TO CD01O-PERSON-PID
                   MOVE DCL-BCS-NAME TO CD01O-PERSON-NAME
      * Was the record not found?
              WHEN '02000'
                   MOVE SPACES TO CD01O-PERSON-PID
                   MOVE 'Person not found' TO CD01O-PERSON-NAME
      * Some other problem other than not found
              WHEN OTHER
                   MOVE SPACES TO CD01O-PERSON-PID
      *            MOVE SQLCODE to SQLCODE-DISP
                   STRING 'SQLSTATE : ' delimited by size
                          SQLSTATE delimited by size
                     INTO CD01O-PERSON-NAME
                   END-STRING
           END-EVALUATE
      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
