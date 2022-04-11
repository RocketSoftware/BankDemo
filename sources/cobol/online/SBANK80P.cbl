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
      * Program:     SBANK80P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Request printing of statements                   *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK80P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK80P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.
         05  WS-WORK1                              PIC X(1).
         05  WS-SUB1                               PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK80.

       01  WS-TIME-DATE-WORK-AREA.
       COPY CDATED.

       01  WS-BANK-DATA-AREAS.
         05  WS-BANK-DATA.
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
               PERFORM SCREEN80-READ THRU
                       SCREEN80-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN80-BUILD-AND-SEND THRU
                       SCREEN80-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK80                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN80-READ.
           MOVE 'BBANK80P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN80-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN80-READ-CICS
           ELSE
              GO TO SCREEN80-READ-INET
           END-IF.

       SCREEN80-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK80A')
                                MAPSET('MBANK80')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP80A')
                                MAPSET('MBANK80')
              END-EXEC
              GO TO SCREEN80-READ-EXIT
           END-IF.

           IF OPT1L IN BANK80AI IS EQUAL TO 0
              MOVE LOW-VALUES TO BANK-SCR80-OPT1
           ELSE
              MOVE OPT1I IN BANK80AI TO BANK-SCR80-OPT1
              IF BANK-SCR80-OPT1 IS EQUAL TO SPACES OR
                 BANK-SCR80-OPT1 IS EQUAL TO '_'
                 MOVE LOW-VALUES TO BANK-SCR80-OPT1
              END-IF
           END-IF.

           IF OPT2L IN BANK80AI IS EQUAL TO 0
              MOVE LOW-VALUES TO BANK-SCR80-OPT2
           ELSE
              MOVE OPT2I IN BANK80AI TO BANK-SCR80-OPT2
              IF BANK-SCR80-OPT2 IS EQUAL TO SPACES OR
                 BANK-SCR80-OPT2 IS EQUAL TO '_'
                 MOVE LOW-VALUES TO BANK-SCR80-OPT2
              END-IF
           END-IF.

           GO TO SCREEN80-READ-EXIT.

       SCREEN80-READ-INET.
           MOVE EXT-IP80-OPT1 TO BANK-SCR80-OPT1.
           MOVE EXT-IP80-OPT2 TO BANK-SCR80-OPT2.
           IF BANK-AID-PFK10
              SET PRINT-CONFIRM TO TRUE
           END-IF.
           GO TO SCREEN80-READ-EXIT.

       SCREEN80-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN80 (BANK80/HELP80)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN80-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK80AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK80' TO BANK-LAST-MAPSET
              MOVE 'HELP80A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK80' TO BANK-LAST-MAPSET
              MOVE 'BANK80A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN80-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN80-BUILD-AND-SEND-INET
           END-IF.

       SCREEN80-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK80A'
              GO TO BANK80-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP80A'
              GO TO HELP80-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK80-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK80AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK80AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK80AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK80AO.
           MOVE DDO-DATA TO DATEO IN BANK80AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK80AO.
      * Move in screen specific fields
           MOVE BANK-SCR80-CONTACT-ID TO USERIDO IN BANK80AO.
           MOVE BANK-SCR80-CONTACT-NAME TO USERNMO IN BANK80AO.

           MOVE BANK-SCR80-ADDR1 TO MADDR1O IN BANK80AO.
           MOVE BANK-SCR80-ADDR2 TO MADDR2O IN BANK80AO.
           MOVE BANK-SCR80-STATE TO MSTATEO IN BANK80AO.
           MOVE BANK-SCR80-CNTRY TO MCNTRYO IN BANK80AO.
           MOVE BANK-SCR80-PSTCDE TO MPSTCDEO IN BANK80AO.
           MOVE BANK-SCR80-EMAIL TO MEMAILO IN BANK80AO.

           IF BANK-SCR80-EMAIL IS NOT EQUAL TO SPACES
              MOVE -1 TO OPT1L IN BANK80AI
              IF BANK-SCR80-OPT1 IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO OPT1O IN BANK80AO
              ELSE
                 MOVE BANK-SCR80-OPT1 TO OPT1O IN BANK80AO
              END-IF
              MOVE -1 TO OPT2L IN BANK80AI
              IF BANK-SCR80-OPT2 IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO OPT2O IN BANK80AO
              ELSE
                 MOVE BANK-SCR80-OPT2 TO OPT2O IN BANK80AO
              END-IF
              IF BANK-SCR80-OPT2 IS EQUAL TO HIGH-VALUES
                 MOVE LOW-VALUES TO BANK-SCR80-OPT2
                 MOVE ALL '_' TO OPT2O IN BANK80AO
                 MOVE DFHBMPRF TO OPT2A IN BANK80AI
              END-IF
           ELSE
              MOVE -1 TO TXT01L IN BANK80AI
              MOVE '(not available)' to MEMAILO IN BANK80AO
              MOVE SPACES TO TXT07O IN BANK80AO
              MOVE SPACES TO TXT08O IN BANK80AO
              MOVE SPACES TO OPT1O IN BANK80AO
              MOVE SPACES TO TXT09O IN BANK80AO
              MOVE SPACES TO OPT2O IN BANK80AO
              MOVE DFHBMPRF TO OPT1A IN BANK80AI
              MOVE DFHBMPRF TO OPT2A IN BANK80AI
           END-IF.

      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK80AO
              MOVE DFHGREEN TO SCRNC IN BANK80AO
              MOVE DFHGREEN TO HEAD1C IN BANK80AO
              MOVE DFHGREEN TO DATEC IN BANK80AO
              MOVE DFHGREEN TO TXT02C IN BANK80AO
              MOVE DFHGREEN TO TRANC IN BANK80AO
              MOVE DFHGREEN TO HEAD2C IN BANK80AO
              MOVE DFHGREEN TO TIMEC IN BANK80AO
              MOVE DFHGREEN TO TXT03C IN BANK80AO
              MOVE DFHGREEN TO USERIDC IN BANK80AO
              MOVE DFHGREEN TO TXT04C IN BANK80AO
              MOVE DFHGREEN TO USERNMC IN BANK80AO
              MOVE DFHGREEN TO TXT05C IN BANK80AO
              MOVE DFHGREEN TO MADDR1C IN BANK80AO
              MOVE DFHGREEN TO MADDR2C IN BANK80AO
              MOVE DFHGREEN TO MSTATEC IN BANK80AO
              MOVE DFHGREEN TO MCNTRYC IN BANK80AO
              MOVE DFHGREEN TO MPSTCDEC IN BANK80AO
              MOVE DFHGREEN TO TXT06C IN BANK80AO
              MOVE DFHGREEN TO MEMAILC IN BANK80AO
              MOVE DFHGREEN TO TXT07C IN BANK80AO
              MOVE DFHGREEN TO TXT08C IN BANK80AO
              MOVE DFHGREEN TO OPT1C IN BANK80AO
              MOVE DFHGREEN TO TXT09C IN BANK80AO
              MOVE DFHGREEN TO OPT2C IN BANK80AO
              MOVE DFHGREEN TO ERRMSGC IN BANK80AO
              MOVE DFHGREEN TO TXT17C IN BANK80AO
              MOVE DFHGREEN TO VERC IN BANK80AO
           END-IF.

           EXEC CICS SEND MAP('BANK80A')
                          MAPSET('MBANK80')
                          CURSOR
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN80-BUILD-AND-SEND-EXIT.

       HELP80-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP80AO==.

           EXEC CICS SEND MAP('HELP80A')
                          MAPSET('MBANK80')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN80-BUILD-AND-SEND-EXIT.

       SCREEN80-BUILD-AND-SEND-INET.
           MOVE SPACES TO EXT-OP-DATA.
           MOVE WS-TRAN-ID TO EXT-OP-TRAN.
           MOVE DDO-DATA TO EXT-OP-DATE.
           MOVE DD-TIME-OUTPUT TO EXT-OP-TIME.
           CALL 'SCUSTOMP' USING SCREEN-TITLES.
           MOVE SCREEN-TITLE1 TO EXT-OP-HEAD1.
           MOVE SCREEN-TITLE2 TO EXT-OP-HEAD2.
           CALL 'SVERSONP' USING SCREEN-TITLES.
           MOVE VERSION TO EXT-OP-VERSION.
      * Move in screen name
           MOVE 'BANK80' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR80-ADDR1 TO EXT-OP80-ADDR1.
           MOVE BANK-SCR80-ADDR2 TO EXT-OP80-ADDR2.
           MOVE BANK-SCR80-STATE TO EXT-OP80-STATE.
           MOVE BANK-SCR80-CNTRY TO EXT-OP80-CNTRY.
           MOVE BANK-SCR80-PSTCDE TO EXT-OP80-PSTCDE.
           MOVE BANK-SCR80-EMAIL TO EXT-OP80-EMAIL.
           MOVE BANK-SCR80-OPT1 TO EXT-OP80-OPT1.
           MOVE BANK-SCR80-OPT2 TO EXT-OP80-OPT2.

       SCREEN80-BUILD-AND-SEND-EXIT.
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
