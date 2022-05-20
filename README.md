# Micro Focus Bankdemo Application
This project provides tutorials and demonstrations of features in Micro Focus Enterprise Server and Enterprise Developer products.
To use these materials simply download the assets of the project [release](https://github.com/MicroFocus/BankDemo/releases) that matches the version of the Micro Focus product you 
will be using and follow the appropriate READMEs.

## Contents

1. [Introduction](#intro)
1. [License](#license)
1. [Using The Bankdemo Application](#using)
    1. Enterprise Developer Introductory Tutorial
    1. On Premise Enterprise Server Capabilities
    1. Cloud Enterprise Server Capabilities
1. Cloud Enterprise Server Capabilities
1. [Prerequisites when using the project on-premise](#onpremprereq)
1. [Prerequisites when using the project for cloud deployment](#cloudrereq)

## <a name="intro"></a>Introduction

The Micro Focus Bankdemo application is a very simplified mainframe "green screen" banking application which runs under Micro Focus 
Enterprise Server. The materials in this project provide demonstrations or tutorials of various ways of configuring or modifying the application
to suit differing requirements which could then be used as a template for running and configuring your own application.

The project can be used to demonstrate a selection of the capabilities of Micro Focus Enterprise Server and these options will be extended over time. 
The project can be used to demonstrate applications running both on-premise and in cloud deployments and also includes introductory tutorials for the use of
the Micro Focus Enterprise Developer for Eclipse and Visual Studio integrated development environments.

In the simplest configuration it demonstrates a CICS COBOL application accessing banking data held in indexed (VSAM) files on disk but it can also be configured
to access data from a Postgres SQL database and further planned demonstrations will show more complex deployments such as those involving scale-out and database hosted VSAM files using MFDBFH.

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
1. As the basis of the introductory tutorials for the Micro Focus Enterprise Developer for Eclipse and Visual Studio integrated development environments.
    - Prerequisites software: 
        - Enterprise Developer for Eclipse or Enterprise Developer for Visual Studio
    - Available tutorials:
        - [Getting Started with Enterprise Developer for Eclipse](tutorial/gettingstarted/eclipse/README.md)
        - [Getting Started with Enterprise Developer for Visual Studio](tutorial/gettingstarted/visualstudio/README.md)
    - Prerequisites: 
        - Micro Focus Directory Server (mfds) is running
        - Micro Focus Common Web Administration (escwa) is running

2. Demonstrations of Micro Focus Enterprise Server capabilities "on-premise"
    - Prerequisite software: 
        - Enterprise Server or Enterprise Developer
        - Python 3 with `requests psycopg2-binary` packages (e.g. `python -m pip install requests psycopg2-binary`)
        - See specific demonstration instructions for any additional requirements
    - Available demonstrations:
        - [Deploying and running Bankdemo with VSAM data](demos/onprem/vsam/README.md) 
        - [Deploying and running Bankdemo with Postgres SQL](demos/onprem/psql/README.md) 
    - Prerequisites: 
        - Micro Focus Directory Server (mfds) is running
        - Micro Focus Common Web Administration (escwa) is running and listening on the default localhost port 10086

3. Cloud deployment of Micro Focus Enterprise Server capabilities
    - Prerequisites: 
        - [Hashicorp Terraform](https://www.terraform.io/)
        - Account with a supported cloud provider, currently:
            - [Google Cloud](https://cloud.google.com)
        - Cloud provider's CLI
        - Micro Focus Enterprise Server License







## <a name="onpremprereq"></a>Prerequisites when using the project on-premise
Unless being used in cloud deployment, the application requires the installation of one of the Micro Focus Enterprise Developer or Enterprise Server 
version 8.0 or later products. 
Be sure to use the release of this sample application that matches the version of the product you have installed as capabilities are being 
constantly added to the products so later releases may not work with your installed product.

The sample can be used on either Microsoft Windows or one of the Linux platforms supported by Micro Focus Enterprise Server and the repository 
contains suitable pre-built binaries for use with Enterprise Server, but where Enterprise Developer is installed that product can be used 
to build the application for deployment.

Except when used for the Enterprise Developer introductory tutorials, the sample also requires the installation Python 3 (to configure and
run the demonstration), depending on the configuration being deployed there may be additional pre-requisites such as a database 
(the documentation for each demonstration lists any additional pre-requisites).

## <a name="cloudrereq"></a>Prerequisites when using the project for cloud deployments
When using the project to deploy into a cloud environment there is a prerequisite on [Hashicorp Terraform](https://www.terraform.io/) 
and you will also need an account with the cloud provider. 
Micro Focus Enterprise Server can be used with many more cloud providers than can be demonstrated
by this project, so far demonstrations have been created for: Google Cloud Platform, but in  
[Amazon AWS](https://github.com/aws-quickstart/quickstart-microfocus-amc-es) and [Azure](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/micro-focus.mfes?tab=Overview) you can find "Quick Start" demonstrations which are also based on the Bankdemo application.


