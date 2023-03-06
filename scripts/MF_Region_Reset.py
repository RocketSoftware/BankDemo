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

Description:  A script to reset a Micro Focus server region to stopped. 
"""

import sys
from ESCWA.escwa_session import EscwaSession
from ESCWA.region_control import mark_region_stopped, confirm_region_status
from utilities.misc import parse_args
from utilities.exceptions import ESCWAException


def reset_region(region_name='BANKDEMO', ip_address='127.0.0.1', mins_allowed=1):
    session = EscwaSession("http", ip_address, 10086)
    try:
        mark_res = mark_region_stopped(session, region_name)
    except ESCWAException as exc:
        print('Unable to mark region as stopped.')
        sys.exit(1)

    try:
        confirmed = confirm_region_status(session, region_name, mins_allowed, 'Stopped')
    except ESCWAException as exc:
        print('Unable to confirm region is stopped.')
        sys.exit(1)

    if not confirmed:
        print('Unable to confirm region is stopped.')
        sys.exit(1)

    print('Micro Focus JES Batch Server has been successfully set to Stopped')       


if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionName': 'region_name',
        '--MFDSIPAddress': 'ip_address',
        '--MinsAllowed': 'mins_allowed'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    reset_region(**kwargs)