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
      * Program:     SBANK70P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Calculate cost of loan                           *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK70P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK70P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.
         05  WS-WORK1                              PIC X(1).
         05  WS-SUB1                               PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK70.

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
               PERFORM SCREEN70-READ THRU
                       SCREEN70-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN70-BUILD-AND-SEND THRU
                       SCREEN70-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK70                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN70-READ.
           MOVE 'BBANK70P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN70-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN70-READ-CICS
           ELSE
              GO TO SCREEN70-READ-INET
           END-IF.

       SCREEN70-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK70A')
                                MAPSET('MBANK70')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP70A')
                                MAPSET('MBANK70')
              END-EXEC
              GO TO SCREEN70-READ-EXIT
           END-IF.

           IF AMOUNTL IN BANK70AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR70-AMOUNT
           ELSE
              MOVE AMOUNTI IN BANK70AI TO BANK-SCR70-AMOUNT
              IF BANK-SCR70-AMOUNT IS EQUAL TO SPACES
                 MOVE LOW-VALUES TO BANK-SCR70-AMOUNT
           END-IF.

           IF RATEL IN BANK70AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR70-RATE
           ELSE
              MOVE RATEI IN BANK70AI TO BANK-SCR70-RATE
              IF BANK-SCR70-RATE IS EQUAL TO SPACES
                 MOVE LOW-VALUES TO BANK-SCR70-RATE
           END-IF.

           IF TERML IN BANK70AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR70-TERM
           ELSE
              MOVE TERMI IN BANK70AI TO BANK-SCR70-TERM
              IF BANK-SCR70-TERM IS EQUAL TO SPACES
                 MOVE LOW-VALUES TO BANK-SCR70-TERM
           END-IF.

           GO TO SCREEN70-READ-EXIT.

       SCREEN70-READ-INET.
           MOVE EXT-IP70-AMOUNT TO BANK-SCR70-AMOUNT.
           MOVE EXT-IP70-RATE TO BANK-SCR70-RATE.
           MOVE EXT-IP70-TERM TO BANK-SCR70-TERM.
           GO TO SCREEN70-READ-EXIT.

       SCREEN70-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN70 (BANK70/HELP70)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN70-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK70AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK70' TO BANK-LAST-MAPSET
              MOVE 'HELP70A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK70' TO BANK-LAST-MAPSET
              MOVE 'BANK70A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN70-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN70-BUILD-AND-SEND-INET
           END-IF.

       SCREEN70-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK70A'
              GO TO BANK70-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP70A'
              GO TO HELP70-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK70-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK70AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK70AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK70AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK70AO.
           MOVE DDO-DATA TO DATEO IN BANK70AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK70AO.
      * Move in screen specific fields
           MOVE BANK-SCR70-AMOUNT TO AMOUNTO IN BANK70AO.
           MOVE BANK-SCR70-RATE TO RATEO IN BANK70AO.
           MOVE BANK-SCR70-TERM TO TERMO IN BANK70AO.
           MOVE BANK-SCR70-PAYMENT TO PAYMENTO IN BANK70AO.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK70AO
              MOVE DFHGREEN TO SCRNC IN BANK70AO
              MOVE DFHGREEN TO HEAD1C IN BANK70AO
              MOVE DFHGREEN TO DATEC IN BANK70AO
              MOVE DFHGREEN TO TXT02C IN BANK70AO
              MOVE DFHGREEN TO TRANC IN BANK70AO
              MOVE DFHGREEN TO HEAD2C IN BANK70AO
              MOVE DFHGREEN TO TIMEC IN BANK70AO
              MOVE DFHGREEN TO TXT03C IN BANK70AO
              MOVE DFHGREEN TO TXT04C IN BANK70AO
              MOVE DFHGREEN TO TXT05C IN BANK70AO
              MOVE DFHGREEN TO AMOUNTC IN BANK70AO
              MOVE DFHGREEN TO TXT06C IN BANK70AO
              MOVE DFHGREEN TO RATEC IN BANK70AO
              MOVE DFHGREEN TO TXT07C IN BANK70AO
              MOVE DFHGREEN TO TERMC IN BANK70AO
              MOVE DFHGREEN TO TXT08C IN BANK70AO
              MOVE DFHGREEN TO PAYMENTC IN BANK70AO
              MOVE DFHGREEN TO ERRMSGC IN BANK70AO
              MOVE DFHGREEN TO TXT10C IN BANK70AO
              MOVE DFHGREEN TO VERC IN BANK70AO
           END-IF.
      * Hide line if no payment
           IF BANK-SCR70-PAYMENT IS EQUAL TO SPACES
              MOVE SPACES TO TXT08O IN BANK70AO
              MOVE SPACES TO PAYMENTO IN BANK70AO
           END-IF.
           EXEC CICS SEND MAP('BANK70A')
                          MAPSET('MBANK70')
                          ERASE
                          FREEKB
           END-EXEC.

           GO TO SCREEN70-BUILD-AND-SEND-EXIT.

       HELP70-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP70AO==.

           EXEC CICS SEND MAP('HELP70A')
                          MAPSET('MBANK70')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN70-BUILD-AND-SEND-EXIT.

       SCREEN70-BUILD-AND-SEND-INET.
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
           MOVE 'BANK70' TO EXT-OP-SCREEN.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR70-AMOUNT TO EXT-OP70-AMOUNT.
           MOVE BANK-SCR70-RATE TO EXT-OP70-RATE.
           MOVE BANK-SCR70-TERM TO EXT-OP70-TERM.
           MOVE BANK-SCR70-PAYMENT TO EXT-OP70-PAYMENT.

       SCREEN70-BUILD-AND-SEND-EXIT.
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
