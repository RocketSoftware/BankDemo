@echo off
rem Options are;
rem -t = use semi-colon as statement delimiter
rem -s = stop execution if an error is found in a batch
rem -c = automatically commit sql statements
rem -v = ech command text to standard output
rem -z = redire output to a file
rem
rem
rem db2options= -t -s -c -v -zc:\demo2bnk.log 
@echo on
set db2options= -t    -c -v -zc:\demo2bnk.log 