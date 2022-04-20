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
from utilities.filesystem import create_new_system, deploy_application, deploy_vsam_data, deploy_partitioned_data

from ESCWA.mfds_config import add_mfds_to_list, check_mfds_list
from ESCWA.region_control import add_region, start_region, del_region, confirm_region_status, stop_region
from ESCWA.region_config import update_region, update_alias, add_initiator, add_datasets
from ESCWA.comm_control import set_jes_listener
from utilities.exceptions import ESCWAException
from ESCWA.resourcedef import  add_sit, add_Startup_list, add_groups, add_fct, add_ppt, add_pct, update_sit_in_use
from ESCWA.xarm import add_xa_rm
from ESCWA.mq_config import add_mq_listener
from build.MFBuild import  run_ant_file
from database.mfpostgres import  Connect_to_PG_server, Execute_PG_Command, Disconnect_from_PG_server, Create_ODBC_Data_Source

from pathlib import Path

import shutil
if not sys.platform.startswith('win32'):
    from pwd import getpwuid
    from os  import stat

def find_owner(filename):
    return getpwuid(stat(filename).st_gid).pw_name

def create_region():

    #set current working directory
    cwd = os.getcwd()
    
    #determine where the Micro Focus product has been installed
    if sys.platform.startswith('win32'):
        os_type = 'Windows'
        install_dir = set_MF_environment (os_type)
        if install_dir is None:
            write_log('COBOL environment not found')
            exit(1)
        cobdir = str(Path(install_dir).parents[0])
        pathMfAnt = Path(os.path.join(cobdir, 'bin', 'mfant.jar')) 
    else:
        os_type = 'Linux'
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

    #read demo configuration file
    write_log('Reading Demo config file')
    main_configfile = os.path.join(config_dir, 'demo.json')
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
    else:
        database_type= main_config["database"]
        sql_folder= os.path.join(cwd, 'config', 'database', database_type)

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

    #data_dir hold the directory name, under the cwd that contains definitions of any datasets to be catalogued - this setting is optional
    if  'data_dir' not in configuration_files:
        data_dir = 'none'
    else:
        data_dir = configuration_files["data_dir"]

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
    
    dataset_dir = os.path.join(cwd, data_dir)

    base_config = os.path.join(config_dir, base_config)
    update_config = os.path.join(config_dir, update_config)
    alias_config = os.path.join(config_dir, alias_config)
    init_config = os.path.join(config_dir, init_config)
    env_config = os.path.join(config_dir, env_config)
    resourcedef_dir = os.path.join(config_dir, 'CSD')

    datafile_list = [file for file in os.scandir(dataset_dir)]

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

    try:
        add_datasets(region_name, ip_address, datafile_list)
    except ESCWAException as exc:
        write_log('Unable to add datasets.')
        sys.exit(1)

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
    if database_type == 'VSAM':

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

    ## Following the update of the SIT attribute, the region must be restarted

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

    ## determine which OS the script is running on
    if sys.platform.startswith('win32'):
        os_type = 'Windows'
        os_distribution =''
    else:
        os_type = 'Linux'
        os_distribution = '' #distro.id()

    if main_config['database'] == 'VSAM':
        dataversion = 'vsam'
    else:
        dataversion = 'sql'

    if dataversion == 'sql':
       database_type= main_config["database"]
       sql_folder= os.path.join(cwd, 'config', 'database', database_type) 

    if  database_type == 'Postgres':
        loadlibDir = 'SQL_Postgres'
        write_log ('Databse type {} selected - database being built'.format(database_type))
        database_connection = main_config['database_connection']
        odbc_filename = 'ODBC' + database_type + '.reg'
        reg_file = os.path.join(config_dir, 'database', database_type, odbc_filename)
        odbc_out = Create_ODBC_Data_Source(reg_file)
        conn = Connect_to_PG_server(database_connection['server_name'],database_connection['server_port'],'postgres',database_connection['user'],database_connection['password'])
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

        xa_config = os.path.join(config_dir, 'xa_Postgres.json')
        xa_detail = read_json(xa_config)
        if is64bit == True:
            xa_bitism = "64"
        else:
            xa_bitism = "32"
        if os_type == "Windows":
            xa_extension = '.dll'
        else:
            xa_extension = ".so"
        xarm_module_version = 'ESPGSQLXA' + xa_bitism + xa_extension
        xa_module = '$ESP/loadlib/' + xarm_module_version
        xa_detail["mfXRMModule"] = xa_module
        write_log ('XA Resource Manager {} being added'.format(xa_module))
        add_xa_rm(region_name,ip_address,xa_detail)
    else:
        loadlibDir = 'VSAM'
        write_log ('VSAM version required - datasets being deployed')
        deploy_vsam_data(parentdir,sys_base,os_type, esuid)

        write_log ('Partitioned datasets being deployed')
        deploy_partitioned_data(parentdir,sys_base, esuid)

    if mf_product != 'EDz':
        write_log('The Micro Focus {} product does not contain a compiler. Precompiled executables therefore being deployed'.format(mf_product))
        deploy_application(parentdir, sys_base, os_type, is64bit, loadlibDir)
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
                if antDir is not None:
                    for file in os.listdir(antdir):
                        if file.startswith("apache-ant-"):
                            ant_home = os.path.join(eclipsInstallDir, file)

        if ant_home is None:
            write_log('ANT_HOME not set. Precompiled executables therefore being deployed'.format(mf_product))
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

    write_log('Micro Focus Demo environment has been provisioned')

if __name__ == '__main__':

    create_region()
