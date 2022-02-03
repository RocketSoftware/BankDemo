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
from utilities.exceptions import HTTPException
from pathlib import Path
from distutils.dir_util import copy_tree

def create_new_system(template_base, sys_base):

    parentdir = str(Path(sys_base).parents[0])
    os.mkdir(parentdir)
    os.mkdir(sys_base)
    
    copy_tree(template_base, sys_base)
    

def deploy_application (repo_dir, sys_base, os_type, os_distribution, database_type):

    target_load = os.path.join(sys_base, 'loadlib')

    if  os_type == 'Windows':
        exec_subfolder = os_type + '_' + database_type
    else:
        exec_subfolder = os_distribution + '_' + os_type + '_' + database_type

    source_load = os.path.join(repo_dir, 'executables', exec_subfolder)

    copy_tree(source_load, target_load)

def deploy_vsam_data (repo_dir, sys_base, os_type):

    target_load = os.path.join(sys_base, 'catalog', 'data')
    source_load = os.path.join(repo_dir, 'datafiles')

    copy_tree(source_load, target_load)


