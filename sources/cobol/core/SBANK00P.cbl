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
      * Program:     SBANK00P.CBL (CICS Version)                      *
      * Layer:       Screen handling                                  *
      * Function:    Screen handling control module                   *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SBANK00P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SBANK00P'.
         05  WS-TRAN-ID                            PIC X(4).
         05  WS-SCREEN-LOGIC-PGM                   PIC X(8)
             VALUE SPACES.
         05  WS-DYNAMIC-PGM                        PIC X(8)
             VALUE 'UNKNOWN'.
         05  WS-ABSTIME                            PIC S9(15) COMP-3.
         05  WS-RESP                               PIC S9(8) COMP.
         05  WS-INPUT-SOURCE-MSG.
           10  FILLER                              PIC X(20)
               VALUE 'Input received from '.
           10  WS-INPUT-SOURCE-MSG-CALL-TYPE       PIC X(8).
       01  WS-BANK-DATA-AREAS.
         05  WS-BANK-DATA.
       COPY CBANKDAT.
         05  WS-BANK-EXT-DATA.
       COPY CBANKEXT.

       01  TS-DATA.
         05  TS-QUEUE-NAME                         PIC X(8).
         05  TS-QUEUE-NAME-PARTS REDEFINES TS-QUEUE-NAME.
           10  TS-QUEUE-NAME-PART1                 PIC X(4).
           10  TS-QUEUE-NAME-PART2                 PIC 9(4).
         05  TS-QUEUE-LEN                          PIC S9(4) COMP.
         05  TS-QUEUE-ITEM                         PIC S9(4) COMP.
         05  TS-QUEUE-DATA                         PIC X(6144).

       COPY DFHAID.

       COPY DFHBMSCA.

       COPY CABENDD.

       01  load-ptr pointer.


       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-TS-QUEUE-NAME                      PIC X(8).
         05  LK-CALL-TYPE                          PIC X(8).
           88  CALL-TYPE-CICSECI                   VALUE 'CICSECI'.
           88  CALL-TYPE-WEBSERV                   VALUE 'WEBSERV'.
         05  LK-PASSED-DATA                        PIC X(1024).
      *COPY CBANKEXT.

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
      * If we have a commarea then its either not the first time in   *
      * from a terminal or we have come from other than a terminal so *
      * display the call type so we know where we came from           *
      *****************************************************************
           IF EIBCALEN IS NOT LESS THAN 8
              IF CALL-TYPE-CICSECI OR
                 CALL-TYPE-WEBSERV
                 MOVE LK-CALL-TYPE TO WS-INPUT-SOURCE-MSG-CALL-TYPE
      *          EXEC CICS WRITE OPERATOR
      *                    TEXT(WS-INPUT-SOURCE-MSG)
      *                    TEXTLENGTH(LENGTH OF WS-INPUT-SOURCE-MSG)
      *          END-EXEC
               END-IF
            END-IF.

      *****************************************************************
      * If this is the first time in, then we assume we are running   *
      * from a CICS terminal so we display map BANK10M and return with*
      * with our COMMAREA set up.                                     *
      *****************************************************************
           IF (EIBCALEN IS EQUAL TO 0) OR
              (EIBCALEN IS NOT EQUAL TO 0 AND
               LK-TS-QUEUE-NAME IS EQUAL TO 'INET****')
              MOVE LOW-VALUES TO WS-BANK-DATA-AREAS
              IF EIBCALEN IS EQUAL TO 0
                 SET BANK-ENV-CICS TO TRUE
                 EXEC CICS RETRIEVE
                           INTO(TS-DATA)
                           LENGTH(LENGTH OF TS-DATA)
                           RESP(WS-RESP)
                 END-EXEC
                 IF TS-DATA(1:7) IS EQUAL TO 'COLOUR='
                    MOVE TS-DATA(8:1) TO BANK-COLOUR-SETTING
                 END-IF
              ELSE
                 SET BANK-ENV-INET TO TRUE
              END-IF
              SET BANK-NO-CONV-IN-PROGRESS TO TRUE
              MOVE SPACES TO BANK-LAST-MAPSET
              MOVE SPACES TO BANK-LAST-MAP
              MOVE SPACES TO BANK-LAST-PROG
              MOVE SPACES TO BANK-NEXT-PROG
              MOVE WS-TRAN-ID TO BANK-CICS-TRANCODE
              EXEC CICS ASKTIME
                        ABSTIME(WS-ABSTIME)
              END-EXEC
              MOVE BANK-ENV TO TS-QUEUE-NAME-PART1
      *       MOVE WS-ABSTIME TO TS-QUEUE-NAME-PART2
              MOVE EIBTASKN   TO TS-QUEUE-NAME-PART2
              EXEC CICS DELETEQ TS
                        QUEUE(TS-QUEUE-NAME)
                        RESP(WS-RESP)
              END-EXEC
              MOVE SPACES TO TS-QUEUE-DATA
              MOVE LENGTH OF TS-QUEUE-DATA TO TS-QUEUE-LEN
              MOVE 0 TO TS-QUEUE-ITEM
              MOVE 0 TO WS-RESP
              EXEC CICS WRITEQ TS
                        QUEUE(TS-QUEUE-NAME)
                        FROM(TS-QUEUE-DATA)
                        LENGTH(TS-QUEUE-LEN)
                        ITEM(TS-QUEUE-ITEM)
                        RESP(WS-RESP)
              END-EXEC
              exec cics write operator
                              text(ts-queue-name)
                              textlength(length of ts-queue-name)
              end-exec

              IF BANK-ENV-INET
                 MOVE TS-QUEUE-NAME TO LK-TS-QUEUE-NAME
              END-IF
           ELSE
              MOVE LOW-VALUES TO WS-BANK-DATA
              MOVE LK-TS-QUEUE-NAME TO TS-QUEUE-NAME
              MOVE LENGTH OF TS-QUEUE-DATA TO TS-QUEUE-LEN
              MOVE 1 TO TS-QUEUE-ITEM
              EXEC CICS READQ TS
                        QUEUE(TS-QUEUE-NAME)
                        INTO(TS-QUEUE-DATA)
                        LENGTH(TS-QUEUE-LEN)
                        ITEM(TS-QUEUE-ITEM)
              END-EXEC
              MOVE TS-QUEUE-DATA TO WS-BANK-DATA
              IF BANK-ENV-INET
                 MOVE LK-PASSED-DATA (1:EIBCALEN) TO WS-BANK-EXT-DATA
                 IF CALL-TYPE-WEBSERV
                    INSPECT WS-BANK-EXT-DATA REPLACING ALL '~' BY
                      LOW-VALUES
                 END-IF
              END-IF
           END-IF.

      *****************************************************************
      * If we get this far then this is not the first time in as we   *
      * have a COMMAREA. Check that BANK-ENV is set correctly to      *
      * ensure we are running in the correct environment etc          *
      *****************************************************************
           IF NOT BANK-ENV-CICS AND
              NOT BANK-ENV-INET
              MOVE WS-PROGRAM-ID TO ABEND-CULPRIT
              MOVE 'S001' TO ABEND-CODE
              MOVE 'Inavlid environment' TO ABEND-REASON
      *        COPY CABENDPO.
              PERFORM ZZ-ABEND
           END-IF.

      *****************************************************************
      * This is the main process                                      *
      *****************************************************************

      *****************************************************************
      * Map the AID in the EIB to our common area                     *
      *****************************************************************
           IF BANK-ENV-INET
              MOVE EXT-IP-AID TO BANK-AID
           ELSE
              EVALUATE TRUE
                WHEN EIBAID IS EQUAL TO DFHENTER
                  SET BANK-AID-ENTER TO TRUE
                WHEN EIBAID IS EQUAL TO DFHCLEAR
                  SET BANK-AID-CLEAR TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPA1
                  SET BANK-AID-PA1   TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPA2
                  SET BANK-AID-PA2   TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF1
                  SET BANK-AID-PFK01 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF2
                  SET BANK-AID-PFK02 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF3
                  SET BANK-AID-PFK03 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF4
                  SET BANK-AID-PFK04 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF5
                  SET BANK-AID-PFK05 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF6
                  SET BANK-AID-PFK06 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF7
                  SET BANK-AID-PFK07 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF8
                  SET BANK-AID-PFK08 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF9
                  SET BANK-AID-PFK09 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF10
                  SET BANK-AID-PFK10 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF11
                  SET BANK-AID-PFK11 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF12
                  SET BANK-AID-PFK12 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF13
                  SET BANK-AID-PFK01 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF14
                 SET BANK-AID-PFK02 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF15
                  SET BANK-AID-PFK03 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF16
                  SET BANK-AID-PFK04 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF17
                  SET BANK-AID-PFK05 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF18
                  SET BANK-AID-PFK06 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF19
                  SET BANK-AID-PFK07 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF20
                  SET BANK-AID-PFK08 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF21
                  SET BANK-AID-PFK09 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF22
                  SET BANK-AID-PFK10 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF23
                  SET BANK-AID-PFK11 TO TRUE
                WHEN EIBAID IS EQUAL TO DFHPF24
                  SET BANK-AID-PFK12 TO TRUE
                WHEN OTHER
                  SET BANK-AID-ENTER TO TRUE
              END-EVALUATE
           END-IF.

      *****************************************************************
      * Check the AID to see if we have to toggle the colour setting  *
      *****************************************************************
           IF BANK-AID-PFK02
              SET BANK-AID-ENTER TO TRUE
              IF COLOUR-ON
                 SET COLOUR-OFF TO TRUE
              ELSE
                 SET COLOUR-ON TO TRUE
              END-IF
           END-IF.

      *****************************************************************
      * If the BANK-NEXT-PROG is not the same as BANK-LAST-PROG then  *
      * we have to go to the next program                             *
      *****************************************************************
       CHECK-PROGRAM-SWITCH.
           IF BANK-NEXT-PROG IS NOT EQUAL TO BANK-LAST-PROG
              EXEC CICS LINK PROGRAM(BANK-NEXT-PROG)
                             COMMAREA(WS-BANK-DATA-AREAS)
                             LENGTH(LENGTH OF WS-BANK-DATA-AREAS)
              END-EXEC
              GO TO CHECK-PROGRAM-SWITCH
           END-IF.

      *****************************************************************
      * We determine what the last screen displayed was and call the  *
      * the appropriate routine to handle it.                         *
      *****************************************************************
           EVALUATE TRUE
             WHEN BANK-LAST-MAPSET IS EQUAL TO SPACES
               MOVE 'SBANK10P' TO WS-SCREEN-LOGIC-PGM
             WHEN OTHER
               STRING 'SBANK' DELIMITED BY SIZE
                      BANK-LAST-MAPSET(6:2) DELIMITED BY SIZE
                      'P' DELIMITED BY SIZE
                 INTO WS-SCREEN-LOGIC-PGM
           END-EVALUATE.
           SET BANK-MAP-FUNCTION-GET TO TRUE.
           EXEC CICS LINK PROGRAM(WS-SCREEN-LOGIC-PGM)
                          COMMAREA(WS-BANK-DATA-AREAS)
                          LENGTH(LENGTH OF WS-BANK-DATA-AREAS)
           END-EXEC.

      *****************************************************************
      * Now we have to see what is required from the business logic   *
      * Essentially the choices will be switch to another program     *
      * (which will be in BANK-NEXT-PROG) or display thge next screen *
      * (which will be in BANK-NEXT-MAPSET/BANK-NEXT-MAP)             *
      *****************************************************************
      * Check for a program switch first
       CHECK-FOR-PGM-SWITCH.
           IF BANK-NEXT-PROG IS NOT EQUAL TO BANK-LAST-PROG
              EXEC CICS LINK PROGRAM(BANK-NEXT-PROG)
                             COMMAREA(WS-BANK-DATA-AREAS)
                             LENGTH(LENGTH OF WS-BANK-DATA-AREAS)
              END-EXEC
              GO TO CHECK-FOR-PGM-SWITCH
           END-IF.

      *****************************************************************
      * We determine which screen we have to display and call the     *
      * appropriate routine to handle it.                             *
      *****************************************************************
      *    MOVE LOW-VALUE TO MAPAREA.
           STRING 'SBANK' DELIMITED BY SIZE
                   BANK-NEXT-MAPSET(6:2) DELIMITED BY SIZE
                  'P' DELIMITED BY SIZE
              INTO WS-SCREEN-LOGIC-PGM.
           SET BANK-MAP-FUNCTION-PUT TO TRUE.
           EXEC CICS LINK PROGRAM(WS-SCREEN-LOGIC-PGM)
                          COMMAREA(WS-BANK-DATA-AREAS)
                          LENGTH(LENGTH OF WS-BANK-DATA-AREAS)
           END-EXEC.

      *****************************************************************
      * Now we have to have finished and can return to our invoker.   *
      * Before retuning, we write out any data we wish to preserve    *
      * to TS. So we can retrieve this data we keep the TS queue id   *
      *****************************************************************
      * Now return to CICS
           MOVE WS-BANK-DATA TO TS-QUEUE-DATA.
           MOVE LENGTH OF TS-QUEUE-DATA TO TS-QUEUE-LEN.
           MOVE 1 TO TS-QUEUE-ITEM.
           MOVE 0 TO WS-RESP.
           EXEC CICS WRITEQ TS
                     QUEUE(TS-QUEUE-NAME)
                     FROM(TS-QUEUE-DATA)
                     LENGTH(TS-QUEUE-LEN)
                     ITEM(TS-QUEUE-ITEM)
                     REWRITE
                     RESP(WS-RESP)
           END-EXEC.

           IF BANK-ENV-INET
              IF CALL-TYPE-WEBSERV
                 INSPECT WS-BANK-EXT-DATA REPLACING ALL LOW-VALUES BY
                   '~'
              END-IF
              MOVE WS-BANK-EXT-DATA TO LK-PASSED-DATA
           END-IF.

           IF BANK-CICS-TRANCODE IS EQUAL TO SPACES OR
              BANK-ENV-INET
              EXEC CICS RETURN
              END-EXEC
           ELSE
              EXEC CICS RETURN
                        TRANSID(BANK-CICS-TRANCODE)
                        COMMAREA(TS-QUEUE-NAME)
                        LENGTH(LENGTH OF TS-QUEUE-NAME)
              END-EXEC
           END-IF.
           GOBACK.

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
