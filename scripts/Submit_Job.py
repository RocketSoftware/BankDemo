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

Description:  A script to submit a JCL job to the Micro Focus JES server region.
"""

import sys
from ESCWA.escwa_session import EscwaSession
from utilities.misc import parse_args
from ESCWA.job_control import submit_jcl, check_job
from utilities.exceptions import ESCWAException


def submit_job(jcl_file, working_folder, ip_address='127.0.0.1', region_name='BANKDEMO'):
    session = EscwaSession("http", ip_address, 10086)
    try:
        submit_res = submit_jcl(session, region_name, ip_address, jcl_file)
    except ESCWAException as exc:
        print('Unable to submit job.')
        sys.exit(1)

    submit_res = submit_res.json()
    job_id = submit_res['JobMsg'][0].split()[1]

    print('', submit_res['JobMsg'][0], submit_res['JobMsg'][1], sep='\n')

    try:
        run_res = check_job(session, region_name, ip_address, job_id)
    except ESCWAException as exc:
        print('Unable to check job.')
        sys.exit(1)

    run_res = run_res.json()

    print('', run_res['SysoutMsgs'][0], run_res['SysoutMsgs'][1])


if __name__ == '__main__':
    # Use : after short_map keys and = after long_map keys to indicate required arguments as in getopt
    short_map = {}
    long_map = {
        '--RegionName': 'region_name',
        '--RegionHost': 'ip_address',
        '--JCLFileName=': 'jcl_file',
        '--WSpaceFolder=': 'working_folder'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    submit_job(**kwargs)