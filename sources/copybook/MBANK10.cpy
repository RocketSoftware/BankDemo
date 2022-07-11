      *   Micro Focus COBOL 2017  7.0.00247
      *   Micro Focus BMS Screen Painter
      *   MapSet Name   MBANK10
      *   Date Created  11/08/2021
      *   Time Created  19:41:40

      *  Input Data For Map BANK10A
         01 BANK10AI REDEFINES MAPAREA.
            03 FILLER                         PIC X(12).
            03 TXT01L                         PIC S9(4) COMP.
            03 TXT01F                         PIC X.
            03 FILLER REDEFINES TXT01F.
               05 TXT01A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT01I                         PIC X(5).
            03 SCRNL                          PIC S9(4) COMP.
            03 SCRNF                          PIC X.
            03 FILLER REDEFINES SCRNF.
               05 SCRNA                          PIC X.
            03 FILLER                         PIC X(4).
            03 SCRNI                          PIC X(6).
            03 HEAD1L                         PIC S9(4) COMP.
            03 HEAD1F                         PIC X.
            03 FILLER REDEFINES HEAD1F.
               05 HEAD1A                         PIC X.
            03 FILLER                         PIC X(4).
            03 HEAD1I                         PIC X(50).
            03 DATEL                          PIC S9(4) COMP.
            03 DATEF                          PIC X.
            03 FILLER REDEFINES DATEF.
               05 DATEA                          PIC X.
            03 FILLER                         PIC X(4).
            03 DATEI                          PIC X(11).
            03 TXT02L                         PIC S9(4) COMP.
            03 TXT02F                         PIC X.
            03 FILLER REDEFINES TXT02F.
               05 TXT02A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT02I                         PIC X(5).
            03 TRANL                          PIC S9(4) COMP.
            03 TRANF                          PIC X.
            03 FILLER REDEFINES TRANF.
               05 TRANA                          PIC X.
            03 FILLER                         PIC X(4).
            03 TRANI                          PIC X(4).
            03 HEAD2L                         PIC S9(4) COMP.
            03 HEAD2F                         PIC X.
            03 FILLER REDEFINES HEAD2F.
               05 HEAD2A                         PIC X.
            03 FILLER                         PIC X(4).
            03 HEAD2I                         PIC X(50).
            03 TIMEL                          PIC S9(4) COMP.
            03 TIMEF                          PIC X.
            03 FILLER REDEFINES TIMEF.
               05 TIMEA                          PIC X.
            03 FILLER                         PIC X(4).
            03 TIMEI                          PIC X(8).
            03 TXT03L                         PIC S9(4) COMP.
            03 TXT03F                         PIC X.
            03 FILLER REDEFINES TXT03F.
               05 TXT03A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT03I                         PIC X(78).
            03 TXT04L                         PIC S9(4) COMP.
            03 TXT04F                         PIC X.
            03 FILLER REDEFINES TXT04F.
               05 TXT04A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT04I                         PIC X(72).
            03 TXT05L                         PIC S9(4) COMP.
            03 TXT05F                         PIC X.
            03 FILLER REDEFINES TXT05F.
               05 TXT05A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT05I                         PIC X(37).
            03 TXT06L                         PIC S9(4) COMP.
            03 TXT06F                         PIC X.
            03 FILLER REDEFINES TXT06F.
               05 TXT06A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT06I                         PIC X(13).
            03 USERIDL                        PIC S9(4) COMP.
            03 USERIDF                        PIC X.
            03 FILLER REDEFINES USERIDF.
               05 USERIDA                        PIC X.
            03 FILLER                         PIC X(4).
            03 USERIDI                        PIC X(5).
            03 TXT07L                         PIC S9(4) COMP.
            03 TXT07F                         PIC X.
            03 FILLER REDEFINES TXT07F.
               05 TXT07A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT07I                         PIC X(13).
            03 PSWDL                          PIC S9(4) COMP.
            03 PSWDF                          PIC X.
            03 FILLER REDEFINES PSWDF.
               05 PSWDA                          PIC X.
            03 FILLER                         PIC X(4).
            03 PSWDI                          PIC X(8).
            03 ERRMSGL                        PIC S9(4) COMP.
            03 ERRMSGF                        PIC X.
            03 FILLER REDEFINES ERRMSGF.
               05 ERRMSGA                        PIC X.
            03 FILLER                         PIC X(4).
            03 ERRMSGI                        PIC X(75).
            03 TXT08L                         PIC S9(4) COMP.
            03 TXT08F                         PIC X.
            03 FILLER REDEFINES TXT08F.
               05 TXT08A                         PIC X.
            03 FILLER                         PIC X(4).
            03 TXT08I                         PIC X(25).
            03 VERL                           PIC S9(4) COMP.
            03 VERF                           PIC X.
            03 FILLER REDEFINES VERF.
               05 VERA                           PIC X.
            03 FILLER                         PIC X(4).
            03 VERI                           PIC X(7).

      *  Output Data For Map BANK10A
         01 BANK10AO REDEFINES BANK10AI.
            03 FILLER                         PIC X(12).
            03 FILLER                         PIC X(3).
            03 TXT01C                         PIC X.
            03 TXT01P                         PIC X.
            03 TXT01H                         PIC X.
            03 TXT01V                         PIC X.
            03 TXT01O                         PIC X(5).
            03 FILLER                         PIC X(3).
            03 SCRNC                          PIC X.
            03 SCRNP                          PIC X.
            03 SCRNH                          PIC X.
            03 SCRNV                          PIC X.
            03 SCRNO                          PIC X(6).
            03 FILLER                         PIC X(3).
            03 HEAD1C                         PIC X.
            03 HEAD1P                         PIC X.
            03 HEAD1H                         PIC X.
            03 HEAD1V                         PIC X.
            03 HEAD1O                         PIC X(50).
            03 FILLER                         PIC X(3).
            03 DATEC                          PIC X.
            03 DATEP                          PIC X.
            03 DATEH                          PIC X.
            03 DATEV                          PIC X.
            03 DATEO                          PIC X(11).
            03 FILLER                         PIC X(3).
            03 TXT02C                         PIC X.
            03 TXT02P                         PIC X.
            03 TXT02H                         PIC X.
            03 TXT02V                         PIC X.
            03 TXT02O                         PIC X(5).
            03 FILLER                         PIC X(3).
            03 TRANC                          PIC X.
            03 TRANP                          PIC X.
            03 TRANH                          PIC X.
            03 TRANV                          PIC X.
            03 TRANO                          PIC X(4).
            03 FILLER                         PIC X(3).
            03 HEAD2C                         PIC X.
            03 HEAD2P                         PIC X.
            03 HEAD2H                         PIC X.
            03 HEAD2V                         PIC X.
            03 HEAD2O                         PIC X(50).
            03 FILLER                         PIC X(3).
            03 TIMEC                          PIC X.
            03 TIMEP                          PIC X.
            03 TIMEH                          PIC X.
            03 TIMEV                          PIC X.
            03 TIMEO                          PIC X(8).
            03 FILLER                         PIC X(3).
            03 TXT03C                         PIC X.
            03 TXT03P                         PIC X.
            03 TXT03H                         PIC X.
            03 TXT03V                         PIC X.
            03 TXT03O                         PIC X(78).
            03 FILLER                         PIC X(3).
            03 TXT04C                         PIC X.
            03 TXT04P                         PIC X.
            03 TXT04H                         PIC X.
            03 TXT04V                         PIC X.
            03 TXT04O                         PIC X(72).
            03 FILLER                         PIC X(3).
            03 TXT05C                         PIC X.
            03 TXT05P                         PIC X.
            03 TXT05H                         PIC X.
            03 TXT05V                         PIC X.
            03 TXT05O                         PIC X(37).
            03 FILLER                         PIC X(3).
            03 TXT06C                         PIC X.
            03 TXT06P                         PIC X.
            03 TXT06H                         PIC X.
            03 TXT06V                         PIC X.
            03 TXT06O                         PIC X(13).
            03 FILLER                         PIC X(3).
            03 USERIDC                        PIC X.
            03 USERIDP                        PIC X.
            03 USERIDH                        PIC X.
            03 USERIDV                        PIC X.
            03 USERIDO                        PIC X(5).
            03 FILLER                         PIC X(3).
            03 TXT07C                         PIC X.
            03 TXT07P                         PIC X.
            03 TXT07H                         PIC X.
            03 TXT07V                         PIC X.
            03 TXT07O                         PIC X(13).
            03 FILLER                         PIC X(3).
            03 PSWDC                          PIC X.
            03 PSWDP                          PIC X.
            03 PSWDH                          PIC X.
            03 PSWDV                          PIC X.
            03 PSWDO                          PIC X(8).
            03 FILLER                         PIC X(3).
            03 ERRMSGC                        PIC X.
            03 ERRMSGP                        PIC X.
            03 ERRMSGH                        PIC X.
            03 ERRMSGV                        PIC X.
            03 ERRMSGO                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 TXT08C                         PIC X.
            03 TXT08P                         PIC X.
            03 TXT08H                         PIC X.
            03 TXT08V                         PIC X.
            03 TXT08O                         PIC X(25).
            03 FILLER                         PIC X(3).
            03 VERC                           PIC X.
            03 VERP                           PIC X.
            03 VERH                           PIC X.
            03 VERV                           PIC X.
            03 VERO                           PIC X(7).

      *  Input Data For Map HELP10A
         01 HELP10AI REDEFINES MAPAREA.
            03 FILLER                         PIC X(12).
            03 ATXT01L                        PIC S9(4) COMP.
            03 ATXT01F                        PIC X.
            03 FILLER REDEFINES ATXT01F.
               05 ATXT01A                        PIC X.
            03 FILLER                         PIC X(4).
            03 ATXT01I                        PIC X(5).
            03 ASCRNL                         PIC S9(4) COMP.
            03 ASCRNF                         PIC X.
            03 FILLER REDEFINES ASCRNF.
               05 ASCRNA                         PIC X.
            03 FILLER                         PIC X(4).
            03 ASCRNI                         PIC X(6).
            03 AHEAD1L                        PIC S9(4) COMP.
            03 AHEAD1F                        PIC X.
            03 FILLER REDEFINES AHEAD1F.
               05 AHEAD1A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHEAD1I                        PIC X(50).
            03 ADATEL                         PIC S9(4) COMP.
            03 ADATEF                         PIC X.
            03 FILLER REDEFINES ADATEF.
               05 ADATEA                         PIC X.
            03 FILLER                         PIC X(4).
            03 ADATEI                         PIC X(11).
            03 ATXT02L                        PIC S9(4) COMP.
            03 ATXT02F                        PIC X.
            03 FILLER REDEFINES ATXT02F.
               05 ATXT02A                        PIC X.
            03 FILLER                         PIC X(4).
            03 ATXT02I                        PIC X(5).
            03 ATRANL                         PIC S9(4) COMP.
            03 ATRANF                         PIC X.
            03 FILLER REDEFINES ATRANF.
               05 ATRANA                         PIC X.
            03 FILLER                         PIC X(4).
            03 ATRANI                         PIC X(4).
            03 AHEAD2L                        PIC S9(4) COMP.
            03 AHEAD2F                        PIC X.
            03 FILLER REDEFINES AHEAD2F.
               05 AHEAD2A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHEAD2I                        PIC X(50).
            03 ATIMEL                         PIC S9(4) COMP.
            03 ATIMEF                         PIC X.
            03 FILLER REDEFINES ATIMEF.
               05 ATIMEA                         PIC X.
            03 FILLER                         PIC X(4).
            03 ATIMEI                         PIC X(8).
            03 AHLP01L                        PIC S9(4) COMP.
            03 AHLP01F                        PIC X.
            03 FILLER REDEFINES AHLP01F.
               05 AHLP01A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP01I                        PIC X(75).
            03 AHLP02L                        PIC S9(4) COMP.
            03 AHLP02F                        PIC X.
            03 FILLER REDEFINES AHLP02F.
               05 AHLP02A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP02I                        PIC X(75).
            03 AHLP03L                        PIC S9(4) COMP.
            03 AHLP03F                        PIC X.
            03 FILLER REDEFINES AHLP03F.
               05 AHLP03A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP03I                        PIC X(75).
            03 AHLP04L                        PIC S9(4) COMP.
            03 AHLP04F                        PIC X.
            03 FILLER REDEFINES AHLP04F.
               05 AHLP04A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP04I                        PIC X(75).
            03 AHLP05L                        PIC S9(4) COMP.
            03 AHLP05F                        PIC X.
            03 FILLER REDEFINES AHLP05F.
               05 AHLP05A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP05I                        PIC X(75).
            03 AHLP06L                        PIC S9(4) COMP.
            03 AHLP06F                        PIC X.
            03 FILLER REDEFINES AHLP06F.
               05 AHLP06A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP06I                        PIC X(75).
            03 AHLP07L                        PIC S9(4) COMP.
            03 AHLP07F                        PIC X.
            03 FILLER REDEFINES AHLP07F.
               05 AHLP07A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP07I                        PIC X(75).
            03 AHLP08L                        PIC S9(4) COMP.
            03 AHLP08F                        PIC X.
            03 FILLER REDEFINES AHLP08F.
               05 AHLP08A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP08I                        PIC X(75).
            03 AHLP09L                        PIC S9(4) COMP.
            03 AHLP09F                        PIC X.
            03 FILLER REDEFINES AHLP09F.
               05 AHLP09A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP09I                        PIC X(75).
            03 AHLP10L                        PIC S9(4) COMP.
            03 AHLP10F                        PIC X.
            03 FILLER REDEFINES AHLP10F.
               05 AHLP10A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP10I                        PIC X(75).
            03 AHLP11L                        PIC S9(4) COMP.
            03 AHLP11F                        PIC X.
            03 FILLER REDEFINES AHLP11F.
               05 AHLP11A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP11I                        PIC X(75).
            03 AHLP12L                        PIC S9(4) COMP.
            03 AHLP12F                        PIC X.
            03 FILLER REDEFINES AHLP12F.
               05 AHLP12A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP12I                        PIC X(75).
            03 AHLP13L                        PIC S9(4) COMP.
            03 AHLP13F                        PIC X.
            03 FILLER REDEFINES AHLP13F.
               05 AHLP13A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP13I                        PIC X(75).
            03 AHLP14L                        PIC S9(4) COMP.
            03 AHLP14F                        PIC X.
            03 FILLER REDEFINES AHLP14F.
               05 AHLP14A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP14I                        PIC X(75).
            03 AHLP15L                        PIC S9(4) COMP.
            03 AHLP15F                        PIC X.
            03 FILLER REDEFINES AHLP15F.
               05 AHLP15A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP15I                        PIC X(75).
            03 AHLP16L                        PIC S9(4) COMP.
            03 AHLP16F                        PIC X.
            03 FILLER REDEFINES AHLP16F.
               05 AHLP16A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP16I                        PIC X(75).
            03 AHLP17L                        PIC S9(4) COMP.
            03 AHLP17F                        PIC X.
            03 FILLER REDEFINES AHLP17F.
               05 AHLP17A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP17I                        PIC X(75).
            03 AHLP18L                        PIC S9(4) COMP.
            03 AHLP18F                        PIC X.
            03 FILLER REDEFINES AHLP18F.
               05 AHLP18A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP18I                        PIC X(75).
            03 AHLP19L                        PIC S9(4) COMP.
            03 AHLP19F                        PIC X.
            03 FILLER REDEFINES AHLP19F.
               05 AHLP19A                        PIC X.
            03 FILLER                         PIC X(4).
            03 AHLP19I                        PIC X(75).
            03 ATXT03L                        PIC S9(4) COMP.
            03 ATXT03F                        PIC X.
            03 FILLER REDEFINES ATXT03F.
               05 ATXT03A                        PIC X.
            03 FILLER                         PIC X(4).
            03 ATXT03I                        PIC X(28).
            03 AVERL                          PIC S9(4) COMP.
            03 AVERF                          PIC X.
            03 FILLER REDEFINES AVERF.
               05 AVERA                          PIC X.
            03 FILLER                         PIC X(4).
            03 AVERI                          PIC X(7).

      *  Output Data For Map HELP10A
         01 HELP10AO REDEFINES HELP10AI.
            03 FILLER                         PIC X(12).
            03 FILLER                         PIC X(3).
            03 ATXT01C                        PIC X.
            03 ATXT01P                        PIC X.
            03 ATXT01H                        PIC X.
            03 ATXT01V                        PIC X.
            03 ATXT01O                        PIC X(5).
            03 FILLER                         PIC X(3).
            03 ASCRNC                         PIC X.
            03 ASCRNP                         PIC X.
            03 ASCRNH                         PIC X.
            03 ASCRNV                         PIC X.
            03 ASCRNO                         PIC X(6).
            03 FILLER                         PIC X(3).
            03 AHEAD1C                        PIC X.
            03 AHEAD1P                        PIC X.
            03 AHEAD1H                        PIC X.
            03 AHEAD1V                        PIC X.
            03 AHEAD1O                        PIC X(50).
            03 FILLER                         PIC X(3).
            03 ADATEC                         PIC X.
            03 ADATEP                         PIC X.
            03 ADATEH                         PIC X.
            03 ADATEV                         PIC X.
            03 ADATEO                         PIC X(11).
            03 FILLER                         PIC X(3).
            03 ATXT02C                        PIC X.
            03 ATXT02P                        PIC X.
            03 ATXT02H                        PIC X.
            03 ATXT02V                        PIC X.
            03 ATXT02O                        PIC X(5).
            03 FILLER                         PIC X(3).
            03 ATRANC                         PIC X.
            03 ATRANP                         PIC X.
            03 ATRANH                         PIC X.
            03 ATRANV                         PIC X.
            03 ATRANO                         PIC X(4).
            03 FILLER                         PIC X(3).
            03 AHEAD2C                        PIC X.
            03 AHEAD2P                        PIC X.
            03 AHEAD2H                        PIC X.
            03 AHEAD2V                        PIC X.
            03 AHEAD2O                        PIC X(50).
            03 FILLER                         PIC X(3).
            03 ATIMEC                         PIC X.
            03 ATIMEP                         PIC X.
            03 ATIMEH                         PIC X.
            03 ATIMEV                         PIC X.
            03 ATIMEO                         PIC X(8).
            03 FILLER                         PIC X(3).
            03 AHLP01C                        PIC X.
            03 AHLP01P                        PIC X.
            03 AHLP01H                        PIC X.
            03 AHLP01V                        PIC X.
            03 AHLP01O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP02C                        PIC X.
            03 AHLP02P                        PIC X.
            03 AHLP02H                        PIC X.
            03 AHLP02V                        PIC X.
            03 AHLP02O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP03C                        PIC X.
            03 AHLP03P                        PIC X.
            03 AHLP03H                        PIC X.
            03 AHLP03V                        PIC X.
            03 AHLP03O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP04C                        PIC X.
            03 AHLP04P                        PIC X.
            03 AHLP04H                        PIC X.
            03 AHLP04V                        PIC X.
            03 AHLP04O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP05C                        PIC X.
            03 AHLP05P                        PIC X.
            03 AHLP05H                        PIC X.
            03 AHLP05V                        PIC X.
            03 AHLP05O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP06C                        PIC X.
            03 AHLP06P                        PIC X.
            03 AHLP06H                        PIC X.
            03 AHLP06V                        PIC X.
            03 AHLP06O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP07C                        PIC X.
            03 AHLP07P                        PIC X.
            03 AHLP07H                        PIC X.
            03 AHLP07V                        PIC X.
            03 AHLP07O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP08C                        PIC X.
            03 AHLP08P                        PIC X.
            03 AHLP08H                        PIC X.
            03 AHLP08V                        PIC X.
            03 AHLP08O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP09C                        PIC X.
            03 AHLP09P                        PIC X.
            03 AHLP09H                        PIC X.
            03 AHLP09V                        PIC X.
            03 AHLP09O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP10C                        PIC X.
            03 AHLP10P                        PIC X.
            03 AHLP10H                        PIC X.
            03 AHLP10V                        PIC X.
            03 AHLP10O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP11C                        PIC X.
            03 AHLP11P                        PIC X.
            03 AHLP11H                        PIC X.
            03 AHLP11V                        PIC X.
            03 AHLP11O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP12C                        PIC X.
            03 AHLP12P                        PIC X.
            03 AHLP12H                        PIC X.
            03 AHLP12V                        PIC X.
            03 AHLP12O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP13C                        PIC X.
            03 AHLP13P                        PIC X.
            03 AHLP13H                        PIC X.
            03 AHLP13V                        PIC X.
            03 AHLP13O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP14C                        PIC X.
            03 AHLP14P                        PIC X.
            03 AHLP14H                        PIC X.
            03 AHLP14V                        PIC X.
            03 AHLP14O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP15C                        PIC X.
            03 AHLP15P                        PIC X.
            03 AHLP15H                        PIC X.
            03 AHLP15V                        PIC X.
            03 AHLP15O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP16C                        PIC X.
            03 AHLP16P                        PIC X.
            03 AHLP16H                        PIC X.
            03 AHLP16V                        PIC X.
            03 AHLP16O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP17C                        PIC X.
            03 AHLP17P                        PIC X.
            03 AHLP17H                        PIC X.
            03 AHLP17V                        PIC X.
            03 AHLP17O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP18C                        PIC X.
            03 AHLP18P                        PIC X.
            03 AHLP18H                        PIC X.
            03 AHLP18V                        PIC X.
            03 AHLP18O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 AHLP19C                        PIC X.
            03 AHLP19P                        PIC X.
            03 AHLP19H                        PIC X.
            03 AHLP19V                        PIC X.
            03 AHLP19O                        PIC X(75).
            03 FILLER                         PIC X(3).
            03 ATXT03C                        PIC X.
            03 ATXT03P                        PIC X.
            03 ATXT03H                        PIC X.
            03 ATXT03V                        PIC X.
            03 ATXT03O                        PIC X(28).
            03 FILLER                         PIC X(3).
            03 AVERC                          PIC X.
            03 AVERP                          PIC X.
            03 AVERH                          PIC X.
            03 AVERV                          PIC X.
            03 AVERO                          PIC X(7).

