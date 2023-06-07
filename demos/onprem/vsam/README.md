# Micro Focus Bankdemo Application Using Disk Files
This demonstration shows how to configure the Bankdemo application to store banking data in VSAM datasets on disk. You access the datasets from COBOL programs using `EXEC CICS` statements such as `STARTBR FILE`, `READ FILE`, `WRITE FILE`. The COBOL modules are stored in the `sources/cobol/data/vsam` directory of this project.

## Prerequisites
- Micro Focus Enterprise Developer or Enterprise Server
- A TN3270 terminal emulator. 
   - The Micro Focus HACloud session server and TN3270 emulator is included with both Enterprise Developer and Enterprise Server.
- The Micro Focus Directory Server (mfds) service must be started and listening on the default port (86).
- The Micro Focus Enterprise Server Common Web Administration (ESCWA) service must be started and listening on the default port (10086).
- Python 3.*n* and the `requests` package from Python.org. You can install the package after installing Python with the following command: 
  ```
  python -m pip install requests
  ```

## Demonstration overview
This demonstration shows a simple COBOL CICS "green screen" application which accesses VSAM data using EXEC CICS statements where the data is held in indexed sequential files on disk. 

The demonstration includes a Python script that helps create the Enterprise Server instance which is:

   - Created in the `BANKVSAM` sub-directory of this project
   - Created (almost exclusively) using the ESCWA Admin API
   - A single command-line utility, `caspcrd`, is used to create the default CICS resource definition file
   - Configured for use with JCL and the VSAM datasets are catalogued 
   - Configured as a 64-bit server and can be reconfigured to deploy a 32-bit server (see below)
   - Uses pre-built application modules

The demonstration also includes some instructions to build the application from the sources (see the next section).

## Running the demonstration
1. Expand the demonstration archive on your machine.
 
   Ensure that there is no `BANKVSAM` sub-directory in the location in which you expanded the archive. If there is one, you must delete it.
2. Load the ESCWA UI by entering http://localhost:10086 in a browser. 

   a. In the ESCWA UI, click **Native**, expand **Directory Servers** and click **Default** in the left pane.

   b. Ensure there is no region called **BANKVSAM** already defined. If there is one, delete it.
3. Ensure that there are no other demonstration servers running. This is to ensure no other servers use the same ports. The server for this demonstration uses a common server definition with many of the same listener ports as the ones other servers in this repository might use.
4. Open a command prompt (Windows) or a terminal (Linux), and navigate to the `scripts` directory in the demonstration files.
5. Execute the following command at the command prompt or the terminal. This executes the `MF_Provision_Region.py` script which creates a BANKVSAM server, and deploys the desired application configuration.

    ```
    python MF_Provision_Region.py vsam
    ```

   **Note:** If you want to deploy a 32-bit enterprise server instance, or build the application from source, you need to change the configuration first as follows:
    
    a. Open the `scripts/options/vsam.json` file in a text editor.
    
    b. Change the `is64bit` and/or the `product` options as required. For example, `"product"="EDz"` indicates you are going to build the application from the sources, `"product"="ES"` indicates that the pre-built programs will be used.

6. Start a TN3270 terminal emulator, and connect to port 9023. 

   The Bankdemo application login screen should load.

7. Enter a valid user-id - a suitable user-id is **B0001** with any characters for the password as the password is not validated.

8. In ESCWA, select the BANKVSAM server under **Directory Servers > Default**. See the options on the **General** tab. Also, click the downwards arrow next to **General** and click any of the menu items to explore the server configuration.
9. The `sources\jcl\ZBNKSTMT.jcl` file can be used to run a JCL batch job via the **JES**, **Control** ESCWA dropdown menu.
