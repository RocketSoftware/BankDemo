import os
import sys
from utilities.input import read_json
from utilities.output import write_log
from utilities.exceptions import ESCWAException
from ESCWA.xarm import add_xa_rm
from ESCWA.region_config import add_datasets

def add_postgresxa(session, os_type, is64bit, region_name, ip_address, xa_config, database_connection):
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
    add_xa_rm(session, region_name,ip_address,xa_detail)

    secret_open_string = '{},USRPASS={}.{}'.format(xa_open_string,database_connection['user'],database_connection['password'])
    return secret_open_string

def catalog_datasets(session, cwd, region_name, ip_address, configuration_files, dataset_key, mfdbfh_location, catalog_dir):
    if  dataset_key in configuration_files:
        data_dir = configuration_files[dataset_key]
        dataset_dir = os.path.join(cwd, data_dir)
        datafile_list = [file for file in os.scandir(dataset_dir)]
        write_log ('Cataloging datasets {} {} {}'.format(region_name,ip_address, datafile_list))
        try:
            add_datasets(session, region_name, ip_address, datafile_list, mfdbfh_location, catalog_dir)
        except ESCWAException as exc:
            write_log('Unable to catalog datasets in {}.'.format(dataset_dir))
            sys.exit(1)

def write_secret(os_type, key, value, esuid):
    write_log ('Writing vault secret {}'.format(key))
    if os_type == "Windows":
        mfsecretsadmin = os.path.join(os.environ['COBDIR'], 'bin', 'mfsecretsadmin')
        command = '"{}" write -overwrite {} {}'.format(mfsecretsadmin, key, value)
        exit_code=os.system(command)
    else:
        #write secrets as the ES user that will read them
        command = 'mfsecretsadmin write -overwrite "{}" "{}"'.format(key, value)
        exit_code=os.WEXITSTATUS(os.system(command))
    if exit_code != 0:
        write_log("write_secret failed rc={}".format(exit_code))