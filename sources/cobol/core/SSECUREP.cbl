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
      * Program:     SSECUREP.CBL                                     *
      * Layer:       Screen handling                                  *
      * Function:    Set flag to determine if security required       *
      *****************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SSECUREP.
       DATE-WRITTEN.
           September 2002.
       DATE-COMPILED.
           Today.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *****************************************************************
      * Security flag                                                 *
      *---------------------------------------------------------------*
      * Set to Y to signal SIGNON/SIGNOFF etc processing required.    *
      * Anything else will indicate no security.                      *
      *****************************************************************
       01  WS-SECURITY-FLAG                        PIC X(1).
         88  SECURITY-NOT-REQUIRED                 VALUE SPACE.
         88  SECURITY-REQUIRED                     VALUE 'Y'.

       LINKAGE SECTION.
       01  LK-SECURITY-TRAN                        PIC X(8).
       01  LK-SECURITY-FLAG                        PIC X(1).

       PROCEDURE DIVISION USING LK-SECURITY-TRAN
                                LK-SECURITY-FLAG.
      *****************************************************************
      * Set the appropriate value and move it to callers area         *
      *****************************************************************
           SET SECURITY-NOT-REQUIRED TO TRUE.
      *    SET SECURITY-REQUIRED TO TRUE.
           MOVE WS-SECURITY-FLAG TO LK-SECURITY-FLAG.
           GOBACK.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
