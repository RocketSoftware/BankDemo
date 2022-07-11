000100***************************************************************** chelpsql
000200*                                                               * chelpsql
000300*  Copyright(C) 1998-2012 Micro Focus. All Rights Reserved.     * chelpsql
000400*                                                               * chelpsql
000500***************************************************************** chelpsql
000600                                                                  chelpsql
000700***************************************************************** chelpsql
000800* CHELPSQL.CPY                                                  * chelpsql
000900*---------------------------------------------------------------* chelpsql
001000* Define SQL areas to access HELP table                         * chelpsql
001100***************************************************************** chelpsql
001200     EXEC SQL DECLARE USERID.BNKHELP TABLE                        chelpsql
001300     (                                                            chelpsql
001400        BHP_SCRN                       CHAR (6)                   chelpsql
001500                                       NOT NULL,                  chelpsql
001600        BHP_LINE                       CHAR (2)                   chelpsql
001700                                       NOT NULL,                  chelpsql
001800        BHP_TEXT                       CHAR (75)                  chelpsql
001900                                       NOT NULL                   chelpsql
002000     )                                                            chelpsql
002100     END-EXEC.                                                    chelpsql
002200                                                                  chelpsql
002300 01  DCLHELP.                                                     chelpsql
002400     03 DCL-BHP-SCRN                   PIC X(6).                  chelpsql
002500     03 DCL-BHP-LINE                   PIC X(2).                  chelpsql
002600     03 DCL-BHP-TEXT                   PIC X(75).                 chelpsql
002700                                                                  chelpsql
002800* $ Version 7.00a sequenced on Thursday 20 Sep 2012 at 3:30pm     chelpsql
