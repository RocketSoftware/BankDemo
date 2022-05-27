# Micro Focus Bankdemo Application using MFDBFH with Postrgres SQL
This demonstration configures the Bankdemo deployment to store banking data in VSAM datasets 
stored within a Postgres SQL database accessed from COBOL programs file input/output EXEC CICS statements such as STARTBR FILE, READ FILE, WRITE FILE. The COBOL modules used to access the data can be found in the `sources/cobol/data/vsam` directory of this project and are unchanged from when the data is held in files on disk.

## Pre-requisites
- Micro Focus Enterprise Developer or Enterprise Server
- Micro Focus Directory Server started and listening on the default port (86)
- Micro Focus Enterprise Server Common Web Administration (ESCWA) server started and listening the default port (10086)

## What the demonstration shows
- This demonstration shows a simple COBOL CICS "green screen" application access VSAM data using EXEC CICS statements. 
- The Enterprise Server instance is created in the `BANKDEMO` sub-directory of the expanded archive directory
- The server instance is configured for use with JCL and the VSAM datasets are catalogued. 
- The server instance is created using the ESCWA Admin API with the use of just a single command-line utility to create an default CICS resource definition file.

such as START, READ, WRITE, DELETE.

## Steps for running the demonstration
- Open a command-prompt or terminal
- Change to the `scripts` directory
- Run the command `MF_Provision_Region.py vsam_postgres` to deploy the desired application configuration
- Start a 3270 terminal emulator 
    1. connect the emulator to port 9023 and the login screen should become visible
    2. enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)