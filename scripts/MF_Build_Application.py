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

Description:  A script to build application. 
"""

import os
import sys
import glob

from pathlib import Path
from utilities.input import read_json
from utilities.output import write_log 
from utilities.misc import parse_args 
from build.MFBuild import  run_ant_file
from utilities.misc import set_MF_environment, get_EclipsePluginsDir, get_CobdirAntDir

def build_programs():

    cwd = os.getcwd()

    main_configfile = os.path.join(cwd, 'config', 'demo.json')
    main_config = read_json(main_configfile)
    region_name = main_config['region_name']
    ant_home = None
    if 'ant_home' in main_config:
        ant_home = main_config['ant_home']
    elif "ANT_HOME" in os.environ:
        ant_home = os.environ["ANT_HOME"]
    else:
        if sys.platform.startswith('win32'):
            os_type = "Windows"
        else:
            os_type = "Linux"
        eclipseInstallDir = get_EclipsePluginsDir(os_type)
        if eclipseInstallDir is not None:
            for file in os.listdir(eclipseInstallDir):
                if file.startswith("org.apache.ant_"):
                    ant_home = os.path.join(eclipseInstallDir, file)
        if ant_home is None:
            antDir = get_CobdirAntDir(os_type)
            if antDir is not None:
                for file in os.listdir(antDir):
                    if file.startswith("apache-ant-"):
                        ant_home = os.path.join(antDir, file)
    if ant_home == None:
        write_log("Ant not found, set ANT_HOME")
        sys.exit(1)

    if main_config['database'] == 'VSAM':
        dataversion = 'vsam'
    else:
        dataversion ='sql'

    build_file = os.path.join(cwd, 'build', 'build.xml')
    parentdir = str(Path(cwd).parents[0])
    source_dir = os.path.join(parentdir, 'sources')
    load_dir = os.path.join(parentdir, region_name,'system','loadlib')
    full_build = True

    if main_config['is64bit'] == False:
        if os_type == 'Linux':
            install_dir = set_MF_environment (os_type)
            if install_dir is None:
                write_log("Unable to determine COBDIR")
                set64bit = True
            else:
                path32 = Path(os.path.join(install_dir,'casstart32'))
                if path32.is_file() == False:
                    # No 32bit executables
                    write_log("Overriding bitism as platform only supports 64 bit")
                    set64bit = True
                else:
                    set64bit = False
    else:
        set64bit = True

    run_ant_file(build_file,source_dir,load_dir,ant_home, full_build, dataversion, set64bit)

   
if __name__ == '__main__':
    build_programs()