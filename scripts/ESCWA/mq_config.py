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

def add_mq_listener(session, region_name, ip_address, mq_details):
    uri = 'native/v1/regions/{}/{}/{}/mqlistener'.format(ip_address, os.getenv("CCITCP2_PORT","86"), region_name)
    req_body = mq_details
    res = session.post(uri, req_body, 'Unable to complete Update Startup API request.')
    return res
