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
from utilities.output import write_log 
from utilities.misc import create_headers, check_http_error
from utilities.input import read_json, read_txt
from utilities.session import get_session, save_cookies
from utilities.exceptions import ESCWAException, InputException, HTTPException


def update_region(region_name, ip_address, template_file, env_file, region_description, region_base):
    """ Updates the settings of a previously created region on the Micro Focus server. """

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}'.format(ip_address, '127.0.0.1', region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    esp_alias = '$ESP'
    if sys.platform.startswith('win32'):
        path_sep = ';'
        log_dir = os.path.join(esp_alias, 'logs')
    else:
        path_sep = ':'
        log_dir = '' # system dir unsupported on Unix/Linux

    loadlib_dir = os.path.join(esp_alias, 'loadlib')
    catalog_dir = os.path.join(esp_alias, 'catalog')
    catalog_data_dir = os.path.join(catalog_dir, 'data')
    #data_dir = os.path.join(esp_alias, 'Data')
    rdef_dir = os.path.join(esp_alias, 'rdef')

    catalog_file = os.path.join(catalog_dir, 'CATALOG.DAT')
    lib_path = loadlib_dir

    try:
        req_body = read_json(template_file)
    except InputException as exc:
        raise ESCWAException('Unable to read template file: {}.'.format(template_file)) from exc

    try:
        env_json = read_json(env_file)
    except InputException as exc:
        raise ESCWAException('Unable to read env file: {}.'.format(env_file)) from exc

    # Flatten and format environment json into flat text
    env_key = next(iter(env_json))
    env_json[env_key]['ESP'] = region_base
    env_list = [key + '=' + val for key, val in env_json[env_key].items()]

    req_body['CN'] = region_name
    req_body['mfConfig'] = '\n'.join([env_key] + env_list)
    req_body['description'] = region_description
    req_body['mfCASSysDir'] = log_dir
    req_body['mfCASTXTRANP'] = lib_path
    req_body['mfCASTXFILEP'] = catalog_data_dir
    req_body['mfCASTXMAPP'] = lib_path
    req_body['mfCASTXRDTP'] = rdef_dir
    req_body['mfCASJCLPATH'] = lib_path
    req_body['mfCASMFSYSCAT'] = catalog_file
    req_body['mfCASJCLALLOCLOC'] = catalog_data_dir

    #print(req_body)

    session = get_session()

    try:
        res = session.put(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Update Region API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Update Region API request.') from exc

    save_cookies(session.cookies)

    return res

def update_region_attribute(region_name, ip_address, attribute_details):

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}'.format(ip_address, '127.0.0.1', region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    req_body=attribute_details

    session = get_session()

    try:
        res = session.put(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Update Region API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Update Region API request.') from exc

    save_cookies(session.cookies)

    return res
    
def update_alias(region_name, ip_address, alias_file):
    """ Updates the aliases on a Micro Focus Server. """

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/alias'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    try:
        req_body = read_json(alias_file)
    except InputException as exc:
        raise ESCWAException('Unable to read alias file: {}'.format(alias_file)) from exc

    session = get_session()

    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Update Alias API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Update Alias API request.') from exc

    save_cookies(session.cookies)

    return res


def add_initiator(region_name, ip_address, template_file):
    """ Adds an initiator to a Micro Focus server. """

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/initiator'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    try:
        req_body = read_json(template_file)
    except InputException as exc:
        raise ESCWAException('Unable to read initiator file: {}'.format(template_file))

    req_body['CN'] = region_name
    session = get_session()

    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Add Initiator API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Add Initiator API request.') from exc

    save_cookies(session.cookies)

    return res


def add_datasets(region_name, ip_address, datafile_list, mfdbfh_location):
    """ Adds data sets to a Micro Focus server. """

    req_headers = create_headers('CreateRegion', ip_address)

    try:
        dataset_list = [read_json(data_file) for data_file in datafile_list]
    except InputException as exc:
        raise ESCWAException('Unable to read dataset files')

    responses = []
    session = get_session()

    for dataset in dataset_list:
        jDSN = dataset['jDSN']
        uri = 'http://{}:10086/native/v1/regions/{}/86/{}/catalog/{}'.format(ip_address, ip_address, region_name, jDSN)
        try:
            if mfdbfh_location is not None:
                # sql://bank_mfdbfh/VSAM/{}?folder=/data
                jPCN = os.path.basename(dataset['jPCN'])
                jPCN = mfdbfh_location.format(jPCN)
                dataset['jPCN'] = jPCN
            res = session.post(uri, headers=req_headers, json=dataset)
            check_http_error(res)
        except requests.exceptions.RequestException as exc:
            raise ESCWAException('Unable to complete Add Dataset API request.') from exc
        except HTTPException as exc:
            raise ESCWAException('Unable to complete Add Dataset API request.') from exc

        responses.append(res)

    save_cookies(session.cookies)

    return responses