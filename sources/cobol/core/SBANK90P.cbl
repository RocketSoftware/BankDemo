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
      * Program:     SBANK90P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Display request for informtion                   *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK90P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK90P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK90.

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
               PERFORM SCREEN90-READ THRU
                       SCREEN90-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN90-BUILD-AND-SEND THRU
                       SCREEN90-BUILD-AND-SEND-EXIT
             WHEN OTHER
               MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
               MOVE '0001' TO ABEND-CODE
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
      * Screen processing for MBANK90                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN90-READ.
           MOVE 'BBANK90P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN90-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN90-READ-CICS
           ELSE
              GO TO SCREEN90-READ-INET
           END-IF.

       SCREEN90-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK90A')
                                MAPSET('MBANK90')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP90A')
                                MAPSET('MBANK90')
              END-EXEC
              GO TO SCREEN90-READ-EXIT
           END-IF.

           GO TO SCREEN90-READ-EXIT.

       SCREEN90-READ-INET.
           GO TO SCREEN90-READ-EXIT.

       SCREEN90-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN90 (BANK90/HELP90)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN90-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK90AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MHELP90' TO BANK-LAST-MAPSET
              MOVE 'HELP90A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK90' TO BANK-LAST-MAPSET
              MOVE 'BANK90A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN90-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN90-BUILD-AND-SEND-INET
           END-IF.

       SCREEN90-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK90A'
              GO TO BANK90-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP90A'
              GO TO HELP90-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK90-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK90AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK90AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK90AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK90AO.
           MOVE DDO-DATA TO DATEO IN BANK90AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK90AO.
      * Move in screen specific fields
      * Move in screen specific fields
              MOVE BANK-SCR90-LINE (01) TO INF01O IN BANK90AO.
              MOVE BANK-SCR90-LINE (02) TO INF02O IN BANK90AO.
              MOVE BANK-SCR90-LINE (03) TO INF03O IN BANK90AO.
              MOVE BANK-SCR90-LINE (04) TO INF04O IN BANK90AO.
              MOVE BANK-SCR90-LINE (05) TO INF05O IN BANK90AO.
              MOVE BANK-SCR90-LINE (06) TO INF06O IN BANK90AO.
              MOVE BANK-SCR90-LINE (07) TO INF07O IN BANK90AO.
              MOVE BANK-SCR90-LINE (08) TO INF08O IN BANK90AO.
              MOVE BANK-SCR90-LINE (09) TO INF09O IN BANK90AO.
              MOVE BANK-SCR90-LINE (10) TO INF10O IN BANK90AO.
              MOVE BANK-SCR90-LINE (11) TO INF11O IN BANK90AO.
              MOVE BANK-SCR90-LINE (12) TO INF12O IN BANK90AO.
              MOVE BANK-SCR90-LINE (13) TO INF13O IN BANK90AO.
              MOVE BANK-SCR90-LINE (14) TO INF14O IN BANK90AO.
              MOVE BANK-SCR90-LINE (15) TO INF15O IN BANK90AO.
              MOVE BANK-SCR90-LINE (16) TO INF16O IN BANK90AO.
              MOVE BANK-SCR90-LINE (17) TO INF17O IN BANK90AO.
              MOVE BANK-SCR90-LINE (18) TO INF18O IN BANK90AO.
              MOVE BANK-SCR90-LINE (19) TO INF19O IN BANK90AO.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK90AO
              MOVE DFHGREEN TO SCRNC IN BANK90AO
              MOVE DFHGREEN TO HEAD1C IN BANK90AO
              MOVE DFHGREEN TO DATEC IN BANK90AO
              MOVE DFHGREEN TO TXT02C IN BANK90AO
              MOVE DFHGREEN TO TRANC IN BANK90AO
              MOVE DFHGREEN TO HEAD2C IN BANK90AO
              MOVE DFHGREEN TO TIMEC IN BANK90AO
              MOVE DFHGREEN TO INF01C IN BANK90AO
              MOVE DFHGREEN TO INF02C IN BANK90AO
              MOVE DFHGREEN TO INF03C IN BANK90AO
              MOVE DFHGREEN TO INF04C IN BANK90AO
              MOVE DFHGREEN TO INF05C IN BANK90AO
              MOVE DFHGREEN TO INF06C IN BANK90AO
              MOVE DFHGREEN TO INF07C IN BANK90AO
              MOVE DFHGREEN TO INF08C IN BANK90AO
              MOVE DFHGREEN TO INF09C IN BANK90AO
              MOVE DFHGREEN TO INF10C IN BANK90AO
              MOVE DFHGREEN TO INF11C IN BANK90AO
              MOVE DFHGREEN TO INF12C IN BANK90AO
              MOVE DFHGREEN TO INF13C IN BANK90AO
              MOVE DFHGREEN TO INF14C IN BANK90AO
              MOVE DFHGREEN TO INF15C IN BANK90AO
              MOVE DFHGREEN TO INF16C IN BANK90AO
              MOVE DFHGREEN TO INF17C IN BANK90AO
              MOVE DFHGREEN TO INF18C IN BANK90AO
              MOVE DFHGREEN TO INF19C IN BANK90AO
              MOVE DFHGREEN TO TXT03C IN BANK90AO
              MOVE DFHGREEN TO ERRMSGC IN BANK90AO
              MOVE DFHGREEN TO VERC IN BANK90AO
           END-IF.

           EXEC CICS SEND MAP('BANK90A')
                          MAPSET('MBANK90')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN90-BUILD-AND-SEND-EXIT.

       HELP90-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP90AO==.

           EXEC CICS SEND MAP('HELP90A')
                          MAPSET('MBANK90')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN90-BUILD-AND-SEND-EXIT.

       SCREEN90-BUILD-AND-SEND-INET.
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
           MOVE 'BANK90' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
      *    MOVE BANK-SCR20-SEL5TX TO EXT-OP20-SEL5TX.
           GO TO SCREEN90-BUILD-AND-SEND-EXIT.

       SCREEN90-BUILD-AND-SEND-EXIT.
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
