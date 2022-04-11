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
      * CSCRNHP2.CPY                                                  *
      *---------------------------------------------------------------*
      * Procedure code to populate screen titles                      *
      *****************************************************************
           CALL 'SCUSTOMP' USING SCREEN-TITLES.
           MOVE SCREEN-TITLE1 TO AHEAD1O IN <<SCRN>>.
           MOVE SCREEN-TITLE2 TO AHEAD2O IN <<SCRN>>.
           CALL 'SVERSONP' USING VERSION.
           MOVE VERSION TO AVERO IN <<SCRN>>.
           MOVE WS-TRAN-ID TO ATRANO IN <<SCRN>>.
           MOVE DD-TIME-OUTPUT TO ATIMEO IN <<SCRN>>.
           MOVE DDO-DATA TO ADATEO IN <<SCRN>>.
      * Move in any error message
      * Move in screen specific fields
              MOVE :OPTN:-HELP-LINE (01) TO AHLP01O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (02) TO AHLP02O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (03) TO AHLP03O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (04) TO AHLP04O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (05) TO AHLP05O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (06) TO AHLP06O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (07) TO AHLP07O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (08) TO AHLP08O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (09) TO AHLP09O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (10) TO AHLP10O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (11) TO AHLP11O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (12) TO AHLP12O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (13) TO AHLP13O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (14) TO AHLP14O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (15) TO AHLP15O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (16) TO AHLP16O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (17) TO AHLP17O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (18) TO AHLP18O IN <<SCRN>>.
              MOVE :OPTN:-HELP-LINE (19) TO AHLP19O IN <<SCRN>>.
      * Turn colour off if required
           IF COLOUR-OFF
              MOVE DFHGREEN TO ATXT01C IN <<SCRN>>
              MOVE DFHGREEN TO ASCRNC IN <<SCRN>>
              MOVE DFHGREEN TO AHEAD1C IN <<SCRN>>
              MOVE DFHGREEN TO ADATEC IN <<SCRN>>
              MOVE DFHGREEN TO ATXT02C IN <<SCRN>>
              MOVE DFHGREEN TO ATRANC IN <<SCRN>>
              MOVE DFHGREEN TO AHEAD2C IN <<SCRN>>
              MOVE DFHGREEN TO ATIMEC IN <<SCRN>>
              MOVE DFHGREEN TO AHLP01C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP02C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP03C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP04C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP05C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP06C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP07C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP08C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP09C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP10C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP11C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP12C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP13C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP14C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP15C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP16C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP17C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP18C IN <<SCRN>>
              MOVE DFHGREEN TO AHLP19C IN <<SCRN>>
              MOVE DFHGREEN TO ATXT03C IN <<SCRN>>
              MOVE DFHGREEN TO AVERC IN <<SCRN>>
           END-IF.

      * $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm
