# Micro Focus Bankdemo Application with PostgreSQL
This demonstration configures the Bankdemo application to store banking data in a PostgreSQL database. The database is accessed from COBOL programs using `EXEC SQL` statements. These COBOL programs are stored in the `sources/cobol/data/sql` directory of this project.

The SQL database is populated with bank account data.

## Prerequisites
- Micro Focus Enterprise Developer or Enterprise Server
- A TN3270 terminal emulator:
   - The Micro Focus HACloud session server and TN3270 emulator is included with both Enterprise Developer and Enterprise Server.
- The Micro Focus Directory Server (mfds) must be running and listening on the default port (86)
- The Micro Focus Enterprise Server Common Web Administration (ESCWA) service must be running and listening on the default port (10086).
- PostgreSQL version 12 or later must be installed and running
- PostgreSQL `psql` command needs to be available on the PATH
- PostgreSQL ODBC driver: 
   - Windows: [install appropriate driver](https://www.postgresql.org/ftp/odbc/versions/msi/)
   - Ubuntu: sudo apt-get install unixodbc unixodbc-dev odbc-postgresql
   - RedHat: sudo yum install unixODBC postgresql-odbc
   - Amazon Linux 2: sudo yum install unixODBC postgresql-odbc
   - SuSE: sudo zypper install unixODBC psqlODBC
- Python 3.*n* and the `requests psycopg2-binary` packages. You can install the packages after installing Python with the following command: 
  ```
  python -m pip install requests psycopg2-binary
  ```

## Demonstration overview
This demonstration shows a simple COBOL CICS "green screen" application which accesses data using EXEC SQL statements. 

The demonstration includes a Python script that helps create the Enterprise Server instance which is:

   - Created in the `BANKSQL` subdirectory of this project
   - Created (almost exclusively) using the ESCWA Admin API
   - A single command-line utility, `caspcrd`, is used to create the default CICS resource definition file
   - Configured for use with JCL and the VSAM datasets are cataloged 
   - Configured as a 64-bit server and can be reconfigured to deploy a 32-bit server (see below)
   - Uses pre-built application modules
   - An ODBC system data source called `bank` is created
   - The database tables are populated with example data
   - The server instance is configured to use PostgreSQL:
      - The credentials vault is populated with database credentials (using the `mfsecretsadmin` command)
       - Specifying the XA switch module espgsqlxa (its source is in the `src/enterpriseserver/xa` directory of the Enterprise Developer installation location)
       - The esxaextcfg module provides encrypted credentials to espgsqlxa

The demonstration also includes some instructions to build the application from the sources (see the next section).

## Running the demonstration
1. Expand the demonstration archive on your machine.

   Ensure that there is no `BANKSQL` subdirectory in the location in which you expanded the archive. If there is one, delete it.

2. Load the ESCWA UI by entering http://localhost:10086 in a browser. 

   a. In the ESCWA UI, click **Native**, expand **Directory Servers** and click **Default** in the left pane.

   b. Ensure there is no region called **BANKSQL** already defined. If there is one, delete it.

3. Ensure that there are no other demonstration servers running. This is to ensure no other servers use the same ports. The server for this demonstration uses a common server definition with many of the same listener ports as the ones other servers in this repository might use.

4. Start an administrator's command prompt (Windows) or a terminal for user under which Enterprise Servers run (Linux).

   **Note:** You need administrator's rights to configure the ODBC data source on Windows. On Linux they are created in the user .odbc.ini file.

5. Navigate to the `scripts` directory in the demonstration.
6. Edit the file `scripts/options/sql_postgres.json` with a text editor: 
    - Verify and, if required, modify the values within the `database_connection` section to match the setting of the database you are using.
    
    - If you want to deploy a 32-bit enterprise server instance, or build the application from source, you need to change the configuration first as follows:
      - Change the `is64bit` and/or the `product` options as required. For example, `"product"="EDz"` indicates you are going to build the application from the sources, `"product"="ES"` indicates that the pre-built programs will be used.

7. Execute the following python script from the `scripts` directory with the specified option to create the Enterprise Server instance, and to deploy the application:

   ```
   python MF_Provision_Region.py sql_postgres
   ``` 
8. Start a TN3270 terminal emulator and connect it to port 9023.

   The Bankdemo application login screen should load.

7. Enter a valid user-id - a suitable user-id is **B0001** with any characters for the password as the password is not validated.

8. In ESCWA, select the BANKSQL server under **Directory Servers > Default**. See the options on the **General** tab. Also, click the downwards arrow next to **General**, and click any of the menu items to explore the server configuration.
    
9. The `sources\jcl\ZBNKSTMS.jcl` file can be used to run a JCL batch job via the **JES**, **Control** ESCWA dropdown menu.
