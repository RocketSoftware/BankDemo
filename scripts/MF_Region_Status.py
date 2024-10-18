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

Description:  A script for checking the status of a Server region. """

import sys
from ESCWA.escwa_session import EscwaSession
from utilities.misc import parse_args
from ESCWA.region_control import get_region_status
from utilities.exceptions import ESCWAException


def check_status(region_name='BANKDEMO', ip_address='127.0.0.1'):
    session = EscwaSession("http", ip_address, 10086)
    try:
        status_res = get_region_status(session, region_name)
    except ESCWAException as exc:
        print('Unable to check region.')
        sys.exit(1)

    status_res = status_res.json()

    print('Current Status of the JES Batch Server is {}'.format(status_res['mfServerStatus']))


if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionName': 'region_name',
        '--MFDSIPAddress': 'ip_address',
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    check_status(**kwargs)