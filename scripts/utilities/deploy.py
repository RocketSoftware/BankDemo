import os
from utilities.output import write_log 
from utilities.input import read_txt
from utilities.resource import add_postgresxa, catalog_datasets, write_secret
from utilities.filesystem import deploy_vsam_data, dbfhdeploy_vsam_data
from utilities.pac import create_crossregion_database
from database.odbc import create_windows_dsn, create_linux_dsn
from ESCWA.region_config import update_region_attribute
from pathlib import Path

def deploy_application_option(session, option, os_type, main_config, cwd, mfdbfh_config, esuid):
    if option == 'SQL_Postgres':
        deploy_sql_postgres(session, os_type, main_config, cwd, esuid)
    elif option == 'VSAM_Postgres':
        deploy_vsam_postgres(session, os_type, main_config, cwd, mfdbfh_config, esuid)
    elif option == 'VSAM_Postgres_PAC':
        deploy_vsam_postgres_pac(session, os_type, main_config, cwd, mfdbfh_config, esuid)
    else:
        deploy_vsam(session, os_type, main_config, cwd, esuid)

def deploy_sql_postgres(session, os_type, main_config, cwd, esuid): 
    from database.mfpostgres import Connect_to_PG_server, Execute_PG_Command, Disconnect_from_PG_server

    configuration_files = main_config["configuration_files"]
    is64bit = main_config["is64bit"]
    ip_address = main_config["ip_address"]
    region_name = main_config["region_name"]
    database_engine = 'Postgres'
    loadlibDir = 'SQL_Postgres'
    database_connection = main_config['database_connection']
    write_log ('Database type {} selected - database being built'.format(database_engine))
    if os_type == 'Windows':
        create_windows_dsn('postgres', is64bit, 'bank', 'bank', database_connection)
    else:
        create_linux_dsn("postgres", "BANK", "bank", "bank", database_connection)
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
    configure_xa(session, os_type, main_config, cwd, mfdbfh_config, esuid)

    xa_config = configuration_files["xa_config"]
    config_dir = os.path.join(cwd, 'config')
    xa_config = os.path.join(config_dir, xa_config)
    xa_openstring = add_postgresxa(session, os_type, is64bit, region_name, ip_address, xa_config, database_connection)

    write_log("Adding XA switch configuration to vault")
    write_secret(os_type, "Microfocus/XASW/DBPG/XAOpenString", xa_openstring, esuid)

def deploy_vsam_postgres(session, os_type, main_config, cwd, mfdbfh_config, esuid):
    configuration_files = main_config["configuration_files"]
    is64bit = main_config["is64bit"]
    ip_address = main_config["ip_address"]
    region_name = main_config["region_name"]
    loadlibDir = 'VSAM'
    database_connection = main_config['database_connection']
    if os_type == 'Windows':
        create_windows_dsn('postgres', is64bit, 'BANKVSAM.MASTER', 'postgres', database_connection)
        create_windows_dsn('postgres', is64bit, 'BANKVSAM.VSAM', 'BANK_ONEDB', database_connection)
    else:
        create_linux_dsn("postgres", "BANKVSAM.MASTER", "BANKVSAM.MASTER", "postgres", database_connection)
        create_linux_dsn("postgres", "BANKVSAM.VSAM", "BANKVSAM.VSAM", "BANK_ONEDB", database_connection)

    write_log("Adding database password to vault for MFDBFH")
    write_secret(os_type, "microfocus/mfdbfh/espacdatabase.bankvsam.master.password", database_connection['password'], esuid)
    write_secret(os_type, "microfocus/mfdbfh/espacdatabase.bankvsam.vsam.password", database_connection['password'], esuid)

    configure_xa(session, os_type, main_config, cwd, mfdbfh_config, esuid)
    update_region_attribute(session, region_name, {"mfCASTXFILEP": "sql://ESPacDatabase/VSAM?type=folder;folder=/data"})

    write_log ('MFDBFH version required - datasets being migrated to database')
    os.environ['MFDBFH_CONFIG'] = mfdbfh_config
    parentdir = str(Path(cwd).parents[0])
    dbfhdeploy_vsam_data(parentdir, os_type, is64bit, configuration_files, "sql://ESPacDatabase/VSAM/{}?folder=/data")

    #data_dir_2 hold the directory name, under the cwd that contains definitions of any additional (e.g VSAM) datasets to be catalogued - this setting is optional
    write_log ('MFDBFH version required - adding database locations to catalog')
    catalog_datasets(session, cwd, region_name, ip_address, configuration_files, 'data_dir_2', "sql://ESPacDatabase/VSAM/{}?folder=/data")

