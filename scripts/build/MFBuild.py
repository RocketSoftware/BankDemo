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
from utilities.misc import set_MF_environment
from pathlib import Path

def run_ant_file(build_file, source_dir, load_dir, ant_home, full_build,dataversion, set64bit):

    if sys.platform.startswith('win32'):
        os_type = 'Windows'
    else:
        os_type = 'Linux'

    #determine where the Micro Focus product has been installed
    install_dir = set_MF_environment (os_type)

    #set ANT_HOME environment variable - this value should be set in demo.json
    os.environ["ANT_HOME"] = ant_home

    #add ANT and Micro Focus Bin directories to the PATH environment variable
    ant_dir = os.path.join(ant_home, 'bin')
    jre_bin = os.path.join(os.environ["JAVA_HOME"], 'jre', 'bin')
    os.environ["PATH"] += ';' + ant_dir + ';'
    os.environ["PATH"] += jre_bin + ';'
    os.environ["PATH"] += install_dir[0]

    #set the COBDIR environment variable
    cobdir = str(Path(install_dir[0]).parents[0])
    os.environ["COBDIR"] = cobdir

    #set JAVA_HOME environment variable
    #os.environ["JAVA_HOME"] = 'C:\\Program Files (x86)\\Java\\jre1.8.0_291'
        
    ant_cmd = 'ant -lib \"' + cobdir + '\\bin\\mfant.jar\" -f ' + build_file + ' -Dbasedir=' + source_dir + ' -Dloaddir=' + load_dir + ' -Ddataversion=' + dataversion + ' -D64bitset=' + set64bit + ' > build.txt'

    test = os.environ
    #ant_process = subprocess.run(ant_cmd, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)  
    ant_process = os.system(ant_cmd) 

