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
      * Program:     SBANK99P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Terminate the pseudo conversation                *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK99P.
       DATE-WRITTEN.
           September 2003.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK99P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK99.

       01  WS-TIME-DATE-WORK-AREA.
       COPY CDATED.

       01  WS-BANK-DATA-AREAS.
         05 WS-BANK-DATA.
       COPY CBANKDAT.
         05  WS-BANK-EXT-DATA.
       COPY CBANKEXT.

       COPY CSCRNHDD.

       COPY CVERSND.

       COPY DFHAID.

       COPY DFHBMSCA.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  FILLER                                PIC X(1)
             OCCURS 1 TO 32767 TIMES DEPENDING ON EIBCALEN.

       PROCEDURE DIVISION.
      *****************************************************************
      * Write entry to log to show we have been invoked               *
      *****************************************************************
           COPY CTRACE.

      *****************************************************************
      * Store our transaction-id                                      *
      *****************************************************************
           MOVE EIBTRNID TO WS-TRAN-ID.

      *****************************************************************
      * Store passed data or abend if there wasn't any                *
      *****************************************************************
           IF EIBCALEN IS EQUAL TO 0
              MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
              MOVE '0001' TO ABEND-CODE
              MOVE SPACES TO ABEND-REASON
              COPY CABENDPO.
           ELSE
              MOVE EIBCALEN TO WS-SAVED-EIBCALEN
              MOVE LOW-VALUES TO WS-BANK-DATA
              MOVE DFHCOMMAREA (1:EIBCALEN)
                TO WS-BANK-DATA-AREAS (1:LENGTH OF WS-BANK-DATA-AREAS)
           END-IF.

      *****************************************************************
      * This is the main process                                      *
      *****************************************************************

      *****************************************************************
      * Determine what we have to do (read from or send to screen)    *
      *****************************************************************
           MOVE LOW-VALUE TO MAPAREA.
           EVALUATE TRUE
             WHEN BANK-MAP-FUNCTION-GET
               PERFORM BANK99-READ THRU
                       BANK99-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM BANK99-BUILD-AND-SEND THRU
                       BANK99-BUILD-AND-SEND-EXIT
             WHEN OTHER
               MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
               MOVE '0002' TO ABEND-CODE
               MOVE SPACES TO ABEND-REASON
               COPY CABENDPO.
           END-EVALUATE.

      * Call the appropriate routine to handle the business logic
           IF BANK-MAP-FUNCTION-GET
              EXEC CICS LINK PROGRAM(WS-BUSINESS-LOGIC-PGM)
                             COMMAREA(WS-BANK-DATA)
                             LENGTH(LENGTH OF WS-BANK-DATA)
              END-EXEC
           END-IF.

      *****************************************************************
      * Now we have to have finished and can return to our invoker.   *
      *****************************************************************
      * Now return to CICS
           MOVE WS-BANK-DATA-AREAS (1:LENGTH OF WS-BANK-DATA-AREAS)
             TO DFHCOMMAREA (1:WS-SAVED-EIBCALEN).
           EXEC CICS
                RETURN
           END-EXEC.
           GOBACK.

      *****************************************************************
      * Screen processing for MBANK99                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       BANK99-READ.
           MOVE 'BBANK99P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO BANK99-READ-EXIT
           END-IF.
           IF BANK-LAST-MAPSET IS EQUAL TO SPACES
              GO TO BANK99-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO BANK99-READ-CICS
           ELSE
              GO TO BANK99-READ-INET
           END-IF.

       BANK99-READ-CICS.
           GO TO BANK99-READ-EXIT.

       BANK99-READ-INET.
           GO TO BANK99-READ-EXIT.

       BANK99-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for MBANK99                                 *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       BANK99-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK99AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           MOVE 'MBANK99' TO BANK-LAST-MAPSET.
           MOVE 'BANK99A' TO BANK-LAST-MAP.
           IF BANK-ENV-CICS
              GO TO BANK99-BUILD-AND-SEND-CICS
           ELSE
              GO TO BANK99-BUILD-AND-SEND-INET
           END-IF.

       BANK99-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK99AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK99AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK99AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK99AO.
           MOVE DDO-DATA TO DATEO IN BANK99AO.
      * Move in any error message
      * Move in screen specific fields
           MOVE 'MBANK99' TO BANK-LAST-MAPSET.
           MOVE 'BANK99A' TO BANK-LAST-MAP.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK99AO
              MOVE DFHGREEN TO SCRNC IN BANK99AO
              MOVE DFHGREEN TO HEAD1C IN BANK99AO
              MOVE DFHGREEN TO DATEC IN BANK99AO
              MOVE DFHGREEN TO TXT02C IN BANK99AO
              MOVE DFHGREEN TO TRANC IN BANK99AO
              MOVE DFHGREEN TO HEAD2C IN BANK99AO
              MOVE DFHGREEN TO TIMEC IN BANK99AO
              MOVE DFHGREEN TO TXT03C IN BANK99AO
              MOVE DFHGREEN TO TXT04C IN BANK99AO
              MOVE DFHGREEN TO VERC IN BANK99AO
           END-IF.
           EXEC CICS SEND MAP('BANK99A')
                          MAPSET('MBANK99')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO BANK99-BUILD-AND-SEND-EXIT.

       BANK99-BUILD-AND-SEND-INET.
           MOVE SPACES TO EXT-OP-DATA.
           MOVE WS-TRAN-ID TO EXT-OP-TRAN.
           MOVE DDO-DATA TO EXT-OP-DATE.
           MOVE DD-TIME-OUTPUT TO EXT-OP-TIME.
           CALL 'SCUSTOMP' USING SCREEN-TITLES.
           MOVE SCREEN-TITLE1 TO EXT-OP-HEAD1.
           MOVE SCREEN-TITLE2 TO EXT-OP-HEAD2.
           CALL 'SVERSONP' USING SCREEN-TITLES.
           MOVE VERSION TO EXT-OP-VERSION.
      * Move in userid and any error message
      * Move in screen specific fields
      * Move in screen name
           MOVE 'BANK99' TO EXT-OP-SCREEN.
           GO TO BANK99-BUILD-AND-SEND-EXIT.

       BANK99-BUILD-AND-SEND-EXIT.
           EXIT.

      *****************************************************************
      * Call common routine to perform date conversions               *
      *****************************************************************
       CALL-DATECONV.
           MOVE BANK-ENV TO DD-ENV.
           MOVE 'UDATECNV' TO WS-DYNAMIC-PGM.
           CALL WS-DYNAMIC-PGM USING WS-TIME-DATE-WORK-AREA.
       CALL-DATECONV-EXIT.
           EXIT.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
