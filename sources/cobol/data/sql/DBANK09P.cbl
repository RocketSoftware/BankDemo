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
      * Program:     DBANK09P.CBL                                     *
      * Function:    Obtain contact information for statements        *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK09P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK09P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD09
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
           MOVE SPACES TO CD09O-DATA.

      *****************************************************************
      * Now attempt to get the requested record                       *
      *****************************************************************
      *DENNY
           EXEC SQL
                SELECT CS.BCS_PID,
                       CS.BCS_NAME,
                       CS.BCS_ADDR1,
                       CS.BCS_ADDR2,
                       CS.BCS_STATE,
                       CS.BCS_COUNTRY,
                       CS.BCS_POST_CODE,
                       CS.BCS_EMAIL
                INTO :DCL-BCS-PID,
                     :DCL-BCS-NAME,
                     :DCL-BCS-ADDR1,
                     :DCL-BCS-ADDR2,
                     :DCL-BCS-STATE,
                     :DCL-BCS-COUNTRY,
                     :DCL-BCS-POST-CODE,
                     :DCL-BCS-EMAIL
                FROM BNKCUST CS
                WHERE CS.BCS_PID = :CD09I-CONTACT-ID
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              MOVE DCL-BCS-PID TO CD09O-CONTACT-ID
              MOVE DCL-BCS-NAME TO CD09O-CONTACT-NAME
              MOVE DCL-BCS-ADDR1 TO CD09O-CONTACT-ADDR1
              MOVE DCL-BCS-ADDR2 TO CD09O-CONTACT-ADDR2
              MOVE DCL-BCS-STATE TO CD09O-CONTACT-STATE
              MOVE DCL-BCS-COUNTRY TO CD09O-CONTACT-CNTRY
              MOVE DCL-BCS-POST-CODE TO CD09O-CONTACT-PSTCDE
              MOVE DCL-BCS-EMAIL TO CD09O-CONTACT-EMAIL
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO '00000'
              MOVE SPACES TO CD09O-DATA
              MOVE HIGH-VALUES TO CD09O-CONTACT-ID
              MOVE 'Bad SQL code' TO CD09O-CONTACT-NAME
           END-IF.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
