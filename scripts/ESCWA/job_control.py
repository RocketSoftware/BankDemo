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

Description:  Functions for control of jobs sent to the Micro Focus server region. 
"""

import time
import requests
from utilities.misc import create_headers, check_http_error
from utilities.session import get_session, save_cookies
from utilities.exceptions import ESCWAException, HTTPException


def submit_jcl(region_name, ip_address, jcl_file):
    """ Submits a JCL to the Micro Focus JES Server. """

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/jescontrol'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('JESProcess', ip_address)
    req_body = {
        'ctlSubmit': 'Submit',
        'subJes': 2,
        'xatSwitch': jcl_file
    }

    session = get_session()

    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete JCL Submit API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete JCL Submit API request.') from exc

    save_cookies(session.cookies)

    return res


def check_job(region_name, ip_address, job_id):
    """ Checks on the status of a job previously submitted to the Micro Focus JES server. """

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/jobview/{}'.format(ip_address, ip_address, region_name, job_id)
    req_headers = create_headers('JESProcess', ip_address)
    session = get_session()

    for i in range(3):
        try:
            res = session.get(uri, headers=req_headers)
            check_http_error(res)
        except requests.exceptions.RequestException as exc:
            raise ESCWAException('Unable to complete Job Check API request.') from exc
        except HTTPException as exc:
            raise ESCWAException('Unable to complete Job Check API request.') from exc

        if res.json()['JobStatus'] == 'Complete ':
            save_cookies(session.cookies)

            return res

        if i != 0:
            time.sleep(60)

    save_cookies(session.cookies)
    
    return res


def get_output(region_name, ip_address, job_id, charset):
    """ Gets the output of a job previously submitted to the Micro Focus JES server. """

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/spool/{}/display'.format(ip_address, ip_address, region_name, job_id)
    req_headers = create_headers('JESProcess', ip_address)
    req_params = {
        'jSvStart': 1,
        'jSvFor': 10000,
        'jSvCode': charset
    }

    session = get_session()

    try:
        res = session.get(uri, headers=req_headers, params=req_params)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Job Ouput API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Job Ouput API request.') from exc

    save_cookies(session.cookies)

    return res