
# Open PL/I Development using Enterprise Developer for Visual Studio
## Contents
- Overview[](#overview)
- Prerequisites[](#prerequisites)
- How to Run this Demonstration[](#how-to-run-the-demonstration)
- Project Description[]()
## Overview
This demonstration shows how you can compile, link, and debug an Open PL/I BANK CICS application using the Visual Studio IDE. The instructions assume you already have a basic understanding of how to use Visual Studio.

## Prerequisites

This demonstration requires:
- Micro Focus Enterprise Developer for Visual Studio 2022
- A TN3270 terminal emulator to run the CICS application. 

  **Note**: A license for Micro Focus Rumba+ Desktop is included with Enterprise Developer. If you do not have Rumba+ Desktop installed, please refer to the Micro Focus Web site.

## How to Run the Demonstration
### 1. Import the supplied enterprise server:
  
1. If you have already imported the enterprise server for the IDE Getting Started tutorial you scan skip these steps
    
2. Run the tutorial\createdefinition.ps1 Powershell script to create the BANKDEMO.xml region definition file. 
    
3. In the "Server Explorer" tab, right-click on "Local" and select "Import...". 
    
4. Click the "Import server definition file" &lt;...&gt; button and select the tutorial\BANKDEMO.xml file. Then click &lt;OK&gt;
    
5. The BANKDEMO server should appear in Server Explorer under "Local"

### 2. Build the application:</description>
    - In Visual Studio, click "File"->"Open"->"Project/Solution", navigate to "tutorial\projects\Studio\pli", select bankdemo.sln, and click Open.
    - Ensure that your active configuration is "x64" for 64-bit by right-clicking on the "bankdemo" solution in the "Solution Explorer", select "Properties", select "Configuration Properties" and "Configuration".  The default configuration and platform can then be set and click "OK" to close the dialog.  Currently, this demo is designed to run only in 64-bit mode.
    - Click "Build"->"Build Solution" to build the solution.
    - Check the "Output" window near the bottom of the IDE to verify that the solution built successfully. The last line in the log typically looks like this: "========== Build: 3 succeeded, 0 failed, 0 skipped =========="

3. Configure the enterprise server for PL/I:
    - In the Visual Studio IDE, in "Server Explorer" (available with \<CTL\>+\<ALT\>+S), right-click "Micro Focus Servers", and click "Administration". This opens the Home page of "Enterprise Server Administration" in the IDE.     
    - On the Home page of the "Enterprise Server Administration", select "NATIVE" on the top toolbar. 
    - On the NATIVE page, expand "Directory Servers" and expand "Default" and select "BANKDEMO"
    - On the General page, note that the "PL/I enabled" checkbox is already selected
    - Click on the "CICS" dropdown and select "Configuration".
    - Change the "System Initialization Table" from "CBLVSAM" to "PLIVSAM" and click &lt;Apply&gt;. This configures the server to use some PL/I CICS resources (BMS maps and programs)
      
4. Associate the projects with enterprise server:
    - Visual Studio IDE, in "Server Explorer", right-click the "BANKDEMO" server and select "Associate with Project" and select "bankmain", then repeat the process and select "fetchables". Making these associations
      before starting the server enables the executables built by the projects are used.

5. Start the enterprise server:</description>
    - In "Server Explorer", right-click the "BANKDEMO" server and click "Start".  If the name does not appear in the list, you may need to refresh the list by right-clicking on "Micro Focus Servers" and selecting "Refresh".
    - Click OK in the "Enterprise Server Sign On" dialog (you can leave the fields blank). You can check the "Output" window to see the progress of starting the server. This also starts the "Enterprise Server Console Daemon" window which also provides information about the server start-up.

6. Execute the CICS application</description>
    - To start debugging in Visual Studio, press &lt;F5&gt; to put the IDE in wait mode for the BANK application to start.
    - If a 3270 window doesn't open automatically, open a 3270 emulation program like Micro Focus Rumba and connect to "localhost" or "127.0.0.1" on port "9023".
    - If using "Micro Focus Rumba+ Desktop" you can do this by first selecting "Mainframe Display" then selecting "Connection" > "Configure...". Select "TN3270" from "Installed Interfaces", in the "TN3270" tab insert "127.0.0.1" and set the "Telnet Port" to "User Defined" and enter 9023, finally click "Connect".
    - In Visual Studio, the source file "SBANK00P.PLI" should automatically display with the SBANK00P PROC line highlighted as the current line of execution.
    - At this point, feel free to step through the SBANK00P program, set breakpoints, and evaluate variables.  Once you're ready to run the program to completion, select "Resume"/&lt;F5&gt; as many times as necessary to run the program to completion.
    - In the 3270 window, type a User id of "b0001", anything for the password and press &lt;Enter&gt;.
    - Visual Studio debugging will be started again so you can debug through the SBANK10P program.          
    - Once you're ready to run the program to completion, select "Resume"/&lt;F5&gt; as many times as necessary to run the program to completion.          
    - As this application is psuedo-conversational, debugging will start and end with the invocation and completion of each transaction in the application.  Since this is a small demo, all of the CICS programs after the Banking main options screen are not built for debug and the sources are not provided.
    - Once you're ready to leave the application, press the &lt;F3&gt; key to end the application in the 3270 window.          
    - You can now disconnect your 3270 terminal to end the demo.          

7. Stop the Enterprise Server</description>
    - Now that you have finished running the CICS demo, you can stop the associated the enterprise server. To do this, in "Server Explorer", right-click the "BANKDEMO" server, and click "Stop".
    - Check the "Output" window for messages that the server has been stopped. A number of messages also appear in the "Enterprise Server Console Daemon" window before it closes down.

