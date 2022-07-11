#!/usr/bin/python3

"""
Copyright (C) 2010-2021 Micro Focus.  All Rights Reserved.
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

Description:  A script to create a Micro Focus server region. 
"""

import os
import sys
import glob


from utilities.misc import parse_args, set_MF_environment, get_EclipsePluginsDir, get_CobdirAntDir
from utilities.input import read_json, read_txt
from utilities.output import write_json, write_log 
from utilities.filesystem import create_new_system, deploy_application, deploy_system_modules, deploy_vsam_data, deploy_partitioned_data, dbfhdeploy_vsam_data

from ESCWA.mfds_config import add_mfds_to_list, check_mfds_list
from ESCWA.region_control import add_region, start_region, del_region, confirm_region_status, stop_region
from ESCWA.region_config import update_region, update_region_attribute, update_alias, add_initiator, add_datasets
from ESCWA.comm_control import set_jes_listener
from ESCWA.pac_config import add_sor, add_pac
from utilities.exceptions import ESCWAException
from ESCWA.resourcedef import  add_sit, add_Startup_list, add_groups, add_fct, add_ppt, add_pct, update_sit_in_use
from ESCWA.xarm import add_xa_rm
from ESCWA.mq_config import add_mq_listener
from build.MFBuild import  run_ant_file
from database.mfpostgres import  Connect_to_PG_server, Execute_PG_Command, Disconnect_from_PG_server

from pathlib import Path

import shutil
if not sys.platform.startswith('win32'):
    from pwd import getpwuid
    from os  import stat

def find_owner(filename):
    return getpwuid(stat(filename,follow_symlinks=False).st_uid).pw_name

def create_pac(config_dir, main_config, pac_config):
    psorType=pac_config["PSOR_type"] 
    psorConnection=pac_config["PSOR_connection"]
    ip_address = main_config["ip_address"]
    write_log ('PAC enabled. Setting up PAC.')
    #Add a PSOR then add the PAC
    addsor_config = os.path.join(config_dir, 'addsor.json')
    try:
        write_log ('PSOR \033[1m{}\033[0m being added'.format("psor1"))
        sor=add_sor("psor1", ip_address, "desc", psorType, psorConnection, addsor_config).json()
    except ESCWAException as exc:
        write_log('Unable to create PSOR.')
        write_log(exc)
        sys.exit(1)

    addpac_config = os.path.join(config_dir, 'addpac.json')
    try:
        write_log ('PAC \033[1m{}\033[0m being added'.format("pac1"))
        add_pac("pac1", ip_address, "desc", sor['Uid'], addpac_config)
    except ESCWAException as exc:
        write_log('Unable to create PAC.')
        write_log(exc)
        sys.exit(1)

def catalog_datasets(cwd, region_name, ip_address, configuration_files, dataset_key, mfdbfh_location):
    if  dataset_key in configuration_files:
        data_dir = configuration_files[dataset_key]
        dataset_dir = os.path.join(cwd, data_dir)
        datafile_list = [file for file in os.scandir(dataset_dir)]
    
        try:
            add_datasets(region_name, ip_address, datafile_list, mfdbfh_location)
        except ESCWAException as exc:
            write_log('Unable to catalog datasets in {}.'.format(dataset_dir))
            sys.exit(1)

def add_postgresxa(os_type, is64bit, region_name, ip_address, xa_config, database_connection):
    xa_detail = read_json(xa_config)
    if os_type == "Windows":
        xa_extension = '.dll'
        xa_bitism = ""
    else:
        xa_extension = ".so"
        if is64bit == True:
            xa_bitism = "64"
        else:
            xa_bitism = "32"
    xarm_module_version = 'ESPGSQLXA' + xa_bitism + xa_extension
    xa_module = '$ESP/loadlib/' + xarm_module_version
    xa_detail["mfXRMModule"] = xa_module
    xa_open_string = xa_detail["mfXRMOpenString"]
    write_log ('XA Resource Manager {} being added'.format(xa_module))
    add_xa_rm(region_name,ip_address,xa_detail)

    secret_open_string = '{},USRPASS={}.{}'.format(xa_open_string,database_connection['user'],database_connection['password'])
    return secret_open_string

