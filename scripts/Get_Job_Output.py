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

Description:  A script to get the output from a job previously submitted to the Micro Focus JES server.
"""

import sys
import os
from ESCWA.escwa_session import EscwaSession
from ESCWA.job_control import check_job, get_output
from utilities.misc import parse_args
from utilities.exceptions import ESCWAException

def get_job_output(job_id, working_folder, ip_address='127.0.0.1', region_name='BANKDEMO'):
    session = EscwaSession("http", ip_address, 10086)
    try:
        check_res = check_job(session, region_name, ip_address, job_id)
    except ESCWAException as exc:
        print('Unable to check job status.')
        sys.exit(1)

    check_res = check_res.json()
    out_dir = os.path.join(working_folder, 'Output')

    print('', check_res['SysoutMsgs'][0], check_res['SysoutMsgs'][1], sep='\n')

    if check_res['JobStatus'] != 'Complete ':
        print('Job is not yet complete.')
        sys.exit(1)

    if not os.path.isdir(out_dir):
        os.mkdir(out_dir)

    for spool_out in check_res['JobDDs']:
        try:
            out_res = get_output(session, region_name, ip_address, spool_out['DDEntityName'], spool_out['DDCode'])
        except ESCWAException as exc:
            print('Unable to get job output.')
            sys.exit(1)

        out_res = out_res.json()

        out_filename = '{}_{}_{}.txt'.format(check_res['JobName'], job_id, spool_out['DDName'])
        out_path = os.path.join(out_dir, out_filename)
        line_count = int(spool_out['DDRecords'])

        try:
            with open(out_path, 'w') as file:
                for i in range(line_count):
                    file.write(out_res['Messages'][i] + '\n')
        except IOError as exc:
            print('Unable to write output to file.')
            sys.exit(1)


if __name__ == "__main__":
    short_map = {}
    long_map = {
        '--RegionName': 'region_name',
        '--RegionHost': 'ip_address',
        '--JobID=': 'job_id',
        '--WSpaceFolder=': 'working_folder'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    get_job_output(**kwargs)