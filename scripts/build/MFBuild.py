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

Description:  Micro Focus Build utility functions. 
"""

import os
import sys
import subprocess
from utilities.output import write_log 
from utilities.misc import set_MF_environment
from pathlib import Path

def run_ant_file(build_file, source_dir, load_dir, ant_home, full_build,dataversion, is64bit):

    if sys.platform.startswith('win32'):
        os_type = 'Windows'
        mfant_dir = 'bin'
    else:
        os_type = 'Linux'
        mfant_dir = 'lib'

    if is64bit == True:
        set64bit = 'true'
    else:
        set64bit = 'false'

    #determine where the Micro Focus product has been installed
    install_dir = set_MF_environment (os_type)
    if install_dir is None:
        write_log("Unable to determine COBDIR")
        sys.exit(1)

    #ant_home - this value should be set in demo.json or ANT_HOME if not determined from product location
    ant_exe = os.path.join(ant_home, 'bin', 'ant')

    #set the COBOL environment
    cobdir = str(Path(install_dir).parents[0])
    write_log('Setting COBDIR={}'.format(cobdir))
    os.environ["COBDIR"] = cobdir
    mfant_jar = os.path.join(cobdir, mfant_dir, 'mfant.jar')

    if os_type == 'Linux':
        os.environ['LD_LIBRARY_PATH'] = cobdir + '/lib:' + os.environ['LD_LIBRARY_PATH']
        os.environ['TXDIR'] = cobdir
        os.environ['COBCPY'] = cobdir + '/cpylib:' + os.environ['COBCPY']
        os.environ['CLASSPATH'] = mfant_jar # Bug in some Ant versions ignores -lib    
        ant_cmd = ['sh', ant_exe, '-lib', mfant_jar, '-f', build_file, '-Dbasedir', source_dir, '-Dloaddir', load_dir, '-Ddataversion', dataversion, '-D64bitset', set64bit]
        useShell = False
    else:
        ant_cmd = [ant_exe, '-lib', mfant_jar, '-f', build_file, '-Dbasedir', source_dir, '-Dloaddir', load_dir, '-Ddataversion', dataversion, '-D64bitset', set64bit]
        useShell = True
    #write_log(ant_cmd)
    

    with open('build.txt', "w") as outfile:
        subprocess.run(ant_cmd, stdout=outfile, stderr=outfile, shell=useShell, check=True)

