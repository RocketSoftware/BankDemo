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

Description:  A series of utility functions for updating MQ Listeners. 
"""

import os
import sys
import requests
from utilities.misc import create_headers, check_http_error
from utilities.input import read_json, read_txt
from utilities.session import get_session, save_cookies
from utilities.exceptions import ESCWAException, InputException, HTTPException

def add_mq_listener(region_name, ip_address, mq_details):
    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/mqlistener'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)

    session = get_session()

    req_body =mq_details
    
    try:
        res = session.post(uri, headers=req_headers, json=req_body)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to complete Update Startup API request.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to complete Update Startup API request.') from exc

    save_cookies(session.cookies)

    return res
