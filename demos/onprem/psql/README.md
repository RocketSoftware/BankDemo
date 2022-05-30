# Micro Focus Bankdemo Application with PostgreSQL
This demonstration configures the Bankdemo deployment to store banking data in a PostgreSQL database
accessed from COBOL programs using `EXEC SQL` statements. The COBOL modules used to access the database
can be found in the `sources/cobol/data/sql` directory of this project.

The SQL database is populated with bank account data.

## Pre-requisites
- Micro Focus Enterprise Developer or Enterprise Server
- Micro Focus Directory Server started and listening on the default port (86)
- Micro Focus Enterprise Server Common Web Administration (ESCWA) server started and listening the default port (10086)
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

## What the demonstration shows
- This demonstration shows a simple COBOL CICS "green screen" application accessing data using EXEC SQL statements. 
- The Enterprise Server instance is created in the `BANKSQL` sub-directory of this project
- The server instance is created using the ESCWA Admin API, using just a single command-line utility to create the default CICS resource definition file.
- The server is configured as 64-bit and uses pre-built executables, but can easily be reconfigured to use 32-bit and/or build the application from source
- On Windows an ODBC system data source called `bank` is created
- The database tables are populated with example data
- The server instance is configured to use MFDBFH by:
    - specifying the XA switch module espgsqlxa (source is in Enterprise Developer product `src/enterpriseserver/xa` directory)

## Steps for running the demonstration
1. Open a (Windows) Administrator command-prompt or (Linux) terminal
    - An Administrator command-prompt is required to configure the ODBC data source
2. Ensure there is no `BANKSQL` sub-directory in the location in which you expanded the archive (if there is delete it)
3. In [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/regions) ensure there is no region called BANKSQL already defined - if there is delete it.
4. As this demonstration uses a common server definition (i.e. many of the same listener ports) as the others in this repository, ensure you do not have any of the other demonstration servers running
5. Change to the `scripts` directory
6. Edit the file scripts/options/sql_postgres.json with a text editor 
    - verify/modify the values within the 
database_connection section to match the setting of the database you are using.
    - If you wish to deploy a 32-bit server, or build the application from source change the `is64bit` and/or `product` options appropriately (specify `"EDz"` to build from source, `"ES"` to use pre-built programs).
7. Run the `python` script `MF_Provision_Region.py sql_postgres` to deploy the desired application configuration
8. Start a 3270 terminal emulator 
    - connect the emulator to port 9023 and the login screen should become visible
    - enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)
    - use [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/region/BANKSQL/generalproperties) to view the server configuration
    