def configure_xa(session, os_type, main_config, cwd, mfdbfh_config, esuid):
    database_connection = main_config['database_connection']
    configuration_files = main_config["configuration_files"]
    is64bit = main_config["is64bit"]
    ip_address = main_config["ip_address"]
    region_name = main_config["region_name"]
    xa_config = configuration_files["xa_config"]
    config_dir = os.path.join(cwd, 'config')
    xa_config = os.path.join(config_dir, xa_config)
    xa_openstring = add_postgresxa(session, os_type, is64bit, region_name, ip_address, xa_config, database_connection)
    
    write_log("Adding XA switch configuration to vault")
    write_secret(os_type, "Microfocus/XASW/DBPG/XAOpenString", xa_openstring, esuid)
    


def deploy_vsam_postgres_pac(session, os_type, main_config, cwd, mfdbfh_config, esuid):
    database_connection = main_config['database_connection']
    configuration_files = main_config["configuration_files"]
    is64bit = main_config["is64bit"]
    ip_address = main_config["ip_address"]
    region_name = main_config["region_name"]

    configure_xa(session, os_type, main_config, cwd, mfdbfh_config, esuid)
    update_region_attribute(session, region_name, {"mfCASTXFILEP": "sql://BankPAC/VSAM?type=folder;folder=/data"})

    if 'data_dir_2' in configuration_files:
        if os_type == 'Windows':
            create_windows_dsn('postgres', is64bit, 'PG.MASTER', 'postgres', database_connection)
            create_windows_dsn('postgres', is64bit, 'PG.VSAM', 'BANK_ONEDB', database_connection)
            create_windows_dsn('postgres', is64bit, 'PG.REGION', 'BANK_ONEDB', database_connection)
            create_windows_dsn('postgres', is64bit, 'PG.CROSSREGION', 'BANK_ONEDB', database_connection)
        else:
            create_linux_dsn("postgres", "PG.MASTER", "BANKPAC.MASTER", "postgres", database_connection)
            create_linux_dsn("postgres", "PG.VSAM", "BANKPAC.VSAM", "BANK_ONEDB", database_connection)
            create_linux_dsn("postgres", "PG.REGION", "BANKPAC.REGION", "BANK_ONEDB", database_connection)
            create_linux_dsn("postgres", "PG.CROSSREGION", "BANKPAC.CROSSREGION", "BANK_ONEDB", database_connection)
            
        write_log("Adding database password to vault for MFDBFH")
        db_pwd = database_connection['password']
        write_secret(os_type, "microfocus/mfdbfh/bankpac.pg.master.password", db_pwd, esuid)
        write_secret(os_type, "microfocus/mfdbfh/bankpac.pg.vsam.password", db_pwd, esuid)
        write_secret(os_type, "microfocus/mfdbfh/bankpac.pg.region.password", db_pwd, esuid)
        write_secret(os_type, "microfocus/mfdbfh/bankpac.pg.crossregion.password", db_pwd, esuid)
    
        write_log ('MFDBFH version required - datasets being migrated to database')
        os.environ['MFDBFH_CONFIG'] = mfdbfh_config
        parentdir = str(Path(cwd).parents[0])
        dbfhdeploy_vsam_data(parentdir, os_type, is64bit, configuration_files, "sql://BankPAC/VSAM/{}?folder=/data")

        #data_dir_2 hold the directory name, under the cwd that contains definitions of any additional (e.g VSAM) datasets to be catalogued - this setting is optional
        write_log ('MFDBFH version required - adding database locations to catalog')
        catalog_datasets(session, cwd, region_name, ip_address, configuration_files, 'data_dir_2', "sql://BankPAC/VSAM/{}?folder=/data")

        write_log ('Creating crossregion database')
        create_crossregion_database(main_config, "BankPAC")

def deploy_vsam(session, os_type, main_config, cwd, esuid):
    write_log ('VSAM version required - datasets being deployed')
    configuration_files = main_config["configuration_files"]
    ip_address = main_config["ip_address"]
    region_name = main_config["region_name"]
    parentdir = str(Path(cwd).parents[0])
    sys_base = os.path.join(parentdir, region_name, 'system')
    deploy_vsam_data(parentdir,sys_base,os_type, esuid)
    #data_dir_2 hold the directory name, under the cwd that contains definitions of any additional (e.g VSAM) datasets to be catalogued - this setting is optional
    catalog_datasets(session, cwd, region_name, ip_address, configuration_files, 'data_dir_2', None)