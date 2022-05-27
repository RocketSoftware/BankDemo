# Micro Focus Bankdemo Application using disk files
This demonstration configures the Bankdemo deployment to store banking data in VSAM datasets 
in disk accessed from COBOL programs using file input/output EXEC CICS statements such as STARTBR FILE, READ FILE, WRITE FILE. The COBOL modules used to access the data can be found in the `sources/cobol/data/vsam` directory of this project

## Pre-requisites
- Micro Focus Enterprise Developer or Enterprise Server
- Micro Focus Directory Server started and listening on the default port (86)
- Micro Focus Enterprise Server Common Web Administration (ESCWA) server started and listening the default port (10086)
- PostgreSQL version 12 or later installed and started
- PostgreSQL ODBC driver installed 
- On Linux ODBC data sources are confgured e.g.
```
odbc.ini:
[PG.MASTER] 
Driver = PostgreSQL
Servername = localhost
Port = 5432
Database = postgres
[PG.VSAM] 
Driver = PostgreSQL
Servername = localhost
Port = 5432
Database = BANK_ONEDB
```

## What the demonstration shows
- This demonstration shows a simple COBOL CICS "green screen" application access VSAM data using EXEC CICS statements but where the data is stored within a PostgreSQL database rather than as indexed sequential files on disk. 
- The Enterprise Server instance is created in the `BANKDEMO` sub-directory of the expanded archive directory
- The server instance is created using the ESCWA Admin API with the use of just a single command-line utility to create an default CICS resource definition file.
- The server instance is configured for use with JCL and the VSAM datasets are catalogued. 
- On Windows an ODBC system data sources called `PG.MASTER` are `PG.VSAM` are created
- The server instance is configured to use MFDBFH
    1. install espgsqlxa XA switch module ((source is in Enterprise Developer product `src/enterpriseserver/xa` directory)
    2. set `MFDBFH_CONFIG` and `ES_DB_FH` environment variables
    3. set the CICS File Path to be the `PG.VSAM` database 
    4. copy the VSAM data into the `PG.VSAM` database
    5. catalog the `PG.VSAM` datasets
- The credentials vault is used to hold the database password used by MFDBFH (using the `mfsecretsadmin` command)

## Steps for running the demonstration
1. Open a command-prompt or terminal
2. In [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/regions) ensure there is no region called BANKDEMO already defined - if there is delete it.
3. Ensure there is no `BANKDEMO` sub-directory in the location in which you expanded the archive (if there is delete it)
4. Change to the `scripts` directory
5. Edit the file options/vsam_postgres.json with a text editor and verify/modify the values within the 
database_connection section to match the setting of the database you are using.
6. Run the command `MF_Provision_Region.py vsam_postgres` to deploy the desired application configuration
7. Start a 3270 terminal emulator 
    - connect the emulator to port 9023 and the login screen should become visible
    - enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)
    - use [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/region/BANKDEMO/generalproperties) to view the server configuration