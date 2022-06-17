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

Description:  File System utility functions. 
"""

import os
import sys
import subprocess
from utilities.exceptions import HTTPException
from utilities.output import write_log 
from pathlib import Path
from distutils.dir_util import copy_tree
import shutil

def create_new_system(template_base, sys_base):

    parentdir = str(Path(sys_base).parents[0])
    os.mkdir(parentdir)
    os.mkdir(sys_base)
    
    copy_tree(template_base, sys_base)
    

def deploy_application (repo_dir, sys_base, os_type, is64bit, database_type):

    target_load = os.path.join(sys_base, 'loadlib')

    if is64bit:
        chip = 'x64'
    else:
        chip = 'x86'
    exec_load = os.path.join(repo_dir, 'executables', os_type, chip)
    
    source_load = os.path.join(exec_load, 'data', database_type)
    copy_tree(source_load, target_load)

    source_load = os.path.join(exec_load, 'core')
    copy_tree(source_load, target_load)

def deploy_system_modules (repo_dir, sys_base, os_type, is64bit, database_type):

    target_load = os.path.join(sys_base, 'loadlib')

    if is64bit:
        chip = 'x64'
    else:
        chip = 'x86'
    exec_load = os.path.join(repo_dir, 'executables', os_type, chip)
    
    source_load = os.path.join(exec_load, 'system')
    copy_tree(source_load, target_load)

def deploy_vsam_data (repo_dir, sys_base, os_type, esuid):

    target_load = os.path.join(sys_base, 'catalog', 'data')
    source_load = os.path.join(repo_dir, 'datafiles')

    copy_tree(source_load, target_load)
    if esuid != '':
        shutil.chown(target_load, esuid, esuid)
        for file in os.scandir(target_load):
            shutil.chown(file, esuid, esuid)

def deploy_partitioned_data (repo_dir, sys_base, esuid):

    target_load = os.path.join(sys_base, 'catalog', 'data', 'proclib')
    source_load = os.path.join(repo_dir, 'sources', 'proclib')
    copy_tree(source_load, target_load)
    if esuid != '':
        shutil.chown(target_load, esuid, esuid)
        for file in os.scandir(target_load):
            shutil.chown(file, esuid, esuid)

    target_load = os.path.join(sys_base, 'catalog', 'data', 'ctlcards')
    source_load = os.path.join(repo_dir, 'sources', 'ctlcards')
    copy_tree(source_load, target_load)
    if esuid != '':
        shutil.chown(target_load, esuid, esuid)
        for file in os.scandir(target_load):
            shutil.chown(file, esuid, esuid)

def dbfhdeploy_vsam_data (repo_dir, os_type, is64Bit, mfdbfh_location):
    source_load = os.path.join(repo_dir, 'datafiles')

    if os_type == 'Windows':
        if is64Bit == True:
            bin = 'bin64'
        else:
            bin = 'bin'
    else:
	    bin = 'bin'
    dbfhdeploy = os.path.join(os.environ['COBDIR'], bin, 'dbfhdeploy')
    db = mfdbfh_location.split('{')
    dbfhdeploy_cmd = '\"{}\" create \"{}\"'.format(dbfhdeploy, db[0])
    write_log(dbfhdeploy_cmd)
    subprocess.run([dbfhdeploy, "create", db[0]])

    for file in os.scandir(source_load):
        if file.name.endswith(".dat"):
            catalog_location = mfdbfh_location.format(file.name)

            dbfhdeploy_cmd = '\"{}\" add \"{}\" \"{}\"'.format(dbfhdeploy, file.path, catalog_location)
            write_log(dbfhdeploy_cmd)
            subprocess.run([dbfhdeploy, "add", file.path, catalog_location])
