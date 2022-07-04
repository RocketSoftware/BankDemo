# Open PL/I Development using Enterprise Developer for Visual Studio 2022
## Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [How to Run this Demonstration](#how-to-run-the-demonstration)


## Overview
This demonstration shows how you can compile, link, and debug an Open PL/I BANK CICS application using the Visual Studio IDE. The instructions assume you already have a basic understanding of how to use Visual Studio.

## Prerequisites

This demonstration requires:
- Micro Focus Enterprise Developer for Visual Studio 2022
- A TN3270 terminal emulator to run the CICS application. 

  **Note**: Licenses for Micro Focus Rumba+ Desktop and the  HACloud Session Server TN3270 emulator are included with Enterprise Developer. If you do not have Rumba+ Desktop installed, please refer to the Micro Focus Web site.

## How to Run the Demonstration
### 1. Import the supplied Bankdemo enterprise server:
  
**Note:** If you have already imported the Bankdemo enterprise server as part of the "[Getting started with Micro Focus Enterprise Developer for Visual Studio 2022](..\cobol\README.md)" tutorial, you scan skip these steps.
    
1. Execute the `tutorial\createdefinition.ps1` PowerShell script to create the **BANKDEMO.xml** region definition file. 
    
2. In  Visual Studio, open Server Explorer, right-click **Local**, and click **Import**. 
    
3. Click **Import server definition file**, and select the **tutorial\BANKDEMO.xml** file, then click **OK**.
    
   The BANKDEMO server should appear in Server Explorer under **Local**.


### 2. Configure the BANKDEMO enterprise server for PL/I:
    
1. In Visual Studio, in Server Explorer, right-click **Micro Focus Servers**, and then click **Administration**. 
  
    This opens the Home page of **Enterprise Server Common Web Administration** (ESCWA for short) in a browser outside of the IDE.     
2. On the Home page of ESCWA, click **NATIVE** in the top taskbar. 
3. On the **NATIVE** tab, expand **Directory Servers**, expand **Default**, and click **BANKDEMO**.
4. On the **General** page of the server, note that the **PL/I enabled** checkbox is already enabled.
5. From the **CICS** drop-down list, select **Configuration**.
6. Change **System Initialization Table** from **CBLVSAM** to **PLIVSAM**, and click **Apply**. This configures the server to use some PL/I CICS resources (BMS maps and programs).

### 3. Build the application:</description>
    
1. In Visual Studio, click **File > Open > Project/Solution**, navigate to the `tutorial\projects\Studio\pli` folder, select **bankdemo.sln**, and click **Open**.
2. Check the project's active configuration - right-click the **bankdemo** solution in Solution Explorer, click **Properties > Configuration Properties**, then click  **Configuration**. Currently, this demo is designed to run only in 64-bit mode. If you make any changes to the default configuration or platform that you want to keep, click **OK** to close the dialog.  
3. Click **Build > Build Solution**.
4. Check the **Output** window near the bottom of the IDE to verify that the solution has built successfully. The last line in the log typically looks like this: 
    ```
    "========== Build: 3 succeeded, 0 failed, 0 skipped =========="
    ```


      
### 4. Associate the projects with enterprise server:
1. In Visual Studio, right-click BANKDEMO in Server Explorer, click **Associate with Project**, and select **bankmain**.

2. Repeat the step above for the **fetchables** project. 

    Making these associations, enables the server to use the executables built by the projects.

### 5. Start the enterprise server:</description>
1. In Server Explorer, right-click **BANKDEMO**, and click **Start**.

2.  Click **OK** in the **Enterprise Server Sign On** dialog box - you can leave the fields blank. 
3. Check the **Output** window to see the progress of starting the server. 
  Starting the server also launches the **Enterprise Server Console Daemon** window which also provides information about the server start-up.

### 6. Execute the CICS application</description>

1. To start debugging in Visual Studio, press **F5** to put the IDE in wait mode for the BANK application to start.
2. If a 3270 window does not open automatically, open a 3270 emulation program such as Micro Focus Rumba Desktop, and connect to **localhost** or **127.0.0.1**) on port **9023**.

    If using Micro Focus Rumba+ Desktop:
    
    a. Click Mainframe Display, then click **Connection > Configure**. 
    
    b. Select **TN3270** from **Installed Interfaces**.
    
    c. On the **TN3270** tab, type **127.0.0.1**.
    
    d. Set **Telnet Port** to **User Defined**, and type **9023**.
    
    e. Click **Connect**.
4. Visual Studio should automatically open the `SBANK00P.PLI` source file with the **SBANK00P PROC** line highlighted as the current line of execution.
5. Next, you can step through the SBANK00P program, set any breakpoints, and evaluate variables.  
6. Once you are ready to run the program to completion, click **F5** (Resume) as many times as necessary to run the program to completion.
7. In the TN3270 window, type a User id of **b0001** and any string for the password, and press **Enter**.

    Visual Studio debugging starts again so you can debug through the SBANK10P program.         

8. Once you are ready to run the program to completion, click **F5** (Resume) as many times as necessary to run the program to completion.         
  
    As this application is psuedo-conversational, debugging will start and end with the invocation and completion of each transaction in the application.  Since this is a small demo, all of the CICS programs after the Banking main options screen are not built for debug and the sources are not provided.
10. Once you are ready to leave the application, press **F3** to end the application in the TN3270 window.          
11. You can now disconnect your TN3270 terminal to end the demo.          

### 7. Stop the BANKDEMO enterprise server

Now that you have finished running the CICS demo, you can stop the associated the BANKDEMO enterprise server. To do this:
 
1. In Server Explorer, right-click the **BANKDEMO** server, and click **Stop**.
2. Check the **Output** window for messages that the server has been stopped. A number of messages also appear in the **Enterprise Server Console Daemon** window outside of Visual Studio before it closes down.
