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

Description:  A series of utility functions for updating resource defs. 
"""

import os
import sys
import requests
import json
from utilities.misc import create_headers, check_http_error
from utilities.input import read_json, read_txt
from utilities.output import write_log
from utilities.session import get_session, save_cookies
from utilities.exceptions import ESCWAException, InputException, HTTPException

def add_sit(region_name, ip_address, sit_details):
    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/sit'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    session = get_session()

    req_body =sit_details
    
    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Update Startup API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Update Startup API request.') from exc

    save_cookies(session.cookies)

    return res


def add_Startup_list(region_name, ip_address, startup_details):
    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/startup'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    session = get_session()

    req_body =startup_details
    
    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Update Startup API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Update Startup API request.') from exc

    save_cookies(session.cookies)

    return res

def add_groups(region_name, ip_address, group_details):
    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/groups'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    session = get_session()

    for new_group in group_details['ResourceGroups']:
        req_body =new_group
        write_log('Adding Resource Group {}'.format(req_body["resNm"]))
        try:
            res = session.post(uri, headers=req_headers, json=req_body)
            check_http_error(res)
        except requests.exceptions.RequestException as exc:
            raise ESCWAException('Unable to complete Update Group API request.') from exc
        except HTTPException as exc:
            raise ESCWAException('Unable to complete Update Group API request.') from exc

        save_cookies(session.cookies)

    return res

def add_fct(region_name, ip_address, group_name, fct_details):
    
    req_headers = create_headers('CreateRegion', ip_address)

    session = get_session()

    for fct_entry in fct_details['FCT_Entries']:
        resource_name = fct_entry['Resource']
        req_body = fct_entry['Parameters']
        uri = 'http://{}:10086/native/v1/regions/{}/86/{}/fct/detail/{}/{}'.format(ip_address, ip_address, region_name, group_name, resource_name)

        try:
            res = session.post(uri, headers=req_headers, json=req_body)
            check_http_error(res)
        except requests.exceptions.RequestException as exc:
            raise ESCWAException('Unable to complete Update FCT API request.') from exc
        except HTTPException as exc:
            raise ESCWAException('Unable to complete Update FCT API request.') from exc

        save_cookies(session.cookies)

def add_ppt(region_name, ip_address, group_name, ppt_details):
    
    req_headers = create_headers('CreateRegion', ip_address)

    session = get_session()

    for ppt_entry in ppt_details['PPT_Entries']:
        resource_name = ppt_entry['Resource']
        req_body = ppt_entry['Parameters']
        uri = 'http://{}:10086/native/v1/regions/{}/86/{}/ppt/detail/{}/{}'.format(ip_address, ip_address, region_name, group_name, resource_name)

        try:
            res = session.post(uri, headers=req_headers, json=req_body)
            check_http_error(res)
        except requests.exceptions.RequestException as exc:
            raise ESCWAException('Unable to complete Update PPT API request.') from exc
        except HTTPException as exc:
            raise ESCWAException('Unable to complete Update PPT API request.') from exc

        save_cookies(session.cookies)

def add_pct(region_name, ip_address, group_name, pct_details):
    
    req_headers = create_headers('CreateRegion', ip_address)

    session = get_session()

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    for pct_entry in pct_details['PCT_Entries']:
        resource_name = pct_entry['Resource']
        req_body = pct_entry['Parameters']
        uri = 'http://{}:10086/native/v1/regions/{}/86/{}/pct/detail/{}/{}'.format(ip_address, ip_address, region_name, group_name, resource_name)

        try:
            res = session.post(uri, headers=req_headers, json=req_body)
            check_http_error(res)
        except requests.exceptions.RequestException as exc:
            raise ESCWAException('Unable to complete Update PCT API request.') from exc
        except HTTPException as exc:
            raise ESCWAException('Unable to complete Update PCT API request.') from exc

        save_cookies(session.cookies)

def update_sit_in_use(region_name, ip_address, sit_name):
    uri = 'http://{}:10086/native/v1/regions/{}/86/{}'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address) 

    session = get_session()

    sit_attribute ='{\"mfCASCICSSIT\": \"' + sit_name + '\"}'
    req_body = json.loads(sit_attribute)

    try:
        res = session.put(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Update region attribute request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Update region attribute request.') from exc

    save_cookies(session.cookies)