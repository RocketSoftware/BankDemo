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
      * Program:     SBANKZZP.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Determine problem / error to create              *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANKZZP.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANKZZP'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-BUSINESS-LOGIC-PGM                 PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-SAVED-EIBCALEN                     PIC S9(4) COMP.

       01  MAPAREA                                 PIC X(2048).
       COPY MBANKZZ.

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
               PERFORM SCREENZZ-READ THRU
                       SCREENZZ-READ-EXIT
             WHEN BANK-MAP-FUNCTION-PUT
               PERFORM SCREENZZ-BUILD-AND-SEND THRU
                       SCREENZZ-BUILD-AND-SEND-EXIT
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
      * Screen processing for MBANKZZ                                 *
      *---------------------------------------------------------------*
      * Retrieve data from screen and format it                       *
      *****************************************************************
       SCREENZZ-READ.
           MOVE 'BBANKZZP' TO WS-BUSINESS-LOGIC-PGM.
           IF BANK-AID-CLEAR
              SET BANK-AID-PFK03 TO TRUE
              GO TO SCREENZZ-READ-EXIT
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREENZZ-READ-CICS
           ELSE
              GO TO SCREENZZ-READ-INET
           END-IF.

       SCREENZZ-READ-CICS.
           IF BANK-HELP-INACTIVE
              EXEC CICS RECEIVE MAP('BANKZZA')
                                MAPSET('MBANKZZ')
              END-EXEC
           ELSE
              EXEC CICS RECEIVE MAP('HELPZZA')
                                MAPSET('MBANKZZ')
              END-EXEC
              GO TO SCREENZZ-READ-EXIT
           END-IF.

           IF SEL1IDL IN BANKZZAI IS EQUAL TO 0
              MOVE SPACES TO BANK-SCRZZ-SEL1ID
           ELSE
              MOVE SEL1IDI IN BANKZZAI TO BANK-SCRZZ-SEL1ID
              IF BANK-SCRZZ-SEL1ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL1ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL1ID
           END-IF.
           IF SEL1IPL IN BANKZZAI IS EQUAL TO 0
              MOVE LOW-VALUES TO BANK-SCRZZ-SEL1IP
           ELSE
              MOVE SEL1IPI IN BANKZZAI TO BANK-SCRZZ-SEL1IP
              IF BANK-SCRZZ-SEL1IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL1IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL1IP
           END-IF.

           IF SEL2IDL IN BANKZZAI IS EQUAL TO 0
                 MOVE SPACES TO BANK-SCRZZ-SEL2ID
           ELSE
              MOVE SEL2IDI IN BANKZZAI TO BANK-SCRZZ-SEL2ID
              IF BANK-SCRZZ-SEL2ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL2ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL2ID
           END-IF.
           IF SEL2IPL IN BANKZZAI IS EQUAL TO 0
              MOVE LOW-VALUES TO BANK-SCRZZ-SEL2IP
           ELSE
              MOVE SEL2IPI IN BANKZZAI TO BANK-SCRZZ-SEL2IP
              IF BANK-SCRZZ-SEL2IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL2IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL2IP
           END-IF.

           IF SEL3IDL IN BANKZZAI IS EQUAL TO 0
              MOVE SPACES TO BANK-SCRZZ-SEL3ID
           ELSE
              MOVE SEL3IDI IN BANKZZAI TO BANK-SCRZZ-SEL3ID
              IF BANK-SCRZZ-SEL3ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL3ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL3ID
           END-IF.
           IF SEL3IPL IN BANKZZAI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL3IP
           ELSE
              MOVE SEL3IPI IN BANKZZAI TO BANK-SCRZZ-SEL3IP
              IF BANK-SCRZZ-SEL3IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL3IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL3IP
           END-IF.

           IF SEL4IDL IN BANKZZAI IS EQUAL TO 0
              MOVE SPACES TO BANK-SCRZZ-SEL4ID
           ELSE
              MOVE SEL4IDI IN BANKZZAI TO BANK-SCRZZ-SEL4ID
              IF BANK-SCRZZ-SEL4ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL4ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL4ID
           END-IF.
           IF SEL4IPL IN BANKZZAI IS EQUAL TO 0
              MOVE LOW-VALUES TO BANK-SCRZZ-SEL4IP
           ELSE
              MOVE SEL4IPI IN BANKZZAI TO BANK-SCRZZ-SEL4IP
              IF BANK-SCRZZ-SEL4IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL4IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL4IP
           END-IF.

           IF SEL5IDL IN BANKZZAI IS EQUAL TO 0
              MOVE SPACES TO BANK-SCRZZ-SEL5ID
           ELSE
              MOVE SEL5IDI IN BANKZZAI TO BANK-SCRZZ-SEL5ID
              IF BANK-SCRZZ-SEL5ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL5ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL5ID
           END-IF.
           IF SEL5IPL IN BANKZZAI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL5IP
           ELSE
              MOVE SEL5IPI IN BANKZZAI TO BANK-SCRZZ-SEL5IP
              IF BANK-SCRZZ-SEL5IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL5IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL5IP
           END-IF.

           IF SEL6IDL IN BANKZZAI IS EQUAL TO 0
              MOVE SPACES TO BANK-SCRZZ-SEL6ID
           ELSE
              MOVE SEL6IDI IN BANKZZAI TO BANK-SCRZZ-SEL6ID
              IF BANK-SCRZZ-SEL6ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL6ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL6ID
           END-IF.
           IF SEL6IPL IN BANKZZAI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL6IP
           ELSE
              MOVE SEL6IPI IN BANKZZAI TO BANK-SCRZZ-SEL6IP
              IF BANK-SCRZZ-SEL6IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL6IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL6IP
           END-IF.

           IF SEL7IDL IN BANKZZAI IS EQUAL TO 0
              MOVE SPACES TO BANK-SCRZZ-SEL7ID
           ELSE
              MOVE SEL7IDI IN BANKZZAI TO BANK-SCRZZ-SEL7ID
              IF BANK-SCRZZ-SEL7ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL7ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL7ID
           END-IF.
           IF SEL7IPL IN BANKZZAI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL7IP
           ELSE
              MOVE SEL7IPI IN BANKZZAI TO BANK-SCRZZ-SEL7IP
              IF BANK-SCRZZ-SEL7IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL7IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL7IP
           END-IF.

           IF SEL8IDL IN BANKZZAI IS EQUAL TO 0
              MOVE SPACES TO BANK-SCRZZ-SEL8ID
           ELSE
              MOVE SEL8IDI IN BANKZZAI TO BANK-SCRZZ-SEL8ID
              IF BANK-SCRZZ-SEL8ID IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL8ID IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL8ID
           END-IF.
           IF SEL8IPL IN BANKZZAI IS EQUAL TO 0
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL8IP
           ELSE
              MOVE SEL8IPI IN BANKZZAI TO BANK-SCRZZ-SEL8IP
              IF BANK-SCRZZ-SEL8IP IS EQUAL TO SPACES OR
                 BANK-SCRZZ-SEL8IP IS EQUAL TO ALL '_'
                 MOVE LOW-VALUES TO BANK-SCRZZ-SEL8IP
           END-IF.

           GO TO SCREENZZ-READ-EXIT.

       SCREENZZ-READ-INET.
           MOVE EXT-IPZZ-SEL1ID TO BANK-SCRZZ-SEL1ID.
           MOVE EXT-IPZZ-SEL1IP TO BANK-SCRZZ-SEL1IP.
           MOVE EXT-IPZZ-SEL2ID TO BANK-SCRZZ-SEL2ID.
           MOVE EXT-IPZZ-SEL2IP TO BANK-SCRZZ-SEL2IP.
           MOVE EXT-IPZZ-SEL3ID TO BANK-SCRZZ-SEL3ID.
           MOVE EXT-IPZZ-SEL3IP TO BANK-SCRZZ-SEL3IP.
           MOVE EXT-IPZZ-SEL4ID TO BANK-SCRZZ-SEL4ID.
           MOVE EXT-IPZZ-SEL4IP TO BANK-SCRZZ-SEL4IP.
           MOVE EXT-IPZZ-SEL5ID TO BANK-SCRZZ-SEL5ID.
           MOVE EXT-IPZZ-SEL5IP TO BANK-SCRZZ-SEL5IP.
           MOVE EXT-IPZZ-SEL6ID TO BANK-SCRZZ-SEL6ID.
           MOVE EXT-IPZZ-SEL6IP TO BANK-SCRZZ-SEL6IP.
           MOVE EXT-IPZZ-SEL7ID TO BANK-SCRZZ-SEL7ID.
           MOVE EXT-IPZZ-SEL7IP TO BANK-SCRZZ-SEL7IP.
           MOVE EXT-IPZZ-SEL8ID TO BANK-SCRZZ-SEL8ID.
           MOVE EXT-IPZZ-SEL8IP TO BANK-SCRZZ-SEL8IP.
           GO TO SCREENZZ-READ-EXIT.

       SCREENZZ-READ-EXIT.
           EXIT.

      *****************************************************************
      * Screen processing for SCREENZZ (BANKZZ/HELPZZ)                *
      *---------------------------------------------------------------*
      * Build the output screen and send it                           *
      *****************************************************************
       SCREENZZ-BUILD-AND-SEND.
      * Clear map area, get date & time and move to the map
           MOVE LOW-VALUES TO BANKZZAO.
           MOVE EIBTIME TO DD-TIME-INPUT-N.
           MOVE EIBDATE TO DDI-DATA-YYDDD-YYDDD-N.
           SET DDI-YYDDD TO TRUE.
           SET DDO-DD-MMM-YYYY TO TRUE.
           PERFORM CALL-DATECONV THRU
                   CALL-DATECONV-EXIT.
      * Ensure the last map fields are correct
           IF BANK-HELP-ACTIVE
              MOVE 'MHELPZZ' TO BANK-LAST-MAPSET
              MOVE 'HELPZZA' TO BANK-LAST-MAP
           ELSE
              MOVE 'MBANKZZ' TO BANK-LAST-MAPSET
              MOVE 'BANKZZA' TO BANK-LAST-MAP
           END-IF.
           IF BANK-ENV-CICS
              GO TO SCREENZZ-BUILD-AND-SEND-CICS
           ELSE
              GO TO SCREENZZ-BUILD-AND-SEND-INET
           END-IF.

       SCREENZZ-BUILD-AND-SEND-CICS.
           IF BANK-LAST-MAP IS EQUAL TO 'BANKZZA'
              GO TO BANKZZ-BUILD-AND-SEND-CICS
           END-IF.
           IF BANK-LAST-MAP IS EQUAL TO 'HELPZZA'
              GO TO HELPZZ-BUILD-AND-SEND-CICS
           END-IF.
           MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
           MOVE '0003' TO ABEND-CODE
           MOVE SPACES TO ABEND-REASON
           COPY CABENDPO.
           GOBACK.

       BANKZZ-BUILD-AND-SEND-CICS.
           COPY CSCRNHP1 REPLACING ==<<SCRN>>== BY ==BANKZZAO==.
           COPY CVERSNP1 REPLACING ==<<SCRN>>== BY ==BANKZZAO==.
           MOVE WS-TRAN-ID TO TRANO IN BANKZZAO.
           MOVE DD-TIME-OUTPUT TO TIMEO IN BANKZZAO.
           MOVE DDO-DATA TO DATEO IN BANKZZAO.
      * Move in any error message
           MOVE BANK-ERROR-MSG TO ERRMSGO IN BANKZZAO.
      * Move in screen specific fields
           IF BANK-SCRZZ-SEL1ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL1IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL1ID TO SEL1IDO IN BANKZZAO
              MOVE -1 TO SEL1IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL1IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL1IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL1IP TO SEL1IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL1TX TO SEL1TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL1IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL1IPA IN BANKZZAI
              MOVE SPACES TO SEL1IDO IN BANKZZAO
              MOVE SPACES TO SEL1IPO IN BANKZZAO
              MOVE SPACES TO SEL1TXO IN BANKZZAO
           END-IF.
           IF BANK-SCRZZ-SEL2ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL2IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL2ID TO SEL2IDO IN BANKZZAO
              MOVE -1 TO SEL2IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL2IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL2IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL2IP TO SEL2IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL2TX TO SEL2TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL2IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL2IPA IN BANKZZAI
              MOVE SPACES TO SEL2IDO IN BANKZZAO
              MOVE SPACES TO SEL2IPO IN BANKZZAO
              MOVE SPACES TO SEL2TXO IN BANKZZAO
           END-IF.
           IF BANK-SCRZZ-SEL3ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL3IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL3ID TO SEL3IDO IN BANKZZAO
              MOVE -1 TO SEL3IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL3IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL3IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL3IP TO SEL3IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL3TX TO SEL3TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL3IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL3IPA IN BANKZZAI
              MOVE SPACES TO SEL3IDO IN BANKZZAO
              MOVE SPACES TO SEL3IPO IN BANKZZAO
              MOVE SPACES TO SEL3TXO IN BANKZZAO
           END-IF.
           IF BANK-SCRZZ-SEL4ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL4IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL4ID TO SEL4IDO IN BANKZZAO
              MOVE -1 TO SEL4IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL4IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL4IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL4IP TO SEL4IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL4TX TO SEL4TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL4IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL4IPA IN BANKZZAI
              MOVE SPACES TO SEL4IDO IN BANKZZAO
              MOVE SPACES TO SEL4IPO IN BANKZZAO
              MOVE SPACES TO SEL4TXO IN BANKZZAO
           END-IF.
           IF BANK-SCRZZ-SEL5ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL5IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL5ID TO SEL5IDO IN BANKZZAO
              MOVE -1 TO SEL5IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL5IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL5IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL5IP TO SEL5IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL5TX TO SEL5TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL5IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL5IPA IN BANKZZAI
              MOVE SPACES TO SEL5IDO IN BANKZZAO
              MOVE SPACES TO SEL5IPO IN BANKZZAO
              MOVE SPACES TO SEL5TXO IN BANKZZAO
           END-IF.
           IF BANK-SCRZZ-SEL6ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL6IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL6ID TO SEL6IDO IN BANKZZAO
              MOVE -1 TO SEL6IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL6IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL6IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL6IP TO SEL6IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL6TX TO SEL6TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL6IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL6IPA IN BANKZZAI
              MOVE SPACES TO SEL6IDO IN BANKZZAO
              MOVE SPACES TO SEL6IPO IN BANKZZAO
              MOVE SPACES TO SEL6TXO IN BANKZZAO
           END-IF.
           IF BANK-SCRZZ-SEL7ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL7IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL7ID TO SEL7IDO IN BANKZZAO
              MOVE -1 TO SEL7IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL7IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL7IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL7IP TO SEL7IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL7TX TO SEL7TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL7IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL7IPA IN BANKZZAI
              MOVE SPACES TO SEL7IDO IN BANKZZAO
              MOVE SPACES TO SEL7IPO IN BANKZZAO
              MOVE SPACES TO SEL7TXO IN BANKZZAO
           END-IF.
           IF BANK-SCRZZ-SEL8ID IS NOT EQUAL TO SPACES
              MOVE -1 TO SEL8IDL IN BANKZZAI
              MOVE BANK-SCRZZ-SEL8ID TO SEL8IDO IN BANKZZAO
              MOVE -1 TO SEL8IPL IN BANKZZAI
              IF BANK-SCRZZ-SEL8IP IS EQUAL TO LOW-VALUES
                 MOVE ALL '_' TO SEL8IPO IN BANKZZAO
              ELSE
                 MOVE BANK-SCRZZ-SEL8IP TO SEL8IPO IN BANKZZAO
              END-IF
              MOVE BANK-SCRZZ-SEL8TX TO SEL8TXO IN BANKZZAO
           ELSE
              MOVE DFHBMASK TO SEL8IDA IN BANKZZAI
              MOVE DFHBMASK TO SEL8IPA IN BANKZZAI
              MOVE SPACES TO SEL8IDO IN BANKZZAO
              MOVE SPACES TO SEL8IPO IN BANKZZAO
              MOVE SPACES TO SEL8TXO IN BANKZZAO
           END-IF.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO TXT01C IN BANKZZAO
              MOVE DFHGREEN TO SCRNC IN BANKZZAO
              MOVE DFHGREEN TO HEAD1C IN BANKZZAO
              MOVE DFHGREEN TO DATEC IN BANKZZAO
              MOVE DFHGREEN TO TXT02C IN BANKZZAO
              MOVE DFHGREEN TO TRANC IN BANKZZAO
              MOVE DFHGREEN TO HEAD2C IN BANKZZAO
              MOVE DFHGREEN TO TIMEC IN BANKZZAO
              MOVE DFHGREEN TO TXT03C IN BANKZZAO
              MOVE DFHGREEN TO TXT04C IN BANKZZAO
              MOVE DFHGREEN TO SEL1IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL1IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL1TXC IN BANKZZAO
              MOVE DFHGREEN TO SEL2IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL2IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL2TXC IN BANKZZAO
              MOVE DFHGREEN TO SEL3IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL3IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL3TXC IN BANKZZAO
              MOVE DFHGREEN TO SEL4IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL4IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL4TXC IN BANKZZAO
              MOVE DFHGREEN TO SEL5IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL5IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL5TXC IN BANKZZAO
              MOVE DFHGREEN TO SEL6IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL6IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL6TXC IN BANKZZAO
              MOVE DFHGREEN TO SEL7IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL7IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL7TXC IN BANKZZAO
              MOVE DFHGREEN TO SEL8IDC IN BANKZZAO
              MOVE DFHGREEN TO SEL8IPC IN BANKZZAO
              MOVE DFHGREEN TO SEL8TXC IN BANKZZAO
              MOVE DFHGREEN TO ERRMSGC IN BANKZZAO
              MOVE DFHGREEN TO VERC IN BANKZZAO
           END-IF.

           EXEC CICS SEND MAP('BANKZZA')
                          MAPSET('MBANKZZ')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREENZZ-BUILD-AND-SEND-EXIT.

       HELPZZ-BUILD-AND-SEND-CICS.
           COPY CSCRNHP2 REPLACING ==:OPTN:== BY ==BANK==
                                   ==<<SCRN>>== BY ==HELPZZAO==.

           EXEC CICS SEND MAP('HELPZZA')
                          MAPSET('MBANKZZ')
                          ERASE
                          FREEKB
           END-EXEC.
           GO TO SCREENZZ-BUILD-AND-SEND-EXIT.

       SCREENZZ-BUILD-AND-SEND-INET.
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
           MOVE 'BANKZZ' TO EXT-OP-SCREEN.
      * Move in userid and any error message
           MOVE BANK-ERROR-MSG TO EXT-OP-ERR-MSG.
           MOVE BANK-USERID TO EXT-OP-USERID.
           MOVE BANK-USERID-NAME TO EXT-OP-NAME.
      * Move in screen specific fields
           MOVE BANK-SCRZZ-SEL1ID TO EXT-OPZZ-SEL1ID.
           MOVE BANK-SCRZZ-SEL1IP TO EXT-OPZZ-SEL1IP.
           MOVE BANK-SCRZZ-SEL1TX TO EXT-OPZZ-SEL1TX.
           MOVE BANK-SCRZZ-SEL2ID TO EXT-OPZZ-SEL2ID.
           MOVE BANK-SCRZZ-SEL2IP TO EXT-OPZZ-SEL2IP.
           MOVE BANK-SCRZZ-SEL2TX TO EXT-OPZZ-SEL2TX.
           MOVE BANK-SCRZZ-SEL3ID TO EXT-OPZZ-SEL3ID.
           MOVE BANK-SCRZZ-SEL3IP TO EXT-OPZZ-SEL3IP.
           MOVE BANK-SCRZZ-SEL3TX TO EXT-OPZZ-SEL3TX.
           MOVE BANK-SCRZZ-SEL4ID TO EXT-OPZZ-SEL4ID.
           MOVE BANK-SCRZZ-SEL4IP TO EXT-OPZZ-SEL4IP.
           MOVE BANK-SCRZZ-SEL4TX TO EXT-OPZZ-SEL4TX.
           MOVE BANK-SCRZZ-SEL5ID TO EXT-OPZZ-SEL5ID.
           MOVE BANK-SCRZZ-SEL5IP TO EXT-OPZZ-SEL5IP.
           MOVE BANK-SCRZZ-SEL5TX TO EXT-OPZZ-SEL5TX.
           MOVE BANK-SCRZZ-SEL6ID TO EXT-OPZZ-SEL6ID.
           MOVE BANK-SCRZZ-SEL6IP TO EXT-OPZZ-SEL6IP.
           MOVE BANK-SCRZZ-SEL6TX TO EXT-OPZZ-SEL6TX.
           MOVE BANK-SCRZZ-SEL7ID TO EXT-OPZZ-SEL7ID.
           MOVE BANK-SCRZZ-SEL7IP TO EXT-OPZZ-SEL7IP.
           MOVE BANK-SCRZZ-SEL7TX TO EXT-OPZZ-SEL7TX.
           MOVE BANK-SCRZZ-SEL8ID TO EXT-OPZZ-SEL8ID.
           MOVE BANK-SCRZZ-SEL8IP TO EXT-OPZZ-SEL8IP.
           MOVE BANK-SCRZZ-SEL8TX TO EXT-OPZZ-SEL8TX.
           GO TO SCREENZZ-BUILD-AND-SEND-EXIT.

       SCREENZZ-BUILD-AND-SEND-EXIT.
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
