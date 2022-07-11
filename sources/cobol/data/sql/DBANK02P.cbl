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
      * Program:     DBANK02P.CBL                                     *
      * Function:    Obtain/update address information                *
      *              SQL version                                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           DBANK02P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'DBANK02P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).

       01  WS-COMMAREA.
           EXEC SQL
                INCLUDE CBANKD02
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
           MOVE SPACES TO CD02O-DATA.

      *****************************************************************
      * See if we have a read or write request and react accordingly  *
      *****************************************************************
           EVALUATE TRUE
             WHEN CD02I-READ
               PERFORM READ-PROCESSING THRU
                       READ-PROCESSING-EXIT
             WHEN CD02I-WRITE
               PERFORM WRITE-PROCESSING THRU
                       WRITE-PROCESSING-EXIT
             WHEN OTHER
               MOVE HIGH-VALUES TO CD02O-CONTACT-ID
               MOVE 'Bad request code' TO CD02O-CONTACT-NAME
           END-EVALUATE.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      *****************************************************************
      * Read request                                                  *
      *****************************************************************
       READ-PROCESSING.
      *DENNY
           EXEC SQL
                SELECT CS.BCS_PID,
                       CS.BCS_NAME,
                       CS.BCS_ADDR1,
                       CS.BCS_ADDR2,
                       CS.BCS_STATE,
                       CS.BCS_COUNTRY,
                       CS.BCS_POST_CODE,
                       CS.BCS_TEL,
                       CS.BCS_EMAIL,
                       CS.BCS_SEND_MAIL,
                       CS.BCS_SEND_EMAIL
                INTO :DCL-BCS-PID,
                     :DCL-BCS-NAME,
                     :DCL-BCS-ADDR1,
                     :DCL-BCS-ADDR2,
                     :DCL-BCS-STATE,
                     :DCL-BCS-COUNTRY,
                     :DCL-BCS-POST-CODE,
                     :DCL-BCS-TEL,
                     :DCL-BCS-EMAIL,
                     :DCL-BCS-SEND-MAIL,
                     :DCL-BCS-SEND-EMAIL
                FROM BNKCUST CS
                WHERE CS.BCS_PID = :CD02I-CONTACT-ID
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO ZERO
              MOVE DCL-BCS-PID TO CD02O-CONTACT-ID
              MOVE DCL-BCS-NAME TO CD02O-CONTACT-NAME
              MOVE DCL-BCS-ADDR1 TO CD02O-CONTACT-ADDR1
              MOVE DCL-BCS-ADDR2 TO CD02O-CONTACT-ADDR2
              MOVE DCL-BCS-STATE TO CD02O-CONTACT-STATE
              MOVE DCL-BCS-COUNTRY TO CD02O-CONTACT-CNTRY
              MOVE DCL-BCS-POST-CODE TO CD02O-CONTACT-PSTCDE
              MOVE DCL-BCS-TEL TO CD02O-CONTACT-TELNO
              MOVE DCL-BCS-EMAIL TO CD02O-CONTACT-EMAIL
              MOVE DCL-BCS-SEND-MAIL TO CD02O-CONTACT-SEND-MAIL
              MOVE DCL-BCS-SEND-EMAIL TO CD02O-CONTACT-SEND-EMAIL
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO ZERO
              MOVE SPACES TO CD02O-DATA
              MOVE HIGH-VALUES TO CD02O-CONTACT-ID
              MOVE 'Bad SQLSTATE code' TO CD02O-CONTACT-NAME
           END-IF.

       READ-PROCESSING-EXIT.
           EXIT.

      *****************************************************************
      * Write request                                                 *
      *****************************************************************
       WRITE-PROCESSING.
           MOVE CD02I-CONTACT-ADDR1 TO DCL-BCS-ADDR1.
           MOVE CD02I-CONTACT-ADDR2 TO DCL-BCS-ADDR2.
           MOVE CD02I-CONTACT-STATE TO DCL-BCS-STATE.
           MOVE CD02I-CONTACT-CNTRY TO DCL-BCS-COUNTRY.
           MOVE CD02I-CONTACT-PSTCDE TO DCL-BCS-POST-CODE.
           MOVE CD02I-CONTACT-TELNO TO DCL-BCS-TEL.
           MOVE CD02I-CONTACT-EMAIL TO DCL-BCS-EMAIL.
           MOVE CD02I-CONTACT-SEND-MAIL TO DCL-BCS-SEND-MAIL.
           MOVE CD02I-CONTACT-SEND-EMAIL TO DCL-BCS-SEND-EMAIL.
           EXEC SQL
                UPDATE BNKCUST
                SET BCS_ADDR1 = :DCL-BCS-ADDR1,
                    BCS_ADDR2 = :DCL-BCS-ADDR2,
                    BCS_STATE = :DCL-BCS-STATE,
                    BCS_COUNTRY = :DCL-BCS-COUNTRY,
                    BCS_POST_CODE = :DCL-BCS-POST-CODE,
                    BCS_TEL = :DCL-BCS-TEL,
                    BCS_EMAIL = :DCL-BCS-EMAIL,
                    BCS_SEND_MAIL = :DCL-BCS-SEND-MAIL,
                    BCS_SEND_EMAIL = :DCL-BCS-SEND-EMAIL
                WHERE BCS_PID = :CD02I-CONTACT-ID
           END-EXEC.

      *****************************************************************
      * Did we get the record OK                                      *
      *****************************************************************
           IF SQLSTATE IS EQUAL TO '00000'
              MOVE HIGH-VALUES TO CD02O-CONTACT-ID
              MOVE 'Update OK' TO CD02O-CONTACT-NAME
           END-IF.

      *****************************************************************
      * Was the record not found?                                     *
      *****************************************************************
           IF SQLSTATE IS NOT EQUAL TO '00000'
              MOVE SPACES TO CD02O-DATA
              MOVE HIGH-VALUES TO CD02O-CONTACT-ID
              MOVE 'Bad SQLSTATE code' TO CD02O-CONTACT-NAME
           END-IF.

       WRITE-PROCESSING-EXIT.
           EXIT.

      * $ Version 5.90a sequenced on Friday 1 Dec 2006 at 6:00pm
