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
      * Program:     SPSWD01P.CBL (CICS Version)                      *
      * Layer:       Transaction manager specific                     *
      * Function:    Perform security operations (sigon, signoff etc)  *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SPSWD01P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SPSWD01P'.
         05  WS-COMMAREA-LENGTH                    PIC 9(5).
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-EIBRESP-DISP                       PIC ZZ9.
         05  WS-EIBRESP2-DISP                      PIC ZZ9.
         05  WS-SECURITY-TRAN                      PIC X(8).
         05  WS-SECURITY-FLAG                      PIC X(1).
           88  SECURITY-REQUIRED                   VALUE 'Y'.

       01  WS-COMMAREA.
       COPY CPSWDD01.

       01  WS-MSG-DATA                             PIC X(80).
       01  WS-MSG-LEN                              PIC S9(8) COMP.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(1)
             OCCURS 1 TO 4096 TIMES
               DEPENDING ON WS-COMMAREA-LENGTH.

       COPY CENTRY.
      *****************************************************************
      * Move the passed data to our area                              *
      *****************************************************************
           MOVE LENGTH OF WS-COMMAREA TO WS-COMMAREA-LENGTH.
           MOVE DFHCOMMAREA TO WS-COMMAREA.

      *****************************************************************
      * Initialize our output area                                    *
      *****************************************************************
           MOVE SPACES TO CPSWDD01O-DATA.

      *****************************************************************
      * Call SSECUREP to see if we need to do security processing     *
      *****************************************************************
           MOVE EIBTRNID TO WS-SECURITY-TRAN.
           CALL 'SSECUREP' USING WS-SECURITY-TRAN
                                 WS-SECURITY-FLAG.

      *****************************************************************
      * If required perform requested processing                      *
      *****************************************************************
           IF SECURITY-REQUIRED
              EVALUATE TRUE
                WHEN PSWD-NOOP
                  PERFORM NOOP-PROCESS
                WHEN PSWD-SIGNON
                  PERFORM SIGNON-PROCESS
                WHEN PSWD-SIGNOFF
                  PERFORM SIGNOFF-PROCESS
                WHEN OTHER
                  PERFORM NOOP-PROCESS
              END-EVALUATE
           END-IF.
           INSPECT CPSWDD01O-MESSAGE REPLACING ALL '~' BY ' '.

      *****************************************************************
      * Move the result back to the callers area                      *
      *****************************************************************
           MOVE WS-COMMAREA TO DFHCOMMAREA(1:WS-COMMAREA-LENGTH).

      *****************************************************************
      * Return to our caller                                          *
      *****************************************************************
       COPY CRETURN.

      *****************************************************************
      * SIGNON Process                                                *
      *****************************************************************
       SIGNON-PROCESS.
           EXEC CICS SIGNOFF
                RESP(WS-RESP)
           END-EXEC.

           EXEC CICS SIGNON
                USERID(CPSWDD01I-USERID)
                PASSWORD(CPSWDD01I-PASSWORD)
                RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS EQUAL TO DFHRESP(USERIDERR) AND
              EIBRESP2 IS EQUAL TO 8
              MOVE FUNCTION LOWER-CASE(CPSWDD01I-USERID)
                TO CPSWDD01I-USERID
              EXEC CICS SIGNON
                   USERID(CPSWDD01I-USERID)
                   PASSWORD(CPSWDD01I-PASSWORD)
                   RESP(WS-RESP)
              END-EXEC
           END-IF.

           IF WS-RESP IS NOT EQUAL TO DFHRESP(NORMAL)
              MOVE EIBRESP TO WS-EIBRESP-DISP
              MOVE EIBRESP2 TO WS-EIBRESP2-DISP
              MOVE SPACES TO WS-MSG-DATA
              IF WS-RESP IS EQUAL TO DFHRESP(NOTAUTH)
                 IF EIBRESP2 IS EQUAL TO 1
                    MOVE 'A password is required~'
                      TO WS-MSG-DATA
                 END-IF
                 IF EIBRESP2 IS EQUAL TO 2
                    MOVE 'The supplied password is wrong~'
                      TO WS-MSG-DATA
                 END-IF
                 IF EIBRESP2 IS EQUAL TO 3
                    MOVE 'A new password is requied~'
                      TO WS-MSG-DATA
                 END-IF
                 IF EIBRESP2 IS EQUAL TO 4
                    MOVE 'The new password is not acceptable~'
                      TO WS-MSG-DATA
                 END-IF
                 IF EIBRESP2 IS EQUAL TO 19
                    MOVE 'The USERID is revoked~'
                      TO WS-MSG-DATA
                 END-IF
                 IF WS-MSG-DATA IS EQUAL TO SPACES
                    STRING 'EIBRESP=NOTAUTH, EIBRESP2='
                             DELIMITED BY SIZE
                           WS-EIBRESP2-DISP DELIMITED BY SIZE
                           '~' DELIMITED BY SIZE
                      INTO WS-MSG-DATA
                 END-IF
              END-IF
              IF WS-RESP IS EQUAL TO DFHRESP(USERIDERR)
                 IF EIBRESP2 IS EQUAL TO 8
                    MOVE 'USERID not known to security manager~'
                      TO WS-MSG-DATA
                 END-IF
                 IF EIBRESP2 IS EQUAL TO 30
                    MOVE 'USERID is blank/null~'
                      TO WS-MSG-DATA
                 END-IF
                 IF WS-MSG-DATA IS EQUAL TO SPACES
                    STRING 'EIBRESP=USERIDERR, EIBRESP2='
                             DELIMITED BY SIZE
                           WS-EIBRESP2-DISP DELIMITED BY SIZE
                           '~' DELIMITED BY SIZE
                      INTO WS-MSG-DATA
                 END-IF
              END-IF
              IF WS-RESP IS EQUAL TO DFHRESP(INVREQ)
                 IF WS-MSG-DATA IS EQUAL TO SPACES
                    STRING 'EIBRESP=NOTAUTH, EIBRESP2='
                             DELIMITED BY SIZE
                           WS-EIBRESP2-DISP DELIMITED BY SIZE
                           '~' DELIMITED BY SIZE
                      INTO WS-MSG-DATA
                 END-IF
              END-IF
              IF WS-RESP IS NOT EQUAL TO DFHRESP(INVREQ) AND
                 WS-RESP IS NOT EQUAL TO DFHRESP(NOTAUTH) AND
                 WS-RESP IS NOT EQUAL TO DFHRESP(USERIDERR)
                 STRING EIBTRMID DELIMITED BY SIZE
                        ' Invalid request. EIBRESP=' DELIMITED BY SIZE
                        WS-EIBRESP-DISP DELIMITED BY SIZE
                        ', EIBRESP2=' DELIMITED BY SIZE
                        WS-EIBRESP2-DISP DELIMITED BY SIZE
                        '~' DELIMITED BY SIZE
                   INTO WS-MSG-DATA
                 MOVE WS-MSG-DATA TO CPSWDD01O-MESSAGE
                 PERFORM DISPLAY-MSG
              END-IF
              MOVE WS-MSG-DATA TO CPSWDD01O-MESSAGE
              PERFORM DISPLAY-MSG
           END-IF.

       SIGNON-PROCESS-EXIT.
           EXIT.

      *****************************************************************
      * SIGNOFF Process                                               *
      *****************************************************************
       SIGNOFF-PROCESS.
           EXEC CICS SIGNOFF
                RESP(WS-RESP)
           END-EXEC.
           IF WS-RESP IS EQUAL TO DFHRESP(NORMAL)
              GO TO SIGNOFF-PROCESS-EXIT
           END-IF.
           MOVE EIBRESP TO WS-EIBRESP-DISP.
           MOVE EIBRESP2 TO WS-EIBRESP2-DISP.
           IF WS-RESP IS EQUAL TO DFHRESP(INVREQ)
              MOVE SPACES TO WS-MSG-DATA
              STRING EIBTRMID DELIMITED BY SIZE
                     ' Invalid operation. EIBRESP=' DELIMITED BY SIZE
                     WS-EIBRESP-DISP DELIMITED BY SIZE
                     ', EIBRESP2=' DELIMITED BY SIZE
                     WS-EIBRESP2-DISP DELIMITED BY SIZE
                     '~' DELIMITED BY SIZE
                INTO WS-MSG-DATA
              PERFORM DISPLAY-MSG
              GO TO SIGNOFF-PROCESS-EXIT
           ELSE
              MOVE SPACES TO WS-MSG-DATA
              STRING EIBTRMID DELIMITED BY SIZE
                     ' Invalid request. EIBRESP=' DELIMITED BY SIZE
                     WS-EIBRESP-DISP DELIMITED BY SIZE
                     ', EIBRESP2=' DELIMITED BY SIZE
                     WS-EIBRESP2-DISP DELIMITED BY SIZE
                     '~' DELIMITED BY SIZE
                INTO WS-MSG-DATA
              PERFORM DISPLAY-MSG
              GO TO SIGNOFF-PROCESS-EXIT
           END-IF
           .
       SIGNOFF-PROCESS-EXIT.
           EXIT.

      *****************************************************************
      * NOOP Process                                                  *
      *****************************************************************
       NOOP-PROCESS.
           CONTINUE.
       NOOP-PROCESS-EXIT.
           EXIT.

      *****************************************************************
      * Write the log message                                         *
      *****************************************************************
       DISPLAY-MSG.
           MOVE 0 TO WS-MSG-LEN.
           INSPECT WS-MSG-DATA TALLYING WS-MSG-LEN
             FOR CHARACTERS BEFORE '~'.
           EXEC CICS WRITE
                     OPERATOR
                     TEXT(WS-MSG-DATA)
                     TEXTLENGTH(WS-MSG-LEN)
           END-EXEC.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
