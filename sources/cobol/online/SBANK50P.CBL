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
      * Program:     SBANK50P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Transfer funds between accounts                  *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK50P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK50P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.
         05  WS-WORK1                              PIC X(1).
         05  WS-SUB1                               PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK50.

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
               PERFORM SCREEN50-READ THRU
                       SCREEN50-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN50-BUILD-AND-SEND THRU
                       SCREEN50-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK50                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN50-READ.
           MOVE 'BBANK50P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN50-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN50-READ-CICS
           ELSE
              GO TO SCREEN50-READ-INET
           END-IF.

       SCREEN50-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK50A')
                                MAPSET('MBANK50')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP50A')
                                MAPSET('MBANK50')
              END-EXEC
              GO TO SCREEN50-READ-EXIT
           END-IF.

           IF XFERAMTL IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-XFER
           ELSE
              MOVE XFERAMTI IN BANK50AI TO BANK-SCR50-XFER
              IF BANK-SCR50-XFER IS EQUAL TO SPACES
                 MOVE LOW-VALUES TO BANK-SCR50-XFER
           END-IF.

           IF FROM1L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-FRM1
           ELSE
              MOVE FROM1I IN BANK50AI TO BANK-SCR50-FRM1
              IF BANK-SCR50-FRM1 IS EQUAL TO SPACES OR
                 BANK-SCR50-FRM1 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-FRM1
           END-IF.

           IF FROM2L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-FRM2
           ELSE
              MOVE FROM2I IN BANK50AI TO BANK-SCR50-FRM2
              IF BANK-SCR50-FRM2 IS EQUAL TO SPACES OR
                 BANK-SCR50-FRM2 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-FRM2
           END-IF.

           IF FROM3L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-FRM3
           ELSE
              MOVE FROM3I IN BANK50AI TO BANK-SCR50-FRM3
              IF BANK-SCR50-FRM3 IS EQUAL TO SPACES OR
                 BANK-SCR50-FRM3 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-FRM3
           END-IF.

           IF FROM4L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-FRM4
           ELSE
              MOVE FROM4I IN BANK50AI TO BANK-SCR50-FRM4
              IF BANK-SCR50-FRM4 IS EQUAL TO SPACES OR
                 BANK-SCR50-FRM4 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-FRM4
           END-IF.

           IF FROM5L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-FRM5
           ELSE
              MOVE FROM5I IN BANK50AI TO BANK-SCR50-FRM5
              IF BANK-SCR50-FRM5 IS EQUAL TO SPACES OR
                 BANK-SCR50-FRM5 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-FRM5
           END-IF.

           IF FROM6L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-FRM6
           ELSE
              MOVE FROM6I IN BANK50AI TO BANK-SCR50-FRM6
              IF BANK-SCR50-FRM6 IS EQUAL TO SPACES OR
                 BANK-SCR50-FRM6 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-FRM6
           END-IF.

           IF TO1L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-TO1
           ELSE
              MOVE TO1I IN BANK50AI TO BANK-SCR50-TO1
              IF BANK-SCR50-TO1 IS EQUAL TO SPACES OR
                 BANK-SCR50-TO1 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-TO1
           END-IF.

           IF TO2L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-TO2
           ELSE
              MOVE TO2I IN BANK50AI TO BANK-SCR50-TO2
              IF BANK-SCR50-TO2 IS EQUAL TO SPACES OR
                 BANK-SCR50-TO2 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-TO2
           END-IF.

           IF TO3L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-TO3
           ELSE
              MOVE TO3I IN BANK50AI TO BANK-SCR50-TO3
              IF BANK-SCR50-TO3 IS EQUAL TO SPACES OR
                 BANK-SCR50-TO3 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-TO3
           END-IF.

           IF TO4L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-TO4
           ELSE
              MOVE TO4I IN BANK50AI TO BANK-SCR50-TO4
              IF BANK-SCR50-TO4 IS EQUAL TO SPACES OR
                 BANK-SCR50-TO4 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-TO4
           END-IF.

           IF TO5L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-TO5
           ELSE
              MOVE TO5I IN BANK50AI TO BANK-SCR50-TO5
              IF BANK-SCR50-TO5 IS EQUAL TO SPACES OR
                 BANK-SCR50-TO5 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-TO5
           END-IF.

           IF TO6L IN BANK50AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR50-TO6
           ELSE
              MOVE TO6I IN BANK50AI TO BANK-SCR50-TO6
              IF BANK-SCR50-TO6 IS EQUAL TO SPACES OR
                 BANK-SCR50-TO6 IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR50-TO6
           END-IF.

           GO TO SCREEN50-READ-EXIT.

       SCREEN50-READ-INET.
           MOVE EXT-IP50-XFER TO BANK-SCR50-XFER.
           MOVE EXT-IP50-FRM1 TO BANK-SCR50-FRM1.
           MOVE EXT-IP50-TO1 TO BANK-SCR50-TO1.
           MOVE EXT-IP50-FRM2 TO BANK-SCR50-FRM2.
           MOVE EXT-IP50-TO2 TO BANK-SCR50-TO2.
           MOVE EXT-IP50-FRM3 TO BANK-SCR50-FRM3.
           MOVE EXT-IP50-TO3 TO BANK-SCR50-TO3.
           MOVE EXT-IP50-FRM4 TO BANK-SCR50-FRM4.
           MOVE EXT-IP50-TO4 TO BANK-SCR50-TO4.
           MOVE EXT-IP50-FRM5 TO BANK-SCR50-FRM5.
           MOVE EXT-IP50-TO5 TO BANK-SCR50-TO5.
           MOVE EXT-IP50-FRM6 TO BANK-SCR50-FRM6.
           MOVE EXT-IP50-TO6 TO BANK-SCR50-TO6.
           GO TO SCREEN50-READ-EXIT.

       SCREEN50-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN50 (BANK50/HELP50)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN50-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK50AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK50' TO BANK-LAST-MAPSET
              MOVE 'HELP50A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK50' TO BANK-LAST-MAPSET
              MOVE 'BANK50A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN50-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN50-BUILD-AND-SEND-INET
           END-IF.

       SCREEN50-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK50A'
              GO TO BANK50-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP50A'
              GO TO HELP50-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK50-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK50AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK50AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK50AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK50AO.
           MOVE DDO-DATA TO DATEO IN BANK50AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK50AO.
      * Move in screen specific fields
           MOVE BANK-USERID TO USERIDO IN BANK50AO.
           MOVE BANK-USERID-NAME TO USERNMO IN BANK50AO.

           MOVE BANK-SCR50-XFER TO XFERAMTO IN BANK50AO.
           IF BANK-SCR50-ACC1 IS NOT EQUAL TO SPACES
              MOVE -1 TO FROM1L IN BANK50AI
              MOVE -1 TO TO1L IN BANK50AI
              MOVE BANK-SCR50-FRM1 TO FROM1O IN BANK50AO
              MOVE BANK-SCR50-TO1  TO TO1O  IN BANK50AO
              MOVE BANK-SCR50-ACC1 TO ACC1O IN BANK50AO
              MOVE BANK-SCR50-DSC1 TO DSC1O IN BANK50AO
              MOVE BANK-SCR50-BAL1 TO BAL1O IN BANK50AO
           ELSE
              MOVE DFHBMASK TO FROM1A IN BANK50AI
              MOVE DFHBMASK TO TO1A IN BANK50AI
              MOVE SPACES TO FROM1O IN BANK50AO
              MOVE SPACES TO TO1O IN BANK50AO
              MOVE SPACES TO ACC1O IN BANK50AO
              MOVE SPACES TO DSC1O IN BANK50AO
              MOVE SPACES TO BAL1O IN BANK50AO
           END-IF.
           IF BANK-SCR50-ACC2 IS NOT EQUAL TO SPACES
              MOVE -1 TO FROM2L IN BANK50AI
              MOVE -1 TO TO2L IN BANK50AI
              MOVE BANK-SCR50-FRM2 TO FROM2O IN BANK50AO
              MOVE BANK-SCR50-TO2  TO TO2O  IN BANK50AO
              MOVE BANK-SCR50-ACC2 TO ACC2O IN BANK50AO
              MOVE BANK-SCR50-DSC2 TO DSC2O IN BANK50AO
              MOVE BANK-SCR50-BAL2 TO BAL2O IN BANK50AO
           ELSE
              MOVE DFHBMASK TO FROM2A IN BANK50AI
              MOVE DFHBMASK TO TO2A IN BANK50AI
              MOVE SPACE TO FROM2O IN BANK50AO
              MOVE SPACE TO TO2O IN BANK50AO
              MOVE SPACES TO ACC2O IN BANK50AO
              MOVE SPACES TO DSC2O IN BANK50AO
              MOVE SPACES TO BAL2O IN BANK50AO
           END-IF.
           IF BANK-SCR50-ACC3 IS NOT EQUAL TO SPACES
              MOVE -1 TO FROM3L IN BANK50AI
              MOVE -1 TO TO3L IN BANK50AI
              MOVE BANK-SCR50-FRM3 TO FROM3O IN BANK50AO
              MOVE BANK-SCR50-TO3  TO TO3O  IN BANK50AO
              MOVE BANK-SCR50-ACC3 TO ACC3O IN BANK50AO
              MOVE BANK-SCR50-DSC3 TO DSC3O IN BANK50AO
              MOVE BANK-SCR50-BAL3 TO BAL3O IN BANK50AO
           ELSE
              MOVE DFHBMASK TO FROM3A IN BANK50AI
              MOVE DFHBMASK TO TO3A IN BANK50AI
              MOVE SPACE TO FROM3O IN BANK50AO
              MOVE SPACE TO TO3O IN BANK50AO
              MOVE SPACES TO ACC3O IN BANK50AO
              MOVE SPACES TO DSC3O IN BANK50AO
              MOVE SPACES TO BAL3O IN BANK50AO
           END-IF.
           IF BANK-SCR50-ACC4 IS NOT EQUAL TO SPACES
              MOVE -1 TO FROM4L IN BANK50AI
              MOVE -1 TO TO4L IN BANK50AI
              MOVE BANK-SCR50-FRM4 TO FROM4O IN BANK50AO
              MOVE BANK-SCR50-TO4  TO TO4O  IN BANK50AO
              MOVE BANK-SCR50-ACC4 TO ACC4O IN BANK50AO
              MOVE BANK-SCR50-DSC4 TO DSC4O IN BANK50AO
              MOVE BANK-SCR50-BAL4 TO BAL4O IN BANK50AO
           ELSE
              MOVE DFHBMASK TO FROM4A IN BANK50AI
              MOVE DFHBMASK TO TO4A IN BANK50AI
              MOVE SPACE TO FROM4O IN BANK50AO
              MOVE SPACE TO TO4O IN BANK50AO
              MOVE SPACES TO ACC4O IN BANK50AO
              MOVE SPACES TO DSC4O IN BANK50AO
              MOVE SPACES TO BAL4O IN BANK50AO
           END-IF.
           IF BANK-SCR50-ACC5 IS NOT EQUAL TO SPACES
              MOVE -1 TO FROM5L IN BANK50AI
              MOVE -1 TO TO5L IN BANK50AI
              MOVE BANK-SCR50-FRM5 TO FROM5O IN BANK50AO
              MOVE BANK-SCR50-TO5  TO TO5O  IN BANK50AO
              MOVE BANK-SCR50-ACC5 TO ACC5O IN BANK50AO
              MOVE BANK-SCR50-DSC5 TO DSC5O IN BANK50AO
              MOVE BANK-SCR50-BAL5 TO BAL5O IN BANK50AO
           ELSE
              MOVE DFHBMASK TO FROM5A IN BANK50AI
              MOVE DFHBMASK TO TO5A IN BANK50AI
              MOVE SPACE TO FROM5O IN BANK50AO
              MOVE SPACE TO TO5O IN BANK50AO
              MOVE SPACES TO ACC5O IN BANK50AO
              MOVE SPACES TO DSC5O IN BANK50AO
              MOVE SPACES TO BAL5O IN BANK50AO
           END-IF.
           IF BANK-SCR50-ACC6 IS NOT EQUAL TO SPACES
              MOVE -1 TO FROM6L IN BANK50AI
              MOVE -1 TO TO6L IN BANK50AI
              MOVE BANK-SCR50-FRM6 TO FROM6O IN BANK50AO
              MOVE BANK-SCR50-TO6  TO TO6O  IN BANK50AO
              MOVE BANK-SCR50-ACC6 TO ACC6O IN BANK50AO
              MOVE BANK-SCR50-DSC6 TO DSC6O IN BANK50AO
              MOVE BANK-SCR50-BAL6 TO BAL6O IN BANK50AO
           ELSE
              MOVE DFHBMASK TO FROM6A IN BANK50AI
              MOVE DFHBMASK TO TO6A IN BANK50AI
              MOVE SPACE TO FROM6O IN BANK50AO
              MOVE SPACE TO TO6O IN BANK50AO
              MOVE SPACES TO ACC6O IN BANK50AO
              MOVE SPACES TO DSC6O IN BANK50AO
              MOVE SPACES TO BAL6O IN BANK50AO
           END-IF.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK50AO
              MOVE DFHGREEN TO SCRNC IN BANK50AO
              MOVE DFHGREEN TO HEAD1C IN BANK50AO
              MOVE DFHGREEN TO DATEC IN BANK50AO
              MOVE DFHGREEN TO TXT02C IN BANK50AO
              MOVE DFHGREEN TO TRANC IN BANK50AO
              MOVE DFHGREEN TO HEAD2C IN BANK50AO
              MOVE DFHGREEN TO TIMEC IN BANK50AO
              MOVE DFHGREEN TO TXT03C IN BANK50AO
              MOVE DFHGREEN TO USERIDC IN BANK50AO
              MOVE DFHGREEN TO TXT04C IN BANK50AO
              MOVE DFHGREEN TO USERNMC IN BANK50AO
              MOVE DFHGREEN TO TXT05C IN BANK50AO
              MOVE DFHGREEN TO TXT06C IN BANK50AO
              MOVE DFHGREEN TO XFERAMTC IN BANK50AO
              MOVE DFHGREEN TO TXT07C IN BANK50AO
              MOVE DFHGREEN TO TXT08C IN BANK50AO
              MOVE DFHGREEN TO TXT09C IN BANK50AO
              MOVE DFHGREEN TO TXT10C IN BANK50AO
              MOVE DFHGREEN TO FROM1C IN BANK50AO
              MOVE DFHGREEN TO TO1C IN BANK50AO
              MOVE DFHGREEN TO ACC1C IN BANK50AO
              MOVE DFHGREEN TO DSC1C IN BANK50AO
              MOVE DFHGREEN TO BAL1C IN BANK50AO
              MOVE DFHGREEN TO FROM2C IN BANK50AO
              MOVE DFHGREEN TO TO2C IN BANK50AO
              MOVE DFHGREEN TO ACC2C IN BANK50AO
              MOVE DFHGREEN TO DSC2C IN BANK50AO
              MOVE DFHGREEN TO BAL2C IN BANK50AO
              MOVE DFHGREEN TO FROM3C IN BANK50AO
              MOVE DFHGREEN TO TO3C IN BANK50AO
              MOVE DFHGREEN TO ACC3C IN BANK50AO
              MOVE DFHGREEN TO DSC3C IN BANK50AO
              MOVE DFHGREEN TO BAL3C IN BANK50AO
              MOVE DFHGREEN TO FROM4C IN BANK50AO
              MOVE DFHGREEN TO TO4C IN BANK50AO
              MOVE DFHGREEN TO ACC4C IN BANK50AO
              MOVE DFHGREEN TO DSC4C IN BANK50AO
              MOVE DFHGREEN TO BAL4C IN BANK50AO
              MOVE DFHGREEN TO FROM5C IN BANK50AO
              MOVE DFHGREEN TO TO5C IN BANK50AO
              MOVE DFHGREEN TO ACC5C IN BANK50AO
              MOVE DFHGREEN TO DSC5C IN BANK50AO
              MOVE DFHGREEN TO BAL5C IN BANK50AO
              MOVE DFHGREEN TO FROM6C IN BANK50AO
              MOVE DFHGREEN TO TO6C IN BANK50AO
              MOVE DFHGREEN TO ACC6C IN BANK50AO
              MOVE DFHGREEN TO DSC6C IN BANK50AO
              MOVE DFHGREEN TO BAL6C IN BANK50AO
              MOVE DFHGREEN TO ERRMSGC IN BANK50AO
              MOVE DFHGREEN TO TXT11C IN BANK50AO
              MOVE DFHGREEN TO VERC IN BANK50AO
           END-IF.

           EXEC CICS SEND MAP('BANK50A')
                          MAPSET('MBANK50')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN50-BUILD-AND-SEND-EXIT.

       HELP50-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP50AO==.

           EXEC CICS SEND MAP('HELP50A')
                          MAPSET('MBANK50')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN50-BUILD-AND-SEND-EXIT.

       SCREEN50-BUILD-AND-SEND-INET.
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
           MOVE 'BANK50' TO EXT-OP-SCREEN.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR50-XFER TO EXT-OP50-XFER.
           MOVE BANK-SCR50-FRM1 TO EXT-OP50-FRM1.
           MOVE BANK-SCR50-TO1  TO EXT-OP50-TO1.
           MOVE BANK-SCR50-ACC1 TO EXT-OP50-ACC1.
           MOVE BANK-SCR50-DSC1 TO EXT-OP50-DSC1.
           MOVE BANK-SCR50-BAL1 TO EXT-OP50-BAL1.
           MOVE BANK-SCR50-FRM2 TO EXT-OP50-FRM2.
           MOVE BANK-SCR50-TO2  TO EXT-OP50-TO2.
           MOVE BANK-SCR50-ACC2 TO EXT-OP50-ACC2.
           MOVE BANK-SCR50-DSC2 TO EXT-OP50-DSC2.
           MOVE BANK-SCR50-BAL2 TO EXT-OP50-BAL2.
           MOVE BANK-SCR50-FRM3 TO EXT-OP50-FRM3.
           MOVE BANK-SCR50-TO3  TO EXT-OP50-TO3.
           MOVE BANK-SCR50-ACC3 TO EXT-OP50-ACC3.
           MOVE BANK-SCR50-DSC3 TO EXT-OP50-DSC3.
           MOVE BANK-SCR50-BAL3 TO EXT-OP50-BAL3.
           MOVE BANK-SCR50-FRM4 TO EXT-OP50-FRM4.
           MOVE BANK-SCR50-TO4  TO EXT-OP50-TO4.
           MOVE BANK-SCR50-ACC4 TO EXT-OP50-ACC4.
           MOVE BANK-SCR50-DSC4 TO EXT-OP50-DSC4.
           MOVE BANK-SCR50-BAL4 TO EXT-OP50-BAL4.
           MOVE BANK-SCR50-FRM5 TO EXT-OP50-FRM5.
           MOVE BANK-SCR50-TO5  TO EXT-OP50-TO5.
           MOVE BANK-SCR50-ACC5 TO EXT-OP50-ACC5.
           MOVE BANK-SCR50-DSC5 TO EXT-OP50-DSC5.
           MOVE BANK-SCR50-BAL5 TO EXT-OP50-BAL5.
           MOVE BANK-SCR50-FRM6 TO EXT-OP50-FRM6.
           MOVE BANK-SCR50-TO6  TO EXT-OP50-TO6.
           MOVE BANK-SCR50-ACC6 TO EXT-OP50-ACC6.
           MOVE BANK-SCR50-DSC6 TO EXT-OP50-DSC6.
           MOVE BANK-SCR50-BAL6 TO EXT-OP50-BAL6.

       SCREEN50-BUILD-AND-SEND-EXIT.
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
