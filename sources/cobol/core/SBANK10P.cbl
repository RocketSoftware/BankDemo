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
      * Program:     SBANK10P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Signon to system to identify user                *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK10P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK10P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK10.

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
      *     COPY CTRACE.
      *****************************************************************
      *                                                               *
      *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved.     *
      *                                                               *
      *****************************************************************

      *****************************************************************
      * CTRACE.CPY                                                    *
      *---------------------------------------------------------------*
      * This copybook is used to provide an a trace of what           *
      * transactions have been run so we get an idea of activity      *
      * There are different versions for CICS and IMS.                *
      *****************************************************************
      *
      * Comment out the instructions and recompile to not use the trace
           EXEC CICS LINK PROGRAM('STRAC00P')
                          COMMAREA(WS-PROGRAM-ID)
                          LENGTH(LENGTH OF WS-PROGRAM-ID)
           END-EXEC.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm

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
      *        COPY CABENDPO.
               PERFORM ZZ-ABEND
               GOBACK

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
               PERFORM SCREEN10-READ THRU
                       SCREEN10-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN10-BUILD-AND-SEND THRU
                       SCREEN10-BUILD-AND-SEND-EXIT
             WHEN OTHER
               MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
               MOVE '0002' TO ABEND-CODE
               MOVE SPACES TO ABEND-REASON
      *         COPY CABENDPO.
               PERFORM ZZ-ABEND
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
      * Screen processing for MBANK10                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN10-READ.
           MOVE 'BBANK10P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN10-READ-EXIT
           END-IF.
           IF BANK-LAST-MAPSET IS EQUAL TO SPACES
              GO TO SCREEN10-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN10-READ-CICS
           ELSE
              GO TO SCREEN10-READ-INET
           END-IF.

       SCREEN10-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK10A')
                                MAPSET('MBANK10')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP10A')
                                MAPSET('MBANK10')
              END-EXEC
              GO TO SCREEN10-READ-EXIT
           END-IF.

           IF USERIDL IN BANK10AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SIGNON-ID
           ELSE
              MOVE USERIDI IN BANK10AI
                TO BANK-SIGNON-ID (1:USERIDL IN BANK10AI)
           END-IF.

           IF PSWDL IN BANK10AI IS EQUAL TO 0
              MOVE LOW-VALUES TO BANK-PSWD
           ELSE
              MOVE PSWDI IN BANK10AI
                TO BANK-PSWD (1:PSWDL IN BANK10AI)
           END-IF.

           GO TO SCREEN10-READ-EXIT.

       SCREEN10-READ-INET.
           MOVE EXT-IP10-USERID TO BANK-SIGNON-ID.
           MOVE EXT-IP10-PSWD TO BANK-PSWD.
           GO TO SCREEN10-READ-EXIT.

       SCREEN10-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN10 (BANK10/HELP10)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN10-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK10AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK10' TO BANK-LAST-MAPSET
              MOVE 'HELP10A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK10' TO BANK-LAST-MAPSET
              MOVE 'BANK10A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN10-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN10-BUILD-AND-SEND-INET
           END-IF.

       SCREEN10-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK10A'
              GO TO BANK10-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP10A'
              GO TO HELP10-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
      *     COPY CABENDPO.
           PERFORM ZZ-ABEND.
           GOBACK.

       BANK10-BUILD-AND-SEND-CICS.
      *     COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK10AO==.
           CALL 'SCUSTOMP' USING SCREEN-TITLES.
           MOVE SCREEN-TITLE1 TO HEAD1O IN BANK10AO.
           MOVE SCREEN-TITLE2 TO HEAD2O IN BANK10AO.


      *    COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK10AO==.
           CALL 'SVERSONP' USING VERSION.
           MOVE VERSION TO VERO IN BANK10AO.

           MOVE WS-TRAN-ID TO TRANO IN BANK10AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK10AO.
           MOVE DDO-DATA TO DATEO IN BANK10AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK10AO.
      * Move in screen specific fields
           MOVE -1 TO USERIDL IN BANK10AI.
           MOVE BANK-SIGNON-ID TO USERIDO IN BANK10AO.
           MOVE -1 TO PSWDL IN BANK10AI.
           MOVE BANK-PSWD TO PSWDO IN BANK10AO.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK10AO
              MOVE DFHGREEN TO SCRNC IN BANK10AO
              MOVE DFHGREEN TO HEAD1C IN BANK10AO
              MOVE DFHGREEN TO DATEC IN BANK10AO
              MOVE DFHGREEN TO TXT02C IN BANK10AO
              MOVE DFHGREEN TO TRANC IN BANK10AO
              MOVE DFHGREEN TO HEAD2C IN BANK10AO
              MOVE DFHGREEN TO TIMEC IN BANK10AO
              MOVE DFHGREEN TO TXT03C IN BANK10AO
              MOVE DFHGREEN TO TXT04C IN BANK10AO
              MOVE DFHGREEN TO TXT05C IN BANK10AO
              MOVE DFHGREEN TO TXT06C IN BANK10AO
              MOVE DFHGREEN TO USERIDC IN BANK10AO
              MOVE DFHGREEN TO TXT07C IN BANK10AO
              MOVE DFHGREEN TO PSWDC IN BANK10AO
              MOVE DFHGREEN TO ERRMSGC IN BANK10AO
              MOVE DFHGREEN TO TXT08C IN BANK10AO
              MOVE DFHGREEN TO VERC IN BANK10AO
           END-IF.

           EXEC CICS SEND MAP('BANK10A')
                          MAPSET('MBANK10')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN10-BUILD-AND-SEND-EXIT.

       HELP10-BUILD-AND-SEND-CICS.
      *    COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
      *                            ==<<SCRN>>== BY ==HELP10AO==.
           CALL 'SCUSTOMP' USING SCREEN-TITLES.
           MOVE SCREEN-TITLE1 TO AHEAD1O IN HELP10AO.
           MOVE SCREEN-TITLE2 TO AHEAD2O IN HELP10AO.
           CALL 'SVERSONP' USING VERSION.
           MOVE VERSION TO AVERO IN HELP10AO.
           MOVE WS-TRAN-ID TO ATRANO IN HELP10AO.
           MOVE DD-TIME-OUTPUT TO ATIMEO IN HELP10AO.
           MOVE DDO-DATA TO ADATEO IN HELP10AO.
      * Move in any error message
      * Move in screen specific fields
              MOVE BANK-HELP-LINE (01) TO AHLP01O IN HELP10AO.
              MOVE BANK-HELP-LINE (02) TO AHLP02O IN HELP10AO.
              MOVE BANK-HELP-LINE (03) TO AHLP03O IN HELP10AO.
              MOVE BANK-HELP-LINE (04) TO AHLP04O IN HELP10AO.
              MOVE BANK-HELP-LINE (05) TO AHLP05O IN HELP10AO.
              MOVE BANK-HELP-LINE (06) TO AHLP06O IN HELP10AO.
              MOVE BANK-HELP-LINE (07) TO AHLP07O IN HELP10AO.
              MOVE BANK-HELP-LINE (08) TO AHLP08O IN HELP10AO.
              MOVE BANK-HELP-LINE (09) TO AHLP09O IN HELP10AO.
              MOVE BANK-HELP-LINE (10) TO AHLP10O IN HELP10AO.
              MOVE BANK-HELP-LINE (11) TO AHLP11O IN HELP10AO.
              MOVE BANK-HELP-LINE (12) TO AHLP12O IN HELP10AO.
              MOVE BANK-HELP-LINE (13) TO AHLP13O IN HELP10AO.
              MOVE BANK-HELP-LINE (14) TO AHLP14O IN HELP10AO.
              MOVE BANK-HELP-LINE (15) TO AHLP15O IN HELP10AO.
              MOVE BANK-HELP-LINE (16) TO AHLP16O IN HELP10AO.
              MOVE BANK-HELP-LINE (17) TO AHLP17O IN HELP10AO.
              MOVE BANK-HELP-LINE (18) TO AHLP18O IN HELP10AO.
              MOVE BANK-HELP-LINE (19) TO AHLP19O IN HELP10AO.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO ATXT01C IN HELP10AO
              MOVE DFHGREEN TO ASCRNC IN HELP10AO
              MOVE DFHGREEN TO AHEAD1C IN HELP10AO
              MOVE DFHGREEN TO ADATEC IN HELP10AO
              MOVE DFHGREEN TO ATXT02C IN HELP10AO
              MOVE DFHGREEN TO ATRANC IN HELP10AO
              MOVE DFHGREEN TO AHEAD2C IN HELP10AO
              MOVE DFHGREEN TO ATIMEC IN HELP10AO
              MOVE DFHGREEN TO AHLP01C IN HELP10AO
              MOVE DFHGREEN TO AHLP02C IN HELP10AO
              MOVE DFHGREEN TO AHLP03C IN HELP10AO
              MOVE DFHGREEN TO AHLP04C IN HELP10AO
              MOVE DFHGREEN TO AHLP05C IN HELP10AO
              MOVE DFHGREEN TO AHLP06C IN HELP10AO
              MOVE DFHGREEN TO AHLP07C IN HELP10AO
              MOVE DFHGREEN TO AHLP08C IN HELP10AO
              MOVE DFHGREEN TO AHLP09C IN HELP10AO
              MOVE DFHGREEN TO AHLP10C IN HELP10AO
              MOVE DFHGREEN TO AHLP11C IN HELP10AO
              MOVE DFHGREEN TO AHLP12C IN HELP10AO
              MOVE DFHGREEN TO AHLP13C IN HELP10AO
              MOVE DFHGREEN TO AHLP14C IN HELP10AO
              MOVE DFHGREEN TO AHLP15C IN HELP10AO
              MOVE DFHGREEN TO AHLP16C IN HELP10AO
              MOVE DFHGREEN TO AHLP17C IN HELP10AO
              MOVE DFHGREEN TO AHLP18C IN HELP10AO
              MOVE DFHGREEN TO AHLP19C IN HELP10AO
              MOVE DFHGREEN TO ATXT03C IN HELP10AO
              MOVE DFHGREEN TO AVERC IN HELP10AO
           END-IF.

           EXEC CICS SEND MAP('HELP10A')
                          MAPSET('MBANK10')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN10-BUILD-AND-SEND-EXIT.


       SCREEN10-BUILD-AND-SEND-INET.
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
           MOVE 'BANK10' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-SIGNON-ID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-PSWD TO EXT-OP10-PSWD.
           GO TO SCREEN10-BUILD-AND-SEND-EXIT.

       SCREEN10-BUILD-AND-SEND-EXIT.
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

       ZZ-ABEND SECTION.

           STRING ABEND-CULPRIT DELIMITED BY SIZE
                  ' Abend ' DELIMITED BY SIZE
                  ABEND-CODE DELIMITED BY SIZE
                  ' - ' DELIMITED BY SIZE
                   ABEND-REASON DELIMITED BY SIZE
               INTO ABEND-MSG
           END-STRING.

           EXEC CICS WRITE
                     OPERATOR
                     TEXT(ABEND-MSG)
                     TEXTLENGTH(LENGTH OF ABEND-MSG)
           END-EXEC.

           EXEC CICS ABEND
                 ABCODE(ABEND-CODE)
           END-EXEC.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
