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
      * CBANKX02.CPY (CICS Version)                                   *
      *---------------------------------------------------------------*
      * This copybook is used to provide an common means of calling   *
      * data access module DBANK02P so that the that module using     *
      * this copy book is insensitive to it environment.              *
      * There are different versions for CICS, IMS and INET.          *
      *****************************************************************
      * by default use CICS commands to call the module
           EXEC CICS LINK PROGRAM('DBANK02P')
                          COMMAREA(CD02-DATA)
                          LENGTH(LENGTH OF CD02-DATA)
           END-EXEC
      *    CALL 'DBANK02P' USING CD02-DATA

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
