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
      * Program:     SBANK20P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Determine user options                           *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK20P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK20P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANK20.

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
               PERFORM SCREEN20-READ THRU
                       SCREEN20-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREEN20-BUILD-AND-SEND THRU
                       SCREEN20-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANK20                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREEN20-READ.
           MOVE 'BBANK20P' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREEN20-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN20-READ-CICS
           ELSE
              GO TO SCREEN20-READ-INET
           END-IF.

       SCREEN20-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANK20A')
                                MAPSET('MBANK20')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELP20A')
                                MAPSET('MBANK20')
              END-EXEC
              GO TO SCREEN20-READ-EXIT
           END-IF.

           IF SEL1IDL IN BANK20AI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCR20-SEL1ID
           ELSE
              MOVE SEL1IDI IN BANK20AI TO BANK-SCR20-SEL1ID
              IF BANK-SCR20-SEL1ID IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL1ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL1ID
           END-IF.
           IF SEL1IPL IN BANK20AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR20-SEL1IP
           ELSE
              MOVE SEL1IPI IN BANK20AI TO BANK-SCR20-SEL1IP
              IF BANK-SCR20-SEL1IP IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL1IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL1IP
           END-IF.

           IF SEL2IDL IN BANK20AI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCR20-SEL2ID
           ELSE
              MOVE SEL2IDI IN BANK20AI TO BANK-SCR20-SEL2ID
              IF BANK-SCR20-SEL2ID IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL2ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL2ID
           END-IF.
           IF SEL2IPL IN BANK20AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR20-SEL2IP
           ELSE
              MOVE SEL2IPI IN BANK20AI TO BANK-SCR20-SEL2IP
              IF BANK-SCR20-SEL2IP IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL2IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL2IP
           END-IF.

           IF SEL3IDL IN BANK20AI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCR20-SEL3ID
           ELSE
              MOVE SEL3IDI IN BANK20AI TO BANK-SCR20-SEL3ID
              IF BANK-SCR20-SEL3ID IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL3ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL3ID
           END-IF.
           IF SEL3IPL IN BANK20AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR20-SEL3IP
           ELSE
              MOVE SEL3IPI IN BANK20AI TO BANK-SCR20-SEL3IP
              IF BANK-SCR20-SEL3IP IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL3IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL3IP
           END-IF.

           IF SEL4IDL IN BANK20AI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCR20-SEL4ID
           ELSE
              MOVE SEL4IDI IN BANK20AI TO BANK-SCR20-SEL4ID
              IF BANK-SCR20-SEL4ID IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL4ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL4ID
           END-IF.
           IF SEL4IPL IN BANK20AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR20-SEL4IP
           ELSE
              MOVE SEL4IPI IN BANK20AI TO BANK-SCR20-SEL4IP
              IF BANK-SCR20-SEL4IP IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL4IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL4IP
           END-IF.

           IF SEL5IDL IN BANK20AI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCR20-SEL5ID
           ELSE
              MOVE SEL5IDI IN BANK20AI TO BANK-SCR20-SEL5ID
              IF BANK-SCR20-SEL5ID IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL5ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL5ID
           END-IF.
           IF SEL5IPL IN BANK20AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR20-SEL5IP
           ELSE
              MOVE SEL5IPI IN BANK20AI TO BANK-SCR20-SEL5IP
              IF BANK-SCR20-SEL5IP IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL5IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL5IP
           END-IF.

           IF SEL6IDL IN BANK20AI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCR20-SEL6ID
           ELSE
              MOVE SEL6IDI IN BANK20AI TO BANK-SCR20-SEL6ID
              IF BANK-SCR20-SEL6ID IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL6ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL6ID
           END-IF.
           IF SEL6IPL IN BANK20AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR20-SEL6IP
           ELSE
              MOVE SEL6IPI IN BANK20AI TO BANK-SCR20-SEL6IP
              IF BANK-SCR20-SEL6IP IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL6IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL6IP
           END-IF.

           IF SEL7IDL IN BANK20AI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCR20-SEL7ID
           ELSE
              MOVE SEL7IDI IN BANK20AI TO BANK-SCR20-SEL7ID
              IF BANK-SCR20-SEL7ID IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL7ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL7ID
           END-IF.
           IF SEL7IPL IN BANK20AI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCR20-SEL7IP
           ELSE
              MOVE SEL7IPI IN BANK20AI TO BANK-SCR20-SEL7IP
              IF BANK-SCR20-SEL7IP IS EQUAL TO SPACES OR
                 BANK-SCR20-SEL7IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCR20-SEL7IP
           END-IF.

           GO TO SCREEN20-READ-EXIT.

       SCREEN20-READ-INET.
           MOVE EXT-IP20-SEL1ID TO BANK-SCR20-SEL1ID.
           MOVE EXT-IP20-SEL1IP TO BANK-SCR20-SEL1IP.
           MOVE EXT-IP20-SEL2ID TO BANK-SCR20-SEL2ID.
           MOVE EXT-IP20-SEL2IP TO BANK-SCR20-SEL2IP.
           MOVE EXT-IP20-SEL3ID TO BANK-SCR20-SEL3ID.
           MOVE EXT-IP20-SEL3IP TO BANK-SCR20-SEL3IP.
           MOVE EXT-IP20-SEL4ID TO BANK-SCR20-SEL4ID.
           MOVE EXT-IP20-SEL4IP TO BANK-SCR20-SEL4IP.
           MOVE EXT-IP20-SEL5ID TO BANK-SCR20-SEL5ID.
           MOVE EXT-IP20-SEL5IP TO BANK-SCR20-SEL5IP.
           MOVE EXT-IP20-SEL6ID TO BANK-SCR20-SEL6ID.
           MOVE EXT-IP20-SEL6IP TO BANK-SCR20-SEL6IP.
           MOVE EXT-IP20-SEL7ID TO BANK-SCR20-SEL7ID.
           MOVE EXT-IP20-SEL7IP TO BANK-SCR20-SEL7IP.
           GO TO SCREEN20-READ-EXIT.

       SCREEN20-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREEN20 (BANK20/HELP20)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREEN20-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANK20AO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MHELP20' TO BANK-LAST-MAPSET
              MOVE 'HELP20A' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANK20' TO BANK-LAST-MAPSET
              MOVE 'BANK20A' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREEN20-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREEN20-BUILD-AND-SEND-INET
           END-IF.

       SCREEN20-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANK20A'
              GO TO BANK20-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELP20A'
              GO TO HELP20-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANK20-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANK20AO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANK20AO==.
           MOVE WS-TRAN-ID TO TRANO IN BANK20AO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANK20AO.
           MOVE DDO-DATA TO DATEO IN BANK20AO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANK20AO.
      * Move in screen specific fields
           IF BANK-SCR20-SEL1ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL1IDL IN BANK20AI
              MOVE BANK-SCR20-SEL1ID TO SEL1IDO IN BANK20AO
              MOVE -1 TO SEL1IPL IN BANK20AI
              IF BANK-SCR20-SEL1IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL1IPO IN BANK20AO
              ELSE
                 MOVE BANK-SCR20-SEL1IP TO SEL1IPO IN BANK20AO
              END-IF
              MOVE BANK-SCR20-SEL1TX TO SEL1TXO IN BANK20AO
           ELSE
              MOVE DFHBMASK TO SEL1IDA IN BANK20AI
              MOVE DFHBMASK TO SEL1IPA IN BANK20AI
              MOVE SPACES TO SEL1IDO IN BANK20AO
              MOVE SPACES TO SEL1IPO IN BANK20AO
              MOVE SPACES TO SEL1TXO IN BANK20AO
           END-IF.
           IF BANK-SCR20-SEL2ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL2IDL IN BANK20AI
              MOVE BANK-SCR20-SEL2ID TO SEL2IDO IN BANK20AO
              MOVE -1 TO SEL2IPL IN BANK20AI
              IF BANK-SCR20-SEL2IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL2IPO IN BANK20AO
              ELSE
                 MOVE BANK-SCR20-SEL2IP TO SEL2IPO IN BANK20AO
              END-IF
              MOVE BANK-SCR20-SEL2TX TO SEL2TXO IN BANK20AO
           ELSE
              MOVE DFHBMASK TO SEL2IDA IN BANK20AI
              MOVE DFHBMASK TO SEL2IPA IN BANK20AI
              MOVE SPACES TO SEL2IDO IN BANK20AO
              MOVE SPACES TO SEL2IPO IN BANK20AO
              MOVE SPACES TO SEL2TXO IN BANK20AO
           END-IF.
           IF BANK-SCR20-SEL3ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL3IDL IN BANK20AI
              MOVE BANK-SCR20-SEL3ID TO SEL3IDO IN BANK20AO
              MOVE -1 TO SEL3IPL IN BANK20AI
              IF BANK-SCR20-SEL3IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL3IPO IN BANK20AO
              ELSE
                 MOVE BANK-SCR20-SEL3IP TO SEL3IPO IN BANK20AO
              END-IF
              MOVE BANK-SCR20-SEL3TX TO SEL3TXO IN BANK20AO
           ELSE
              MOVE DFHBMASK TO SEL3IDA IN BANK20AI
              MOVE DFHBMASK TO SEL3IPA IN BANK20AI
              MOVE SPACES TO SEL3IDO IN BANK20AO
              MOVE SPACES TO SEL3IPO IN BANK20AO
              MOVE SPACES TO SEL3TXO IN BANK20AO
           END-IF.
           IF BANK-SCR20-SEL4ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL4IDL IN BANK20AI
              MOVE BANK-SCR20-SEL4ID TO SEL4IDO IN BANK20AO
              MOVE -1 TO SEL4IPL IN BANK20AI
              IF BANK-SCR20-SEL4IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL4IPO IN BANK20AO
              ELSE
                 MOVE BANK-SCR20-SEL4IP TO SEL4IPO IN BANK20AO
              END-IF
              MOVE BANK-SCR20-SEL4TX TO SEL4TXO IN BANK20AO
           ELSE
              MOVE DFHBMASK TO SEL4IDA IN BANK20AI
              MOVE DFHBMASK TO SEL4IPA IN BANK20AI
              MOVE SPACES TO SEL4IDO IN BANK20AO
              MOVE SPACES TO SEL4IPO IN BANK20AO
              MOVE SPACES TO SEL4TXO IN BANK20AO
           END-IF.
           IF BANK-SCR20-SEL5ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL5IDL IN BANK20AI
              MOVE BANK-SCR20-SEL5ID TO SEL5IDO IN BANK20AO
              MOVE -1 TO SEL5IPL IN BANK20AI
              IF BANK-SCR20-SEL5IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL5IPO IN BANK20AO
              ELSE
                 MOVE BANK-SCR20-SEL5IP TO SEL5IPO IN BANK20AO
              END-IF
              MOVE BANK-SCR20-SEL5TX TO SEL5TXO IN BANK20AO
           ELSE
              MOVE DFHBMASK TO SEL5IDA IN BANK20AI
              MOVE DFHBMASK TO SEL5IPA IN BANK20AI
              MOVE SPACES TO SEL5IDO IN BANK20AO
              MOVE SPACES TO SEL5IPO IN BANK20AO
              MOVE SPACES TO SEL5TXO IN BANK20AO
           END-IF.
           IF BANK-SCR20-SEL6ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL6IDL IN BANK20AI
              MOVE BANK-SCR20-SEL6ID TO SEL6IDO IN BANK20AO
              MOVE -1 TO SEL6IPL IN BANK20AI
              IF BANK-SCR20-SEL6IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL6IPO IN BANK20AO
              ELSE
                 MOVE BANK-SCR20-SEL6IP TO SEL6IPO IN BANK20AO
              END-IF
              MOVE BANK-SCR20-SEL6TX TO SEL6TXO IN BANK20AO
           ELSE
              MOVE DFHBMASK TO SEL6IDA IN BANK20AI
              MOVE DFHBMASK TO SEL6IPA IN BANK20AI
              MOVE SPACES TO SEL6IDO IN BANK20AO
              MOVE SPACES TO SEL6IPO IN BANK20AO
              MOVE SPACES TO SEL6TXO IN BANK20AO
           END-IF.
           IF BANK-SCR20-SEL7ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL7IDL IN BANK20AI
              MOVE BANK-SCR20-SEL7ID TO SEL7IDO IN BANK20AO
              MOVE -1 TO SEL7IPL IN BANK20AI
              IF BANK-SCR20-SEL7IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL7IPO IN BANK20AO
              ELSE
                 MOVE BANK-SCR20-SEL7IP TO SEL7IPO IN BANK20AO
              END-IF
              MOVE BANK-SCR20-SEL7TX TO SEL7TXO IN BANK20AO
           ELSE
              MOVE DFHBMASK TO SEL7IDA IN BANK20AI
              MOVE DFHBMASK TO SEL7IPA IN BANK20AI
              MOVE SPACES TO SEL7IDO IN BANK20AO
              MOVE SPACES TO SEL7IPO IN BANK20AO
              MOVE SPACES TO SEL7TXO IN BANK20AO
           END-IF.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANK20AO
              MOVE DFHGREEN TO SCRNC IN BANK20AO
              MOVE DFHGREEN TO HEAD1C IN BANK20AO
              MOVE DFHGREEN TO DATEC IN BANK20AO
              MOVE DFHGREEN TO TXT02C IN BANK20AO
              MOVE DFHGREEN TO TRANC IN BANK20AO
              MOVE DFHGREEN TO HEAD2C IN BANK20AO
              MOVE DFHGREEN TO TIMEC IN BANK20AO
              MOVE DFHGREEN TO TXT03C IN BANK20AO
              MOVE DFHGREEN TO TXT04C IN BANK20AO
              MOVE DFHGREEN TO SEL1IDC IN BANK20AO
              MOVE DFHGREEN TO SEL1IPC IN BANK20AO
              MOVE DFHGREEN TO SEL1TXC IN BANK20AO
              MOVE DFHGREEN TO SEL2IDC IN BANK20AO
              MOVE DFHGREEN TO SEL2IPC IN BANK20AO
              MOVE DFHGREEN TO SEL2TXC IN BANK20AO
              MOVE DFHGREEN TO SEL3IDC IN BANK20AO
              MOVE DFHGREEN TO SEL3IPC IN BANK20AO
              MOVE DFHGREEN TO SEL3TXC IN BANK20AO
              MOVE DFHGREEN TO SEL4IDC IN BANK20AO
              MOVE DFHGREEN TO SEL4IPC IN BANK20AO
              MOVE DFHGREEN TO SEL4TXC IN BANK20AO
              MOVE DFHGREEN TO SEL5IDC IN BANK20AO
              MOVE DFHGREEN TO SEL5IPC IN BANK20AO
              MOVE DFHGREEN TO SEL5TXC IN BANK20AO
              MOVE DFHGREEN TO SEL6IDC IN BANK20AO
              MOVE DFHGREEN TO SEL6IPC IN BANK20AO
              MOVE DFHGREEN TO SEL6TXC IN BANK20AO
              MOVE DFHGREEN TO SEL7IDC IN BANK20AO
              MOVE DFHGREEN TO SEL7IPC IN BANK20AO
              MOVE DFHGREEN TO SEL7TXC IN BANK20AO
              MOVE DFHGREEN TO TXT05C IN BANK20AO
              MOVE DFHGREEN TO ERRMSGC IN BANK20AO
              MOVE DFHGREEN TO VERC IN BANK20AO
           END-IF.

           EXEC CICS SEND MAP('BANK20A')
                          MAPSET('MBANK20')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN20-BUILD-AND-SEND-EXIT.

       HELP20-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELP20AO==.

           EXEC CICS SEND MAP('HELP20A')
                          MAPSET('MBANK20')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREEN20-BUILD-AND-SEND-EXIT.

       SCREEN20-BUILD-AND-SEND-INET.
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
           MOVE 'BANK20' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCR20-SEL1ID TO EXT-OP20-SEL1ID.
           MOVE BANK-SCR20-SEL1IP TO EXT-OP20-SEL1IP.
           MOVE BANK-SCR20-SEL1TX TO EXT-OP20-SEL1TX.
           MOVE BANK-SCR20-SEL2ID TO EXT-OP20-SEL2ID.
           MOVE BANK-SCR20-SEL2IP TO EXT-OP20-SEL2IP.
           MOVE BANK-SCR20-SEL2TX TO EXT-OP20-SEL2TX.
           MOVE BANK-SCR20-SEL3ID TO EXT-OP20-SEL3ID.
           MOVE BANK-SCR20-SEL3IP TO EXT-OP20-SEL3IP.
           MOVE BANK-SCR20-SEL3TX TO EXT-OP20-SEL3TX.
           MOVE BANK-SCR20-SEL4ID TO EXT-OP20-SEL4ID.
           MOVE BANK-SCR20-SEL4IP TO EXT-OP20-SEL4IP.
           MOVE BANK-SCR20-SEL4TX TO EXT-OP20-SEL4TX.
           MOVE BANK-SCR20-SEL5ID TO EXT-OP20-SEL5ID.
           MOVE BANK-SCR20-SEL5IP TO EXT-OP20-SEL5IP.
           MOVE BANK-SCR20-SEL5TX TO EXT-OP20-SEL5TX.
           MOVE BANK-SCR20-SEL6ID TO EXT-OP20-SEL6ID.
           MOVE BANK-SCR20-SEL6IP TO EXT-OP20-SEL6IP.
           MOVE BANK-SCR20-SEL6TX TO EXT-OP20-SEL6TX.
           MOVE BANK-SCR20-SEL7ID TO EXT-OP20-SEL7ID.
           MOVE BANK-SCR20-SEL7IP TO EXT-OP20-SEL7IP.
           MOVE BANK-SCR20-SEL7TX TO EXT-OP20-SEL7TX.
           GO TO SCREEN20-BUILD-AND-SEND-EXIT.

       SCREEN20-BUILD-AND-SEND-EXIT.
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
