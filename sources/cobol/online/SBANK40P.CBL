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
      * Program:     SBANK40P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Display transaction details                      *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK40P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK40P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.
         05  WS-WORK1                              PIC X(1).
         05  WS-SUB1                               PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK40.

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
               PERFORM SCREEN40-READ THRU
                       SCREEN40-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN40-BUILD-AND-SEND THRU
                       SCREEN40-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK40                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN40-READ.
           MOVE 'BBANK40P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN40-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN40-READ-CICS
           ELSE
              GO TO SCREEN40-READ-INET
           END-IF.

       SCREEN40-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK40A')
                                MAPSET('MBANK40')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP40A')
                                MAPSET('MBANK40')
              END-EXEC
              GO TO SCREEN40-READ-EXIT
           END-IF.

           GO TO SCREEN40-READ-EXIT.

       SCREEN40-READ-INET.
           GO TO SCREEN40-READ-EXIT.

       SCREEN40-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN40 (BANK40/HELP40)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN40-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK40AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MBANK40' TO BANK-LAST-MAPSET
              MOVE 'HELP40A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK40' TO BANK-LAST-MAPSET
              MOVE 'BANK40A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN40-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN40-BUILD-AND-SEND-INET
           END-IF.

       SCREEN40-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK40A'
              GO TO BANK40-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP40A'
              GO TO HELP40-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK40-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK40AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK40AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK40AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK40AO.
           MOVE DDO-DATA TO DATEO IN BANK40AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK40AO.
      * Move in screen specific fields
           MOVE BANK-SCR40-ACC TO ACCNOO IN BANK40AO.
           MOVE BANK-SCR40-ACCTYPE TO ACCTYPEO IN BANK40AO.

           EVALUATE TRUE
             WHEN BANK-PAGING-OFF
               MOVE DFHBMDAR TO TXT09A IN BANK40AI
               MOVE SPACES TO MOREO IN BANK40AO
               MOVE SPACES TO PAGINGO IN BANK40AO
             WHEN BANK-PAGING-FIRST
               MOVE ' /+' TO MOREO IN BANK40AO
               MOVE '        F8=Forward' TO PAGINGO IN BANK40AO
             WHEN BANK-PAGING-MIDDLE
               MOVE '-/+' TO MOREO IN BANK40AO
               MOVE 'F7=Back F8=Forward' TO PAGINGO IN BANK40AO
             WHEN BANK-PAGING-LAST
               MOVE '-/ ' TO MOREO IN BANK40AO
               MOVE 'F7=Back           ' TO PAGINGO IN BANK40AO
             WHEN OTHER
               MOVE DFHBMDAR TO TXT09A IN BANK40AI
               MOVE SPACES TO MOREO IN BANK40AO
               MOVE SPACES TO PAGINGO IN BANK40AO
           END-EVALUATE.

           MOVE BANK-SCR40-DAT1 TO DAT1O IN BANK40AO.
           MOVE BANK-SCR40-TIM1 TO TIM1O IN BANK40AO.
           MOVE BANK-SCR40-AMT1 TO AMT1O IN BANK40AO.
           MOVE BANK-SCR40-DSC1 TO DSC1O IN BANK40AO.
           MOVE BANK-SCR40-DAT2 TO DAT2O IN BANK40AO.
           MOVE BANK-SCR40-TIM2 TO TIM2O IN BANK40AO.
           MOVE BANK-SCR40-AMT2 TO AMT2O IN BANK40AO.
           MOVE BANK-SCR40-DSC2 TO DSC2O IN BANK40AO.
           MOVE BANK-SCR40-DAT3 TO DAT3O IN BANK40AO.
           MOVE BANK-SCR40-TIM3 TO TIM3O IN BANK40AO.
           MOVE BANK-SCR40-AMT3 TO AMT3O IN BANK40AO.
           MOVE BANK-SCR40-DSC3 TO DSC3O IN BANK40AO.
           MOVE BANK-SCR40-DAT4 TO DAT4O IN BANK40AO.
           MOVE BANK-SCR40-TIM4 TO TIM4O IN BANK40AO.
           MOVE BANK-SCR40-AMT4 TO AMT4O IN BANK40AO.
           MOVE BANK-SCR40-DSC4 TO DSC4O IN BANK40AO.
           MOVE BANK-SCR40-DAT5 TO DAT5O IN BANK40AO.
           MOVE BANK-SCR40-TIM5 TO TIM5O IN BANK40AO.
           MOVE BANK-SCR40-AMT5 TO AMT5O IN BANK40AO.
           MOVE BANK-SCR40-DSC5 TO DSC5O IN BANK40AO.
           MOVE BANK-SCR40-DAT6 TO DAT6O IN BANK40AO.
           MOVE BANK-SCR40-TIM6 TO TIM6O IN BANK40AO.
           MOVE BANK-SCR40-AMT6 TO AMT6O IN BANK40AO.
           MOVE BANK-SCR40-DSC6 TO DSC6O IN BANK40AO.
           MOVE BANK-SCR40-DAT7 TO DAT7O IN BANK40AO.
           MOVE BANK-SCR40-TIM7 TO TIM7O IN BANK40AO.
           MOVE BANK-SCR40-AMT7 TO AMT7O IN BANK40AO.
           MOVE BANK-SCR40-DSC7 TO DSC7O IN BANK40AO.
           MOVE BANK-SCR40-DAT8 TO DAT8O IN BANK40AO.
           MOVE BANK-SCR40-TIM8 TO TIM8O IN BANK40AO.
           MOVE BANK-SCR40-AMT8 TO AMT8O IN BANK40AO.
           MOVE BANK-SCR40-DSC8 TO DSC8O IN BANK40AO.
      * Turn colour off if requ8red
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK40AO
              MOVE DFHGREEN TO SCRNC IN BANK40AO
              MOVE DFHGREEN TO HEAD1C IN BANK40AO
              MOVE DFHGREEN TO DATEC IN BANK40AO
              MOVE DFHGREEN TO TXT02C IN BANK40AO
              MOVE DFHGREEN TO TRANC IN BANK40AO
              MOVE DFHGREEN TO HEAD2C IN BANK40AO
              MOVE DFHGREEN TO TIMEC IN BANK40AO
              MOVE DFHGREEN TO TXT03C IN BANK40AO
              MOVE DFHGREEN TO ACCNOC IN BANK40AO
              MOVE DFHGREEN TO TXT04C IN BANK40AO
              MOVE DFHGREEN TO ACCTYPEC IN BANK40AO
              MOVE DFHGREEN TO TXT05C IN BANK40AO
              MOVE DFHGREEN TO TXT06C IN BANK40AO
              MOVE DFHGREEN TO TXT07C IN BANK40AO
              MOVE DFHGREEN TO TXT08C IN BANK40AO
              MOVE DFHGREEN TO TXT09C IN BANK40AO
              MOVE DFHGREEN TO MOREC IN BANK40AO
              MOVE DFHGREEN TO DAT1C IN BANK40AO
              MOVE DFHGREEN TO TIM1C IN BANK40AO
              MOVE DFHGREEN TO AMT1C IN BANK40AO
              MOVE DFHGREEN TO DSC1C IN BANK40AO
              MOVE DFHGREEN TO DAT2C IN BANK40AO
              MOVE DFHGREEN TO TIM2C IN BANK40AO
              MOVE DFHGREEN TO AMT2C IN BANK40AO
              MOVE DFHGREEN TO DSC2C IN BANK40AO
              MOVE DFHGREEN TO DAT3C IN BANK40AO
              MOVE DFHGREEN TO TIM3C IN BANK40AO
              MOVE DFHGREEN TO AMT3C IN BANK40AO
              MOVE DFHGREEN TO DSC3C IN BANK40AO
              MOVE DFHGREEN TO DAT4C IN BANK40AO
              MOVE DFHGREEN TO TIM4C IN BANK40AO
              MOVE DFHGREEN TO AMT4C IN BANK40AO
              MOVE DFHGREEN TO DSC4C IN BANK40AO
              MOVE DFHGREEN TO DAT5C IN BANK40AO
              MOVE DFHGREEN TO TIM5C IN BANK40AO
              MOVE DFHGREEN TO AMT5C IN BANK40AO
              MOVE DFHGREEN TO DSC5C IN BANK40AO
              MOVE DFHGREEN TO DAT6C IN BANK40AO
              MOVE DFHGREEN TO TIM6C IN BANK40AO
              MOVE DFHGREEN TO AMT6C IN BANK40AO
              MOVE DFHGREEN TO DSC6C IN BANK40AO
              MOVE DFHGREEN TO DAT7C IN BANK40AO
              MOVE DFHGREEN TO TIM7C IN BANK40AO
              MOVE DFHGREEN TO AMT7C IN BANK40AO
              MOVE DFHGREEN TO DSC7C IN BANK40AO
              MOVE DFHGREEN TO DAT8C IN BANK40AO
              MOVE DFHGREEN TO TIM8C IN BANK40AO
              MOVE DFHGREEN TO AMT8C IN BANK40AO
              MOVE DFHGREEN TO DSC8C IN BANK40AO
              MOVE DFHGREEN TO ERRMSGC IN BANK40AO
              MOVE DFHGREEN TO TXT10C IN BANK40AO
              MOVE DFHGREEN TO PAGINGC IN BANK40AO
              MOVE DFHGREEN TO VERC IN BANK40AO
           END-IF.

           EXEC CICS SEND MAP('BANK40A')
                          MAPSET('MBANK40')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN40-BUILD-AND-SEND-EXIT.

       HELP40-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP40AO==.

           EXEC CICS SEND MAP('HELP40A')
                          MAPSET('MBANK40')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN40-BUILD-AND-SEND-EXIT.

       SCREEN40-BUILD-AND-SEND-INET.
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
           MOVE 'BANK40' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR40-ACC TO EXT-OP40-ACCNO.
           MOVE BANK-SCR40-ACCTYPE TO EXT-OP40-ACCTYPE.
           MOVE BANK-PAGING-STATUS TO EXT-OP40-PAGING-STATUS.
           MOVE 0 TO WS-SUB1.
           PERFORM SCREEN40-BUILD-AND-SEND-INET1 8 TIMES.
           GO TO SCREEN40-BUILD-AND-SEND-EXIT.
       SCREEN40-BUILD-AND-SEND-INET1.
           ADD 1 TO WS-SUB1.
           MOVE BANK-SCR40-DATE (WS-SUB1) TO EXT-OP40-DATE (WS-SUB1).
           MOVE BANK-SCR40-TIME (WS-SUB1) TO EXT-OP40-TIME (WS-SUB1).
           MOVE BANK-SCR40-AMNT (WS-SUB1) TO EXT-OP40-AMNT (WS-SUB1).
           MOVE BANK-SCR40-DESC (WS-SUB1) TO EXT-OP40-DESC (WS-SUB1).


       SCREEN40-BUILD-AND-SEND-EXIT.
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
