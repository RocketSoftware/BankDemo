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

Description:  Function for configuring a Micro Focus server region. 
"""

import os
import sys
import requests
from utilities.misc import create_headers, check_http_error
from utilities.input import read_json, read_txt
from utilities.session import get_session, save_cookies
from utilities.exceptions import ESCWAException, InputException, HTTPException

def add_sor(sor_name, ip_address, sor_description, sorType, sorConnectPath, template_file):
    """ Adds a SOR. """
    uri = 'http://{}:10086/server/v1/config/groups/sors'.format(ip_address)
    req_headers = create_headers('CreateRegion', ip_address)

    esp_alias = '$ESP'
    try:
        req_body = read_json(template_file)
    except InputException as exc:
        raise ESCWAException('Unable to read template file: {}.'.format(template_file)) from exc

    req_body['SorName'] = sor_name
    req_body['Sor_description'] = sor_description
    req_body['SorType'] = sorType
    req_body['SorConnectPath'] = sorConnectPath
    session = get_session()

    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Add SOR API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Add SOR API request.') from exc

    save_cookies(session.cookies)

    return res

def add_pac(pac_name, ip_address, pac_description, sorUid, template_file):
    """ Adds a PAC. """
    uri = 'http://{}:10086/server/v1/config/groups/pacs'.format(ip_address)
    req_headers = create_headers('CreateRegion', ip_address)
    try:
        req_body = read_json(template_file)
    except InputException as exc:
        raise ESCWAException('Unable to read template file: {}.'.format(template_file)) from exc
    req_body['PacName'] = pac_name
    req_body['PacDescription'] = pac_description
    req_body['PacResourceSorUid'] = sorUid
    session = get_session()

    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Add PAC API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Add PAC API request.') from exc

    save_cookies(session.cookies)

    return res
