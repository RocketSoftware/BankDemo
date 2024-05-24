# Open PL/I Development using Enterprise Developer for Visual Studio 2022
## Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [How to Run this Demonstration](#how-to-run-the-demonstration)


## Overview
This demonstration shows how you can compile, link, and debug an Open PL/I BANK CICS application using the Visual Studio IDE. The instructions assume you already have a basic understanding of how to use Visual Studio.

## Prerequisites

This demonstration requires:
- Micro Focus Enterprise Developer for Visual Studio 2022. [*Click here*](https://www.microfocus.com/documentation/enterprise-developer/) to access the product Help and the release notes of Enterprise Developer.
- A TN3270 terminal emulator to run the CICS application. 

**Note:**
A license for Micro Focus Host Access for the Cloud (HACloud) TN3270 emulator is included with Enterprise Developer. 

## How to Run the Demonstration
### Import the supplied Bankdemo enterprise server:
  
**Note:**
If you have already imported the BANKDEMO enterprise server as part of the "[Getting started with Micro Focus Enterprise Developer for Visual Studio 2022](..\README.md)" tutorial, you can skip these steps.
    
1. Execute the `tutorial\createdefinition.ps1` PowerShell script to create the **BANKDEMO.xml** region definition file. 
    
2. In  Visual Studio, open Server Explorer, right-click **Local**, and click **Import**. 
    
3. Click **Import server definition file**, and select the **tutorial\BANKDEMO.xml** file, then click **OK**.
    
   The BANKDEMO server should appear in Server Explorer under **Local**.

### Start the HACloud session server

You must start the HACloud session server before attempting to use the HACloud TN3270 terminal emulator. To do this you need to start the respective Windows service.

1. Ensure you have a 64-bit Java installed and added to the PATH environment variable.
2. Open the Windows Service Manager.
3. Go to **Micro Focus HA Cloud** and click **Start the service**. 
4. Alternatively, you can start the session by opening a command prompt as administrator and executing the following command:

    ```
    net start mfhacloud
    ```


### Configure the BANKDEMO enterprise server for PL/I:
    
1. In Visual Studio, in Server Explorer, right-click **Micro Focus Servers**, and then click **Administration**.
     This opens the Home page of **Enterprise Server Common Web Administration** (ESCWA for short) in a browser outside of the IDE.
2. On the Home page of ESCWA, click **Native** in the top taskbar.
3. On the **Native** tab, expand **Directory Servers >  Default**, and the click **BANKDEMO**.
4. On the **General** page of the server, note that the **PL/I enabled** checkbox is already enabled.
5. From the **CICS** drop-down list, select **Configuration**.
6. Change **System Initialization Table** from **CBLVSAM** to **PLIVSAM**, and click **Apply**. 
    This configures the server to use some PL/I CICS resources (BMS maps and programs).

### Build the application:</description>

1. In Visual Studio:
     a.  Click **File > Open > Project/Solution**.
     b.  Navigate to the `tutorial\projects\Studio\pli` folder.
     c.  Select **bankdemo.sln**, and then click **Open**.
2. Check the project's active configuration:
    a.  Right-click the **bankdemo** solution in Solution Explorer.
    b.  Click **Properties > Configuration Properties**, and then click  **Configuration**. 
        Currently, this demo is designed to run only in 64-bit mode. If you make any changes to the default configuration or platform that you want to keep, click **OK** to close the dialog box.  
3. Click **Build > Build Solution**.
4. Check the **Output** window near the bottom of the IDE to verify that the solution has built successfully. The last line in the log typically looks like this: 
    ```
        "========== Build: 3 succeeded, 0 failed, 0 skipped =========="
    ```

### Associate the projects with the enterprise server region:

1. In Visual Studio, right-click **BANKDEMO** in Server Explorer, click **Associate with Project**, and select **bankmain**.

2. Repeat the step above for the **fetchables** project.

    Making these associations enables the server to use the executables built by the projects.

### Start the enterprise server: BANKDEMO

1.  In Server Explorer, right-click **BANKDEMO**, and click **Start**.
2.  Click **OK** in the **Enterprise Server Sign On** dialog box, and leave the fields blank.
3.  Check the **Output** window to see the progress of starting the server.
    Starting the server also launches the **Enterprise Server Console Daemon** window which also provides information about the server start-up.

### Execute the CICS application: bankmain

1.   To start debugging in Visual Studio, press **F5** to put the IDE in wait mode for the BANK application to start.
2.  Open a TN3270 emulation program like Micro Focus Host Access for the Cloud, and connect to **localhost** (or **127.0.0.1**) on port **9023**.
3.  Visual Studio should automatically open the `SBANK00P.PLI` source file with the **SBANK00P PROC** line highlighted as the current line of execution.
4.  Next, you can step through the SBANK00P program, set any breakpoints, and evaluate variables.  
5.  Once you are ready to run the program to completion, click **F5** (Resume) as many times as necessary to run the program to completion.
6.  In the TN3270 window, type a User id of **b0001** and any string for the password, and press **Enter**.

    Visual Studio debugging starts again so you can debug through the SBANK10P program.         
7. Once you are ready to run the program to completion, click **F5** (Resume) as many times as necessary to run the program to completion.         
  
    As this application is psuedo-conversational, debugging will start and end with the invocation and completion of each transaction in the application.  Since this is a small demo, all of the CICS programs after the Banking main options screen are not built for debug and the sources are not provided.
8.  Once you are ready to leave the application, press **F3** to end the application in the TN3270 window.          
9.  You can now disconnect your TN3270 terminal to end the demo.          

### Stop the BANKDEMO enterprise server

Now that you have finished running the CICS demo, you can stop the associated the BANKDEMO enterprise server. To do this:
 
1.  In Server Explorer, right-click the **BANKDEMO** server, and click **Stop**.
2.  Check the **Output** window for messages that the server has been stopped. A number of messages also appear in the **Enterprise Server Console Daemon** window outside of Visual Studio before it closes down.
