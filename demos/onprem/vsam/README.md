# Micro Focus Bankdemo Application using disk files
This demonstration configures the Bankdemo application to store banking data in VSAM datasets 
on disk accessed from COBOL programs using `EXEC CICS` statements such as `STARTBR FILE`, `READ FILE`, `WRITE FILE`. The COBOL modules used to access the data can be found in the `sources/cobol/data/vsam` directory of this project

## Pre-requisites
- Micro Focus Enterprise Developer or Enterprise Server
- Micro Focus Directory Server started and listening on the default port (86)
- Micro Focus Enterprise Server Common Web Administration (ESCWA) server started and listening the default port (10086)

## What the demonstration shows
- This demonstration shows a simple COBOL CICS "green screen" application which accesses VSAM data using EXEC CICS statements where the data is held in indexed sequential files on disk. 
- The Enterprise Server instance is:
    - created in the `BANKVSAM` sub-directory of this project
    - created (almost exclusively) using the ESCWA Admin API
    - a single command-line utility `caspcrd` is used to create the default CICS resource definition file
    - configured for use with JCL and the VSAM datasets are catalogued 
    - configured as a 64-bit server
    - uses pre-built application modules
    - can be reconfigured to deploy a 32-bit server (see below)
    - build the application from source (see below)

## Steps for running the demonstration
1. Open a command-prompt or terminal
2. Ensure there is no `BANKVSAM` sub-directory in the location in which you expanded the archive (if there is delete it)
3. In [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/regions) ensure there is no region called `BANKVSAM` already defined - if there is delete it.
4. As this demonstration uses a common server definition (i.e. many of the same listener ports) as the others in this repository, ensure you do not have any of the other demonstration servers running
5. Change to the `scripts` directory
6. Run the `python` script `MF_Provision_Region.py vsam` to deploy the desired application configuration
    - If you wish to deploy a 32-bit server, or build the application from source open the `scripts/options/vsam.json` file in a text editor and change the `is64bit` and/or `product` options appropriately (specify `"EDz"` to build from source, `"ES"` to use pre-built programs).
7. Start a 3270 terminal emulator 
    - connect the emulator to port 9023 and the login screen should become visible
    - enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)
    - use [ESCWA](http://localhost:10086/#/native/ds/127.0.0.1/86/region/BANKVSAM/generalproperties) to view the server configuration