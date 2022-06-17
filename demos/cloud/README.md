## Cloud Enterprise Server Capabilities

The cloud capabilities demonstration is an extension of the on-premise demonstration but does not require a Micro Focus product installation as 
this will occur as part of the cloud deployment. The cloud deployment is performed using Terraform.  
The capabilities and characteristics of the application of the Bankdemo application can be configured by editting the file scripts/config/demo.json 
- Open a command-prompt or terminal
- Change to the `terraform` directory
- Change to the sub-directory for you cloud provider and target operating system - e.g. `cd gcp-windows`
- Run the `apply` script e.g. `apply.bat` or `apply.sh`