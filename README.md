# Micro Focus Bankdemo Application
This project provides tutorials and demonstrations of features in the Micro Focus Enterprise Developer and Enterprise Server products.
To use these materials, download the assets of the project [release](https://github.com/MicroFocus/BankDemo/releases) that matches the version of the Micro Focus product you will be using. Check and follow the appropriate READMEs for instructions.

## Contents

1. [Introduction](#intro)
1. [License](#license)
1. [Using The Bankdemo Application](#using)
    1. [Enterprise Developer Introductory Tutorial](#tutorial)
    1. [On Premise Enterprise Server Capabilities](#onprem)


## <a name="intro"></a>Introduction

The Micro Focus Bankdemo application is a simplified mainframe "green screen" banking application which runs under Micro Focus 
Enterprise Server. This project provides demonstrations and tutorials of various ways you can configure or modify the application
to suit differing requirements which could then be used as a template for running and configuring your own application.

The project demonstrates a selection of the capabilities of Micro Focus Enterprise Server and these options will be extended over time. 
It demonstrates applications running on-premise and also includes introductory tutorials for the use of
the Micro Focus Enterprise Developer for Eclipse and Visual Studio integrated development environments.

In the simplest configuration, it demonstrates a CICS/JCL COBOL application that accesses banking data held in indexed (VSAM) files on disk. However, it can also be configured to access data from a PostgreSQL database and database hosted VSAM files using the Micro Focus Database File Handler (or MFDBFH for short). Micro Focus will be adding further demonstrations in the future to show more complex deployments such as those involving scale-out and cloud deployments.

## <a name="license"></a>License

Copyright &copy; 2010-2022 Micro Focus.  All Rights Reserved.
This software may be used, modified, and distributed 
(provided this notice is included without modification)
solely for internal demonstration purposes with other 
Micro Focus software, and is otherwise subject to the EULA at
https://www.microfocus.com/en-us/legal/software-licensing.

THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED 
WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,
SHALL NOT APPLY.
TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL 
MICRO FOCUS HAVE ANY LIABILITY WHATSOEVER IN CONNECTION
WITH THIS SOFTWARE.

## <a name="using"></a>Using The Bankdemo Application
To use the project, download the **source.zip** or **source.tar.gz** from the [release](https://github.com/MicroFocus/BankDemo/releases) that matches the Micro Focus product version you want to use, then follow the relevant readme instructions. You can use the project in one of the following ways:
1. <a name="tutorial"></a> As the basis of the introductory tutorials for the Micro Focus Enterprise Developer for Eclipse and Visual Studio integrated development environments.
    - Prerequisite software: 
        - Micro Focus Enterprise Developer for Eclipse or Micro Focus Enterprise Developer for Visual Studio 2022
    - Available tutorials:
        - [Getting Started with Enterprise Developer for Eclipse (Windows)](tutorial/gettingstarted/eclipse/README.md)
        - [Getting Started with Enterprise Developer for Eclipse (Linux)](tutorial/gettingstarted/eclipseux/readme.md)
        - [Getting Started with Enterprise Developer for Visual Studio](tutorial/gettingstarted/visualstudio/readme.md)
        - [Open PL/I Bankdemo Application in Enterprise Developer for Eclipse](tutorial/gettingstarted/eclipse/PLIDemo.md)
        - [Open PL/I Bankdemo Application in Enterprise Development for Visual Studio](tutorial/gettingstarted/visualstudio/PLIDemo.md)
    - Requirements: 
        - The Micro Focus Directory Server (mfds) service must be running
        - Micro Focus Common Web Administration (ESCWA) must be running and listening on the default localhost port - 10086.

2. <a name="onprem"></a> Demonstrations of the Micro Focus Enterprise Server capabilities in "on-premise" scenarios:
    - Prerequisite software: 
        - Micro Focus Enterprise Server or Enterprise Developer on Windows or on a supported Linux distribution.
        - Python 3 with the `requests psycopg2-binary` packages (use the following command to install the packages: `python -m pip install requests psycopg2-binary`)
        - Check the tutorial or demonstration instruction for any additional requirements
    - Available demonstrations:
        - [Deploying and running Bankdemo with VSAM data](demos/onprem/vsam/README.md) 
        - [Deploying and running Bankdemo with Postgres SQL](demos/onprem/psql/README.md) 
        - [Deploying and running Bankdemo with VSAM stored in Postgres SQL using MFDBFH](demos/onprem/psqlmfdbfh/README.md) 
    - Requirements: 
        - The Micro Focus Directory Server (mfds) service must be running
        - Micro Focus Common Web Administration (ESCWA) must be running and listening on the default localhost port - 10086.

Use the **Issues** tab to report issues, or to raise questions.
