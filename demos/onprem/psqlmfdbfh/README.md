# Bankdemo Application using MFDBFH with PostgreSQL
This demonstration configures the Bankdemo application to store banking data in VSAM datasets stored within a PostgreSQL database. The database is accessed from COBOL programs using `EXEC CICS` statements such as: `STARTBR FILE`, `READ FILE`, and `WRITE FILE`. 

The COBOL modules used to access the data are stored in the `sources/cobol/data/vsam` directory of this project and are unchanged from when the data is stored in indexed sequential files on disk.

The Rocket Secrets Vault is used to store the database credentials.

## Prerequisites
- Rocket Enterprise Developer or Enterprise Server
- A TN3270 terminal emulator:
   - The Rocket Host Access for the Cloud session server and TN3270 emulator is included with both Enterprise Developer and Enterprise Server.
- The Rocket Directory Server (mfds) must be running and listening on the default port (86)
- The Enterprise Server Common Web Administration (ESCWA) service must be running and listening on the default port (10086).
- PostgreSQL version 12 or later must be installed and running
- PostgreSQL ODBC driver: 
   - Windows: [install appropriate driver](https://www.postgresql.org/ftp/odbc/versions/msi/)
   - Ubuntu: sudo apt-get install unixodbc unixodbc-dev odbc-postgresql
   - RedHat: sudo yum install unixODBC postgresql-odbc
   - Amazon Linux 2: sudo yum install unixODBC postgresql-odbc
   - SuSE: sudo zypper install unixODBC psqlODBC
- Python 3.*n* and the `requests` package. You can install the package after installing Python with the following command: 
  ```
  python -m pip install requests
  ```

## Demonstration overview
This demonstration shows a simple COBOL CICS "green screen" application accessing VSAM data using EXEC CICS statements where that data is actually stored in a PostreSQL database. 

The demonstration includes a Python script that helps create the Enterprise Server instance which is:

   - Created in the `BANKMFDB` subdirectory of this project
   - Created (almost exclusively) using the ESCWA Admin API
   - A single command-line utility, `caspcrd`, is used to create the default CICS resource definition file
   - Configured for use with JCL and the VSAM datasets are catalogued 
   - Configured as a 64-bit server and can be reconfigured to deploy a 32-bit server (see the next section)
   - Uses pre-built application modules
   - Two ODBC system data sources called `BANKVSAM.MASTER` and `BANKVSAM.VSAM` are created
   - The VSAM data is uploaded to the database using `dbfhdeploy add` commands 
   - The server instance is configured to use the Database File Handler by:
       - The credentials vault is populated with database credentials (using the `mfsecretsadmin` command)
        - Specifying the XA switch module espgsqlxa (its source is in the `src/enterpriseserver/xa` directory of the Enterprise Developer installation location)
       - The esxaextcfg module provides encrypted credentials to espgsqlxa        
        - Setting the environment variables MFDBFH_CONFIG and ES_DB_FH
        - Configuring the `CICS File Path` setting to point use an MFDBFH location (i.e., `sql://...`)
        - Cataloging the VSAM datasets with MFDBFH locations (i.e. `sql://...`)

The demonstration also includes some instructions to build the application from the sources (see the next section).


## Running the demonstration
1. Expand the demonstration archive on your machine.
 
   Ensure that there is no `BANKMFDB` subdirectory in the location in which you expanded the archive. If there is one, you must delete it.
2. Load the ESCWA UI by entering http://localhost:10086 in a browser. 

   a. In the ESCWA UI, click **Native**, expand **Directory Servers** and click **Default** in the left pane.

   b. Ensure there is no region called **BANKMFDB** already defined. If there is one, delete it.

3. Ensure that there are no other demonstration servers running. This is to ensure no other servers use the same ports. The server for this demonstration uses a common server definition with many of the same listener ports as the ones other servers in this repository might use.
4. Start an administrator's command prompt (Windows) or a terminal for user under which Enterprise Servers run (Linux).

   **Note:** You need administrator's rights to configure the ODBC data source on Windows. On Linux they are created in the user .odbc.ini file.

5. Navigate to the `scripts` directory in the demonstration files.
6. Edit the file `scripts/options/vsam_postgres.json` with a text editor:

    - Verify and, if required, modify the values within the `database_connection` section to match the setting of the database you are using.
    
    - If you want to deploy a 32-bit enterprise server instance, or build the application from source, you need to change the configuration first as follows:
      - Change the `is64bit` and/or the `product` options as required. For example, `"product"="EDz"` indicates you are going to build the application from the sources, `"product"="ES"` indicates that the pre-built programs will be used.

7. Execute the following command at the command prompt or the terminal. This executes the `MF_Provision_Region.py` script which creates a BANKMFDB server, and deploys the desired application configuration.

    ```
    python MF_Provision_Region.py vsam_postgres
    ```

8. Start a TN3270 terminal emulator, and connect to port 9023. 

   The Bankdemo application login screen should load.

9. Enter a valid user-id - a suitable user-id is **B0001** with any characters for the password as the password is not validated.

10. In ESCWA, select the BANKMFDB server under **Directory Servers > Default**. See the options on the **General** tab. Also, click the downwards arrow next to **General** and click any of the menu items to explore the server configuration.
    
11. The `sources\jcl\ZBNKSTMT.jcl` file can be used to run a JCL batch job via the **JES**, **Control** ESCWA dropdown menu.
