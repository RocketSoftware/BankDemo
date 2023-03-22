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
from ESCWA.escwa_session import EscwaSession
from utilities.misc import parse_args, get_elem_with_prop
from utilities.input import read_json, read_txt
from ESCWA.resourcedef import  add_sit, add_Startup_list, add_groups, add_fct, add_ppt, add_pct

def update_rdef(ip_address='127.0.0.1',region_name='OMPTRAIN'):
    session = EscwaSession("http", ip_address, 10086)
    cwd = os.getcwd()
    config_dir = os.path.join(cwd, 'config')
    resourcedef_dir = os.path.join(config_dir, 'CSD')

    rdef_startup = os.path.join(resourcedef_dir, 'rdef_startup.json')

    if os.path.isfile(rdef_startup):
        startup_details = read_json(rdef_startup)
        add_Startup_list(session, region_name,ip_address,startup_details)

    rdef_sit = os.path.join(resourcedef_dir, 'rdef_sit.json')

    if os.path.isfile(rdef_sit):
        sit_details = read_json(rdef_sit)
        add_sit(session, region_name,ip_address,sit_details)

    rdef_group = os.path.join(resourcedef_dir, 'rdef_groups.json')

    if os.path.isfile(rdef_group):
        group_details = read_json(rdef_group)
        add_groups(session, region_name,ip_address,group_details)  

    fct_match_pattern = resourcedef_dir + '\\rdef_fct_*.json'
    fct_filelist = glob.glob(fct_match_pattern)

    if fct_filelist != '':
       for filename in fct_filelist:
           fct_details = read_json(filename)
           add_fct(session, region_name,ip_address,fct_details)

    ppt_match_pattern = resourcedef_dir + '\\rdef_ppt_*.json'
    ppt_filelist = glob.glob(ppt_match_pattern)

    if ppt_filelist != '':
       for filename in ppt_filelist:
           ppt_details = read_json(filename)
           add_ppt(session, region_name,ip_address, ppt_details)

    pct_match_pattern = resourcedef_dir + '\\rdef_pct_*.json'
    pct_filelist = glob.glob(pct_match_pattern)

    if pct_filelist != '':
       for filename in pct_filelist:
           pct_details = read_json(filename)
           add_pct(session, region_name,ip_address,pct_details)

   
if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionHost': 'ip_address',
        '--RegionName': 'region_name'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    update_rdef(**kwargs)