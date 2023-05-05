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

Description:  Functions for configuration of MFDS lists on the Micro Focus server.
"""

def check_mfds_list(session):
    """ Check the MFDS list of a Micro Focus server. """
    res = session.get('server/v1/config/mfds', 'Unable to complete Check MFDS API request.')
    return res

def add_mfds_to_list(session, mfds_host, mfds_port, mfds_description):
    """ Add an MFDS to a Micro Focus server. """
    uri = 'server/v1/config/mfds'
    req_body = {
        'MfdsHost': mfds_host,
        'MfdsPort': mfds_port,
        'MfdsIdentifier': mfds_host,
        'MfdsDescription': mfds_description
    }
    res = session.post('server/v1/config/mfds', req_body, 'Unable to complete Add MFDS API request.')
    return res