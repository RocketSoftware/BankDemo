      *$set dialect(MF) cicsecm()
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
      * Program:     DFHUAINS.CBL                                     *
      * Function:    Assign terminal ids                              *
      *****************************************************************

       identification division.
       program-id.
           DFHUAINS.
       date-written.
           September 2002.
       date-compiled.
           Today.

       environment division.

       data division.
       working-storage section.
       01  ws-misc-storage.
         05  ws-program-id                         pic x(8)
             value 'DFHUAINS'.
         05  ws-sub                                pic s9(4) comp-5
             value 0.
         05  ws-cwa-area-ptr                       pointer.
         05  ws-term-id.
           10  ws-term-id-alpha                    pic x(1).
           10  ws-term-id-numeric                  pic 9(3).
         05  ws-alpha.
           10  ws-alpha-string                     pic x(26)
               value 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
           10  filler redefines ws-alpha-string.
             15  ws-alpha-char                     pic x(1)
                 occurs 26 times.
         05  ws-numeric.
           10  ws-numeric-string                   pic x(10)
               value '0123456789'.
           10  filler redefines ws-numeric-string.
             15  ws-numeric-char                   pic x(1)
                 occurs 10 times.
         05  two-bytes.
           10  two-bytes-left                      pic x(1).
           10  two-bytes-right                     pic x(1).
         05  two-bytes-binary redefines two-bytes  pic 9(4) comp.
         05  ws-temp4                              pic x(4).
         05  ws-abstime                            pic s9(15) comp-3.
         05  ws-date-yyyy-mm-dd                    pic x(10).
         05  filler redefines ws-date-yyyy-mm-dd.
           10  ws-date-yyyy                        pic x(4).
           10  ws-date-mm                          pic 9(2).
           10  ws-date-dd                          pic x(2).
         05  ws-months                             pic x(36)
             value 'JanFebMarAprMayJunJulAugSepOctNovDec'.
         05  filler redefines ws-months.
           10  ws-month                            pic x(3)
               occurs 12 times.

       01  ws-client-data.
         05  ws-client-port                        pic z9(5).
         05  ws-client-ip-address                  pic x(15).
         05  ws-client-ip-address-v4.
           10 ws-client-addr-part1                 pic zzz9.
           10 ws-client-addr-part2                 pic zzz9.
           10 ws-client-addr-part3                 pic zzz9.
           10 ws-client-addr-part4                 pic zzz9.

       01  ws-server-data.
         05  ws-server-port                        pic z9(5).
         05  ws-server-ip-address                  pic x(15).
         05  ws-server-ip-address-v4.
           10 ws-server-addr-part1                 pic zzz9.
           10 ws-server-addr-part2                 pic zzz9.
           10 ws-server-addr-part3                 pic zzz9.
           10 ws-server-addr-part4                 pic zzz9.

       78  78-srv-cmsg-entry-name          value 'SRV_CONSOLE_MSG'.

       01  ws-srv-console-msg.
         03  value 0                               pic x(4) comp-5.
         03  value 0                               pic x(4) comp-5.
         03                                        pic x(4) comp-5.
         03  ws-srv-cmsg-size                      pic x(4) comp-5.
         03  value 0                               pic x(4) comp-5.
         03                                        pic x(4) comp-5.
         03  occurs 2                              pic x(4) comp-5.
         03  ws-srv-cmsg-ptr                       pointer.
         03                                        pointer.
         03  occurs 3                              pointer.

       01  ws-msg                                  pic x(120)
           value z'Hello world'.


       linkage section.
       01  dfhcommarea.
         05  a-string                              pic x(4).
         05  data-ptr-1                            pointer.
         05  data-ptr-2                            pointer.
         05  data-ptr-3                            pointer.
         05  data-ptr-4                            pointer.
         05  data-ptr-5                            pointer.
         05  data-ptr-6                            pointer.

       01  netname-info.
         05  netname-length                        pic 9(2) comp-x.
         05  netname                               pic x(8).

       01  model-table.
         05  model-table-length                    pic 9(2) comp-x.
         05  model-table-names
               occurs 1 to 50 times depending on model-table-length.
           10  model-table-name                    pic x(8).

       01  tct-info.
         05  tct-info-name                         pic x(8).
         05  tct-info-term-id                      pic x(4).
         05  tct-info-prr-id                       pic x(4).
         05  tct-info-alt-prt-id                   pic x(4).
         05  tct-info-status                       pic x(1).

      * Attributes of terminal user sitting at
      * may be used to match against predefined naming convention in
      * autoint-name determined by installation to decide which model
      * to use.
       01  term-info.
         05  term-info-length                      pic 9(2) comp-x.
         05  term-info-rows                        pic x(1) comp-x.
         05  term-info-cols                        pic x(1) comp-x.
         05  uctran-setting                        pic x(1).

       01  tn3270-client-ip.
         05  client-ip-type                        pic x(1).
           88  client-ip-type-4-88                 value '4'.
           88  client-ip-type-6-88                 value '6'.
         05                                        pic x(1).
         05  client-ip-port                        pic x(2) comp-x.
         05  client-ip-address-6.
           10  client-ip-address-4                 pic x(4).
           10                                      pic x(12).

       01  tn3270-server-ip.
         05  server-ip-type                        pic x(1).
           88  server-ip-type-4-88                 value '4'.
           88  server-ip-type-6-88                 value '6'.
         05                                        pic x(1).
         05  server-ip-port                        pic x(2) comp-x.
         05  server-ip-address-6.
           10  server-ip-address-4                 pic x(4).
           10                                      pic x(12).

       01  cwa-area.
         05  cwa-last-term-id                      pic x(4).

       01  lk-ip-address                           pic x(15).
       01  lk-ip-address-v4x.
           10 lk-addr-part1x                       pic x(4).
           10 lk-addr-part2x                       pic x(4).
           10 lk-addr-part3x                       pic x(4).
           10 lk-addr-part4x                       pic x(4).



       procedure division.
      *      call 'CBL_DEBUGBREAK'.
           exec cics address cwa(ws-cwa-area-ptr)
           end-exec.

           set address of cwa-area to ws-cwa-area-ptr.

           exec cics enq resource(cwa-area)
               length(length of cwa-area )
           end-exec.

           set address of netname-info to data-ptr-1.
           set address of model-table to data-ptr-2.
           set address of tct-info to data-ptr-3.
           set address of term-info to data-ptr-4.
           set address of tn3270-server-ip to data-ptr-5.
           set address of tn3270-client-ip to data-ptr-6.

      *  check if we have a ip-address to work with
      *  for the connected client

           if address of tn3270-client-ip not = null
              move client-ip-port  to ws-client-port
              if client-ip-type-4-88
                  move zeroes to ws-client-ip-address-v4
                  move 0 to two-bytes-binary
                  move client-ip-address-4(1:1) to two-bytes-right
                  move two-bytes-binary to ws-client-addr-part1
                  move 0 to two-bytes-binary
                  move client-ip-address-4(2:1) to two-bytes-right
                  move two-bytes-binary to ws-client-addr-part2
                  move 0 to two-bytes-binary
                  move client-ip-address-4(3:1) to two-bytes-right
                  move two-bytes-binary to ws-client-addr-part3
                  move 0 to two-bytes-binary
                  move client-ip-address-4(4:1) to two-bytes-right
                  move two-bytes-binary to ws-client-addr-part4
                  set address of lk-ip-address
                   to address of ws-client-ip-address
                  set address of lk-ip-address-v4x
                   to address of ws-client-ip-address-v4
                  perform get-dotted-addr
              end-if
           end-if.

      *  check if we have a ip-address to work with
      *  for the connected server

           if address of tn3270-server-ip not = null
               move server-ip-port to ws-server-port
               if server-ip-type-4-88
                   move zeroes to ws-server-ip-address-v4
                   move 0 to two-bytes-binary
                   move server-ip-address-4(1:1) to two-bytes-right
                   move two-bytes-binary to ws-server-addr-part1
                   move 0 to two-bytes-binary
                   move server-ip-address-4(2:1) to two-bytes-right
                   move two-bytes-binary to ws-server-addr-part2
                   move 0 to two-bytes-binary
                   move server-ip-address-4(3:1) to two-bytes-right
                   move two-bytes-binary to ws-server-addr-part3
                   move 0 to two-bytes-binary
                   move server-ip-address-4(4:1) to two-bytes-right
                   move two-bytes-binary to ws-server-addr-part4
               end-if
           end-if.

      *  Start from A000 to B000 through Z000 then A001 to B001 through
      *  Z001 through A999 to B999 through Z999
      *  allows limit of 26 x 999 terminals

      *  Must have low-values in status-byte on return else
      *  auto install will be rejected.

           move low-values to tct-info.
           if cwa-last-term-id not = low-values
               perform allocate-term-id
           else
               move 'A000' to ws-term-id
           end-if.

      *  This program uses the first entry by default but may scan
      *  for user terminal attributes in the autoinst-name according to
      *  defined convention to find appropriate model to return.

           move model-table-name(1) to tct-info-name.

      *     if term-info-rows = 24 and
      *        term-info-cols = 80
      *        move 'MODMOD2' to tct-info-name
      *     end-if.

           move ws-term-id to tct-info-term-id.
           move ws-term-id to cwa-last-term-id.

           exec cics deq resource(cwa-area)
              length(length of cwa-area )
           end-exec.

           perform display-connection.

           exec cics return end-exec.

       allocate-term-id section.

      *  build unique terminal id

           move cwa-last-term-id to ws-term-id.
           if ws-term-id-alpha = 'Z'
              add 1 to ws-term-id-numeric
              move 'A' to ws-term-id-alpha
           else
              perform varying ws-sub from 1 by 1
                until ws-term-id-alpha = ws-alpha-char(ws-sub)
                       or ws-sub = 26
               end-perform
               add 1 to ws-sub
               move ws-alpha-char(ws-sub) to ws-term-id-alpha
           end-if.


       get-dotted-addr section.
           move lk-addr-part1x to ws-temp4.
           perform 3 times
             if ws-temp4(1:1) is equal to space
                move ws-temp4(2:3) to ws-temp4(1:3)
                move space to ws-temp4(4:1)
             end-if
           end-perform.
           move ws-temp4 to lk-addr-part1x.
           move lk-addr-part2x to ws-temp4.
           perform 3 times
             if ws-temp4(1:1) is equal to space
                move ws-temp4(2:3) to ws-temp4(1:3)
                move space to ws-temp4(4:1)
             end-if
           end-perform.
           move ws-temp4 to lk-addr-part2x.
           move lk-addr-part3x to ws-temp4.
           perform 3 times
             if ws-temp4(1:1) is equal to space
                move ws-temp4(2:3) to ws-temp4(1:3)
                move space to ws-temp4(4:1)
             end-if
           end-perform.
           move ws-temp4 to lk-addr-part3x.
           move lk-addr-part4x to ws-temp4.
           perform 3 times
             if ws-temp4(1:1) is equal to space
                move ws-temp4(2:3) to ws-temp4(1:3)
                move space to ws-temp4(4:1)
             end-if
           end-perform.
           move ws-temp4 to lk-addr-part4x.
           move spaces to lk-ip-address.
           string lk-addr-part1x delimited by space
                  '.' delimited by size
                  lk-addr-part2x delimited by space
                  '.' delimited by size
                  lk-addr-part3x delimited by space
                  '.' delimited by size
                  lk-addr-part4x delimited by space
             into lk-ip-address.


       display-connection section.
           exec cics asktime abstime(ws-abstime)
           end-exec.
           exec cics formattime abstime(ws-abstime)
                                yyyymmdd(ws-date-yyyy-mm-dd)
           end-exec.

           move low-values to ws-msg
           string ws-term-id delimited by size
                  ' connected from ' delimited by size
                  ws-client-ip-address delimited by space
                  ' on ' delimited by size
                  ws-date-yyyy delimited by size
                  '-' delimited by size
                  ws-month(ws-date-mm) delimited by size
                  '-' delimited by size
                  ws-date-dd delimited by size
                  x'00' delimited by size
             into ws-msg.
           move 0 to ws-srv-cmsg-size.
           inspect ws-msg tallying ws-srv-cmsg-size
             for characters before x'00'.
           set ws-srv-cmsg-ptr to address of ws-msg.

           call 78-srv-cmsg-entry-name using ws-srv-console-msg
           end-call.

      * $ version 5.97a sequenced on tuesday 15 jul 2008 at 12:45am
      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
