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

from utilities.misc import parse_args
from utilities.input import read_json, read_txt
from utilities.output import write_json, write_log 
from utilities.filesystem import create_new_system, deploy_application, deploy_vsam_data
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

def create_region():

    #set current working directory
    cwd = os.getcwd()
    

    write_log('Provision Process starting')
   
    config_dir = os.path.join(cwd, 'config')

    #read demo configuration file
    write_log('Reading Demo config file')
    main_configfile = os.path.join(config_dir, 'demo.json')
    main_config = read_json(main_configfile)

    #retrieve the demo configuration settings
    ip_address = main_config["ip_address"]
    region_name = main_config["region_name"]
    mf_product = main_config["product"]
    cics_region = main_config["CICS"]
    jes_region = main_config["JES"]
    mq_region = main_config["MQ"]
    is64bit = main_config["is64bit"]

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
    caspcrd_process = os.system('caspcrd /c /dp=' + sys_base + '/rdef')
    
    dataset_dir = os.path.join(cwd, data_dir)

    base_config = os.path.join(config_dir, base_config)
    update_config = os.path.join(config_dir, update_config)
    alias_config = os.path.join(config_dir, alias_config)
    init_config = os.path.join(config_dir, init_config)
    env_config = os.path.join(config_dir, env_config)
    resourcedef_dir = os.path.join(config_dir, 'csd')

    datafile_list = [file for file in os.scandir(dataset_dir)]

    try:
        write_log ('Region \033[1m{}\033[0m being added'.format(region_name))
        add_region(region_name, ip_address, region_port, base_config, is64bit)
    except ESCWAException as exc:
        write_log('Unable to create region.')
        sys.exit(1)

    try:
        write_log ('Region {} being updated with requested settings'.format(region_name))
        update_region(region_name, ip_address, update_config, env_config, 'Test Region', sys_base)
    except ESCWAException as exc:
        write_log('Unable to update region.')
        sys.exit(1)

    try:
        write_log ('Web Services and J2EE listener port set to {}'.format(jes_port))
        set_jes_listener(region_name, ip_address, jes_port)
    except ESCWAException as exc:
        write_log('Unable to set JES listener.')
        sys.exit(1)

    try:
        write_log('Region {} being started before further configuration'.format(region_name))
        start_region(region_name, ip_address)
    except ESCWAException as exc:
        write_log('Unable to start region.')
        sys.exit(1)

    try:
        write_log('Checking region {} start succesfully'.format(region_name))
        confirmed = confirm_region_status(region_name, ip_address, 1, 'Started')
    except ESCWAException as exc:
        write_log('Unable to check region status.')
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
            sys.exit(1)

    if  init_config != 'none':
        write_log('JES initiator configuration found. Initiators being added')
        try:
            add_initiator(region_name, ip_address, init_config)
        except ESCWAException as exc:
            write_log('Unable to add initiator.')
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
        fct_match_pattern = resourcedef_dir + '\\rdef_fct_*.json'
        fct_filelist = glob.glob(fct_match_pattern)

        if fct_filelist != '':
            for filename in fct_filelist:
                fct_details = read_json(filename)
                groupx = filename.split('_')
                group_name = groupx[2].split('.')
                add_fct(region_name,ip_address,group_name[0], fct_details)

    ppt_match_pattern = resourcedef_dir + '\\rdef_ppt_*.json'
    ppt_filelist = glob.glob(ppt_match_pattern)

    if ppt_filelist != '':
       write_log ('CICS Resource PPT definitions found - being added') 
       for filename in ppt_filelist:
           ppt_details = read_json(filename)
           groupx = filename.split('_')
           group_name = groupx[2].split('.')
           add_ppt(region_name,ip_address,group_name[0], ppt_details)

    pct_match_pattern = resourcedef_dir + '\\rdef_pct_*.json'
    pct_filelist = glob.glob(pct_match_pattern)

    if pct_filelist != '':
       write_log ('CICS Resource PCT definitions found - being added')  
       for filename in pct_filelist:
           pct_details = read_json(filename)
           groupx = filename.split('_')
           group_name = groupx[2].split('.')
           add_pct(region_name,ip_address,group_name[0], pct_details)

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
        sys.exit(1)

    try:
        write_log('Checking region {} stopped successfully'.format(region_name))
        confirmed = confirm_region_status(region_name, ip_address, 1, 'Stopped')
    except ESCWAException as exc:
        write_log('Unable to check region status.')
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
        sys.exit(1)

    try:
        write_log('Checking region {} restarted successfully'.format(region_name))
        confirmed = confirm_region_status(region_name, ip_address, 1, 'Started')
    except ESCWAException as exc:
        write_log('Unable to check region status.')
        sys.exit(1)

    if not confirmed:
        print('Region Failed to start. Environment being rewound')

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
            sys.exit(1)
    
   ## The following code deploys the application

    ## determine which OS the script is running on
    if sys.platform.startswith('win32'):
        os_type = 'Windows'
        os_distribution =''
    else:
        os_type = 'Linux'
        os_distribution = sys.platform.linux_distribution()

    if main_config['database'] == 'VSAM':
        dataversion = 'vsam'
    else:
        dataversion = 'sql'

    if dataversion == 'sql':
       database_type= main_config["database"]
       sql_folder= os.path.join(cwd, 'config', 'database', database_type) 

    if  database_type == 'Postgres':
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
        write_log ('VSAM version required - datasets being deployed')
        deploy_vsam_data(parentdir,sys_base,os_type)

    if mf_product != 'EDz':
        write_log('The Micro Focus {} product does not contain a compiler. Precompiled executables therefore being deployed'.format(mf_product))
        deploy_application(parentdir, sys_base, os_type, os_distribution, database_type)
    else:
        write_log('Application being built')
        ant_home = main_config['ant_home']

        build_file = os.path.join(cwd, 'build', 'build.xml')
        parentdir = str(Path(cwd).parents[0])
        source_dir = os.path.join(parentdir, 'sources')
        load_dir = os.path.join(parentdir, region_name,'system','loadlib')
        full_build = True

        if main_config['is64bit'] == True:
            set64bit = 'true'
        else:
            set64bit = 'false'

        run_ant_file(build_file,source_dir,load_dir,ant_home, full_build, dataversion, set64bit)

    write_log('Micro Focus Demo environment has been provisioned')

if __name__ == '__main__':
    create_region()