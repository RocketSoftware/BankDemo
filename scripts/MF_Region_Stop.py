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

Description:  A script to stop a Micro Focus Server. 
"""

import sys
from ESCWA.escwa_session import EscwaSession
from utilities.misc import parse_args
from ESCWA.region_control import stop_region
from ESCWA.region_control import confirm_region_status
from utilities.exceptions import ESCWAException


def stop_server(region_name='BANKDEMO', ip_address='127.0.0.1', mins_allowed=1):
    session = EscwaSession("http", ip_address, 10086)
    try:
        stop_res = stop_region(session, region_name)
    except ESCWAException as exc:
        print('Unable to stop region.')
        sys.exit(1)

    try:
        confirmed = confirm_region_status(session, region_name, mins_allowed, 'Stopped')
    except ESCWAException as exc:
        print('Unable to check region.')
        sys.exit(1)
    
    if not confirmed:
        print('Micro Focus JES Batch Server has failed to stop')
        sys.exit(1)

    print('Micro Focus JES Batch Server has stopped successfully')


if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionName': 'region_name',
        '--MFDSIPAddress': 'ip_address',
        '--MinsAllowed': 'mins_allowed'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    stop_server(**kwargs)