#!/usr/bin/python3

"""
Copyright 2010 – 2024 Rocket Software, Inc. or its affiliates. 
This software may be used, modified, and distributed
(provided this notice is included without modification)
solely for internal demonstration purposes with other
Rocket® products, and is otherwise subject to the EULA at
https://www.rocketsoftware.com/company/trust/agreements.

THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED
WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,
SHALL NOT APPLY.
TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL
ROCKET SOFTWARE HAVE ANY LIABILITY WHATSOEVER IN CONNECTION
WITH THIS SOFTWARE.

Description:  A script to start a server region. 
"""

import sys
from ESCWA.escwa_session import EscwaSession
from utilities.misc import parse_args
from ESCWA.region_control import start_region
from ESCWA.region_control import confirm_region_status
from utilities.exceptions import ESCWAException


def start_server(region_name='BANKDEMO', ip_address='127.0.0.1', mins_allowed=1):
    session = EscwaSession("http", ip_address, 10086)
    try:
        start_res = start_region(session, region_name, ip_address)
    except ESCWAException as exc:
        print('Unable to start region.')
        sys.exit(1)

    try:
        confirmed = confirm_region_status(session, region_name, mins_allowed, 'Started')
    except ESCWAException as exc:
        print('Unable to check region.')
        sys.exit(1)

    if not confirmed:
        print('JES Batch Server has failed to start')
        sys.exit(1)

    print('JES Batch Server has started successfully')


if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionName': 'region_name',
        '--MFDSIPAddress': 'ip_address',
        '--MinsAllowed': 'mins_allowed'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    start_server(**kwargs)