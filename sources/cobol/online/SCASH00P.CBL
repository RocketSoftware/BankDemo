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
      * Program:     SCASH00P.CBL (CICS Version)                      *
      * Layer:       ?                                                *
      * Function:    ATM - socket interface                           *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SCASH00P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'SCASH00P'.
         05  WS-TRAN-ID                            PIC X(4).

       01  WS-SF-ACCEPT              PIC X(16) VALUE 'ACCEPT          '.
       01  WS-SF-BIND                PIC X(16) VALUE 'BIND            '.
       01  WS-SF-CLOSE               PIC X(16) VALUE 'CLOSE           '.
       01  WS-SF-CONNECT             PIC X(16) VALUE 'CONNECT         '.
       01  WS-SF-FCNTL               PIC X(16) VALUE 'FCNTL           '.
       01  WS-SF-GETCLIENTID         PIC X(16) VALUE 'GETCLIENTID     '.
       01  WS-SF-GETHOSTBYADDR       PIC X(16) VALUE 'GETHOSTBYADDR   '.
       01  WS-SF-GETHOSTBYNAME       PIC X(16) VALUE 'GETHOSTBYNAME   '.
       01  WS-SF-GETHOSTID           PIC X(16) VALUE 'GETHOSTID       '.
       01  WS-SF-GETHOSTNAME         PIC X(16) VALUE 'GETHOSTNAME     '.
       01  WS-SF-GIVESOCKET          PIC X(16) VALUE 'GIVESOCKET      '.
       01  WS-SF-INITAPI             PIC X(16) VALUE 'INITAPI         '.
       01  WS-SF-IOCTL               PIC X(16) VALUE 'IOCTL           '.
       01  WS-SF-LISTEN              PIC X(16) VALUE 'LISTEN          '.
       01  WS-SF-RECV                PIC X(16) VALUE 'RECV            '.
       01  WS-SF-SELECT              PIC X(16) VALUE 'SELECT          '.
       01  WS-SF-SEND                PIC X(16) VALUE 'SEND            '.
       01  WS-SF-SHUTDOWN            PIC X(16) VALUE 'SHUTDOWN        '.
       01  WS-SF-SOCKET              PIC X(16) VALUE 'SOCKET          '.
       01  WS-SF-TAKESOCKET          PIC X(16) VALUE 'TAKESOCKET      '.

       01  WS-PASS-SOCKET-DATA.
         05  WS-PASS-SOCKET            PIC 9(8)  BINARY.
         05  WS-PASS-LSTN-NAME         PIC X(8).
         05  WS-PASS-LSTN-SUBNAME      PIC X(8).
         05  WS-PASS-CLIENT-IN-DATA    PIC X(35).
         05  WS-PASS-OTE               PIC X(1).
         05  WS-PASS-SOCKADDR-IN-PARM.
           10  WS-PASS-SIN-FAMILY      PIC 9(4)  BINARY.
           10  WS-PASS-SIN-PORT        PIC 9(4)  BINARY.
           10  WS-PASS-SIN-ADDR        PIC 9(8)  BINARY.
           10  WS-PASS-SIN-ZERO        PIC X(8).

       01  WS-CLIENTID-LSTN.
         05  WS-CID-DOMAIN-LSTN        PIC 9(8)  BINARY.
         05  WS-CID-NAME-LSTN          PIC X(8).
         05  WS-CID-SUBTASKNAME-LSTN   PIC X(8).
         05  WS-CID-RES-LSTN           PIC X(20).

       01  WS-CHARSET-LOCAL            PIC X(1)  VALUE SPACE.
         88  88-LOCAL-CHARSET-ASCII    VALUE X'20'.
         88  88-LOCAL-CHARSET-EBCDIC   VALUE X'40'.
       01  WS-CHARSET-REMOTE           PIC X(1)  VALUE SPACE.
         88  88-REMOTE-CHARSET-ASCII   VALUE X'20'.
         88  88-REMOTE-CHARSET-EBCDIC  VALUE X'40'.
       01  WS-CHARSET-TRANSLATE        PIC X(1).
         88  88-TRANSLATE-CHARSET-RECV VALUE 'R'.
         88  88-TRANSLATE-CHARSET-SEND VALUE 'S'.

       01  WS-WTO-IND                  PIC X(1)  VALUE 'N'.
         88  88-WTO-REQUIRED           VALUE 'Y'.
       01  WS-SUB                      PIC 9(5)  VALUE 0.
       01  WS-SOCKID                   PIC 9(4)  BINARY VALUE 0.
       01  WS-SOCKID-FWD               PIC 9(4)  BINARY VALUE 0.
       01  WS-TAKESOCKET               PIC 9(8)  BINARY VALUE 0.
       01  WS-ERRNO                    PIC 9(8)  BINARY VALUE 0.
       01  WS-RETCODE                  PIC S9(8) BINARY VALUE 0.
       01  WS-FLAGS                    PIC 9(8)  BINARY VALUE 0.

       01  WS-BUFFER-IN-LEN            PIC 9(8)  BINARY VALUE 0.
       01  WS-BUFFER-OUT-LEN           PIC 9(8)  BINARY VALUE 0.

       01  WS-TRANSLATE-LEN            PIC 9(8)  BINARY.

       01  WS-LK-BUFFER-ADDR           POINTER.
       01  WS-ENDBUFF-FLAG             PIC X(1)  VALUE 'N'.
         88  88-ENDBUFF-TRUE           VALUE 'Y'.
         88  88-ENDBUFF-FALSE          VALUE 'N'.

       01  WS-BUFFER-IN-AREA.
         05  FILLER                    PIC X(1024)
                                                 VALUE SPACES.
       01  WS-BUFFER-OUT-AREA.
         05  FILLER                    PIC X(1024)
                                                 VALUE SPACES.

       01  WS-EZA-MSG                  PIC X(256).
       01  WS-EZA-MSG-len              PIC S9(8) BINARY.

       01  WS-ERR-MSG-AREA.
         05  WS-ERR-ERRNO              PIC 9(5).
         05  FILLER                    PIC X(1) VALUE ','.
         05  WS-ERR-MSG                PIC X(30).
         05  WS-ERR-MSG-DELIM          PIC X(1) VALUE LOW-VALUE.

       01  WS-CICS-ERR-MSG-AREA.
         05  WS-CICS-ERR-EIBRESP       PIC Z(2)9.
         05  WS-CICS-ERR-FUNC          PIC X(128).
         05  WS-CICS-ERR-MSG           PIC X(128).
         05  WS-CICS-ERR-MSG-LEN       PIC S9(8) BINARY.

       01  WS-GETMAIN-INIT-VALUE       PIC X(1)  VALUE SPACE.
       01  WS-GETMAIN-FLENGTH          PIC S9(8) BINARY VALUE 0.
       01  WS-DFHRESP                  PIC S9(8) BINARY VALUE 0.
       01  WS-ABSTIME                  PIC S9(15) COMP-3.
       01  WS-BUSINESS-MODULE          PIC X(8).

       01  WS-TRACE-TSQ-NAME           PIC X(08) VALUE 'CASH-TSQ'.

       01  WS-TRACE-TSQ-MSG-LEN        PIC S9(4) BINARY.

       01  WS-TRACE-TSQ-MSG.
         05  WS-TRACE-TSQ-TIMESTAMP.
           10  WS-TRACE-TSQ-DATE       PIC X(6).
           10  WS-TRACE-TSQ-COMMA1     PIC X(1).
           10  WS-TRACE-TSQ-TIME       PIC X(8).
           10  WS-TRACE-TSQ-COMMA2     PIC X(1).
         05  WS-TRACE-TSQ-MSG-DATA     PIC X(200) VALUE SPACES.

      *****************************************************************
      * The following tables are used by the INSPECT statement to do  *
      * the conversion betweeen EBCDIC and ASCII.                     *
      * inspect FIELD-NAME converting EBCDIC-INFO to ASCII-INFO       *
      * inspect FIELD-NAME converting ASCII-INFO  to EBCDIC-INFO      *
      *                                                               *
      * The tables may also be used to convert between lower and      *
      * upper case.         *                                         *
      * inspect FIELD-NAME converting EBCDIC-LOWER to EBCDIC-UPPER    *
      * inspect FIELD-NAME converting ASCII-LOWER  to ASCII-UPPER     *
      *****************************************************************
      *
      *>   ------------------------------------------------------------
      *>   **  The EBCDIC Table ...
      *>   **  01                             A B C D E F G H I
      *>   **  02                             J K L M N O P Q R
      *>   **  03                             S T U V W X Y Z
      *>   **  04                             a b c d e f g h i
      *>   **  05                             j k l m n o p q r
      *>   **  06                             s t u v w x y z
      *>   **  07                             0 1 2 3 4 5 6 7 8 9
      *>   **  08                         space . < ( + | & ! $ *
      *>   **  09                             ) ; - / , % _ > ? `
      *>   **  10  7D/7F Single/Double quote  : # @7D =7F [ ] { }
      *>   **  11                             \ ~ ^
       01  EBCDIC-CONVERSION-DATA.
         05  EBCDIC-DATA.
           10  EBCDIC-UPPER-CASE-DATA.
             15  FILLER                            PIC X(9)
                 VALUE X'C1C2C3C4C5C6C7C8C9'.
             15  FILLER                            PIC X(9)
                 VALUE X'D1D2D3D4D5D6D7D8D9'.
             15  FILLER                            PIC X(8)
                 VALUE X'E2E3E4E5E6E7E8E9'.
           10  EBCDIC-UPPER REDEFINES EBCDIC-UPPER-CASE-DATA
                                                   PIC X(26).
           10  EBCDIC-LOWER-CASE-DATA.
             15  FILLER                            PIC X(9)
                 VALUE X'818283848586878889'.
             15  FILLER                            PIC X(9)
                 VALUE X'919293949596979899'.
             15  FILLER                            PIC X(8)
                 VALUE X'A2A3A4A5A6A7A8A9'.
           10  EBCDIC-LOWER REDEFINES EBCDIC-LOWER-CASE-DATA
                                                   PIC X(26).
           10  EBCDIC-DIGITS.
             15  FILLER                            PIC X(10)
                 VALUE X'F0F1F2F3F4F5F6F7F8F9'.
           10  EBCDIC-SPECIAL.
             15  FILLER                            PIC X(10)
                 VALUE X'404B4C4D4E4F505A5B5C'.
             15  FILLER                            PIC X(10)
                 VALUE X'5D5E60616B6C6D6E6F79'.
             15  FILLER                            PIC X(10)
                 VALUE X'7A7B7C7D7E7FADBDC0D0'.
             15  FILLER                            PIC X(3)
                 VALUE X'E0A1B0'.
         05  EBCDIC-INFO REDEFINES EBCDIC-DATA     PIC X(95).
         05  EBCDIC-TABLE REDEFINES EBCDIC-DATA.
           10  EBCDIC-BYTE                         PIC X(1)
                                                   OCCURS 95 TIMES.
      *
      *>   ------------------------------------------------------------
      *>   **  The ASCII Table ...
      *>   **  01                             A B C D E F G H I
      *>   **  02                             J K L M N O P Q R
      *>   **  03                             S T U V W X Y Z
      *>   **  04                             a b c d e f g h i
      *>   **  05                             j k l m n o p q r
      *>   **  06                             s t u v w x y z
      *>   **  07                             0 1 2 3 4 5 6 7 8 9
      *>   **  08                         space . < ( + | & ! $ *
      *>   **  09                             ) ; - / , % _ > ? `
      *>   **  10  27/22 Single/Double quote  : # @27 =22 [ ] { }
      *>   **  11                             \ ~ ^
       01  ASCII-CONVERSION-DATA.
         05  ASCII-DATA.
           10  ASCII-UPPER-CASE-DATA.
             15  FILLER                            PIC X(9)
                 VALUE X'414243444546474849'.
             15  FILLER                            PIC X(9)
                 VALUE X'4A4B4C4D4E4F505152'.
             15  FILLER                            PIC X(8)
                 VALUE X'535455565758595A'.
           10  ASCII-UPPER REDEFINES ASCII-UPPER-CASE-DATA
                                                   PIC X(26).
           10  ASCII-LOWER-CASE-DATA.
             15  FILLER                            PIC X(9)
                 VALUE X'616263646566676869'.
             15  FILLER                            PIC X(9)
                 VALUE X'6A6B6C6D6E6F707172'.
             15  FILLER                            PIC X(8)
                 VALUE X'737475767778797A'.
           10  ASCII-LOWER REDEFINES ASCII-LOWER-CASE-DATA
                                                   PIC X(26).
           10  ASCII-DIGITS.
             15  FILLER                            PIC X(10)
                 VALUE X'30313233343536373839'.
           10  ASCII-SPECIAL.
             15  FILLER                            PIC X(10)
                 VALUE X'202E3C282B7C2621242A'.
             15  FILLER                            PIC X(10)
                 VALUE X'293B2D2F2C255F3E3F79'.
             15  FILLER                            PIC X(10)
                 VALUE X'3A2340273D225B5D7B7D'.
             15  FILLER                            PIC X(3)
                 VALUE X'5C7E5E'.
         05  ASCII-INFO REDEFINES ASCII-DATA       PIC X(95).

         05  ASCII-TABLE REDEFINES ASCII-DATA.
           10  ASCII-BYTE                          PIC X(1)
                                                   OCCURS 95 TIMES.
       LINKAGE SECTION.
       01  DFHCOMMAREA.
      *  05  LK-CALLING-RTN            PIC X(8).
         05  FILLER PIC X(1) OCCURS 1 TO 32767 TIMES
             DEPENDING ON EIBCALEN.



       01  LK-AREA-TO-TRANSLATE.
         05  FILLER                    PIC X(1)
             OCCURS 1 TO 32768 TIMES DEPENDING ON WS-TRANSLATE-LEN.

       01  LK-BUFFER-CASH.
       COPY CCASHDAT.
       01  LK-BUFFER REDEFINES LK-BUFFER-CASH.
         05  LK-BUFFER-IN-AREA.
           10 LK-BUFFER-BYTE           PIC X(1)
                occurs 1024.

       PROCEDURE DIVISION.
      *****************************************************************
      * Store our transaction-id in msg                               *
      *****************************************************************
           MOVE EIBTRNID TO WS-TRAN-ID.

      *****************************************************************
      * Get storage for the area to be passed to linked-to programs    *
      *****************************************************************
           MOVE LENGTH OF LK-BUFFER TO WS-GETMAIN-FLENGTH.
           EXEC CICS GETMAIN
                     SET(WS-LK-BUFFER-ADDR)
                     FLENGTH(WS-GETMAIN-FLENGTH)
                     INITIMG(WS-GETMAIN-INIT-VALUE)
                     RESP(WS-DFHRESP)
           END-EXEC.
           IF WS-DFHRESP IS NOT EQUAL DFHRESP(NORMAL)
              MOVE  LOW-VALUES TO WS-CICS-ERR-MSG
              MOVE WS-DFHRESP TO WS-CICS-ERR-EIBRESP
              STRING EIBTRNID DELIMITED BY SIZE
                     ': getmain failed, resp=' DELIMITED BY SIZE
                     WS-CICS-ERR-EIBRESP DELIMITED BY SIZE
                INTO WS-CICS-ERR-MSG
              MOVE LOW-VALUES TO WS-EZA-MSG
              MOVE WS-CICS-ERR-MSG
                TO WS-EZA-MSG(1:LENGTH OF WS-CICS-ERR-MSG)
              PERFORM Z0200-CICS-WRITE-OPERATOR
              PERFORM A0900-RETURN-TO-CICS
              GOBACK
           END-IF.
           SET ADDRESS OF LK-BUFFER TO WS-LK-BUFFER-ADDR.

      *****************************************************************
      * Retrieve data from listener transaction                        *
      *****************************************************************
           EXEC CICS RETRIEVE
                     INTO(WS-PASS-SOCKET-DATA)
                     LENGTH(LENGTH OF WS-PASS-SOCKET-DATA)
                     RESP(WS-DFHRESP)
           END-EXEC.
           if WS-DFHRESP IS NOT EQUAL DFHRESP(NORMAL)
              MOVE LOW-VALUES TO WS-CICS-ERR-MSG
              MOVE WS-DFHRESP TO WS-CICS-ERR-EIBRESP
              STRING EIBTRNID DELIMITED BY SIZE
                     ': retrieve failed, resp=' DELIMITED BY SIZE
                     WS-CICS-ERR-EIBRESP DELIMITED BY SIZE
                     X'1A' DELIMITED BY SIZE
                INTO WS-CICS-ERR-MSG
              MOVE LOW-VALUES TO WS-EZA-MSG
              MOVE WS-CICS-ERR-MSG
                TO WS-EZA-MSG(1:LENGTH OF WS-CICS-ERR-MSG)
              PERFORM Z0200-CICS-WRITE-OPERATOR
              PERFORM A0900-RETURN-TO-CICS
              GOBACK
           END-IF.

           MOVE WS-PASS-SIN-FAMILY TO WS-CID-DOMAIN-LSTN.
           MOVE WS-PASS-LSTN-NAME TO WS-CID-NAME-LSTN.
           MOVE WS-PASS-LSTN-SUBNAME TO WS-CID-SUBTASKNAME-LSTN.
           MOVE WS-PASS-SOCKET TO WS-TAKESOCKET.
           MOVE WS-PASS-SOCKET TO WS-SOCKID.

           MOVE SPACE TO WS-CHARSET-LOCAL
           SET 88-REMOTE-CHARSET-ASCII TO TRUE.
           IF FUNCTION UPPER-CASE(WS-PASS-CLIENT-IN-DATA(1:3))
                IS EQUAL TO 'ASC'
              SET 88-REMOTE-CHARSET-ASCII TO TRUE
           END-IF.
           IF FUNCTION UPPER-CASE(WS-PASS-CLIENT-IN-DATA(1:3))
                IS EQUAL TO 'EBC'
              SET 88-REMOTE-CHARSET-ASCII TO TRUE
           END-IF.

      *****************************************************************
      * Take the passed socket                                        *
      *****************************************************************
           CALL 'EZASOKET' USING WS-SF-TAKESOCKET
                                 WS-SOCKID
                                 WS-CLIENTID-LSTN
                                 WS-ERRNO
                                 WS-RETCODE.

           IF WS-RETCODE IS LESS THAN ZERO
              MOVE 'TAKESOCKET Error' TO WS-ERR-MSG
              MOVE WS-ERRNO TO WS-ERR-ERRNO
              PERFORM Z0100-PROGRAM-ERROR
              PERFORM A0900-RETURN-TO-CICS
              GOBACK
           ELSE
              MOVE WS-RETCODE TO WS-SOCKID-FWD
           END-IF.

      *****************************************************************
      * Now receive tha data sent from caller                          *
      *****************************************************************
           MOVE ZERO TO WS-FLAGS.
           MOVE LENGTH OF WS-BUFFER-IN-AREA TO WS-BUFFER-IN-LEN.
           MOVE LOW-VALUES TO WS-BUFFER-IN-AREA.
           CALL 'EZASOKET' USING WS-SF-RECV
                                 WS-SOCKID-FWD
                                 WS-FLAGS
                                 WS-BUFFER-IN-LEN
                                 WS-BUFFER-IN-AREA
                                 WS-ERRNO
                                 WS-RETCODE.

           IF WS-RETCODE IS LESS THAN ZERO
              MOVE 'RECEIVE Error' TO WS-ERR-MSG
              MOVE WS-ERRNO TO WS-ERR-ERRNO
              PERFORM Z0100-PROGRAM-ERROR
              PERFORM A0900-RETURN-TO-CICS
              GOBACK
           END-IF.
           SET ADDRESS OF LK-AREA-TO-TRANSLATE
            TO ADDRESS OF WS-BUFFER-IN-AREA.
           MOVE WS-BUFFER-IN-LEN TO WS-TRANSLATE-LEN.
           SET 88-TRANSLATE-CHARSET-RECV TO TRUE.
           PERFORM A1000-TRANSLATE.

      * THIS IS WHERE WE WILL CALL THE APPLICATION LOGIC

           MOVE LOW-VALUES TO LK-BUFFER.
           MOVE WS-BUFFER-IN-AREA(1:WS-BUFFER-IN-LEN)
             TO LK-BUFFER(1:WS-BUFFER-IN-LEN).

           MOVE 'BCASH00P' TO WS-BUSINESS-MODULE.

           EXEC CICS LINK PROGRAM(WS-BUSINESS-MODULE)
                          COMMAREA(LK-BUFFER)
                          LENGTH(LENGTH OF LK-BUFFER)
                          RESP(WS-DFHRESP)
           END-EXEC.


      *****************************************************************
      * Check to see if the connection has beeen closed                *
      *****************************************************************
      *    IF WS-RETCODE IS EQUAL TO ZERO
      *       GO TO A0800-CLOSE-SOCKET
      *   END-IF.

      *****************************************************************
      * Find length OF data returned from linked program               *
      *****************************************************************
           MOVE 1 TO WS-SUB.
           SET 88-ENDBUFF-FALSE TO TRUE
           PERFORM UNTIL 88-ENDBUFF-TRUE
             IF LK-BUFFER-BYTE(WS-SUB) IS EQUAL TO X'00'
                 SET 88-ENDBUFF-TRUE TO TRUE
             END-IF
             IF 88-ENDBUFF-TRUE
                CONTINUE
             ELSE
                ADD 1 TO WS-SUB
                IF WS-SUB IS GREATER THAN LENGTH OF LK-BUFFER
                   SET 88-ENDBUFF-TRUE TO TRUE
                END-IF
             END-IF
           END-PERFORM.

           SUBTRACT 1 FROM WS-SUB.

           MOVE LOW-VALUES TO WS-BUFFER-OUT-AREA.
           MOVE LK-BUFFER-IN-AREA(1:WS-SUB) TO WS-BUFFER-OUT-AREA.
           MOVE WS-SUB TO WS-BUFFER-OUT-LEN.
           SET ADDRESS OF LK-AREA-TO-TRANSLATE
            TO ADDRESS OF WS-BUFFER-OUT-AREA.
           MOVE WS-BUFFER-OUT-LEN TO WS-TRANSLATE-LEN.
           SET 88-TRANSLATE-CHARSET-SEND TO TRUE.
           PERFORM A1000-TRANSLATE.

      *****************************************************************
      * Send the requested data back to the caller                    *
      *****************************************************************
           CALL 'EZASOKET' USING WS-SF-SEND
                                 WS-SOCKID-FWD
                                 WS-FLAGS
                                 WS-BUFFER-OUT-LEN
                                 WS-BUFFER-OUT-AREA(1:WS-SUB)
                                 WS-ERRNO
                                 WS-RETCODE.

           IF WS-RETCODE IS LESS THAN ZERO
              MOVE 'SEND Error' TO WS-ERR-MSG
              MOVE WS-ERRNO TO WS-ERR-ERRNO
              PERFORM Z0100-PROGRAM-ERROR
           END-IF.

      *****************************************************************
      * Close the socket                                               *
      *****************************************************************
       A0800-CLOSE-SOCKET.
           MOVE LOW-VALUES TO WS-EZA-MSG.
           STRING EIBTRNID DELIMITED BY SIZE
                  ' Closing connection...' DELIMITED BY SIZE
             INTO WS-CICS-ERR-MSG.
           PERFORM Z0200-CICS-WRITE-OPERATOR.
           CALL 'EZASOKET' USING WS-SF-CLOSE
                                 WS-SOCKID-FWD
                                 WS-ERRNO
                                 WS-RETCODE.

           IF WS-RETCODE IS LESS THAN ZERO
              MOVE 'CLOSE Error' TO WS-ERR-MSG
              MOVE WS-ERRNO TO WS-ERR-ERRNO
              PERFORM Z0100-PROGRAM-ERROR
           END-IF.
           PERFORM A0900-RETURN-TO-CICS.
           GOBACK.

      *****************************************************************
      * Return control to CICS                                         *
      *****************************************************************
       A0900-RETURN-TO-CICS.
           EXEC CICS RETURN
           END-EXEC.

       A1000-TRANSLATE.
      *****************************************************************
      * Use INSPECT to perform ASCII<>EBCDIC translations             *
      *****************************************************************
           IF 88-TRANSLATE-CHARSET-RECV
              IF 88-LOCAL-CHARSET-EBCDIC AND 88-REMOTE-CHARSET-ASCII
                 INSPECT LK-AREA-TO-TRANSLATE
                   CONVERTING ASCII-INFO TO EBCDIC-INFO
              END-IF
              IF 88-LOCAL-CHARSET-ASCII AND 88-REMOTE-CHARSET-EBCDIC
                 INSPECT LK-AREA-TO-TRANSLATE
                   CONVERTING EBCDIC-INFO TO ASCII-INFO
              END-IF
           END-IF.
           IF 88-TRANSLATE-CHARSET-SEND
              IF 88-LOCAL-CHARSET-EBCDIC AND 88-REMOTE-CHARSET-ASCII
                 INSPECT LK-AREA-TO-TRANSLATE
                   CONVERTING EBCDIC-INFO TO ASCII-INFO
              END-IF
              IF 88-LOCAL-CHARSET-ASCII AND 88-REMOTE-CHARSET-EBCDIC
                 INSPECT LK-AREA-TO-TRANSLATE
                   CONVERTING ASCII-INFO TO EBCDIC-INFO
              END-IF
           END-IF.

      *****************************************************************
      * Program error so write message oy                             *
      *****************************************************************
       Z0100-PROGRAM-ERROR.
           MOVE WS-ERR-MSG-AREA TO WS-CICS-ERR-MSG.
           MOVE LOW-VALUES TO WS-EZA-MSG
           MOVE WS-CICS-ERR-MSG
             TO WS-EZA-MSG(1:LENGTH OF WS-CICS-ERR-MSG)
           PERFORM Z0200-CICS-WRITE-OPERATOR.

      *****************************************************************
      * Write message to CICS console                                 *
      *****************************************************************
       Z0200-CICS-WRITE-OPERATOR.
           IF 88-WTO-REQUIRED
              MOVE ZERO TO WS-EZA-MSG-LEN
              INSPECT WS-EZA-MSG
                TALLYING WS-EZA-MSG-LEN
                  FOR CHARACTERS BEFORE X'00'
              EXEC CICS WRITE
                        OPERATOR
                        TEXT(WS-EZA-MSG)
                        TEXTLENGTH(WS-EZA-MSG-LEN)
              END-EXEC
           END-IF.

      *****************************************************************
      * Write tracevdata out to a TS queue                            *
      *****************************************************************
       Z0300-WRITE-TSQ.
           EXEC CICS ASKTIME
                     ABSTIME(WS-ABSTIME)
           END-EXEC.
           EXEC CICS FORMATTIME
                     ABSTIME(WS-ABSTIME)
                     YYMMDD(WS-TRACE-TSQ-DATE)
                     TIMESEP(':')
                     TIME(WS-TRACE-TSQ-TIME)
           END-EXEC.
           MOVE ',' TO WS-TRACE-TSQ-COMMA1.
           MOVE ',' TO WS-TRACE-TSQ-COMMA2.
           MOVE LENGTH OF WS-TRACE-TSQ-MSG TO WS-SUB
           PERFORM UNTIL WS-TRACE-TSQ-MSG(WS-SUB:1)
             IS NOT EQUAL TO X'00'
              SUBTRACT 1 FROM WS-SUB
           END-PERFORM .
           ADD 1 TO WS-SUB.
           MOVE WS-SUB TO WS-TRACE-TSQ-MSG-LEN.
           EXEC CICS ENQ
                     RESOURCE(WS-TRACE-TSQ-NAME)
                     LENGTH(LENGTH OF WS-TRACE-TSQ-NAME)
           END-EXEC.
           EXEC CICS WRITEQ TS
                     QUEUE(WS-TRACE-TSQ-NAME)
                     FROM(WS-TRACE-TSQ-MSG)
                     LENGTH(WS-TRACE-TSQ-MSG-LEN)
                     RESP(WS-DFHRESP)
           END-EXEC.
           EXEC CICS DEQ
                     RESOURCE(WS-TRACE-TSQ-NAME)
                     LENGTH(LENGTH OF WS-TRACE-TSQ-NAME)
           END-EXEC.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
