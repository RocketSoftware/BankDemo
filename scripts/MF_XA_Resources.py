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
from ESCWA.xarm import add_xa_rm

def update_xa(ip_address='127.0.0.1',region_name='OMPTRAIN'):
    session = EscwaSession("http", ip_address, 10086)
    cwd = os.getcwd()
    config_dir = os.path.join(cwd, 'config')

    xa_config = os.path.join(config_dir, 'xa.json')

    if os.path.isfile(xa_config):
        xa_details = read_json(xa_config)
        for xa_detail in xa_details['XAResources']:
            add_xa_rm(session, region_name,ip_address,xa_detail)
   
if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionHost': 'ip_address',
        '--RegionName': 'region_name'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    update_xa(**kwargs)