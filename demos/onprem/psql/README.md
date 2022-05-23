# Micro Focus Bankdemo Application with PostgreSQL
This demonstration configures the Bankdemo deployment to store banking data in a PostgreSQL database
accessed from COBOL programs using EXEC SQL statements. The COBOL modules used to access the database
can be found in the sources/cobol/data/sql folder of this project, in addition an XA switch module
espgsqlxa module is configured (source is in Enterprise Developer product src/enterpriseserver/xa folder).

The SQL database is populated with bank account data.

## Additional Pre-requisites
- PostgreSQL version 12 or later installed and started
- PostgreSQL ODBC driver installed 
- On Linux ODBC `bank` data source configured e.g.
```
odbc.ini:
[bank] 
Driver = PostgreSQL
Servername = localhost
Port = 5432
Database = bank
```

## Steps for running the demonstration
1. Open a (Windows) Administrator command-prompt or (Linux) terminal
    - An Administrator command-prompt is required to configure the ODBC data source
2. Change to the `scripts` directory
3. Edit the file options/sql_postgres.json with a text editor and verify/modify the values within the 
database_connection section to match the setting of the database you are using.
4. Run the command `MF_Provision_Region.py sql_postgres` to deploy the desired application configuration
5. Start a 3270 terminal emulator 
    - connect the emulator to port 9023 and the login screen should become visible
    - enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)