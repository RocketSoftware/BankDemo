  /****************************************************************
  *
  *  Copyright(C) 1998-2010 Micro Focus. All Rights Reserved,
  *
  ****************************************************************/

  /****************************************************************
  * CTIMERD.INC
  *---------------------------------------------------------------
  * Work areas for run timer
  ****************************************************************/
 DCL 1 TIMER_DATA,
     05  TIMER_START                           PIC'(8)9'
         INIT(0),
     05  TIMER_END                             PIC'(8)9'
         INIT(0),
     05  TIMER_ELAPSED                         PIC'(8)9',
     05  TIMER_RUN_TIME,
       10  FILL03                              CHAR(17)
           INIT('Elaped run time: '),
       10  TIMER_RUN_TIME_CHAR                 CHAR(9),
       10  FILL04                              CHAR(8)
           INIT(' seconds');

 DCL 1 TIMER_START_BITS BASED(ADDR(TIMER_START)),
       10  TIMER_START_HH                      PIC'(2)9',
       10  TIMER_START_MM                      PIC'(2)9',
       10  TIMER_START_SS                      PIC'(2)9',
       10  TIMER_START_DD                      PIC'(2)9';

 DCL 1 TIMER_END_BITS BASED(ADDR(TIMER_END)),
       10  TIMER_END_HH                        PIC'(2)9',
       10  TIMER_END_MM                        PIC'(2)9',
       10  TIMER_END_SS                        PIC'(2)9',
       10  TIMER_END_DD                        PIC'(2)9';

 DCL 1 TIMER_ELAPSED_BITS BASED(ADDR(TIMER_RUN_TIME_CHAR)),
       10 TIMER_RUN_TIME_ELAPSED               PIC'(5)Z9.99';
