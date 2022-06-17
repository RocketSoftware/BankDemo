# Micro Focus Bankdemo Application using MFDBFH with PostrgreSQL
This demonstration configures the Bankdemo application to store banking data in VSAM datasets 
stored within a PostgreSQL database accessed from COBOL programs using `EXEC CICS` statements such as: `STARTBR FILE`, `READ FILE`, `WRITE FILE`. 

The COBOL modules used to access the data can be found in the `sources/cobol/data/vsam` directory of this project and are unchanged from when the data is stored in indexed sequential files on disk.

The Micro Focus Secrets Vault is used to store the database credentials.

## Pre-requisites
- Micro Focus Enterprise Developer or Enterprise Server
- Micro Focus Directory Server started and listening on the default port (86)
- Micro Focus Enterprise Server Common Web Administration (ESCWA) server started and listening the default port (10086)
- PostgreSQL version 12 or later installed and started
- PostgreSQL ODBC driver installed 
- On Linux ODBC data sources are confgured e.g.
```
odbc.ini:
[BANKVSAM.MASTER] 
Driver = PostgreSQL
Servername = localhost
Port = 5432
Database = postgres
[BANKVSAM.VSAM] 
Driver = PostgreSQL
Servername = localhost
Port = 5432
Database = BANK_ONEDB
```

## What the demonstration shows
- This demonstration shows a simple COBOL CICS "green screen" application accessing VSAM data using EXEC CICS statements where that data is actually stored in a PostreSQL database. 
- The Enterprise Server instance is:
    - created in the `BANKMFDB` sub-directory of this project
    - created (almost exclusively) using the ESCWA Admin API
    - command-line utility `caspcrd` is used to create the default CICS resource definition file
    - configured for use with JCL and the VSAM datasets are catalogued 
    - configured as a 64-bit server
    - uses pre-built application modules
    - can be reconfigured to deploy a 32-bit server (see below)
    - build the application from source (see below)
    - On Windows an ODBC system data sources called `BANKVSAM.MASTER` and `BANKVSAM.VSAM` are created
    - The VSAM data is uploaded to the database using `dbfhdeploy add` commands 
    - The server instance is configured to use MFDBFH by:
        - the credentials vault is populated with database credentials (using the `mfsecretsadmin` command)
        - specifying the XA switch module espgsqlxa (source is in Enterprise Developer product `src/enterpriseserver/xa` directory)
        - esxaextcfg is used to provide encrypted credentials to espgsqlxa
        - setting the environment variables MFDBFH_CONFIG and ES_DB_FH
        - configuring the `CICS File Path` setting to point use an MFDBFH location (ie `sql://...`)
        - cataloging the VSAM datasets with MFDBFH locations (i.e. `sql://...`)

## Steps for running the demonstration
1. Open a (Windows) Administrator command-prompt or (Linux) terminal
    - An Administrator command-prompt is required to configure the ODBC data source
2. Ensure there is no `BANKMFDB` sub-directory in the location in which you expanded the archive (if there is delete it)
3. In [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/regions) ensure there is no region called `BANKMFDB` already defined - if there is delete it.
4. As this demonstration uses a common server definition (i.e. many of the same listener ports) as the others in this repository, ensure you do not have any of the other demonstration servers running
5. Change to the `scripts` directory
6. Edit the file scripts/options/vsam_postgres.json with a text editor 
    - verify/modify the values within the 
database_connection section to match the setting of the database you are using.
    - If you wish to deploy a 32-bit server, or build the application from source change the `is64bit` and/or `product` options appropriately (specify `"EDz"` to build from source, `"ES"` to use pre-built programs).

6. Run the `python` script `MF_Provision_Region.py vsam_postgres` to deploy the desired application configuration
    - If you wish to deploy a 32-bit server, or build the application from source open the `scripts/options/vsam_postgres.json` file in a text editor and change the `is64bit` and/or `product` options appropriately (specify "EDz" to build from source, "ES" to use pre-built programs).
7. Start a 3270 terminal emulator 
    - connect the emulator to port 9023 and the login screen should become visible
    - enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)
    - use [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/region/BANKMFDB/generalproperties) to view the server configuration
    