      *   Micro Focus COBOL 2017  7.0.00247
      *   Micro Focus BMS Screen Painter
      *   MapSet Name   DFHZSGM
      *   Date Created  11/15/2021
      *   Time Created  17:00:18

      *  Input Data For Map CSGM
         01 CSGMI REDEFINES MAPAREA.
            03 FILLER                         PIC X(12).
            03 TXT00L                         PIC S9(4) COMP.
            03 TXT00F                         PIC X.
            03 FILLER REDEFINES TXT00F.
               05 TXT00A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT00I                         PIC X(39).
            03 VAR01L                         PIC S9(4) COMP.
            03 VAR01F                         PIC X.
            03 FILLER REDEFINES VAR01F.
               05 VAR01A                         PIC X.
            03 FILLER                         PIC X(4).
            03 VAR01I                         PIC X(20).
            03 TXT01L                         PIC S9(4) COMP.
            03 TXT01F                         PIC X.
            03 FILLER REDEFINES TXT01F.
               05 TXT01A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT01I                         PIC X(77).
            03 TXT02L                         PIC S9(4) COMP.
            03 TXT02F                         PIC X.
            03 FILLER REDEFINES TXT02F.
               05 TXT02A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT02I                         PIC X(79).
            03 TXT03L                         PIC S9(4) COMP.
            03 TXT03F                         PIC X.
            03 FILLER REDEFINES TXT03F.
               05 TXT03A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT03I                         PIC X(77).
            03 TXT04L                         PIC S9(4) COMP.
            03 TXT04F                         PIC X.
            03 FILLER REDEFINES TXT04F.
               05 TXT04A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT04I                         PIC X(77).
            03 TXT05L                         PIC S9(4) COMP.
            03 TXT05F                         PIC X.
            03 FILLER REDEFINES TXT05F.
               05 TXT05A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT05I                         PIC X(78).
            03 TXT06L                         PIC S9(4) COMP.
            03 TXT06F                         PIC X.
            03 FILLER REDEFINES TXT06F.
               05 TXT06A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT06I                         PIC X(77).
            03 TXT07L                         PIC S9(4) COMP.
            03 TXT07F                         PIC X.
            03 FILLER REDEFINES TXT07F.
               05 TXT07A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT07I                         PIC X(76).
            03 TXT08L                         PIC S9(4) COMP.
            03 TXT08F                         PIC X.
            03 FILLER REDEFINES TXT08F.
               05 TXT08A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT08I                         PIC X(77).
            03 TXT09L                         PIC S9(4) COMP.
            03 TXT09F                         PIC X.
            03 FILLER REDEFINES TXT09F.
               05 TXT09A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT09I                         PIC X(77).
            03 TXT10L                         PIC S9(4) COMP.
            03 TXT10F                         PIC X.
            03 FILLER REDEFINES TXT10F.
               05 TXT10A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT10I                         PIC X(76).
            03 TXT11L                         PIC S9(4) COMP.
            03 TXT11F                         PIC X.
            03 FILLER REDEFINES TXT11F.
               05 TXT11A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT11I                         PIC X(75).

      *  Output Data For Map CSGM
         01 CSGMO REDEFINES CSGMI.
            03 FILLER                         PIC X(12).
            03 FILLER                         PIC X(3).
            03 TXT00C                         PIC X.
            03 TXT00P                         PIC X.
            03 TXT00H                         PIC X.
            03 TXT00V                         PIC X.
            03 TXT00O                         PIC X(39).
            03 FILLER                         PIC X(3).
            03 VAR01C                         PIC X.
            03 VAR01P                         PIC X.
            03 VAR01H                         PIC X.
            03 VAR01V                         PIC X.
            03 VAR01O                         PIC X(20).
            03 FILLER                         PIC X(3).
            03 TXT01C                         PIC X.
            03 TXT01P                         PIC X.
            03 TXT01H                         PIC X.
            03 TXT01V                         PIC X.
            03 TXT01O                         PIC X(77).
            03 FILLER                         PIC X(3).
            03 TXT02C                         PIC X.
            03 TXT02P                         PIC X.
            03 TXT02H                         PIC X.
            03 TXT02V                         PIC X.
            03 TXT02O                         PIC X(79).
            03 FILLER                         PIC X(3).
            03 TXT03C                         PIC X.
            03 TXT03P                         PIC X.
            03 TXT03H                         PIC X.
            03 TXT03V                         PIC X.
            03 TXT03O                         PIC X(77).
            03 FILLER                         PIC X(3).
            03 TXT04C                         PIC X.
            03 TXT04P                         PIC X.
            03 TXT04H                         PIC X.
            03 TXT04V                         PIC X.
            03 TXT04O                         PIC X(77).
            03 FILLER                         PIC X(3).
            03 TXT05C                         PIC X.
            03 TXT05P                         PIC X.
            03 TXT05H                         PIC X.
            03 TXT05V                         PIC X.
            03 TXT05O                         PIC X(78).
            03 FILLER                         PIC X(3).
            03 TXT06C                         PIC X.
            03 TXT06P                         PIC X.
            03 TXT06H                         PIC X.
            03 TXT06V                         PIC X.
            03 TXT06O                         PIC X(77).
            03 FILLER                         PIC X(3).
            03 TXT07C                         PIC X.
            03 TXT07P                         PIC X.
            03 TXT07H                         PIC X.
            03 TXT07V                         PIC X.
            03 TXT07O                         PIC X(76).
            03 FILLER                         PIC X(3).
            03 TXT08C                         PIC X.
            03 TXT08P                         PIC X.
            03 TXT08H                         PIC X.
            03 TXT08V                         PIC X.
            03 TXT08O                         PIC X(77).
            03 FILLER                         PIC X(3).
            03 TXT09C                         PIC X.
            03 TXT09P                         PIC X.
            03 TXT09H                         PIC X.
            03 TXT09V                         PIC X.
            03 TXT09O                         PIC X(77).
            03 FILLER                         PIC X(3).
            03 TXT10C                         PIC X.
            03 TXT10P                         PIC X.
            03 TXT10H                         PIC X.
            03 TXT10V                         PIC X.
            03 TXT10O                         PIC X(76).
            03 FILLER                         PIC X(3).
            03 TXT11C                         PIC X.
            03 TXT11P                         PIC X.
            03 TXT11H                         PIC X.
            03 TXT11V                         PIC X.
            03 TXT11O                         PIC X(75).

