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
      * Program:     SBANK30P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Display account balances                         *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK30P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK30P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.
         05  WS-WORK1                              PIC X(1).
         05  WS-SUB1                               PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK30.

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
               PERFORM SCREEN30-READ THRU
                       SCREEN30-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN30-BUILD-AND-SEND THRU
                       SCREEN30-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK30                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN30-READ.
           MOVE 'BBANK30P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN30-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN30-READ-CICS
           ELSE
              GO TO SCREEN30-READ-INET
           END-IF.

       SCREEN30-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK30A')
                                MAPSET('MBANK30')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP30A')
                                MAPSET('MBANK30')
              END-EXEC
              GO TO SCREEN30-READ-EXIT
           END-IF.

           IF DET1L IN BANK30AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR30-DET1
           ELSE
              MOVE DET1I IN BANK30AI TO BANK-SCR30-DET1
              IF BANK-SCR30-DET1 IS EQUAL TO SPACES OR
                 BANK-SCR30-DET1 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR30-DET1
           END-IF.

           IF DET2L IN BANK30AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR30-DET2
           ELSE
              MOVE DET2I IN BANK30AI TO BANK-SCR30-DET2
              IF BANK-SCR30-DET2 IS EQUAL TO SPACES OR
                 BANK-SCR30-DET2 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR30-DET2
           END-IF.

           IF DET3L IN BANK30AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR30-DET3
           ELSE
              MOVE DET3I IN BANK30AI TO BANK-SCR30-DET3
              IF BANK-SCR30-DET3 IS EQUAL TO SPACES OR
                 BANK-SCR30-DET3 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR30-DET3
           END-IF.

           IF DET4L IN BANK30AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR30-DET4
           ELSE
              MOVE DET4I IN BANK30AI TO BANK-SCR30-DET4
              IF BANK-SCR30-DET4 IS EQUAL TO SPACES OR
                 BANK-SCR30-DET4 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR30-DET4
           END-IF.

           IF DET5L IN BANK30AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR30-DET5
           ELSE
              MOVE DET5I IN BANK30AI TO BANK-SCR30-DET5
              IF BANK-SCR30-DET5 IS EQUAL TO SPACES OR
                 BANK-SCR30-DET5 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR30-DET5
           END-IF.

           IF DET6L IN BANK30AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR30-DET6
           ELSE
              MOVE DET6I IN BANK30AI TO BANK-SCR30-DET6
              IF BANK-SCR30-DET6 IS EQUAL TO SPACES OR
                 BANK-SCR30-DET6 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR30-DET6
           END-IF.

           GO TO SCREEN30-READ-EXIT.

       SCREEN30-READ-INET.
           MOVE EXT-IP30-DET1 TO BANK-SCR30-DET1.
           MOVE EXT-IP30-DET2 TO BANK-SCR30-DET2.
           MOVE EXT-IP30-DET3 TO BANK-SCR30-DET3.
           MOVE EXT-IP30-DET4 TO BANK-SCR30-DET4.
           MOVE EXT-IP30-DET5 TO BANK-SCR30-DET5.
           MOVE EXT-IP30-DET6 TO BANK-SCR30-DET6.
           GO TO SCREEN30-READ-EXIT.

       SCREEN30-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN30 (BANK30/HELP30)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN30-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK30AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK30' TO BANK-LAST-MAPSET
              MOVE 'HELP30A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK30' TO BANK-LAST-MAPSET
              MOVE 'BANK30A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN30-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN30-BUILD-AND-SEND-INET
           END-IF.

       SCREEN30-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK30A'
              GO TO BANK30-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP30A'
              GO TO HELP30-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK30-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK30AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK30AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK30AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK30AO.
           MOVE DDO-DATA TO DATEO IN BANK30AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK30AO.
      * Move in screen specific fields
           MOVE BANK-USERID TO USERIDO IN BANK30AO.
           MOVE BANK-USERID-NAME TO USERNMO IN BANK30AO.

           IF BANK-SCR30-ACC1 IS NOT EQUAL TO SPACES
              MOVE -1 TO DET1L IN BANK30AI
              MOVE BANK-SCR30-DET1 TO DET1O IN BANK30AO
           ELSE
              MOVE DFHBMASK TO DET1A IN BANK30AI
              MOVE SPACE TO DET1O IN BANK30AO
           END-IF.
           MOVE BANK-SCR30-ACC1 TO ACC1O IN BANK30AO.
           MOVE BANK-SCR30-DSC1 TO DSC1O IN BANK30AO.
           MOVE BANK-SCR30-BAL1 TO BAL1O IN BANK30AO.
           MOVE BANK-SCR30-SRV1 TO SRV1O IN BANK30AO.
           MOVE BANK-SCR30-DTE1 TO DTE1O IN BANK30AO.
           MOVE BANK-SCR30-TXN1 TO TXN1O IN BANK30AO.

           IF BANK-SCR30-ACC2 IS NOT EQUAL TO SPACES
              MOVE -1 TO DET2L IN BANK30AI
              MOVE BANK-SCR30-DET2 TO DET2O IN BANK30AO
           ELSE
              MOVE DFHBMASK TO DET2A IN BANK30AI
              MOVE SPACE TO DET2O IN BANK30AO
           END-IF.
           MOVE BANK-SCR30-ACC2 TO ACC2O IN BANK30AO.
           MOVE BANK-SCR30-DSC2 TO DSC2O IN BANK30AO.
           MOVE BANK-SCR30-BAL2 TO BAL2O IN BANK30AO.
           MOVE BANK-SCR30-SRV2 TO SRV2O IN BANK30AO.
           MOVE BANK-SCR30-DTE2 TO DTE2O IN BANK30AO.
           MOVE BANK-SCR30-TXN2 TO TXN2O IN BANK30AO.

           IF BANK-SCR30-ACC3 IS NOT EQUAL TO SPACES
              MOVE -1 TO DET3L IN BANK30AI
              MOVE BANK-SCR30-DET3 TO DET3O IN BANK30AO
           ELSE
              MOVE DFHBMASK TO DET3A IN BANK30AI
              MOVE SPACE TO DET3O IN BANK30AO
           END-IF.
           MOVE BANK-SCR30-ACC3 TO ACC3O IN BANK30AO.
           MOVE BANK-SCR30-DSC3 TO DSC3O IN BANK30AO.
           MOVE BANK-SCR30-BAL3 TO BAL3O IN BANK30AO.
           MOVE BANK-SCR30-SRV3 TO SRV3O IN BANK30AO.
           MOVE BANK-SCR30-DTE3 TO DTE3O IN BANK30AO.
           MOVE BANK-SCR30-TXN3 TO TXN3O IN BANK30AO.

           IF BANK-SCR30-ACC4 IS NOT EQUAL TO SPACES
              MOVE -1 TO DET4L IN BANK30AI
              MOVE BANK-SCR30-DET4 TO DET4O IN BANK30AO
           ELSE
              MOVE DFHBMASK TO DET4A IN BANK30AI
              MOVE SPACE TO DET4O IN BANK30AO
           END-IF.
           MOVE BANK-SCR30-ACC4 TO ACC4O IN BANK30AO.
           MOVE BANK-SCR30-DSC4 TO DSC4O IN BANK30AO.
           MOVE BANK-SCR30-BAL4 TO BAL4O IN BANK30AO.
           MOVE BANK-SCR30-SRV4 TO SRV4O IN BANK30AO.
           MOVE BANK-SCR30-DTE4 TO DTE4O IN BANK30AO.
           MOVE BANK-SCR30-TXN4 TO TXN4O IN BANK30AO.

           IF BANK-SCR30-ACC5 IS NOT EQUAL TO SPACES
              MOVE -1 TO DET5L IN BANK30AI
              MOVE BANK-SCR30-DET5 TO DET5O IN BANK30AO
           ELSE
              MOVE DFHBMASK TO DET5A IN BANK30AI
              MOVE SPACE TO DET5O IN BANK30AO
           END-IF.
           MOVE BANK-SCR30-ACC5 TO ACC5O IN BANK30AO.
           MOVE BANK-SCR30-DSC5 TO DSC5O IN BANK30AO.
           MOVE BANK-SCR30-BAL5 TO BAL5O IN BANK30AO.
           MOVE BANK-SCR30-SRV5 TO SRV5O IN BANK30AO.
           MOVE BANK-SCR30-DTE5 TO DTE5O IN BANK30AO.
           MOVE BANK-SCR30-TXN5 TO TXN5O IN BANK30AO.

           IF BANK-SCR30-ACC6 IS NOT EQUAL TO SPACES
              MOVE -1 TO DET6L IN BANK30AI
              MOVE BANK-SCR30-DET6 TO DET6O IN BANK30AO
           ELSE
              MOVE DFHBMASK TO DET6A IN BANK30AI
              MOVE SPACE TO DET6O IN BANK30AO
           END-IF.
           MOVE BANK-SCR30-ACC6 TO ACC6O IN BANK30AO.
           MOVE BANK-SCR30-DSC6 TO DSC6O IN BANK30AO.
           MOVE BANK-SCR30-BAL6 TO BAL6O IN BANK30AO.
           MOVE BANK-SCR30-SRV6 TO SRV6O IN BANK30AO.
           MOVE BANK-SCR30-DTE6 TO DTE6O IN BANK30AO.
           MOVE BANK-SCR30-TXN6 TO TXN6O IN BANK30AO.

           MOVE BANK-SCR30-SRVMSG TO SRVMSGO IN BANK30AO.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK30AO
              MOVE DFHGREEN TO SCRNC IN BANK30AO
              MOVE DFHGREEN TO HEAD1C IN BANK30AO
              MOVE DFHGREEN TO DATEC IN BANK30AO
              MOVE DFHGREEN TO TXT02C IN BANK30AO
              MOVE DFHGREEN TO TRANC IN BANK30AO
              MOVE DFHGREEN TO HEAD2C IN BANK30AO
              MOVE DFHGREEN TO TIMEC IN BANK30AO
              MOVE DFHGREEN TO TXT03C IN BANK30AO
              MOVE DFHGREEN TO USERIDC IN BANK30AO
              MOVE DFHGREEN TO TXT04C IN BANK30AO
              MOVE DFHGREEN TO USERNMC IN BANK30AO
              MOVE DFHGREEN TO TXT05C IN BANK30AO
              MOVE DFHGREEN TO TXT06C IN BANK30AO
              MOVE DFHGREEN TO TXT07C IN BANK30AO
              MOVE DFHGREEN TO TXT08C IN BANK30AO
              MOVE DFHGREEN TO TXT09C IN BANK30AO
              MOVE DFHGREEN TO TXT10C IN BANK30AO
              MOVE DFHGREEN TO TXT11C IN BANK30AO
              MOVE DFHGREEN TO TXT12C IN BANK30AO
              MOVE DFHGREEN TO TXT13C IN BANK30AO
              MOVE DFHGREEN TO TXT14C IN BANK30AO
              MOVE DFHGREEN TO TXT15C IN BANK30AO
              MOVE DFHGREEN TO DET1C IN BANK30AO
              MOVE DFHGREEN TO ACC1C IN BANK30AO
              MOVE DFHGREEN TO DSC1C IN BANK30AO
              MOVE DFHGREEN TO BAL1C IN BANK30AO
              MOVE DFHGREEN TO SRV1C IN BANK30AO
              MOVE DFHGREEN TO DTE1C IN BANK30AO
              MOVE DFHGREEN TO TXN1C IN BANK30AO
              MOVE DFHGREEN TO DET2C IN BANK30AO
              MOVE DFHGREEN TO ACC2C IN BANK30AO
              MOVE DFHGREEN TO DSC2C IN BANK30AO
              MOVE DFHGREEN TO BAL2C IN BANK30AO
              MOVE DFHGREEN TO SRV2C IN BANK30AO
              MOVE DFHGREEN TO DTE2C IN BANK30AO
              MOVE DFHGREEN TO TXN2C IN BANK30AO
              MOVE DFHGREEN TO ACC3C IN BANK30AO
              MOVE DFHGREEN TO DSC3C IN BANK30AO
              MOVE DFHGREEN TO BAL3C IN BANK30AO
              MOVE DFHGREEN TO SRV3C IN BANK30AO
              MOVE DFHGREEN TO DTE3C IN BANK30AO
              MOVE DFHGREEN TO TXN3C IN BANK30AO
              MOVE DFHGREEN TO DET4C IN BANK30AO
              MOVE DFHGREEN TO ACC4C IN BANK30AO
              MOVE DFHGREEN TO DSC4C IN BANK30AO
              MOVE DFHGREEN TO BAL4C IN BANK30AO
              MOVE DFHGREEN TO SRV4C IN BANK30AO
              MOVE DFHGREEN TO DTE4C IN BANK30AO
              MOVE DFHGREEN TO TXN4C IN BANK30AO
              MOVE DFHGREEN TO DET5C IN BANK30AO
              MOVE DFHGREEN TO ACC5C IN BANK30AO
              MOVE DFHGREEN TO DSC5C IN BANK30AO
              MOVE DFHGREEN TO BAL5C IN BANK30AO
              MOVE DFHGREEN TO SRV5C IN BANK30AO
              MOVE DFHGREEN TO DTE5C IN BANK30AO
              MOVE DFHGREEN TO TXN5C IN BANK30AO
              MOVE DFHGREEN TO DET6C IN BANK30AO
              MOVE DFHGREEN TO ACC6C IN BANK30AO
              MOVE DFHGREEN TO DSC6C IN BANK30AO
              MOVE DFHGREEN TO BAL6C IN BANK30AO
              MOVE DFHGREEN TO SRV6C IN BANK30AO
              MOVE DFHGREEN TO DTE6C IN BANK30AO
              MOVE DFHGREEN TO TXN6C IN BANK30AO
              MOVE DFHGREEN TO SRVMSGC IN BANK30AO
              MOVE DFHGREEN TO ERRMSGC IN BANK30AO
              MOVE DFHGREEN TO TXT16C IN BANK30AO
              MOVE DFHGREEN TO VERC IN BANK30AO
           END-IF.

           EXEC CICS SEND MAP('BANK30A')
                          MAPSET('MBANK30')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN30-BUILD-AND-SEND-EXIT.

       HELP30-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP30AO==.

           EXEC CICS SEND MAP('HELP30A')
                          MAPSET('MBANK30')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN30-BUILD-AND-SEND-EXIT.

       SCREEN30-BUILD-AND-SEND-INET.
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
           MOVE 'BANK30' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR30-DET1 TO EXT-OP30-DET1.
           MOVE BANK-SCR30-ACC1 TO EXT-OP30-ACC1.
           MOVE BANK-SCR30-DSC1 TO EXT-OP30-DSC1.
           MOVE BANK-SCR30-BAL1 TO EXT-OP30-BAL1.
           MOVE BANK-SCR30-SRV1 TO EXT-OP30-SRV1.
           MOVE BANK-SCR30-DTE1 TO EXT-OP30-DTE1.
           MOVE BANK-SCR30-TXN1 TO EXT-OP30-TXN1.
           MOVE BANK-SCR30-DET2 TO EXT-OP30-DET2.
           MOVE BANK-SCR30-ACC2 TO EXT-OP30-ACC2.
           MOVE BANK-SCR30-DSC2 TO EXT-OP30-DSC2.
           MOVE BANK-SCR30-BAL2 TO EXT-OP30-BAL2.
           MOVE BANK-SCR30-SRV2 TO EXT-OP30-SRV2.
           MOVE BANK-SCR30-DTE2 TO EXT-OP30-DTE2.
           MOVE BANK-SCR30-TXN2 TO EXT-OP30-TXN2.
           MOVE BANK-SCR30-DET3 TO EXT-OP30-DET3.
           MOVE BANK-SCR30-ACC3 TO EXT-OP30-ACC3.
           MOVE BANK-SCR30-DSC3 TO EXT-OP30-DSC3.
           MOVE BANK-SCR30-BAL3 TO EXT-OP30-BAL3.
           MOVE BANK-SCR30-SRV3 TO EXT-OP30-SRV3.
           MOVE BANK-SCR30-DTE3 TO EXT-OP30-DTE3.
           MOVE BANK-SCR30-TXN3 TO EXT-OP30-TXN3.
           MOVE BANK-SCR30-DET4 TO EXT-OP30-DET4.
           MOVE BANK-SCR30-ACC4 TO EXT-OP30-ACC4.
           MOVE BANK-SCR30-DSC4 TO EXT-OP30-DSC4.
           MOVE BANK-SCR30-BAL4 TO EXT-OP30-BAL4.
           MOVE BANK-SCR30-SRV4 TO EXT-OP30-SRV4.
           MOVE BANK-SCR30-DTE4 TO EXT-OP30-DTE4.
           MOVE BANK-SCR30-TXN4 TO EXT-OP30-TXN4.
           MOVE BANK-SCR30-DET5 TO EXT-OP30-DET5.
           MOVE BANK-SCR30-ACC5 TO EXT-OP30-ACC5.
           MOVE BANK-SCR30-DSC5 TO EXT-OP30-DSC5.
           MOVE BANK-SCR30-BAL5 TO EXT-OP30-BAL5.
           MOVE BANK-SCR30-SRV5 TO EXT-OP30-SRV5.
           MOVE BANK-SCR30-DTE5 TO EXT-OP30-DTE5.
           MOVE BANK-SCR30-TXN5 TO EXT-OP30-TXN5.
           MOVE BANK-SCR30-DET6 TO EXT-OP30-DET6.
           MOVE BANK-SCR30-ACC6 TO EXT-OP30-ACC6.
           MOVE BANK-SCR30-DSC6 TO EXT-OP30-DSC6.
           MOVE BANK-SCR30-BAL6 TO EXT-OP30-BAL6.
           MOVE BANK-SCR30-SRV6 TO EXT-OP30-SRV6.
           MOVE BANK-SCR30-DTE6 TO EXT-OP30-DTE6.
           MOVE BANK-SCR30-TXN6 TO EXT-OP30-TXN6.

       SCREEN30-BUILD-AND-SEND-EXIT.
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
