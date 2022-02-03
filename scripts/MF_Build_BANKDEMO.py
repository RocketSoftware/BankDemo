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

Description:  A script to add/update the CICS resource definitions. 
"""

import os
import sys
import glob

from pathlib import Path
from utilities.input import read_json
from utilities.misc import parse_args 
from Build.MFBuild import  run_ant_file

def build_programs(ip_address='127.0.0.1',region_name='BANKDEMO'):

    cwd = os.getcwd()

    main_configfile = os.path.join(cwd, 'config', 'demo.json')
    main_config = read_json(main_configfile)
    ant_home = main_config['ant_home']

    if main_config['database'] == 'VSAM':
        dataversion = 'VSAM'
    else:
        dataversion ='SQL'

    build_file = os.path.join(cwd, 'Build', 'build.xml')
    parentdir = str(Path(cwd).parents[0])
    source_dir = os.path.join(parentdir, 'Source')
    load_dir = os.path.join(parentdir, region_name,'System','Loadlib')
    full_build = True

    if main_config['is64bit'] == True:
        set64bit = 'true'
    else:
        set64bit = 'false'

    run_ant_file(build_file,source_dir,load_dir,ant_home, full_build, dataversion, set64bit)

   
if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionHost': 'ip_address',
        '--RegionName': 'region_name'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    build_programs(**kwargs)