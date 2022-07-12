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

Description:  A function to setup a JES listener on the Micro Focus server. 
"""

import requests
from utilities.misc import get_elem_with_prop, create_headers, check_http_error
from utilities.session import get_session, save_cookies
from utilities.exceptions import ESCWAException, HTTPException


def set_jes_listener(region_name, ip_address, port):
    """ Sets a JES listener on the Micro Focus server. """

    uri = 'http://{}:10086/native/v1/regions/{}/86/{}/commsserver'.format(ip_address, ip_address, region_name)
    req_headers = create_headers('CreateRegion', ip_address)
    session = get_session()

    try:
        res = session.get(uri, headers=req_headers)
        check_http_error(res)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to get Comm Server information.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to get Comm Server information.') from exc

    comm_server = res.json()
    uri += '/{}/listener'.format(comm_server[0]['mfServerUID'])

    try:
        res = session.get(uri, headers=req_headers)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to get Comm Server Listener information.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to get Comm Server Listener information.') from exc

    listener_list = res.json()
    req_body = {'mfRequestedEndpoint': 'tcp:127.0.0.1:{}'.format(port)}
    listener = get_elem_with_prop(listener_list, 'CN', 'Web Services and J2EE')
    uri += '/{}'.format(listener['mfUID'])
    
    try:
        res = session.put(uri, headers=req_headers, json=req_body)
    except requests.exceptions.RequestException as exc:
        raise ESCWAException('Unable to update Web Services and J2EE Listener.') from exc
    except HTTPException as exc:
        raise ESCWAException('Unable to update Web Services and J2EE Listener.') from exc

    save_cookies(session.cookies)
    
    return res