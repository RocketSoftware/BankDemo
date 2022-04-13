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

Description:  Miscelaneous utility functions. 
"""

import getopt
import winreg
from utilities.output import write_log 
from utilities.exceptions import HTTPException


def get_elem_with_prop(arr, key, value):
    """ Gets an array object with a specific property"""
    for elem in arr:
        if elem[key] == value:
            return elem


def create_headers(requested_with, ip_address):
    """ Creates headers for sending API requests to the Micro Focus server. """

    headers = {
        'accept': 'application/json',
        'X-Requested-With': requested_with,
        'Content-Type': 'application/json',
        'Origin': 'http://{}:10086'.format(ip_address)
        #'Origin': 'http://{}:10086'.format('127.0.0.1')
    }

    return headers


def check_http_error(res):
    """ Error handling for HTTP status codes. """
    if res.status_code >= 400 and res.status_code < 500:
        raise HTTPException('A general Client Error occured.')
    if res.status_code >= 500 and res.status_code < 600:
        raise HTTPException('A general Server Error occured.')


def parse_args(arg_list, short_map, long_map):
    """ Parses arguments passed on the command line. """

    short_opts = "".join([key.lstrip('-') for key in short_map.keys()])
    long_opts = [key.lstrip('-') for key in long_map.keys()]

    try:
        opts, args = getopt.getopt(arg_list, short_opts, long_opts)
    except getopt.GetoptError as error:
        print(error)
        return None

    short_map = {key.rstrip(':'): val for key, val in short_map.items()}
    long_map = {key.rstrip('='): val for key, val in long_map.items()}
    arg_map = {**short_map, **long_map}

    kwargs = {arg_map[opt[0]]: opt[1] for opt in opts}

    return kwargs

def set_MF_environment (os_type):

    if os_type == 'Windows':
       localMachineKey = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
       cobolKey = winreg.OpenKey(localMachineKey, r"SOFTWARE\\Micro Focus\\Visual COBOL")
       defaultVersion = winreg.QueryValueEx(cobolKey, "DefaultVersion")
       installKeyString =  r'{}\\COBOL\\Install'.format(defaultVersion[0])
       write_log('Found COBOL version: {}'.format(defaultVersion[0]))
       installKey = winreg.OpenKey(cobolKey, installKeyString)
       install_dir = winreg.QueryValueEx(installKey, "BIN")
       winreg.CloseKey(installKey)
       winreg.CloseKey(cobolKey)
       winreg.CloseKey(localMachineKey)
       return install_dir[0]
       
    return ''