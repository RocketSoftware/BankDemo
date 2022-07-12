How to set up the database for DB2

- DB2 must be started

- go to a DB2 command line prompt

- run "db2opts.cmd" or type in:
  "set db2options= -t -s -c -v -zc:\demo2bnk.log"

- create the database:
  "db2 -f zdbnase.sql"
  This will create the database DBNASDE in C:\DB2 for you

- connect to the database:
  "db2 connect to dbnase"

- create the tables and populate them:
  "db2 -f ????" where ???? is:
    zbnkatyp.sql
    zbnkcust.sql
    zbnkacc.sql
    zbnktxn.sql
    zbnkdets.sql
    zbnkhelp.sql
    zbnkspa.sql
  they should be done in the above order as there are referential integrity checks,
  ie you can't create an account for a customer until you have created the 

Alternatively, one DB@OPTS has been run, type "db2 -fzbnkall.sql"
which will drop the database, recreate it and add the tables 