def create_region(main_configfile):

    #set current working directory
    cwd = os.getcwd()
    
    #determine where the Micro Focus product has been installed
    if sys.platform.startswith('win32'):
        os_type = 'Windows'
        os_distribution =''
        install_dir = set_MF_environment (os_type)
        if install_dir is None:
            write_log('COBOL environment not found')
            exit(1)
        cobdir = str(Path(install_dir).parents[0])
        os.environ['COBDIR'] = cobdir
        pathMfAnt = Path(os.path.join(cobdir, 'bin', 'mfant.jar')) 
    else:
        os_type = 'Linux'
        os_distribution = '' #distro.id()
        install_dir = set_MF_environment (os_type)
        if install_dir is None:
            write_log('COBOL environment not set - run cobsetenv')
            exit(1)
        cobdir = str(Path(install_dir).parents[0])
        if cobdir == '':
            write_log('COBOL environment not set - run cobsetenv')
            exit(1)
        pathMfAnt = Path(os.path.join(cobdir,'lib', 'mfant.jar')) 

    write_log('COBDIR={}'.format(cobdir))
    write_log('Provision Process starting')
   
    config_dir = os.path.join(cwd, 'config')
    options_dir = os.path.join(cwd, 'options')

    #read demo configuration file
    write_log('Reading deployment config file {}'.format(main_configfile))
    main_config = read_json(main_configfile)

    #retrieve the demo configuration settings
    ip_address = main_config["ip_address"]
    region_name = main_config["region_name"]
    if main_config["product"] != '':
        mf_product = main_config["product"]
    else:
        mf_product = 'EDz'
    # Override if compiler is mfant.jar is not found
    if mf_product == 'EDz':
        if pathMfAnt.is_file() != True:
            mf_product = 'ES'
        elif "JAVA_HOME" not in os.environ:
            if os_type == 'Windows':
                pathJDK = Path(os.path.join(cobdir,'AdoptOpenJDK'))
                if pathJDK.is_dir():
                    os.environ["JAVA_HOME"] = str(pathJDK)
                    write_log('Using JAVA_HOME={}'.format(str(pathJDK)))
                else:
                    write_log('JAVA_HOME not set, cannot build application')
                    mf_product = 'ES'
            else:
                write_log('JAVA_HOME not set, cannot build application')
                mf_product = 'ES'

    write_log('Configured for product: {}'.format(mf_product))

    cics_region = main_config["CICS"]
    jes_region = main_config["JES"]
    mq_region = main_config["MQ"]

    is64bit = main_config["is64bit"]
    if os_type == 'Linux':
        path32 = Path(os.path.join(install_dir,'casstart32'))
        if path32.is_file() == False:
            # No 32bit executables
            is64bit = True;

    if 'database' not in main_config:
        database_type = 'none'
        dataversion = 'vsam'
    else:
        database_type= main_config["database"]
        sql_folder= os.path.join(cwd, 'config', 'database', database_type)
        if database_type.split('_')[0] == 'VSAM':
            dataversion = 'vsam'
        else:
            dataversion = 'sql'

    #determine te individual component configuration files to be used
    configuration_files = main_config["configuration_files"]

    #base_config is used for settings to create the base region definition
    base_config = configuration_files["base_config"]

    #update_config is used to amend the base settings for the region definition
    update_config = configuration_files["update_config"]

    #env_config is used to set the environment space details for the region
    env_config = configuration_files["env_config"]

    #alias_config and JES Alias updates that are region for a region - this setting is optional
    if 'alias_config' not in configuration_files:
        alias_config = 'none'
    else:
        alias_config = configuration_files["alias_config"]

    #init_config contains the details of any JES initiators that need to be configured - this settings is optional
    if 'init_config' not in configuration_files:
        init_config ='none'
    else:
        init_config = configuration_files["init_config"]

    #read the next usable port numbers when configuring the region 
    write_log('Reading ports configuration file')
    ports_config = os.path.join(config_dir, 'ports.json')

    port_details = read_json(ports_config)

    region_port = port_details['regionPort']
    jes_port = port_details['jesPort']

    #start the provision of the region
    parentdir = str(Path(cwd).parents[0])
    template_base = os.path.join(parentdir, 'system')
    sys_base = os.path.join(parentdir, region_name, 'system')

    create_new_system(template_base,sys_base)
    
    #create an empty resource definition file
    caspcrd = os.path.join(install_dir, 'caspcrd')
    rdef = os.path.join(sys_base, 'rdef')
    create_dfhdrdat =  '\"' +caspcrd + '\" /c /dp=' + rdef
    write_log ('Create resource definition file {}'.format(create_dfhdrdat))
    caspcrd_process = os.system(create_dfhdrdat)
    #change ownership to match ES user
    if os_type == 'Linux':
        casstart = os.path.join(os.environ['COBDIR'], 'bin', 'casstart')
        esuid = find_owner(casstart)
        dfhdrdat = os.path.join(rdef, 'dfhdrdat')
        shutil.chown(dfhdrdat, esuid, esuid)
        write_log ('Set owner of {} to {}'.format(dfhdrdat, esuid))
    else:
        esuid = ''

    # Update the mfdbfh.cfg file with the database user id
    if 'mfdbfh_config' in main_config:
        mfdbfh_config = os.path.join(sys_base, 'config', main_config['mfdbfh_config'])
        if 'database_connection' in main_config:
            database_connection = main_config['database_connection']

            # Set the user id mfdbfh.cfg
            f_in = open(mfdbfh_config, "rt")
            data = f_in.read()
            f_in.close()
            new_data = data.replace('$$user$$', database_connection['user'])
            f_out = open(mfdbfh_config, "wt")
            f_out.write(new_data)
            f_out.close()

    
    base_config = os.path.join(config_dir, base_config)
    update_config = os.path.join(config_dir, update_config)
    alias_config = os.path.join(config_dir, alias_config)
    init_config = os.path.join(config_dir, init_config)
    env_config = os.path.join(config_dir, env_config)
    resourcedef_dir = os.path.join(config_dir, 'CSD')

    pac_config = main_config["PAC"]
    pac_enabled=pac_config["enabled"]
    if pac_enabled == True:
        create_pac(config_dir, main_config, pac_config)
    else:
        write_log('Not using PAC.')
        
    try:
        write_log ('Region \033[1m{}\033[0m being added'.format(region_name))
        add_region(region_name, ip_address, region_port, base_config, is64bit)
    except ESCWAException as exc:
        write_log('Unable to create region.')
        write_log(exc)
        sys.exit(1)

    try:
        write_log ('Region {} being updated with requested settings'.format(region_name))
        update_region(region_name, ip_address, update_config, env_config, 'Test Region', sys_base)
    except ESCWAException as exc:
        write_log('Unable to update region.')
        write_log(exc)
        sys.exit(1)

    try:
        write_log ('Web Services and J2EE listener port set to {}'.format(jes_port))
        set_jes_listener(region_name, ip_address, jes_port)
    except ESCWAException as exc:
        write_log('Unable to set JES listener.')
        write_log(exc)
        sys.exit(1)

    try:
        write_log('Region {} being started before further configuration'.format(region_name))
        start_region(region_name, ip_address)
    except ESCWAException as exc:
        write_log('Unable to start region.')
        write_log(exc)
        sys.exit(1)

    try:
        write_log('Checking region {} start succesfully'.format(region_name))
        confirmed = confirm_region_status(region_name, ip_address, 1, 'Started')
    except ESCWAException as exc:
        write_log('Unable to check region status.')
        write_log(exc)
        sys.exit(1)

    if not confirmed:
        write_log('Region Failed to start. Environment being rewound')

        del_res = del_region(region_name, ip_address)

        if del_res.status_code == 204:
            write_log('Environment cleaned successfully')
        
        sys.exit(1)
    else:
        write_log('Region {} started succedsfully'.format(region_name))
    
    if  alias_config != 'none':
        write_log ('JES Alias configuration found. Aliases being added')
        try:
            update_alias(region_name, ip_address, alias_config)
        except ESCWAException as exc:
            write_log('Unable to update aliases.')
            write_log(exc)
            sys.exit(1)

    if  init_config != 'none':
        write_log('JES initiator configuration found. Initiators being added')
        try:
            add_initiator(region_name, ip_address, init_config)
        except ESCWAException as exc:
            write_log('Unable to add initiator.')
            write_log(exc)
            sys.exit(1)

    #data_dir_1 hold the directory name, under the cwd that contains definitions of any datasets to be catalogued - this setting is optional
    catalog_datasets(cwd, region_name, ip_address, configuration_files, 'data_dir_1', None)

    ## The following code updates the CICS Resource Definitions

    rdef_startup = os.path.join(resourcedef_dir, 'rdef_startup.json')

    if os.path.isfile(rdef_startup):
        startup_details = read_json(rdef_startup)
        write_log('Adding Startup List {}'.format(startup_details["resNm"]))
        add_Startup_list(region_name,ip_address,startup_details)

    rdef_sit = os.path.join(resourcedef_dir, 'rdef_sit.json')

    if os.path.isfile(rdef_sit):
        sit_details = read_json(rdef_sit)
        new_sit_name = sit_details['resNm']
        write_log('Adding SIT {}'.format(sit_details["resNm"]))
        add_sit(region_name,ip_address,sit_details)

    rdef_group = os.path.join(resourcedef_dir, 'rdef_groups.json')

    if os.path.isfile(rdef_group):
            group_details = read_json(rdef_group)
            add_groups(region_name,ip_address,group_details)  
            
    #The FCT entries are only required if the VSAM version of the application is in use
    if dataversion == 'vsam':

        write_log ('VSAM version selected - FCT entries being added')
        fct_match_pattern = os.path.join(resourcedef_dir, 'rdef_fct_*.json')
        fct_filelist = glob.glob(fct_match_pattern)

        if fct_filelist != '':
            for filename in fct_filelist:
                fct_details = read_json(filename)
                groupx = filename.split('_')
                group_name = groupx[2].split('.')
                add_fct(region_name,ip_address,group_name[0], fct_details)
        else:
            write_log('fct match pattern failed')
    ppt_match_pattern = os.path.join(resourcedef_dir, 'rdef_ppt_*.json')
    ppt_filelist = glob.glob(ppt_match_pattern)

    if ppt_filelist != '':
       write_log ('CICS Resource PPT definitions found - being added') 
       for filename in ppt_filelist:
           ppt_details = read_json(filename)
           groupx = filename.split('_')
           group_name = groupx[2].split('.')
           add_ppt(region_name,ip_address,group_name[0], ppt_details)
    else:
        write_log('ppt match pattern failed')
    pct_match_pattern = os.path.join(resourcedef_dir, 'rdef_pct_*.json')
    pct_filelist = glob.glob(pct_match_pattern)

    if pct_filelist != '':
       write_log ('CICS Resource PCT definitions found - being added')  
       for filename in pct_filelist:
           pct_details = read_json(filename)
           groupx = filename.split('_')
           group_name = groupx[2].split('.')
           add_pct(region_name,ip_address,group_name[0], pct_details)
    else:
        write_log('pct match pattern failed')

    ## Update the SIT setting for this region

    if new_sit_name != '': 
        write_log ('SIT {} previously added - setting this as the default for region {}'.format(new_sit_name, region_name))
        update_sit_in_use(region_name, ip_address, new_sit_name)
        write_log ('Region restart now required')

   ## The following code adds MQ listeners as defined in mq.json

    if  main_config['MQ'] == True:
        write_log('Region requires MQ settings - being added')
        mq_config = os.path.join(config_dir, 'mq.json')

        mq_details = read_json(mq_config)

        mq_details["mfMQTrigger"] = 'MQ_Q_' + region_name
        mq_details["mfMQManager"] = 'MQ_QM_' + region_name

        try: 
            add_mq_listener(region_name, ip_address, mq_details)
        except ESCWAException as exc:
            print('Unable to add MQ Listener.')
            write_log(exc)
            sys.exit(1)
    
   ## The following code deploys the application

    if  database_type == 'SQL_Postgres':
        database_engine = 'Postgres'
        loadlibDir = 'SQL_Postgres'
        database_connection = main_config['database_connection']
        write_log ('Database type {} selected - database being built'.format(database_engine))
        if os_type == 'Windows':

            # windll.ODBCCP32.SQLConfigDataSource(0, 4, bytes('PostgreSQL ANSI', 'iso-8859-1'), bytes('DSN=bank\x00Database=bank\x00Servername={}\x00Port={}\x00Username={}\x00Password={}\x00\x00'.format(database_connection['server_name'],database_connection['server_port'],database_connection['user'],database_connection['password']), 'iso-8859-1'))
            if is64bit == True:
                odbcDriver = 'PostgreSQL ANSI(x64)'
                odbcconf = os.path.join(os.environ['windir'], 'system32', 'odbcconf.exe')
            else:
                odbcDriver = 'PostgreSQL ANSI'
                odbcconf = os.path.join(os.environ['windir'], 'syswow64', 'odbcconf.exe')
            createDSN = odbcconf + ' /a {CONFIGSYSDSN "' + '{}" "DSN=bank|Database=bank|Servername={}|Port={}|Username={}|Password={}'.format(odbcDriver, database_connection['server_name'],database_connection['server_port'],database_connection['user'],database_connection['password']) + '"}'
            write_log(createDSN)
            createDSN_process = os.system(createDSN)

        conn = Connect_to_PG_server(database_connection['server_name'],database_connection['server_port'],'postgres',database_connection['user'],database_connection['password'])
        sql_folder = os.path.join(cwd, 'config', 'database', database_engine) 
        sql_file = os.path.join(sql_folder, 'create.sql')
        sql_command = read_txt(sql_file)
        execute_res = Execute_PG_Command(conn, sql_command)
        dconn_res = Disconnect_from_PG_server(conn)
        conn = Connect_to_PG_server(database_connection['server_name'],database_connection['server_port'],'bank',database_connection['user'],database_connection['password'])
        sql_file = os.path.join(sql_folder, 'tables.sql')
        sql_command = read_txt(sql_file)
        execute_res = Execute_PG_Command(conn, sql_command)
        dconn_res = Disconnect_from_PG_server(conn)
        ## The following code adds XA resource managers as defined in xa.json

        xa_config = configuration_files["xa_config"]
        xa_config = os.path.join(config_dir, xa_config)
        xa_openstring = add_postgresxa(os_type, is64bit, region_name, ip_address, xa_config, database_connection)

        write_log("Adding XA switch configuration to vault")
        mfsecretsadmin = os.path.join(os.environ['COBDIR'], 'bin', 'mfsecretsadmin')
        secret = '"{}" write -overwrite Microfocus/XASW/DBPG/XAOpenString {}'.format(mfsecretsadmin, xa_openstring)
        secret_process = os.system(secret)

    else:
        loadlibDir = 'VSAM'
        if database_type == 'VSAM_Postgres':
            database_connection = main_config['database_connection']
            if os_type == 'Windows':

                # windll.ODBCCP32.SQLConfigDataSource(0, 4, bytes('PostgreSQL ODBC Driver(ANSI)', 'iso-8859-1'), bytes('DSN=bank\x00Database=bank\x00Servername={}\x00Port={}\x00Username={}\x00Password={}\x00\x00'.format(database_connection['server_name'],database_connection['server_port'],database_connection['user'],database_connection['password']), 'iso-8859-1'))
                if is64bit == True:
                    odbcDriver = 'PostgreSQL ODBC Driver(ANSI)'
                    odbcconf = os.path.join(os.environ['windir'], 'system32', 'odbcconf.exe')
                else:
                    odbcDriver = 'PostgreSQL ANSI'
                    odbcconf = os.path.join(os.environ['windir'], 'syswow64', 'odbcconf.exe')
                createDSN = odbcconf + ' /a {CONFIGSYSDSN "' + '{}" "DSN=BANKVSAM.MASTER|Database=postgres|Servername={}|Port={}|Username={}|Password={}'.format(odbcDriver, database_connection['server_name'],database_connection['server_port'],database_connection['user'],database_connection['password']) + '"}'
                write_log(createDSN)
                createDSN_process = os.system(createDSN)
                createDSN = odbcconf + ' /a {CONFIGSYSDSN "' + '{}" "DSN=BANKVSAM.VSAM|Database=BANK_ONEDB|Servername={}|Port={}|Username={}|Password={}'.format(odbcDriver, database_connection['server_name'],database_connection['server_port'],database_connection['user'],database_connection['password']) + '"}'
                write_log(createDSN)
                createDSN_process = os.system(createDSN)

            xa_config = configuration_files["xa_config"]
            xa_config = os.path.join(config_dir, xa_config)
            xa_openstring = add_postgresxa(os_type, is64bit, region_name, ip_address, xa_config, database_connection)

            write_log("Adding database password to vault for MFDBFH")
            mfsecretsadmin = os.path.join(os.environ['COBDIR'], 'bin', 'mfsecretsadmin')
            secret = '"{}" write -overwrite microfocus/mfdbfh/espacdatabase.bankvsam.master.password {}'.format(mfsecretsadmin, database_connection['password'])
            secret_process = os.system(secret)
            secret = '"{}" write -overwrite microfocus/mfdbfh/espacdatabase.bankvsam.vsam.password {}'.format(mfsecretsadmin, database_connection['password'])
            secret_process = os.system(secret)
            secret = '"{}" write -overwrite Microfocus/XASW/DBPG/XAOpenString {}'.format(mfsecretsadmin, xa_openstring)
            secret_process = os.system(secret)

            write_log ('MFDBFH version required - datasets being migrated to database')
            os.environ['MFDBFH_CONFIG'] = mfdbfh_config
            update_region_attribute(region_name, ip_address, {"mfCASTXFILEP": "sql://ESPacDatabase/VSAM?type=folder;folder=/data"})
            dbfhdeploy_vsam_data(parentdir, os_type, is64bit, "sql://ESPacDatabase/VSAM/{}?folder=/data")

            #data_dir_2 hold the directory name, under the cwd that contains definitions of any additional (e.g VSAM) datasets to be catalogued - this setting is optional
            write_log ('MFDBFH version required - adding database locations to catalog')
            catalog_datasets(cwd, region_name, ip_address, configuration_files, 'data_dir_2', "sql://ESPacDatabase/VSAM/{}?folder=/data")
        else:
            write_log ('VSAM version required - datasets being deployed')
            deploy_vsam_data(parentdir,sys_base,os_type, esuid)
            #data_dir_2 hold the directory name, under the cwd that contains definitions of any additional (e.g VSAM) datasets to be catalogued - this setting is optional
            catalog_datasets(cwd, region_name, ip_address, configuration_files, 'data_dir_2', None)

    write_log ('Partitioned datasets being deployed')
    deploy_partitioned_data(parentdir,sys_base, esuid)

    if mf_product != 'EDz':
        write_log('The Micro Focus {} product does not contain a compiler. Precompiled executables therefore being deployed'.format(mf_product))
        deploy_application(parentdir, sys_base, os_type, is64bit, loadlibDir)

        write_log('Precompiled system executables being deployed'.format(mf_product))
        deploy_system_modules(parentdir, sys_base, os_type, is64bit, loadlibDir)

    else:
        ant_home = None
        if 'ant_home' in main_config:
            ant_home = main_config['ant_home']
        elif "ANT_HOME" in os.environ:
            ant_home = os.environ["ANT_HOME"]
        else:
            eclipsInstallDir = get_EclipsePluginsDir(os_type)
            if eclipsInstallDir is not None:
                for file in os.listdir(eclipsInstallDir):
                    if file.startswith("org.apache.ant_"):
                        ant_home = os.path.join(eclipsInstallDir, file)
            if ant_home is None:
                antdir = get_CobdirAntDir(os_type)
                if antdir is not None:
                    for file in os.listdir(antdir):
                        if file.startswith("apache-ant-"):
                            ant_home = os.path.join(eclipsInstallDir, file)

        if ant_home is None:
            write_log('ANT_HOME not set. Precompiled executables therefore being deployed')
            deploy_application(parentdir, sys_base, os_type, is64bit, loadlibDir)
        else:
            write_log('Application being built')

            build_file = os.path.join(cwd, 'build', 'build.xml')
            parentdir = str(Path(cwd).parents[0])
            source_dir = os.path.join(parentdir, 'sources')
            load_dir = os.path.join(parentdir, region_name,'system','loadlib')
            full_build = True

            if is64bit == True:
                set64bit = 'true'
            else:
                set64bit = 'false'

            run_ant_file(build_file,source_dir,load_dir,ant_home, full_build, dataversion, set64bit)

        write_log('Precompiled system executables being deployed'.format(mf_product))
        deploy_system_modules(parentdir, sys_base, os_type, is64bit, loadlibDir)

    ## Following the update of the SIT and other attributes, the region must be restarted
    try:
        write_log('Stopping region {}'.format(region_name))
        stop_region(region_name, ip_address)
    except ESCWAException as exc:
        write_log('Unable to execute stop request for region.')
        write_log(exc)
        sys.exit(1)

    try:
        write_log('Checking region {} stopped successfully'.format(region_name))
        confirmed = confirm_region_status(region_name, ip_address, 1, 'Stopped')
    except ESCWAException as exc:
        write_log('Unable to check region status.')
        write_log(exc)
        sys.exit(1)

    if not confirmed:
        print('Region Failed to stop.')
        sys.exit(1)
    else:
        write_log ('Region stopped successfully')

    try:
        write_log('Restarting region {}'.format(region_name))
        start_region(region_name, ip_address)
    except ESCWAException as exc:
        write_log('Unable to start region.')
        write_log(exc)
        sys.exit(1)

    try:
        write_log('Checking region {} restarted successfully'.format(region_name))
        confirmed = confirm_region_status(region_name, ip_address, 1, 'Started')
    except ESCWAException as exc:
        write_log('Unable to check region status.')
        write_log(exc)
        sys.exit(1)

    if not confirmed:
        print('Region Failed to start. Environment being rewound')
        sys.exit(1)

        del_res = del_region(region_name, ip_address)

        if del_res.status_code == 204:
            print('Environment cleaned successfully')
        
        sys.exit(1)
    else:
        write_log('Region {} restarted successfully'.format(region_name))

    write_log('Micro Focus Demo environment has been provisioned')

if __name__ == '__main__':

    cwd = os.getcwd()
    if len(sys.argv) < 2:
        config_dir = os.path.join(cwd, 'config')
        config_fullpath = os.path.join(config_dir, "demo.json")
    else:
        options_dir = os.path.join(cwd, 'options')
        config_file = sys.argv[1] + '.json'
        config_fullpath = os.path.join(options_dir, config_file)
        if os.path.isfile(config_fullpath) == False:
            write_log('File {} could not be found'.format(config_fullpath))
            write_log('Valid options are:')
            for f in os.listdir(options_dir):
                if os.path.isfile(os.path.join(options_dir, f)):
                    write_log('    {}'.format(f))
            sys.exit(1)

    create_region(config_fullpath)
