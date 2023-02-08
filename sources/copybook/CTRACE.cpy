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
