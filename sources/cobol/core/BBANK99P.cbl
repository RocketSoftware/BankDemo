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
      * Program:     BBANK99P.CBL                                     *
      * Layer:       Business logic                                   *
      * Function:    Terminate the pseudo converation                 *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           BBANK99P.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MISC-STORAGE.
         05  WS-PROGRAM-ID                         PIC X(8)
             VALUE 'BBANK99P'.
         05  WS-INPUT-FLAG                         PIC X(1).
           88  INPUT-OK                            VALUE '0'.
           88  INPUT-ERROR                         VALUE '1'.
         05  WS-ERROR-MSG                          PIC X(75).

       01  WS-BANK-DATA.
       COPY CBANKDAT.

       01  WS-SECURITY.
       COPY CPSWDD01.

       COPY CABENDD.

       LINKAGE SECTION.
       01  DFHCOMMAREA.
         05  LK-COMMAREA                           PIC X(6144).

       COPY CENTRY.

      *****************************************************************
      * Make ourselves re-entrant                                     *
      *****************************************************************
           MOVE SPACES TO WS-ERROR-MSG.

      *****************************************************************
      * Move the passed area to our area                              *
      *****************************************************************
           MOVE DFHCOMMAREA (1:LENGTH OF WS-BANK-DATA) TO WS-BANK-DATA.

      *****************************************************************
      * Ensure error message is cleared                               *
      *****************************************************************
           MOVE SPACES TO BANK-ERROR-MSG.

      *****************************************************************
      * This is the main process                                      *
      *****************************************************************
      * We now make sure the user is logged off.......
           MOVE SPACES TO CPSWDD01-DATA.
           MOVE BANK-SIGNON-ID TO CPSWDD01I-USERID.
           MOVE BANK-PSWD TO CPSWDD01I-PASSWORD
      * If user starts with "Z" then treat as "B"
           IF CPSWDD01I-USERID(1:1) IS EQUAL TO 'Z'
              MOVE 'B' TO  CPSWDD01I-USERID(1:1)
           END-IF.

           SET PSWD-SIGNOFF TO TRUE

       COPY CPSWDX01.
           IF CPSWDD01O-MESSAGE IS NOT EQUAL TO SPACES
              MOVE CPSWDD01O-MESSAGE TO WS-ERROR-MSG
           END-IF.

           MOVE SPACES TO BANK-IMS-SPA-TRANCODE.
           MOVE 'BBANK99P' TO BANK-LAST-PROG
           MOVE 'BBANK99P' TO BANK-NEXT-PROG
           MOVE 'MBANK99' TO BANK-LAST-MAPSET
           MOVE 'BANK99A' TO BANK-LAST-MAP
           MOVE 'MBANK99' TO BANK-NEXT-MAPSET
           MOVE 'BANK99A' TO BANK-NEXT-MAP
           GO TO COMMON-RETURN.

       COMMON-RETURN.
           MOVE WS-BANK-DATA TO DFHCOMMAREA (1:LENGTH OF WS-BANK-DATA).
       COPY CRETURN.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
