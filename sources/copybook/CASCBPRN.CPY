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

       01  (ws)-prn-exit-interface.
           *>  What is the format of the structure used to call the
           *>  printer exit.  Will change with major revisions to this
           *>  Data Structure.
           03  (ws)-prn-version                     pic x(4) comp-5.
               88  (ws)-prn-current-version-88      value 1.
           *>  The printer exit is driven once as the batch printer SEP
           *>  starts, once for every print job, and once when the batch
           *>  printer is shut down.
           03  (ws)-prn-command                     pic x    comp-5.
               88  (ws)-prn-exit-init-88            value 0.
               88  (ws)-prn-exit-print-88           value 1.
               88  (ws)-prn-exit-term-88            value 2.
           *>  For the requested print job.  (ws)-prn-exit-print-88
           *>  what is the character set of the data being printed.
           03  (ws)-prn-char                        pic x.
               88  (ws)-prn-char-ascii-88           value 'A'.
               88  (ws)-prn-char-ebcdic-88          value 'E'.
               88  (ws)-prn-char-unknown-88         value '?'.
           *>  This is the file status returned by driving the procedure
           *>  pointers:
           *>              (ws)-prn-sysout-open-pptr
           *>              (ws)-prn-sysout-read-next-pptr
           *>              (ws)-prn-sysout-close-pptr
           *>
           03  (ws)-prn-sysout-status               pic x(2).
               88  (ws)-prn-sysout-status-ok-88     value '00'.
               88  (ws)-prn-sysout-status-eof-88    value '10'.
      ***--------------------------------------------------------------*
           *>  Procedure pointer to drive the open of the sysout dataset
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-sysout-open-pptr            procedure-pointer.
           *>  Procedure pointer to a read of the sysout dataset
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-sysout-read-next-pptr       procedure-pointer.
           *>  Procedure pointer to drive the close of the sysout datase
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-sysout-close-pptr           procedure-pointer.
           *>  Procedure pointer to allow a message to be driven to the
           *>  console.  (all functions)
           03  (ws)-prn-message-pptr                procedure-pointer.
           *>  Procedure pointer to retrieve the next OUTPUT statement.
           *>  Returns a null (ws)-prn-output-record-ptr if none are
           *>  available.
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-output-read-next-pptr       procedure-pointer.
           03                                       procedure-pointer.
           03                                       procedure-pointer.
      ***--------------------------------------------------------------*
           *>  A pointer to the data structure contained in Spool.cpy
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-spool-record-ptr            pointer.
           *>  A pointer to the data structure contained in mvscatlg.cpy
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-catalog-record-ptr          pointer.
           *>  The printer handle for the printer assigned to the this S
           03  (ws)-prn-printer-handle              pic x(4) comp-5.
           *>  The LRECL of the dataset being printed.
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-lrecl                       pic x(4) comp-5.
           *>  The Maximum LRECL of the dataset being printed.
           *>  Same as ws-prn-lrecl.
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-lrecl-max                   pic x(4) comp-5.
           *>  The Minimum LRECL of the dataset being printed.
           *>  (Variable Length SYSOUT Datasets.
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-lrecl-min                   pic x(4) comp-5.
           *>  disposition of the printed spool file.  Set to '1' to DEL
           03  (ws)-prn-file-disp                   PIC x.
           03                                       pic x(3).
           *>  The length of the buffer used to return data when driving
           *>     (ws)-prn-sysout-read-next-pptr
           *>  (How much data was returned)
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-buffer-len                  pic x(4) comp-5.
           03  (ws)-prn-buffer.
               05  (ws)-prn-buffer-byte occurs 32765 times pic x comp-x.
               05  (ws)-prn-buffer-char redefines (ws)-prn-buffer-byte
                                        occurs 32765 times pic x.
           *>  The "MVS" Name of the document being printed.
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-buffer-cc-data redefines (ws)-prn-buffer.
               05  (ws)-prn-buffer-ccbyte           pic x.
               88 skip-to-channel-1     value "1".
               88 skip-to-channel-2     value "2".
               88 skip-to-channel-3     value "3".
               88 skip-to-channel-4     value "4".
               88 skip-to-channel-5     value "5".
               88 skip-to-channel-6     value "6".
               88 skip-to-channel-7     value "7".
               88 skip-to-channel-8     value "8".
               88 skip-to-channel-9     value "9".
               88 skip-to-channel-a     value "A".
               88 skip-to-channel-b     value "B".
               88 skip-to-channel-c     value "C".
               88 space-one-line        value " ".
               88 space-two-lines       value "0".
               88 carriage-return       value "+".
               88 space-three-lines     value "-".
               88 space-one-line-a      value x"09".
               88 space-two-lines-a     value x"11".
               88 space-three-lines-a   value x"19".
               88 space-one-line-i      value x"0B".
               88 space-two-lines-i     value x"13".
               88 space-three-lines-i   value x"1B".
               88 write-without-spacing value x"01".
               88 skip-to-channel-1-a   value x"89".
               88 skip-to-channel-1-i   value x"8B".
               88 skip-to-channel-2-a   value x"91".
               88 skip-to-channel-2-i   value x"93".
               88 skip-to-channel-3-a   value x"99".
               88 skip-to-channel-3-i   value x"9B".
               88 skip-to-channel-4-a   value x"A1".
               88 skip-to-channel-4-i   value x"A3".
               88 skip-to-channel-5-a   value x"A9".
               88 skip-to-channel-5-i   value x"AB".
               88 skip-to-channel-6-a   value x"B1".
               88 skip-to-channel-6-i   value x"B3".
               88 skip-to-channel-7-a   value x"B9".
               88 skip-to-channel-7-i   value x"BB".
               88 skip-to-channel-8-a   value x"C1".
               88 skip-to-channel-8-i   value x"C3".
               88 skip-to-channel-9-a   value x"C9".
               88 skip-to-channel-9-i   value x"CB".
               88 skip-to-channel-a-a   value x"D1".
               88 skip-to-channel-a-i   value x"D3".
               88 skip-to-channel-b-a   value x"D9".
               88 skip-to-channel-b-i   value x"DB".
               88 skip-to-channel-c-a   value x"E1".
               88 skip-to-channel-c-i   value x"E3".

               05 (ws)-prn-buffer-data              pic x(32764).

           03  (ws)-prn-document.
               05  (ws)-prn-document-len            pic x(2) comp-5.
               05  (ws)-prn-document-title          pic x(128).
           *>  The name of the batch printer driving this print job.
           03  (ws)-prn-printer.
               05  (ws)-prn-printer-name-len        pic x(2) comp-5.
               05  (ws)-prn-printer-name            pic x(128).
           *>  The "physical" filename for the file being printed.
           *>  (eg.  Where does it reside on the disk pack)
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-sysout-file-name            pic x(260).
           *>  A pointer to an OUTPUT Statement associated with this
           *>  SYSOUT Dataset.  Points to the data structure contained
           *>  in IDADOUTP.CPY
           *>    (ws)-prn-exit-print-88 only
           03  (ws)-prn-output-record-ptr           pointer.
           *>  DD statement SUBSYS= value length
           03  (ws)-prn-subsys-len                  pic x(4) comp-5.
           *>  if SUBSYS= value length (previous field) is non-zero,
           *>  a pointer to entire (including subsystem name, the 1st
           *>  subparameter) DD SUBSYS= string
           03  (ws)-prn-subsys-ptr                  pointer.
      ***--------------------------------------------------------------*
      ***  $Workfile:   cascbprn.cpy  $ end
      ***--------------------------------------------------------------*
