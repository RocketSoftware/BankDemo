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
      * Program:     SBANK60P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Update address & telno                           *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK60P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK60P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.
         05  WS-WORK1                              PIC X(1).
         05  WS-SUB1                               PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK60.

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
               PERFORM SCREEN60-READ THRU
                       SCREEN60-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN60-BUILD-AND-SEND THRU
                       SCREEN60-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK60                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN60-READ.
           MOVE 'BBANK60P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN60-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN60-READ-CICS
           ELSE
              GO TO SCREEN60-READ-INET
           END-IF.

       SCREEN60-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK60A')
                                MAPSET('MBANK60')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP60A')
                                MAPSET('MBANK60')
              END-EXEC
              GO TO SCREEN60-READ-EXIT
           END-IF.

           IF NADDR1L IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NADDR1I IN BANK60AI
           END-IF.

           IF NADDR2L IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NADDR2I IN BANK60AI
           END-IF.

           IF NSTATEL IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NSTATEI IN BANK60AI
           END-IF.

           IF NCNTRYL IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NCNTRYI IN BANK60AI
           END-IF.

           IF NPSTCDEL IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NPSTCDEI IN BANK60AI
           END-IF.

           IF NTELNOL IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NTELNOI IN BANK60AI
           END-IF.

           IF NEMAILL IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NEMAILI IN BANK60AI
           END-IF.

           IF NSMAILL IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NSMAILI IN BANK60AI
           END-IF.

           IF NSEMAILL IN BANK60AI IS EQUAL TO 0
              MOVE SPACES TO NSEMAILI IN BANK60AI
           END-IF.

           MOVE NADDR1I IN BANK60AI TO BANK-SCR60-NEW-ADDR1.
           MOVE NADDR2I IN BANK60AI TO BANK-SCR60-NEW-ADDR2.
           MOVE NSTATEI IN BANK60AI TO BANK-SCR60-NEW-STATE.
           MOVE NCNTRYI IN BANK60AI TO BANK-SCR60-NEW-CNTRY.
           MOVE NPSTCDEI IN BANK60AI TO BANK-SCR60-NEW-PSTCDE.
           MOVE NTELNOI IN BANK60AI TO BANK-SCR60-NEW-TELNO.
           MOVE NEMAILI IN BANK60AI TO BANK-SCR60-NEW-EMAIL.
           MOVE NSMAILI IN BANK60AI TO BANK-SCR60-NEW-SEND-MAIL.
           MOVE NSEMAILI IN BANK60AI TO BANK-SCR60-NEW-SEND-EMAIL.

           GO TO SCREEN60-READ-EXIT.

       SCREEN60-READ-INET.
           MOVE EXT-IP60-NADDR1 TO BANK-SCR60-NEW-ADDR1.
           MOVE EXT-IP60-NADDR2 TO BANK-SCR60-NEW-ADDR2.
           MOVE EXT-IP60-NSTATE TO BANK-SCR60-NEW-STATE.
           MOVE EXT-IP60-NCNTRY TO BANK-SCR60-NEW-CNTRY.
           MOVE EXT-IP60-NPSTCDE TO BANK-SCR60-NEW-PSTCDE.
           MOVE EXT-IP60-NTELNO TO BANK-SCR60-NEW-TELNO.
           MOVE EXT-IP60-NEMAIL TO BANK-SCR60-NEW-EMAIL.
           MOVE EXT-IP60-NSMAIL TO BANK-SCR60-NEW-SEND-MAIL.
           MOVE EXT-IP60-NSEMAIL TO BANK-SCR60-NEW-SEND-EMAIL.
           GO TO SCREEN60-READ-EXIT.

       SCREEN60-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN60 (BANK60/HELP60)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN60-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK60AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK60' TO BANK-LAST-MAPSET
              MOVE 'HELP60A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK60' TO BANK-LAST-MAPSET
              MOVE 'BANK60A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN60-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN60-BUILD-AND-SEND-INET
           END-IF.

       SCREEN60-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK60A'
              GO TO BANK60-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP60A'
              GO TO HELP60-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK60-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK60AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK60AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK60AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK60AO.
           MOVE DDO-DATA TO DATEO IN BANK60AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK60AO.
      * Move in screen specific fields
           MOVE BANK-SCR60-CONTACT-ID TO USERIDO IN BANK60AO.
           MOVE BANK-SCR60-CONTACT-NAME TO USERNMO IN BANK60AO.

           MOVE BANK-SCR60-OLD-ADDR1 TO OADDR1O IN BANK60AO.
           MOVE BANK-SCR60-OLD-ADDR2 TO OADDR2O IN BANK60AO.
           MOVE BANK-SCR60-OLD-STATE TO OSTATEO IN BANK60AO.
           MOVE BANK-SCR60-OLD-CNTRY TO OCNTRYO IN BANK60AO.
           MOVE BANK-SCR60-OLD-PSTCDE TO OPSTCDEO IN BANK60AO.
           MOVE BANK-SCR60-OLD-TELNO TO OTELNOO IN BANK60AO.
           MOVE BANK-SCR60-OLD-EMAIL TO OEMAILO IN BANK60AO.
           MOVE BANK-SCR60-OLD-SEND-MAIL TO OSMAILO IN BANK60AO.
           MOVE BANK-SCR60-OLD-SEND-EMAIL TO OSEMAILO IN BANK60AO.
           MOVE BANK-SCR60-NEW-ADDR1 TO NADDR1O IN BANK60AO.
           MOVE BANK-SCR60-NEW-ADDR2 TO NADDR2O IN BANK60AO.
           MOVE BANK-SCR60-NEW-STATE TO NSTATEO IN BANK60AO.
           MOVE BANK-SCR60-NEW-CNTRY TO NCNTRYO IN BANK60AO.
           MOVE BANK-SCR60-NEW-PSTCDE TO NPSTCDEO IN BANK60AO.
           MOVE BANK-SCR60-NEW-TELNO TO NTELNOO IN BANK60AO.
           MOVE BANK-SCR60-NEW-EMAIL TO NEMAILO IN BANK60AO.
           MOVE BANK-SCR60-NEW-SEND-MAIL TO NSMAILO IN BANK60AO.
           MOVE BANK-SCR60-NEW-SEND-EMAIL TO NSEMAILO IN BANK60AO.
           IF ADDR-CHANGE-VERIFY
              MOVE DFHBMPRF TO NADDR1A IN BANK60AI
              MOVE DFHBMPRF TO NADDR2A IN BANK60AI
              MOVE DFHBMPRF TO NSTATEA IN BANK60AI
              MOVE DFHBMPRF TO NCNTRYA IN BANK60AI
              MOVE DFHBMPRF TO NADDR1A IN BANK60AI
              MOVE DFHBMPRF TO NPSTCDEA IN BANK60AI
              MOVE DFHBMPRF TO NTELNOA IN BANK60AI
              MOVE DFHBMPRF TO NEMAILA IN BANK60AI
              MOVE DFHBMPRF TO NSMAILA IN BANK60AI
              MOVE DFHBMPRF TO NSEMAILA IN BANK60AI
           END-IF.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK60AO
              MOVE DFHGREEN TO SCRNC IN BANK60AO
              MOVE DFHGREEN TO HEAD1C IN BANK60AO
              MOVE DFHGREEN TO DATEC IN BANK60AO
              MOVE DFHGREEN TO TXT02C IN BANK60AO
              MOVE DFHGREEN TO TRANC IN BANK60AO
              MOVE DFHGREEN TO HEAD2C IN BANK60AO
              MOVE DFHGREEN TO TIMEC IN BANK60AO
              MOVE DFHGREEN TO TXT03C IN BANK60AO
              MOVE DFHGREEN TO USERIDC IN BANK60AO
              MOVE DFHGREEN TO TXT04C IN BANK60AO
              MOVE DFHGREEN TO USERNMC IN BANK60AO
              MOVE DFHGREEN TO TXT05C IN BANK60AO
              MOVE DFHGREEN TO TXT06C IN BANK60AO
              MOVE DFHGREEN TO TXT07C IN BANK60AO
              MOVE DFHGREEN TO NADDR1C IN BANK60AO
              MOVE DFHGREEN TO OADDR1C IN BANK60AO
              MOVE DFHGREEN TO NADDR2C IN BANK60AO
              MOVE DFHGREEN TO OADDR2C IN BANK60AO
              MOVE DFHGREEN TO TXT08C IN BANK60AO
              MOVE DFHGREEN TO NSTATEC IN BANK60AO
              MOVE DFHGREEN TO OSTATEC IN BANK60AO
              MOVE DFHGREEN TO TXT09C IN BANK60AO
              MOVE DFHGREEN TO NCNTRYC IN BANK60AO
              MOVE DFHGREEN TO OCNTRYC IN BANK60AO
              MOVE DFHGREEN TO TXT10C IN BANK60AO
              MOVE DFHGREEN TO NPSTCDEC IN BANK60AO
              MOVE DFHGREEN TO OPSTCDEC IN BANK60AO
              MOVE DFHGREEN TO TXT11C IN BANK60AO
              MOVE DFHGREEN TO NTELNOC IN BANK60AO
              MOVE DFHGREEN TO OTELNOC IN BANK60AO
              MOVE DFHGREEN TO TXT12C IN BANK60AO
              MOVE DFHGREEN TO NEMAILC IN BANK60AO
              MOVE DFHGREEN TO OEMAILC IN BANK60AO
              MOVE DFHGREEN TO TXT13C IN BANK60AO
              MOVE DFHGREEN TO TXT14C IN BANK60AO
              MOVE DFHGREEN TO NSMAILC IN BANK60AO
              MOVE DFHGREEN TO TXT15C IN BANK60AO
              MOVE DFHGREEN TO NSEMAILC IN BANK60AO
              MOVE DFHGREEN TO TXT16C IN BANK60AO
              MOVE DFHGREEN TO OSMAILC IN BANK60AO
              MOVE DFHGREEN TO OSEMAILC IN BANK60AO
              MOVE DFHGREEN TO ERRMSGC IN BANK60AO
              MOVE DFHGREEN TO TXT17C IN BANK60AO
              MOVE DFHGREEN TO VERC IN BANK60AO
           END-IF.

           EXEC CICS SEND MAP('BANK60A')
                          MAPSET('MBANK60')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN60-BUILD-AND-SEND-EXIT.

       HELP60-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP60AO==.

           EXEC CICS SEND MAP('HELP60A')
                          MAPSET('MBANK60')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN60-BUILD-AND-SEND-EXIT.

       SCREEN60-BUILD-AND-SEND-INET.
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
           MOVE 'BANK60' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR60-OLD-ADDR1 TO EXT-OP60-OADDR1.
           MOVE BANK-SCR60-OLD-ADDR2 TO EXT-OP60-OADDR2.
           MOVE BANK-SCR60-OLD-STATE TO EXT-OP60-OSTATE.
           MOVE BANK-SCR60-OLD-CNTRY TO EXT-OP60-OCNTRY.
           MOVE BANK-SCR60-OLD-PSTCDE TO EXT-OP60-OPSTCDE.
           MOVE BANK-SCR60-OLD-TELNO TO EXT-OP60-OTELNO.
           MOVE BANK-SCR60-NEW-ADDR1 TO EXT-OP60-NADDR1.
           MOVE BANK-SCR60-NEW-ADDR2 TO EXT-OP60-NADDR2.
           MOVE BANK-SCR60-NEW-STATE TO EXT-OP60-NSTATE.
           MOVE BANK-SCR60-NEW-CNTRY TO EXT-OP60-NCNTRY.
           MOVE BANK-SCR60-NEW-PSTCDE TO EXT-OP60-NPSTCDE.
           MOVE BANK-SCR60-NEW-TELNO TO EXT-OP60-NTELNO.
           MOVE BANK-SCR60-NEW-EMAIL TO EXT-OP60-NEMAIL.
           MOVE BANK-SCR60-NEW-SEND-MAIL TO EXT-OP60-NSMAIL.
           MOVE BANK-SCR60-NEW-SEND-EMAIL TO EXT-OP60-NSEMAIL.

       SCREEN60-BUILD-AND-SEND-EXIT.
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
