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

       01  ws-default-table.                           *>----<*
           03  value '................'   pic x(16).   *> 00 <*
           03  value '................'   pic x(16).   *> 10 <*
           03  value ' !"#$%&''()*+,-./'  pic x(16).   *> 20 <*
           03  value '0123456789:;<=>?'   pic x(16).   *> 30 <*
           03  value ' ABCDEFGHIJKLMNO'   pic x(16).   *> 40 <*
           03  value 'PQRSTUVWXYZ[\]^_'   pic x(16).   *> 50 <*
           03  value '`abcdefghijklmno'   pic x(16).   *> 60 <*
           03  value 'pqrstuvwxyz{|}~.'   pic x(16).   *> 70 <*
           03  value '.abcdefghi......'   pic x(16).   *> 80 <*
           03  value '.jklmnopqr......'   pic x(16).   *> 90 <*
           03  value '..stuvwxyz......'   pic x(16).   *> a0 <*
           03  value '................'   pic x(16).   *> b0 <*
           03  value '{ABCDEFGHI......'   pic x(16).   *> c0 <*
           03  value '}JKLMNOPQR......'   pic x(16).   *> d0 <*
           03  value '\.STUVWXYZ......'   pic x(16).   *> e0 <*
           03  value '0123456789|.....'   pic x(16).   *> f0 <*
       01  ws-ASCII-table.                             *>----<*
           03  value '................'   pic x(16).   *> 00 <*
           03  value '................'   pic x(16).   *> 10 <*
           03  value ' !"#$%&''()*+,-./'  pic x(16).   *> 20 <*
           03  value '0123456789:;<=>?'   pic x(16).   *> 30 <*
           03  value '@ABCDEFGHIJKLMNO'   pic x(16).   *> 40 <*
           03  value 'PQRSTUVWXYZ[\]^_'   pic x(16).   *> 50 <*
           03  value '`abcdefghijklmno'   pic x(16).   *> 60 <*
           03  value 'pqrstuvwxyz{|}~.'   pic x(16).   *> 70 <*
           03  value '................'   pic x(16).   *> 80 <*
           03  value '................'   pic x(16).   *> 90 <*
           03  value '................'   pic x(16).   *> a0 <*
           03  value '................'   pic x(16).   *> b0 <*
           03  value '................'   pic x(16).   *> c0 <*
           03  value '................'   pic x(16).   *> d0 <*
           03  value '................'   pic x(16).   *> e0 <*
           03  value '................'   pic x(16).   *> f0 <*
       01  ws-EBCDIC-table.                            *>----<*
      $if NCHAR set
           03  value '................'   pic x(16).   *> 00 <*
           03  value '................'   pic x(16).   *> 10 <*
           03  value '................'   pic x(16).   *> 20 <*
           03  value '................'   pic x(16).   *> 30 <*
           03  value '................'   pic x(16).   *> 40 <*
           03  value '................'   pic x(16).   *> 50 <*
           03  value '................'   pic x(16).   *> 60 <*
           03  value '................'   pic x(16).   *> 70 <*
           03  value '.abcdefghi......'   pic x(16).   *> 80 <*
           03  value '.jklmnopqr......'   pic x(16).   *> 90 <*
           03  value '..stuvwxyz......'   pic x(16).   *> a0 <*
           03  value '................'   pic x(16).   *> b0 <*
           03  value '.ABCDEFGHI......'   pic x(16).   *> c0 <*
           03  value '.JKLMNOPQR......'   pic x(16).   *> d0 <*
           03  value '..STUVWXYZ......'   pic x(16).   *> e0 <*
           03  value '0123456789......'   pic x(16).   *> f0 <*
      $else
           03  value '................'   pic x(16).   *> 00 <*
           03  value '................'   pic x(16).   *> 10 <*
           03  value '................'   pic x(16).   *> 20 <*
           03  value '................'   pic x(16).   *> 30 <*
           03  value ' |�.�..�.�.<(+|'   pic x(16).   *> 40 <*
           03  value '&��.ۥ.�.!$*);^'   pic x(16).   *> 50 <*
           03  value '-/��.��~.�|,%_>?'   pic x(16).   *> 60 <*
           03  value 'x^"������`:#@.="'   pic x(16).   *> 70 <*
           03  value x'f86162636465666768692da4f3afaec5'
                                          pic x(16).   *> 80 <*
           03  value x'2e6a6b6c6d6e6f7071722e23ce23f1fe'
                                          pic x(16).   *> 90 <*
           03  value x'c87e737475767778797aefc0da5bf2f9'
                                          pic x(16).   *> a0 <*
           03  value x'b520fdb7b8b9e6bbbcbd2ed9bf5dd8c4'
                                          pic x(16).   *> b0 <*
           03  value x'7b414243444546474849cbcabee8eced'
                                          pic x(16).   *> c0 <*
           03  value x'7d4a4b4c4d4e4f505152a12ef5f4a32e'
                                          pic x(16).   *> d0 <*
           03  value x'5ce7535455565758595a2e2e2ee9e4d1'
                                          pic x(16).   *> e0 <*
           03  value x'30313233343536373839b3f7f0faa7ff'
                                          pic x(16).   *> f0 <*
      $end
       01  ws-dump-char-table.                         *>----<*
           03                                            pic x.
           03  ws-dump-char occurs 255 times             pic x.
      ***--------------------------------------------------------------*
      ***  $Workfile:   cascwprn.cbl  $ end
      ***--------------------------------------------------------------*
