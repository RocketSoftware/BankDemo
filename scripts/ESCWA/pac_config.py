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

from utilities.input import read_json
from utilities.exceptions import ESCWAException, InputException

def find_sor(session, sor_name):
    """ Adds a SOR. """
    uri = 'server/v1/config/groups/sors'
    res = session.get(uri, 'Unable to get SOR information.')
    sors = res.json()
    for sor in sors:
        if sor['SorName'] == sor_name:
            return sor['Uid']
    return None

def add_sor(session, sor_name, sor_description, sorType, sorConnectPath, template_file):
    """ Adds/updates a SOR. """
    try:
        req_body = read_json(template_file)
    except InputException as exc:
        raise ESCWAException('Unable to read template file: {}.'.format(template_file)) from exc
    req_body['SorName'] = sor_name
    req_body['SorDescription'] = sor_description
    req_body['SorType'] = sorType
    req_body['SorConnectPath'] = sorConnectPath
    sorUid = find_sor(session, sor_name)
    if sorUid is None:
        uri = 'server/v1/config/groups/sors'
        res = session.post(uri, req_body, 'Unable to complete Add SOR API request.')
    else:
        uri = 'server/v1/config/groups/sors/{}'.format(sorUid)
        res = session.put(uri, req_body, 'Unable to complete Update SOR API request.')

    return res

def add_pac(session, pac_name, pac_description, sorUid, template_file):
    """ Adds a PAC. """
    pacs = get_pacs(session).json()
    pacUid = None
    for pac in pacs:
        if pac['PacName'] == pac_name:
            pacUid = pac['Uid']
            break

    try:
        req_body = read_json(template_file)
    except InputException as exc:
        raise ESCWAException('Unable to read template file: {}.'.format(template_file)) from exc
    req_body['PacName'] = pac_name
    req_body['PacDescription'] = pac_description
    req_body['PacResourceSorUid'] = sorUid
    if pacUid is None:
        uri = 'server/v1/config/groups/pacs'
        res = session.post(uri, req_body, 'Unable to complete Add PAC API request.')
    else:
        uri = 'server/v1/config/groups/pacs/{}'.format(pacUid)
        res = session.put(uri, req_body, 'Unable to complete Update PAC API request.')

    return res

def get_pacs(session):
    uri = 'server/v1/config/groups/pacs'
    res = session.get(uri, 'Unable to complete get PAC list API request.')
    return res

def install_region_into_pac(session, ip_address, region_name, pac_uid, template_file):
    uri = 'native/v1/config/groups/pacs/{}/install'.format(pac_uid)
    try:
        req_body = read_json(template_file)
    except InputException as exc:
        raise ESCWAException('Unable to read template file: {}.'.format(template_file)) from exc
    req_body['Regions'][0]['Host'] = ip_address
    req_body['Regions'][0]['Port'] = "86"
    req_body['Regions'][0]['CN'] = region_name
    res = session.post(uri, req_body, 'Unable to complete install PAC region API request.')
    return res
