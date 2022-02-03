      *   Micro Focus COBOL 2017  7.0.00247
      *   Micro Focus BMS Screen Painter
      *   MapSet Name   BTS01M
      *   Date Created  09/30/2021
      *   Time Created  10:37:41

      *  Input Data For Map BTS01A
         01 BTS01AI REDEFINES MAPAREA.
            03 FILLER                         PIC X(12).
            03 USERIDL                        PIC S9(4) COMP.
            03 USERIDF                        PIC X.
            03 FILLER REDEFINES USERIDF.
               05 USERIDA                        PIC X.
            03 FILLER                         PIC X(4).
            03 USERIDI                        PIC X(8).
            03 PSWDL                          PIC S9(4) COMP.
            03 PSWDF                          PIC X.
            03 FILLER REDEFINES PSWDF.
               05 PSWDA                          PIC X.
            03 FILLER                         PIC X(4).
            03 PSWDI                          PIC X(8).

      *  Output Data For Map BTS01A
         01 BTS01AO REDEFINES BTS01AI.
            03 FILLER                         PIC X(12).
            03 FILLER                         PIC X(3).
            03 USERIDC                        PIC X.
            03 USERIDP                        PIC X.
            03 USERIDH                        PIC X.
            03 USERIDV                        PIC X.
            03 USERIDO                        PIC X(8).
            03 FILLER                         PIC X(3).
            03 PSWDC                          PIC X.
            03 PSWDP                          PIC X.
            03 PSWDH                          PIC X.
            03 PSWDV                          PIC X.
            03 PSWDO                          PIC X(8).

