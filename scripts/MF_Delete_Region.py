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

Description:  A script to delete a Micro Focus server region. 
"""

import sys
from ESCWA.escwa_session import EscwaSession
from utilities.misc import parse_args
from ESCWA.region_control import confirm_region_status, del_region
from utilities.exceptions import ESCWAException


def delete_server(region_name='BANKDEMO', ip_address='127.0.0.1'):
    """ Deletes a Micro Focus server. """
    session = EscwaSession("http", ip_address, 10086)
    try:
        confirmed = confirm_region_status(session, region_name, 0, 'Stopped')
    except ESCWAException as exc:
        # TODO: This triggers when the region is deleted successfully.
        print('Unable to check region status.')
        sys.exit(1)

    if not confirmed:
        print('Region is not stopped; Please stop the region before deleting.')
        sys.exit(1)

    try:
        del_res = del_region(session, region_name)
    except ESCWAException as exc:
        print('Unable to delete region.')
        sys.exit(1)

    if del_res.status_code != 204:
        print('Unable to delete environment at this time')
        sys.exit(1)
    
    print('Environment deleted successfully')


if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--RegionName': 'region_name',
        '--MFDSIPAddress': 'ip_address'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    delete_server(**kwargs)