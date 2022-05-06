# Micro Focus Bankdemo Application with Postrgres SQL
This demonstration configures the Bankdemo deployment to store banking data in a Postgres SQL database
accessed from COBOL programs using EXEC SQL statements.

## Steps for running the demonstration
- Open a command-prompt or terminal
- Change to the `scripts` directory
- Run the command `MF_Provision_Region.py sql_postgres` to deploy the desired application configuration
- Start a 3270 terminal emulator 
    1. connect the emulator to port 9023 and the login screen should become visible
    2. enter an valid user-id (e.g. B0001 with any character for the password as it isn't validated)