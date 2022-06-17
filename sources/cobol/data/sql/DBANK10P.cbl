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
      * Program:     DBANK10P.CBL                                     *
      * Function:    "SPA" I/O for non-conversational transactions    *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK10P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK10P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-CD10-LENGTH                        PIC 9(5).

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD10
           END-EXEC.

           EXEC SQL
                BEGIN DECLARE SECTION
           END-EXEC.
           EXEC SQL
                INCLUDE CBANKSSP
           END-EXEC.
           EXEC SQL
                INCLUDE SQLCA
           END-EXEC.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
             OCCURS 1 TO 12298 TIMES
               DEPENDING WS-CD10-LENGTH.

       COPY CENTRY.
      *****************************************************************
      * Move the passed data to our area                              *
      *****************************************************************
           MOVE LENGTH OF CD10-DATA TO WS-CD10-LENGTH.
           MOVE DFHCOMMAREA TO CD10-DATA.

      *****************************************************************
      * Initialize our output area                                    *
      *****************************************************************
           MOVE SPACES TO CD10O-DATA.

      *****************************************************************
      * See if we have a delete, read or write request and proceed    *
      * accordingly                                                   *
      *****************************************************************
           EVALUATE TRUE
             WHEN CD10I-DELETE
               PERFORM DELETE-PROCESSING THRU
                       DELETE-PROCESSING-EXIT
             WHEN CD10I-READ
               PERFORM READ-PROCESSING THRU
                       READ-PROCESSING-EXIT
             WHEN CD10I-WRITE
               PERFORM WRITE-PROCESSING THRU
                       WRITE-PROCESSING-EXIT
             WHEN OTHER
               SET CD10O-RESULT-FAILED TO TRUE
               MOVE 'Bad request code' TO CD10O-SPA-DATA
           END-EVALUATE.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE CD10-DATA TO DFHCOMMAREA(1:WS-CD10-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      *****************************************************************
      * Delete request                                                *
      *****************************************************************
       DELETE-PROCESSING.
           EXEC SQL
                DELETE
                FROM BNKSPA SP
                WHERE SP.BSP_TERM = :CD10I-TERM
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              SET CD10O-RESULT-OK TO TRUE
              MOVE SPACES TO CD10O-SPA-DATA
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '02000'
              MOVE SPACES TO CD10O-DATA
              SET CD10O-RESULT-NOT-FOUND TO TRUE
              MOVE 'Record not found' TO CD10O-SPA-DATA
           END-IF.
           IF SQLSTATE IS NOT EQUAL TO '00000' AND
              SQLSTATE IS NOT EQUAL TO '02000'
              MOVE SPACES TO CD10O-DATA
              SET CD10O-RESULT-FAILED TO TRUE
              MOVE 'Bad SQLSTATE code' TO CD10O-SPA-DATA
           END-IF.

       DELETE-PROCESSING-EXIT.
           EXIT.

      *****************************************************************
      * Read request                                                  *
      *****************************************************************
       READ-PROCESSING.
           EXEC SQL
                SELECT SP.BSP_TERM,
                       SP.BSP_SPA_DATA
                INTO :DCL-BSP-TERM,
                     :DCL-BSP-SPA-DATA
                FROM BNKSPA SP
                WHERE SP.BSP_TERM = :CD10I-TERM
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              SET CD10O-RESULT-OK TO TRUE
              MOVE DCL-BSP-SPA-DATA-DATA TO CD10O-SPA-DATA
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO ZERO
              MOVE SPACES TO CD10O-DATA
              SET CD10O-RESULT-FAILED TO TRUE
              MOVE 'Bad SQLSTATE code' TO CD10O-SPA-DATA
           END-IF.

       READ-PROCESSING-EXIT.
           EXIT.

      *****************************************************************
      * Write request                                                 *
      *****************************************************************
       WRITE-PROCESSING.
           MOVE CD10I-TERM TO DCL-BSP-TERM.
           MOVE CD10I-SPA-DATA TO DCL-BSP-SPA-DATA-DATA.
           MOVE LENGTH OF CD10I-SPA-DATA TO DCL-BSP-SPA-DATA-LEN.
           EXEC SQL
                INSERT
                INTO BNKSPA (BSP_TERM,
                             BSP_SPA_DATA)
                VALUES (:CD10I-TERM,
                        :CD10I-SPA-DATA)
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              SET CD10O-RESULT-OK TO TRUE
              MOVE 'Update OK' TO CD10O-SPA-DATA
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO ZERO
              MOVE SPACES TO CD10O-DATA
              SET CD10O-RESULT-FAILED TO TRUE
              MOVE 'Bad SQLSTATE code' TO CD10O-SPA-DATA
           END-IF.

       WRITE-PROCESSING-EXIT.
           EXIT.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
