      * $set dialect(mf) assign(dynamic)
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
      * Program:     ZBNKPRNX.CBL                                     *
      * Function:    Print exit for bank statements                   *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ZBNKPRNX.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT   SECTION.
         FILE-CONTROL.
           SELECT INPUT-FILE
                  ASSIGN       TO WS-INPUT-NAME
                  ORGANIZATION IS LINE SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-INPUT-STATUS.
           SELECT OUTPUT-FILE
                  ASSIGN       TO WS-OUTPUT-NAME
                  ORGANIZATION IS LINE SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS WS-OUTPUT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  INPUT-FILE.
       01  INPUT-REC                               PIC X(512).

       FD  OUTPUT-FILE.
       01  OUTPUT-REC                              PIC X(512).

       WORKING-STORAGE SECTION.
       COPY 'CASCWPRN.CPY'.

       01  WS-TITLE-COPYRIGHT.
         05  WS-TITLE.
           10  FILLER                              PIC X(47)
               VALUE 'ZBNKPRNX - Print exit. Write to HTML.'.
         05  WS-COPYRIGHT.
           10  FILLER                              PIC X(20)
               VALUE 'ZBNKPRNX  V1.0.02 - '.
           10  FILLER                              PIC X(19)
               VALUE '(C) Copyright 2007 '.
           10  FILLER                              PIC X(26)
               VALUE 'Micro Focus International '.

       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'ZBNKPRNX'.
         05  WS-INPUT-STATUS.
           10  WS-INPUT-STAT1                      PIC X(1).
           10  WS-INPUT-STAT2                      PIC X(1).
         05  WS-INPUT-NAME                         PIC X(256).
         05  WS-OUTPUT-STATUS.
           10  WS-OUTPUT-STAT1                     PIC X(1).
           10  WS-OUTPUT-STAT2                     PIC X(1).
         05  WS-OUTPUT-NAME                        PIC X(256).
         05  WS-PAGE-BREAK                         PIC X(1).
           88  PAGE-BREAK-NEEDED                   VALUE '1'.
           88  PAGE-BREAK-NOT-NEEDED               VALUE '0'.
         05  WS-CODESET-FUNCTION                   PIC 9(2) COMP-X.
           88  CONVERT-CODESET-E2A                 VALUE 0.
           88  CONVERT-CODESET-A2E                 VALUE 1.
         05  WS-CODESET-CONVERT-LENGTH             PIC 9(9) COMP-X.
         05  WS-CURRENT-DATE.
           10  WS-CURRENT-YYYY                     PIC X(4).
           10  WS-CURRENT-MTH                      PIC 9(2).
           10  WS-CURRENT-DD                       PIC X(2).
           10  WS-CURRENT-HH                       PIC X(2).
           10  WS-CURRENT-MM                       PIC X(2).
           10  WS-CURRENT-SS                       PIC X(2).
           10  WS-CURRENT-FILLER                   PIC X(5).
         05  WS-MONTH-TABLE.
           10  FILLER          VALUE 'Jan'         PIC X(3).
           10  FILLER          VALUE 'Feb'         PIC X(3).
           10  FILLER          VALUE 'Mar'         PIC X(3).
           10  FILLER          VALUE 'Apr'         PIC X(3).
           10  FILLER          VALUE 'May'         PIC X(3).
           10  FILLER          VALUE 'Jun'         PIC X(3).
           10  FILLER          VALUE 'Jul'         PIC X(3).
           10  FILLER          VALUE 'Aug'         PIC X(3).
           10  FILLER          VALUE 'Sep'         PIC X(3).
           10  FILLER          VALUE 'Oct'         PIC X(3).
           10  FILLER          VALUE 'Nov'         PIC X(3).
           10  FILLER          VALUE 'Dec'         PIC X(3).
         05  WS-MONTH-TABLE-R REDEFINES WS-MONTH-TABLE.
           10  WS-MONTH                            PIC X(3)
               OCCURS 12 TIMES.
         05  WS-INDEX-ENTRY-DATE                   PIC X(21).

      *****************************************************************
      * Data-structures for CBL sub routines                          *
      *****************************************************************
       01  CBL-SUB-ROUTINE-FIELDS.
         05  CBL-SPLIT-FILENAME.
           10  CBL-SPLIT-PARAM-LENGTH              PIC X(2) COMP-X.
           10  CBL-SPLIT-FLG1                      PIC X(1) COMP-X.
           10  CBL-SPLIT-FLG2                      PIC X(1) COMP-X.
           10  CBL-SPLIT-PATH-STRT                 PIC X(2) COMP-X.
           10  CBL-SPLIT-PATH-LEN                  PIC X(2) COMP-X.
           10  CBL-SPLIT-BASENAME-STRT             PIC X(2) COMP-X.
           10  CBL-SPLIT-BASENAME-LEN              PIC X(2) COMP-X.
           10  CBL-SPLIT-EXTENSION-STRT            PIC X(2) COMP-X.
           10  CBL-SPLIT-EXTENSION-LEN             PIC X(2) COMP-X.
           10  CBL-SPLIT-TOTAL-LENGTH              PIC X(2) COMP-X.
           10  CBL-SPLIT-SPLIT-BUF-LEN             PIC X(2) COMP-X.
           10  CBL-SPLIT-JOIN-BUF-LEN              PIC X(2) COMP-X.
           10  CBL-SPLIT-FIRST-PATH-LEN            PIC X(2) COMP-X.
           10  CBL-SPLIT-PATH-STRT                 PIC X(2) COMP-X.
         05  CBL-SPLIT-BUFFER                      PIC X(256).
         05  CBL-JOIN-BUFFER                       PIC X(256).
       01  CBL-STATUS-CODE                         PIC X(2) COMP-X.
       01  CBL-LENGTH                              PIC X(4) COMP-5.
       01  WS-INDEX-NAME                           PIC X(256).
       01  WS-INDEX-NAME-LEN                       PIC X(2) COMP-X.
       01  WS-HTML-DOC-NAME                        PIC X(256).
       01  WS-HTML-DOC-NAME-LEN                    PIC X(2) COMP-X.
       01  WS-NEW-EXTENSION                        PIC X(3).

       01  WS-FILE-DETAILS.
         05  WS-FILE-SIZE                          PIC X(8) COMP-X.
         05  WS-FILE-DATE.
           10  WS-FILE-DAY                         PIC X(1) COMP-X.
           10  WS-FILE-MONTH                       PIC X(1) COMP-X.
           10  WS-FILE-YEAR                        PIC X(2) COMP-X.
         05  WS-FILE-TIME.
           10  WS-FILE-HOURS                       PIC X(1) COMP-X.
           10  WS-FILE-MINUTES                     PIC X(1) COMP-X.
           10  WS-FILE-SECONDS                     PIC X(1) COMP-X.
           10  WS-FILE-HUNDREDTHS             PIC X(1) COMP-X.

      *****************************************************************
      * ES environment variabe we use to determine where to save data *
      *****************************************************************
       01  WS-ALLOC-DIR-ENV-NAME                   PIC X(128)
           VALUE 'MFALLOC.LOC'.
       01  WS-ALLOC-DIR-ENV-VALUE                  PIC X(128)
           VALUE SPACES.

      *****************************************************************
      * ES environment variabe we use to determine the server name    *
      *****************************************************************
       01  WS-ES-SERVER-ENV-NAME                   PIC X(128)
           VALUE 'ES_SERVER'.
       01  WS-ES-SERVER-ENV-VALUE                  PIC X(128)
           VALUE SPACES.

      *****************************************************************
      * HTML code we will use for the document we are outputting      *
      *****************************************************************
       01  WS-HTML-CODE.
         05  WS-HTML-TOP-01                        PIC X(6)
             VALUE '<html>'.
         05  WS-HTML-TOP-02                        PIC X(6)
             VALUE '<head>'.
         05  WS-HTML-TOP-03.
           10  FILLER                              PIC X(32)
               VALUE '<meta http-equiv="Content-Type" '.
           10  FILLER                              PIC X(20)
               VALUE 'content="text/html; '.
           10  FILLER                              PIC X(22)
               VALUE 'charset=windows-1252">'.
         05  WS-HTML-TOP-04                        PIC X(7)
             VALUE '<title>'.
         05  WS-HTML-TOP-05                        PIC X(128)
             VALUE 'doc name'.
         05  WS-HTML-TOP-06                        PIC X(8)
             VALUE '</title>'.
         05  WS-HTML-TOP-07                        PIC X(7)
             VALUE '</head>'.
         05  WS-HTML-TOP-08                        PIC X(6)
             VALUE '<body>'.
         05  WS-HTML-TOP-09                        PIC X(5)
             VALUE '<pre>'.
         05  WS-HTML-BTM-01                        PIC X(6)
             VALUE '</pre>'.
         05  WS-HTML-BTM-02                        PIC X(7)
             VALUE '</body>'.
         05  WS-HTML-BTM-03                        PIC X(7)
             VALUE '</html>'.
         05  WS-HTML-PAGE-BREAK.
           10  FILLER                              PIC X(40)
               VALUE '<---------------------------------------'.
           10  FILLER                              PIC X(22)
               VALUE ' Page Break '.
           10  FILLER                              PIC X(40)
               VALUE '--------------------------------------->'.

      *****************************************************************
      * HTML code we will use to create the index file                *
      *****************************************************************
       01  WS-INDEX-HTML-CODE.
         05  WS-INDX-TOP-01                        PIC X(6)
             VALUE '<html>'.
         05  WS-INDX-TOP-02                        PIC X(6)
             VALUE '<head>'.
         05  WS-INDX-TOP-03.
           10  FILLER                              PIC X(32)
               VALUE '<meta http-equiv="Content-Type" '.
           10  FILLER                              PIC X(20)
               VALUE 'content="text/html; '.
           10  FILLER                              PIC X(22)
               VALUE 'charset=windows-1252">'.
         05  WS-INDX-TOP-04                        PIC X(7)
             VALUE '<title>'.
         05  WS-INDX-TOP-05                        PIC X(128)
             VALUE 'Index of printed statements'.
         05  WS-INDX-TOP-06                        PIC X(8)
             VALUE '</title>'.
         05  WS-INDX-TOP-07                        PIC X(7)
             VALUE '</head>'.
         05  WS-INDX-TOP-08                        PIC X(6)
             VALUE '<body>'.
         05  WS-INDX-TOP-09                        PIC X(8)
             VALUE '<center>'.
         05  WS-INDX-TOP-10                        PIC X(35)
             VALUE '<font size="+1" face="Arial"><b><u>'.
         05  WS-INDX-TOP-11                        PIC X(40)
             VALUE 'Output from ES/MTO Printer exit ZBNKPRNX'.
         05  WS-INDX-TOP-12                        PIC X(15)
             VALUE '</u></b></font>'.
         05  WS-INDX-TOP-13                        PIC X(3)
             VALUE '<p>'.
         05  WS-INDX-TOP-14                        PIC X(9)
             VALUE '</center>'.
         05  WS-INDX-TOP-15                        PIC X(19)
             VALUE '<font face="Arial">'.
         05  WS-INDX-TOP-16                        PIC X(31)
             VALUE '<table border="1" width="100%">'.
         05  WS-INDX-TOP-17                        PIC X(20)
             VALUE '<!-- next page ---->'.
         05  WS-INDX-TOP-18                        PIC X(34)
             VALUE '<tr><td>&nbsp;</td><td>&nbsp;</td>'.
         05  WS-INDX-BTM-01                        PIC X(5)
             VALUE '</tr>'.
         05  WS-INDX-BTM-02                        PIC X(8)
             VALUE '</table>'.
         05  WS-INDX-BTM-03                        PIC X(7)
             VALUE '</body>'.
         05  WS-INDX-BTM-04                        PIC X(7)
             VALUE '</html>'.


       LINKAGE SECTION.
       COPY 'CASCBPRN.CPY' REPLACING ==(WS)== BY ==LK==.


       PROCEDURE DIVISION USING LK-PRN-EXIT-INTERFACE.
      *    CALL 'cbl_debugbreak'                                                x
           EVALUATE TRUE
             WHEN LK-PRN-EXIT-INIT-88
               PERFORM PRINT-INITIALIZE
             WHEN LK-PRN-EXIT-PRINT-88
               PERFORM PRINT-PROCESSOR
             WHEN LK-PRN-EXIT-TERM-88
               PERFORM PRINT-TERMINATE
             WHEN OTHER
      * Initialize isn't always set so if we have a suspect do this
               PERFORM PRINT-INITIALIZE
      *        MOVE 0 TO RETURN-CODE
           END-EVALUATE.
           EXIT PROGRAM.
           STOP RUN.

      *****************************************************************
      * Initialize the exit                                           *
      *****************************************************************
       PRINT-INITIALIZE SECTION.
      * Locate the data allocation directory
           DISPLAY WS-ALLOC-DIR-ENV-NAME UPON ENVIRONMENT-NAME.
           ACCEPT WS-ALLOC-DIR-ENV-VALUE FROM ENVIRONMENT-VALUE.

      * "Spilt" the allocation path name to get its attributes
           MOVE WS-ALLOC-DIR-ENV-VALUE TO CBL-SPLIT-BUFFER.
           MOVE LOW-VALUES TO CBL-SPLIT-FILENAME.
           MOVE LENGTH OF CBL-SPLIT-BUFFER TO CBL-SPLIT-SPLIT-BUF-LEN.
           CALL 'CBL_SPLIT_FILENAME' USING CBL-SPLIT-FILENAME
                                           CBL-SPLIT-BUFFER
                                     RETURNING CBL-STATUS-CODE.

      * Add a file name of "index.htm"and joint it to the path
           MOVE CBL-SPLIT-TOTAL-LENGTH TO CBL-SPLIT-PATH-LEN.
           MOVE 'index' TO WS-INDEX-NAME.
           MOVE 1 TO CBL-SPLIT-BASENAME-STRT.
           MOVE 5 TO CBL-SPLIT-BASENAME-LEN.
           MOVE 'htm' TO WS-NEW-EXTENSION.
           MOVE 1 TO CBL-SPLIT-EXTENSION-STRT.
           MOVE 3 TO CBL-SPLIT-EXTENSION-LEN.
           MOVE LENGTH OF CBL-JOIN-BUFFER TO CBL-SPLIT-JOIN-BUF-LEN.
           MOVE 0 TO CBL-SPLIT-FLG2.
           CALL 'CBL_JOIN_FILENAME' USING CBL-SPLIT-FILENAME
                                          CBL-JOIN-BUFFER
                                          CBL-SPLIT-BUFFER
                                          WS-INDEX-NAME
                                          WS-NEW-EXTENSION
                                     RETURNING CBL-STATUS-CODE.
           MOVE CBL-JOIN-BUFFER(1:) TO WS-INDEX-NAME.
           MOVE CBL-SPLIT-TOTAL-LENGTH TO WS-INDEX-NAME-LEN.

      * Check to see if the $path\index.htm exists
           CALL 'CBL_CHECK_FILE_EXIST' USING WS-INDEX-NAME
                                             WS-FILE-DETAILS
                                       RETURNING CBL-STATUS-CODE.
      * If the file exits, exit the sectio
           IF CBL-STATUS-CODE = 0
              GO TO PRINT-INITIALIZE-EXIT
           END-IF.
      * File doesn't exist so create the initial one
           MOVE WS-INDEX-NAME TO WS-OUTPUT-NAME.
           OPEN OUTPUT OUTPUT-FILE.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-01.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-02.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-03.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-04.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-05.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-06.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-07.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-08.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-09.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-10.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-11.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-12.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-13.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-14.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-15.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-16.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-17.
           WRITE OUTPUT-REC FROM WS-INDX-TOP-18.
           WRITE OUTPUT-REC FROM WS-INDX-BTM-01.
           WRITE OUTPUT-REC FROM WS-INDX-BTM-02.
           WRITE OUTPUT-REC FROM WS-INDX-BTM-03.
           WRITE OUTPUT-REC FROM WS-INDX-BTM-04.
           CLOSE OUTPUT-FILE.
       PRINT-INITIALIZE-EXIT.
           EXIT SECTION.
           .
      *****************************************************************
      * Main process                                                  *
      *****************************************************************
       PRINT-PROCESSOR SECTION.

      * "Spilt" the sysout file name
           MOVE LK-PRN-SYSOUT-FILE-NAME TO CBL-SPLIT-BUFFER.
           MOVE LENGTH OF CBL-SPLIT-BUFFER TO CBL-SPLIT-SPLIT-BUF-LEN.
           CALL 'CBL_SPLIT_FILENAME' USING CBL-SPLIT-FILENAME
                                           CBL-SPLIT-BUFFER
                                     RETURNING CBL-STATUS-CODE.
      * New name will be the same but with an extension of HTM
           MOVE 'htm' TO WS-NEW-EXTENSION.
           MOVE 1 TO CBL-SPLIT-EXTENSION-STRT.
           MOVE LENGTH OF WS-NEW-EXTENSION TO CBL-SPLIT-EXTENSION-LEN.
           MOVE LENGTH OF CBL-JOIN-BUFFER TO CBL-SPLIT-JOIN-BUF-LEN
           CALL 'CBL_JOIN_FILENAME' USING CBL-SPLIT-FILENAME
                                          CBL-JOIN-BUFFER
                                          CBL-SPLIT-BUFFER
                                          CBL-SPLIT-BUFFER
                                          WS-NEW-EXTENSION
                                     RETURNING CBL-STATUS-CODE.
           MOVE CBL-JOIN-BUFFER(1:) TO WS-HTML-DOC-NAME.
           MOVE WS-HTML-DOC-NAME TO WS-OUTPUT-NAME.
           MOVE CBL-SPLIT-TOTAL-LENGTH TO WS-HTML-DOC-NAME-LEN.

           OPEN OUTPUT OUTPUT-FILE.

      * Turn of page break
           SET PAGE-BREAK-NOT-NEEDED TO TRUE.

      * Create the top of the HTML document
           MOVE LK-PRN-DOCUMENT-TITLE TO WS-HTML-TOP-05.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-01.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-02.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-03.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-04.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-05.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-06.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-07.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-08.
           WRITE OUTPUT-REC FROM WS-HTML-TOP-09.

      * Now read the print file and output the records to HTML
           CALL LK-PRN-SYSOUT-OPEN-PPTR.
           IF LK-PRN-SYSOUT-STATUS-OK-88
              PERFORM UNTIL EXIT
                CALL LK-PRN-SYSOUT-READ-NEXT-PPTR
                IF LK-PRN-SYSOUT-STATUS-OK-88
                   IF LK-PRN-CHAR-EBCDIC-88
                      SET CONVERT-CODESET-E2A TO TRUE
                      MOVE LK-PRN-LRECL TO WS-CODESET-CONVERT-LENGTH
                      CALL '_CODESET' USING WS-CODESET-FUNCTION
                                            WS-CODESET-CONVERT-LENGTH
                                            LK-PRN-BUFFER
                   END-IF
      *            IF LK-PRN-BUFFER(1:1) IS EQUAL TO '1'
      *               IF PAGE-BREAK-NEEDED
      *                  WRITE OUTPUT-REC FROM WS-HTML-PAGE-BREAK
      *                ELSE
      *                  SET PAGE-BREAK-NEEDED TO TRUE
      *                END-IF
      *            END-IF
      *            IF LK-PRN-BUFFER(1:1) IS EQUAL TO '0'
      *               MOVE SPACES TO OUTPUT-REC
      *               WRITE OUTPUT-REC
      *            END-IF
      *            IF LK-PRN-BUFFER(1:1) IS EQUAL TO '-'
      *               MOVE SPACES TO OUTPUT-REC
      *               WRITE OUTPUT-REC
      *               MOVE SPACES TO OUTPUT-REC
      *               WRITE OUTPUT-REC
      *            END-IF
      *            MOVE LK-PRN-BUFFER(2:) TO OUTPUT-REC
      *            WRITE OUTPUT-REC
                MOVE LK-PRN-BUFFER(1:LK-PRN-LRECL) TO OUTPUT-REC
                WRITE OUTPUT-REC
                ELSE
                   EXIT PERFORM
                END-IF
           END-IF.

      * Create the bottom of the HTML document
           WRITE OUTPUT-REC FROM WS-HTML-BTM-01.
           WRITE OUTPUT-REC FROM WS-HTML-BTM-02.
           WRITE OUTPUT-REC FROM WS-HTML-BTM-03.

           CLOSE OUTPUT-FILE.
      *    call 'cbl_debugbreak'
      * Add this file to the index
           PERFORM UPDATE-INDEX.

           EXIT SECTION.

      *****************************************************************
      * Termination process                                           *
      *****************************************************************
       PRINT-TERMINATE SECTION.
           EXIT SECTION.

      *****************************************************************
      * Update the index file                                        *
      *****************************************************************
       UPDATE-INDEX SECTION.
      * "Spilt" the file name of the index.htm file
           MOVE WS-INDEX-NAME TO CBL-SPLIT-BUFFER.
           MOVE LOW-VALUES TO CBL-SPLIT-FILENAME.
           MOVE LENGTH OF CBL-SPLIT-BUFFER TO CBL-SPLIT-SPLIT-BUF-LEN.
           CALL 'CBL_SPLIT_FILENAME' USING CBL-SPLIT-FILENAME
                                           CBL-SPLIT-BUFFER
                                     RETURNING CBL-STATUS-CODE.

      * Change the extension to tmp
           MOVE 'tmp' TO WS-NEW-EXTENSION.
           MOVE 1 TO CBL-SPLIT-EXTENSION-STRT.
           MOVE 3 TO CBL-SPLIT-EXTENSION-LEN.
           MOVE LENGTH OF CBL-JOIN-BUFFER TO CBL-SPLIT-JOIN-BUF-LEN.
           MOVE 0 TO CBL-SPLIT-FLG2.
           CALL 'CBL_JOIN_FILENAME' USING CBL-SPLIT-FILENAME
                                          CBL-JOIN-BUFFER
                                          CBL-SPLIT-BUFFER
                                          WS-INDEX-NAME
                                          WS-NEW-EXTENSION
                                     RETURNING CBL-STATUS-CODE.
           MOVE CBL-JOIN-BUFFER(1:) TO WS-OUTPUT-NAME.

           MOVE WS-INDEX-NAME TO WS-INPUT-NAME.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE.
           STRING WS-CURRENT-DD DELIMITED BY SIZE
                  ' 'DELIMITED BY SIZE
                  WS-MONTH(WS-CURRENT-MTH) DELIMITED BY SIZE
                  ' 'DELIMITED BY SIZE
                  WS-CURRENT-YYYY DELIMITED BY SIZE
                  '  'DELIMITED BY SIZE
                  WS-CURRENT-HH DELIMITED BY SIZE
                  ':'DELIMITED BY SIZE
                  WS-CURRENT-MM DELIMITED BY SIZE
                  ':'DELIMITED BY SIZE
                  WS-CURRENT-SS DELIMITED BY SIZE
                  ':'DELIMITED BY SIZE
             INTO WS-INDEX-ENTRY-DATE.
           OPEN INPUT INPUT-FILE.
           OPEN OUTPUT OUTPUT-FILE.
       UPDATE-INDEX-READ-LOOP.
           READ INPUT-FILE
             AT END
               GO TO UPDATE-INDEX-READ-EXIT.
           IF INPUT-REC(1:11) IS EQUAL TO 'Output from'
              DISPLAY WS-ES-SERVER-ENV-NAME UPON ENVIRONMENT-NAME
              ACCEPT WS-ES-SERVER-ENV-VALUE FROM ENVIRONMENT-VALUE
              MOVE SPACES TO INPUT-REC
              STRING 'Output from ES/MTO server ' DELIMITED BY SIZE
                     WS-ES-SERVER-ENV-VALUE DELIMITED BY SPACE
                     ' Printer exit ' DELIMITED BY SIZE
                     WS-PROGRAM-ID DELIMITED BY SIZE
                INTO INPUT-REC
           END-IF.
      * Is this the insert point for the next record
           IF INPUT-REC = WS-INDX-TOP-17
              WRITE OUTPUT-REC FROM INPUT-REC
              MOVE '<tr>' TO OUTPUT-REC
              WRITE OUTPUT-REC
              MOVE SPACES TO OUTPUT-REC
              STRING '  <td>' DELIMITED BY SIZE
                     WS-INDEX-ENTRY-DATE DELIMITED BY SIZE
                     '</td>' DELIMITED BY SIZE
                INTO OUTPUT-REC
                     WRITE OUTPUT-REC
              MOVE SPACES TO OUTPUT-REC
              STRING '    <td><a href="' DELIMITED BY SIZE
                     WS-HTML-DOC-NAME(1:WS-HTML-DOC-NAME-LEN)
                       DELIMITED BY SIZE
                     '">' DELIMITED BY SIZE
                INTO OUTPUT-REC
              WRITE OUTPUT-REC
              MOVE SPACES TO OUTPUT-REC
              STRING '        ' DELIMITED BY SIZE
                     WS-HTML-TOP-05(1:LK-PRN-DOCUMENT-LEN)
                DELIMITED BY SIZE
                     '</a></td>' DELIMITED BY SIZE
                INTO OUTPUT-REC
              WRITE OUTPUT-REC
              MOVE '</tr>' TO OUTPUT-REC
              WRITE OUTPUT-REC
           ELSE
              WRITE OUTPUT-REC FROM INPUT-REC
           END-IF.
           GO TO UPDATE-INDEX-READ-LOOP.
       UPDATE-INDEX-READ-EXIT.
           CLOSE INPUT-FILE.
           CLOSE OUTPUT-FILE.
           CALL 'CBL_DELETE_FILE' USING WS-INPUT-NAME
                                  RETURNING CBL-STATUS-CODE.
           CALL 'CBL_RENAME_FILE' USING WS-OUTPUT-NAME
                                        WS-INPUT-NAME
                                  RETURNING CBL-STATUS-CODE.
       UPDATE-INDEX-EXIT.
           EXIT SECTION.


      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
