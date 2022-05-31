# Open PL/I Development using Enterprise Developer for Eclipse
## Contents
- Overview
- How to Run this Demonstration
- Project Description

## Overview
This demonstration shows you how to compile, link and debug an Open PL/I BANK CICS application using the Eclipse IDE.  
The demo instructions assume you already have a basic understanding of how to use Eclipse and some basic familiarity with Enterprise Server.
If you decide to use the remote debug instructions, please check with your system administrator for connection details (machine name, port, connection type, credentials) before starting.

This demonstration requires a working Eclipse IDE, Micro Focus Enterprise Developer, and 3270 emulator (like Micro Focus Rumba) in order to be executed successfully.  

Before running this demo remotely, be sure you have a Micro Focus RDO and MFDS agent already configured and running on the remote unix/linux machine.
Please see the Micro Focus product documentation for more information.

## How to Run the Demonstration
1. Import the supplied enterprise server:
    - If you have already imported the enterprise server for the IDE Getting Started tutorial you scan skip these steps
    - Run the tutorial\creatdefinition.ps1 Powershell script(Windows) or tutorial/createdefinition.sh shell script(Linux) to create the BANKDEMO.xml region definition file. 
    - In the "Server Explorer" tab, right-click on "Local" and select "Import Server...". 
    - Click the &lt;Browse...&gt; button and select the tutorial/BANKDEMO.xml file. Then click &lt;Finish&gt;
    - The BANKDEMO server should appear in Server Explorer under "Local"

2. Import the INCLUDES, FETCHABLES, and BANKMAIN projects into an Eclipse workspace:
    - After opening Enterprise Developer for Eclipse, either create a new workspace or open an existing one.
    - If it's not already open, open the PL/I perspective in the Eclipse IDE ("Window"->"Open Perspective"->"Other..."->"PL/I").
    - Start the project import process by selecting "Import..." from the "File" menu or right clicking in the "PL/I Explorer" tab and selecting "Import->Import..."
    - On the import pop-up window, expand "General", select "Existing Projects into Workspace", and click &lt;Next&gt;.
    - In "Select root directory:", click &lt;Browse...&gt; to navigate to the location of the "tutorial\projects\Eclipse\pli" directory, select it and click &lt;Select Folder&gt;.
    - The "BANKMAIN", "FETCHABLES" and "INCLUDES" projects should now be visible in the "Projects:" list.
    - Ensure "Copy projects into workspace" is not checked and click &lt;Finish&gt;
    - Once the import is complete, the "BANKMAIN", "FETCHABLES" and "INCLUDES" projects should display in the "PL/I Explorer" tab.
    - Be sure to check the active build configuration is 'x64' in the project properties before continuing as this demo is designed to run only in 64-bit mode.
    - Ensure the project has been built (either because Auto-build is enabled) or by selecting Build from the Project menu.

3. Configure the enterprise server for PL/I:
    - In the "Server Explorer" tab, right-click on "BANKDEMO" under "Local" and select "Open Administration Page". This opens "Enterprise Server Administration"  page.
    - Click on the "CICS" dropdown and select "Configuration".
    - Change the "System Initialization Table" from "CBLVSAM" to "PLIVSAM" and click &lt;Apply&gt;. This configures the server to use some PL/I CICS resources.
      
4. Associate the projects with enterprise server:
    - In the "Server Explorer" tab, right-click the "BANKDEMO" server and select "Associate with Project" and select "BANKMAIN", then repeat the process and select "FETCHABLES". Making these associations
      before starting the server enables the executables built by the projects are used.

5. Start the enterprise server:
    - On the "Server Explorer" tab, right-click the "BANKDEMO" server and click &lt;Start&gt;.
    - Click &lt;OK&gt; in the Enterprise Server Sign On dialog (you can leave the fields blank). You can check the Output window to see the progress of starting the server. This also starts the Enterprise Server Console Daemon window which also provides information about the server start-up.

6. Execute the BANKDEMO application
    - To prepare for debugging in Eclipse, create a debug configuration by selecting "Debug Configurations..." from the "Run" menu.
    - On the Debug Configurations dialog, right-click on "PL/I Enterprise Server" and select "New".
    - Change the "Name:" from "New_configuration" to something meaningful like "BANK", enter "Local" for "Connection", enter "BANKDEMO" for "Server", click the "Apply" button, and click the "Debug" button.
    - Open a 3270 emulation program like Micro Focus Rumba and connect to "localhost" or "127.0.0.1" on port "9023".
    - If using "Micro Focus Rumba+ Desktop" you can do this by first selecting "Mainframe Display" then selecting "Connection" > "Configure...". Select "TN3270" from "Installed Interfaces", in the "TN3270" tab insert "127.0.0.1" and set the "Telnet Port" to "User Defined" and enter 9023, finally click "Connect".
    - If a dialog asking whether to automatically switch to the debug perspective is displayed, select "Remember my decision" and click &lt;Yes&gt;.
    - From the debug perspective, the source file "SBANK00P.PLI" should automatically display with the SBANK00P PROC line highlighted as the current line of execution.
    - If line numbers are not turned on in the source window, right-click in the left-hand column of the source pane and select "Show Line Numbers".
    - At this point, feel free to step through the SBANK00P program, set breakpoints, and evaluate variables.  Once you're ready to run the program to completion, select "Resume"/&lt;F8&gt; as many times as necessary to run the program to completion.
    - In the 3270 window, type a User id of "b0001", anything for the password and press &lt;Enter&gt;.
    - Eclipse debugging will be started again so you can debug through the SBANK10P program.          
    - Once you're ready to run the program to completion, select "Resume"/&lt;F8&gt; as many times as necessary to run the program to completion.          
    - As this application is psuedo-conversational, debugging will start and end with the invocation and completion of each transaction in the application.  Since this is a small demo, all of the CICS programs after the Banking main options screen are not built for debug and the sources are not provided.
    - Once you're ready to leave the application, press the &lt;F3&gt; key to end the application in the 3270 window.
    - You can now disconnect your 3270 terminal to end the demo.

7. Stop the Enterprise Server
    - Now that you have finished running the CICS demo, you can stop the associated the enterprise server. To do this, on the "Server Explorer" tab right-click the "BANKDEMO" server, and click &lt;Stop&gt;.
    - Check the Output window for messages that the server has been stopped. A number of messages also appear in the "Enterprise Server Console Daemon" window before it closes down.