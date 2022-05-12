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
      * Program:     SBANK35P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Display account details (extended)               *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK35P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK35P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.
         05  WS-WORK1                              PIC X(1).

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK35.

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
               PERFORM SCREEN35-READ THRU
                       SCREEN35-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN35-BUILD-AND-SEND THRU
                       SCREEN35-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK35                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN35-READ.
           MOVE 'BBANK35P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN35-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN35-READ-CICS
           ELSE
              GO TO SCREEN35-READ-INET
           END-IF.

       SCREEN35-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK35A')
                                MAPSET('MBANK35')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP35A')
                                MAPSET('MBANK35')
              END-EXEC
              GO TO SCREEN35-READ-EXIT
           END-IF.

           GO TO SCREEN35-READ-EXIT.

       SCREEN35-READ-INET.
           GO TO SCREEN35-READ-EXIT.

       SCREEN35-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN35 (BANK35/HELP35)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN35-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK35AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK35' TO BANK-LAST-MAPSET
              MOVE 'HELP35A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK35' TO BANK-LAST-MAPSET
              MOVE 'BANK35A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN35-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN35-BUILD-AND-SEND-INET
           END-IF.

       SCREEN35-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK35A'
              GO TO BANK35-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP35A'
              GO TO HELP35-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK35-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK35AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK35AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK35AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK35AO.
           MOVE DDO-DATA TO DATEO IN BANK35AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK35AO.
      * Move in screen specific fields
           MOVE BANK-USERID TO USERIDO IN BANK35AO.
           MOVE BANK-USERID-NAME TO USERNMO IN BANK35AO.

           MOVE BANK-SCR35-ACC TO ACCNOO IN BANK35AO.
           MOVE BANK-SCR35-DSC TO ACCTYPEO IN BANK35AO.

           MOVE BANK-SCR35-BAL TO BALO IN BANK35AO.
           MOVE BANK-SCR35-DTE TO DTEO IN BANK35AO.

           MOVE BANK-SCR35-TRANS TO TRANSO IN BANK35AO.

           IF BANK-SCR35-ATM-ENABLED IS EQUAL TO 'Y'
              MOVE 'Yes' TO ATMVISO IN BANK35AO
              MOVE BANK-SCR35-ATM-LIM TO ATMLIMO IN BANK35AO
              MOVE BANK-SCR35-ATM-LDTE TO ATMLDTEO IN BANK35AO
              MOVE BANK-SCR35-ATM-LAMT TO ATMLAMTO IN BANK35AO
           ELSE
              MOVE 'No' TO ATMVISO IN BANK35AO
              MOVE SPACES TO TXT11O IN BANK35AO
              MOVE SPACES TO ATMLIMO IN BANK35AO
              MOVE SPACES TO TXT12O IN BANK35AO
              MOVE SPACES TO ATMLDTEO IN BANK35AO
              MOVE SPACES TO TXT13O IN BANK35AO
              MOVE SPACES TO ATMLAMTO IN BANK35AO
           END-IF.
           IF BANK-SCR35-RP1ACC IS NOT EQUAL TO SPACES
              MOVE BANK-SCR35-RP1DAY TO RP1DAYO IN BANK35AO
              MOVE BANK-SCR35-RP1AMT TO RP1AMTO IN BANK35AO
              MOVE BANK-SCR35-RP1PID TO RP1PIDO IN BANK35AO
              MOVE '/' TO RP1SEPO IN BANK35AO
              MOVE BANK-SCR35-RP1ACC TO RP1ACCO IN BANK35AO
              MOVE BANK-SCR35-RP1DTE TO RP1DTEO IN BANK35AO
           ELSE
              MOVE SPACES TO RP1DAYO IN BANK35AO
              MOVE SPACES TO RP1AMTO IN BANK35AO
              MOVE SPACES TO RP1PIDO IN BANK35AO
              MOVE SPACES TO RP1SEPO IN BANK35AO
              MOVE SPACES TO RP1ACCO IN BANK35AO
              MOVE SPACES TO RP1DTEO IN BANK35AO
           END-IF.
           IF BANK-SCR35-RP2ACC IS NOT EQUAL TO SPACES
              MOVE BANK-SCR35-RP2DAY TO RP2DAYO IN BANK35AO
              MOVE BANK-SCR35-RP2AMT TO RP2AMTO IN BANK35AO
              MOVE BANK-SCR35-RP2PID TO RP2PIDO IN BANK35AO
              MOVE '/' TO RP2SEPO IN BANK35AO
              MOVE BANK-SCR35-RP2ACC TO RP2ACCO IN BANK35AO
              MOVE BANK-SCR35-RP2DTE TO RP2DTEO IN BANK35AO
           ELSE
              MOVE SPACES TO RP2DAYO IN BANK35AO
              MOVE SPACES TO RP2AMTO IN BANK35AO
              MOVE SPACES TO RP2PIDO IN BANK35AO
              MOVE SPACES TO RP2SEPO IN BANK35AO
              MOVE SPACES TO RP2ACCO IN BANK35AO
              MOVE SPACES TO RP2DTEO IN BANK35AO
           END-IF.
           IF BANK-SCR35-RP3ACC IS NOT EQUAL TO SPACES
              MOVE BANK-SCR35-RP3DAY TO RP3DAYO IN BANK35AO
              MOVE BANK-SCR35-RP3AMT TO RP3AMTO IN BANK35AO
              MOVE BANK-SCR35-RP3PID TO RP3PIDO IN BANK35AO
              MOVE '/' TO RP3SEPO IN BANK35AO
              MOVE BANK-SCR35-RP3ACC TO RP3ACCO IN BANK35AO
              MOVE BANK-SCR35-RP3DTE TO RP3DTEO IN BANK35AO
           ELSE
              MOVE SPACES TO RP3DAYO IN BANK35AO
              MOVE SPACES TO RP3AMTO IN BANK35AO
              MOVE SPACES TO RP3PIDO IN BANK35AO
              MOVE SPACES TO RP3SEPO IN BANK35AO
              MOVE SPACES TO RP3ACCO IN BANK35AO
              MOVE SPACES TO RP3DTEO IN BANK35AO
           END-IF.

           IF BANK-SCR35-TRANS(1:1) IS NOT NUMERIC
              MOVE SPACES TO TXNPFKO IN BANK35AO
           END-IF.

      * Turn colour off if requ8red
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK35AO
              MOVE DFHGREEN TO SCRNC IN BANK35AO
              MOVE DFHGREEN TO HEAD1C IN BANK35AO
              MOVE DFHGREEN TO DATEC IN BANK35AO
              MOVE DFHGREEN TO TXT02C IN BANK35AO
              MOVE DFHGREEN TO TRANC IN BANK35AO
              MOVE DFHGREEN TO HEAD2C IN BANK35AO
              MOVE DFHGREEN TO TIMEC IN BANK35AO
              MOVE DFHGREEN TO TXT03C IN BANK35AO
              MOVE DFHGREEN TO USERIDC IN BANK35AO
              MOVE DFHGREEN TO TXT13C IN BANK35AO
              MOVE DFHGREEN TO TXT04C IN BANK35AO
              MOVE DFHGREEN TO USERNMC IN BANK35AO
              MOVE DFHGREEN TO TXT05C IN BANK35AO
              MOVE DFHGREEN TO ACCNOC IN BANK35AO
              MOVE DFHGREEN TO ACCTYPEC IN BANK35AO
              MOVE DFHGREEN TO TXT06C IN BANK35AO
              MOVE DFHGREEN TO BALC IN BANK35AO
              MOVE DFHGREEN TO TXT07C IN BANK35AO
              MOVE DFHGREEN TO DTEC IN BANK35AO
              MOVE DFHGREEN TO TXT08C IN BANK35AO
              MOVE DFHGREEN TO TRANSC IN BANK35AO
              MOVE DFHGREEN TO TXT09C IN BANK35AO
              MOVE DFHGREEN TO TXT10C IN BANK35AO
              MOVE DFHGREEN TO ATMVISC IN BANK35AO
              MOVE DFHGREEN TO TXT11C IN BANK35AO
              MOVE DFHGREEN TO ATMLIMC IN BANK35AO
              MOVE DFHGREEN TO TXT12C IN BANK35AO
              MOVE DFHGREEN TO ATMLDTEC IN BANK35AO
              MOVE DFHGREEN TO TXT13C IN BANK35AO
              MOVE DFHGREEN TO ATMLAMTC IN BANK35AO
              MOVE DFHGREEN TO TXT14C IN BANK35AO
              MOVE DFHGREEN TO TXT15C IN BANK35AO
              MOVE DFHGREEN TO TXT16C IN BANK35AO
              MOVE DFHGREEN TO TXT17C IN BANK35AO
              MOVE DFHGREEN TO TXT18C IN BANK35AO
              MOVE DFHGREEN TO RP1DAYC IN BANK35AO
              MOVE DFHGREEN TO RP1AMTC IN BANK35AO
              MOVE DFHGREEN TO RP1PIDC IN BANK35AO
              MOVE DFHGREEN TO RP1SEPC IN BANK35AO
              MOVE DFHGREEN TO RP1ACCC IN BANK35AO
              MOVE DFHGREEN TO RP1DTEC IN BANK35AO
              MOVE DFHGREEN TO RP2DAYC IN BANK35AO
              MOVE DFHGREEN TO RP2AMTC IN BANK35AO
              MOVE DFHGREEN TO RP2PIDC IN BANK35AO
              MOVE DFHGREEN TO RP2SEPC IN BANK35AO
              MOVE DFHGREEN TO RP2ACCC IN BANK35AO
              MOVE DFHGREEN TO RP2DTEC IN BANK35AO
              MOVE DFHGREEN TO RP3DAYC IN BANK35AO
              MOVE DFHGREEN TO RP3AMTC IN BANK35AO
              MOVE DFHGREEN TO RP3PIDC IN BANK35AO
              MOVE DFHGREEN TO RP3SEPC IN BANK35AO
              MOVE DFHGREEN TO RP3ACCC IN BANK35AO
              MOVE DFHGREEN TO RP3DTEC IN BANK35AO
              MOVE DFHGREEN TO ERRMSGC IN BANK35AO
              MOVE DFHGREEN TO TXT19C IN BANK35AO
              MOVE DFHGREEN TO TXNPFKC IN BANK35AO
              MOVE DFHGREEN TO VERC IN BANK35AO
           END-IF.

           EXEC CICS SEND MAP('BANK35A')
                          MAPSET('MBANK35')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN35-BUILD-AND-SEND-EXIT.

       HELP35-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP35AO==.

           EXEC CICS SEND MAP('HELP35A')
                          MAPSET('MBANK35')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN35-BUILD-AND-SEND-EXIT.

       SCREEN35-BUILD-AND-SEND-INET.
           MOVE SPACES TO EXT-OP-DATA.
           MOVE WS-TRAN-ID TO EXT-OP-TRAN.
           MOVE DDO-DATA TO EXT-OP-DATE.
           MOVE DD-TIME-OUTPUT TO EXT-OP-TIME.
           CALL 'SCUSTOMP' USING SCREEN-TITLES.
           MOVE SCREEN-TITLE1 TO EXT-OP-HEAD1.
           MOVE SCREEN-TITLE2 TO EXT-OP-HEAD2.
           CALL 'SVERSONP' USING VERSION.
           MOVE VERSION TO EXT-OP-VERSION.
      * Move in screen name
           MOVE 'BANK35' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR35-ACC TO EXT-OP35-ACCNO.
           MOVE BANK-SCR35-DSC TO EXT-OP35-ACCTYPE.
           MOVE BANK-SCR35-BAL TO EXT-OP35-BALANCE.
           MOVE BANK-SCR35-DTE TO EXT-OP35-STMT-DATE.
           MOVE BANK-SCR35-ATM-ENABLED TO EXT-OP35-ATM-VIS.
           MOVE BANK-SCR35-ATM-LIM TO EXT-OP35-ATM-LIM
           MOVE BANK-SCR35-ATM-LDTE TO EXT-OP35-ATM-LDTE.
           MOVE BANK-SCR35-ATM-LAMT TO EXT-OP35-ATM-LAMT.
           IF BANK-SCR35-RP1ACC IS NOT EQUAL TO SPACES
              MOVE BANK-SCR35-RP1DAY TO EXT-OP35-RP-DAY(1)
              MOVE BANK-SCR35-RP1AMT TO EXT-OP35-RP-AMT(1)
              MOVE BANK-SCR35-RP1PID TO EXT-OP35-RP-PID(1)
              MOVE BANK-SCR35-RP1ACC TO EXT-OP35-RP-ACC(1)
              MOVE BANK-SCR35-RP1DTE TO EXT-OP35-RP-DTE(1)
           ELSE
              MOVE SPACES TO EXT-OP35-RP-DETAILS(1)
           END-IF.
           IF BANK-SCR35-RP2ACC IS NOT EQUAL TO SPACES
              MOVE BANK-SCR35-RP2DAY TO EXT-OP35-RP-DAY(2)
              MOVE BANK-SCR35-RP2AMT TO EXT-OP35-RP-AMT(2)
              MOVE BANK-SCR35-RP2PID TO EXT-OP35-RP-PID(2)
              MOVE BANK-SCR35-RP2ACC TO EXT-OP35-RP-ACC(2)
              MOVE BANK-SCR35-RP2DTE TO EXT-OP35-RP-DTE(2)
           ELSE
              MOVE SPACES TO EXT-OP35-RP-DETAILS(2)
           END-IF.
           IF BANK-SCR35-RP3ACC IS NOT EQUAL TO SPACES
              MOVE BANK-SCR35-RP3DAY TO EXT-OP35-RP-DAY(3)
              MOVE BANK-SCR35-RP3AMT TO EXT-OP35-RP-AMT(3)
              MOVE BANK-SCR35-RP3PID TO EXT-OP35-RP-PID(3)
              MOVE BANK-SCR35-RP3ACC TO EXT-OP35-RP-ACC(3)
              MOVE BANK-SCR35-RP3DTE TO EXT-OP35-RP-DTE(3)
           ELSE
              MOVE SPACES TO EXT-OP35-RP-DETAILS(3)
           END-IF.

       SCREEN35-BUILD-AND-SEND-EXIT.
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
