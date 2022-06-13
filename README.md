# Micro Focus Bankdemo Application
This project provides tutorials and demonstrations of features in Micro Focus Enterprise Server and Enterprise Developer products.
To use these materials simply download the assets of the project [release](https://github.com/MicroFocus/BankDemo/releases) that matches the version of the Micro Focus product you 
will be using and follow the appropriate READMEs.

## Contents

1. [Introduction](#intro)
1. [License](#license)
1. [Using The Bankdemo Application](#using)
    1. [Enterprise Developer Introductory Tutorial](#tutorial)
    1. [On Premise Enterprise Server Capabilities](#onprem)


## <a name="intro"></a>Introduction

The Micro Focus Bankdemo application is a very simplified mainframe "green screen" banking application which runs under Micro Focus 
Enterprise Server. The materials in this project provide demonstrations or tutorials of various ways of configuring or modifying the application
to suit differing requirements which could then be used as a template for running and configuring your own application.

The project can be used to demonstrate a selection of the capabilities of Micro Focus Enterprise Server and these options will be extended over time. 
The project can be used to demonstrate applications running both on-premise and in cloud deployments and also includes introductory tutorials for the use of
the Micro Focus Enterprise Developer for Eclipse and Visual Studio integrated development environments.

In the simplest configuration it demonstrates a CICS/JCL COBOL application accessing banking data held in indexed (VSAM) files on disk but it can also be configured
to access data using EXEC SQL from a PostgreSQL database and database hosted VSAM files using the Micro Focus Database File Handler (or MFDBFH for short) again using PostgreSQL database server. Further planned demonstrations will show more complex deployments such as those involving scale-out and cloud deployments.

## <a name="license"></a>License

Copyright (C) 2010-2022 Micro Focus.  All Rights Reserved.
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
To use the project just download the source.zip or source.tar.gz from the [release](https://github.com/MicroFocus/BankDemo/releases) matching the Micro Focus product version you wish to use and follow the relevant instructions. The project can be used in three ways:
1. <a name="tutorial"></a> As the basis of the introductory tutorials for the Micro Focus Enterprise Developer for Eclipse and Visual Studio integrated development environments.
    - Prerequisites software: 
        - Enterprise Developer for Eclipse or Enterprise Developer for Visual Studio
    - Available tutorials:
        - [Getting Started with Enterprise Developer for Eclipse](tutorial/gettingstarted/eclipse/README.md)
        - [Getting Started with Enterprise Developer for Visual Studio](tutorial/gettingstarted/visualstudio/README.md)
        - [Open PL/I Development using Enterprise Developer for Eclipse](tutorial/gettingstarted/eclipse/PLIDemo.md)
        - [Open PL/I Development using Enterprise Developer for Visual Studio](tutorial/gettingstarted/visualstudio/PLIDemo.md)
    - Prerequisites: 
        - Micro Focus Directory Server (mfds) is running
        - Micro Focus Common Web Administration (escwa) is running

2. <a name="onprem"></a> Demonstrations of Micro Focus Enterprise Server capabilities "on-premise"
    - Prerequisite software: 
        - Enterprise Server or Enterprise Developer on Microsoft Windows or supported Linux distribution
        - Python 3 with `requests psycopg2-binary` packages (e.g. `python -m pip install requests psycopg2-binary`)
        - See specific demonstration instructions for any additional requirements
    - Available demonstrations:
        - [Deploying and running Bankdemo with VSAM data](demos/onprem/vsam/README.md) 
        - [Deploying and running Bankdemo with PostgreSQL](demos/onprem/psql/README.md) 
        - [Deploying and running Bankdemo with VSAM stored in PostgreSQL using MFDBFH](demos/onprem/psqlmfdbfh/README.md) 
    - Prerequisites: 
        - Micro Focus Directory Server (mfds) is running
        - Micro Focus Common Web Administration (escwa) is running and listening on the default localhost port 10086
