# Micro Focus Bankdemo Application using disk files
This demonstration configures the Bankdemo deployment to store banking data in VSAM datasets 
in disk accessed from COBOL programs using file input/output verbs
such as START, READ, WRITE, DELETE.

## Steps for running the demonstration
- Open a command-prompt or terminal
- Change to the `scripts` directory
- Run the command `MF_Provision_Region.py vsam` to deploy the desired application configuration
- Start a 3270 terminal emulator 
    1. connect the emulator to port 9023 and the login screen should become visible
    2. enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)