#!/usr/bin/python3

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

Description:  A script to create a Micro Focus PAC definition
"""

import sys
import os
from ESCWA.escwa_session import EscwaSession
from utilities.misc import parse_args
from ESCWA.pac_config import add_pac, add_sor
from utilities.exceptions import ESCWAException
from utilities.output import write_log 

def create_pac(session, config_dir, pac_name, psor_connection, pac_description="pac", psor_type="redis"):
    write_log("Creating PAC {} with PSOR {}".format(pac_name, psor_connection))
    addsor_config = os.path.join(config_dir, 'addsor.json')
    try:
        print ('PSOR \033[1m{}\033[0m being added'.format("BANKPSOR"))
        sor=add_sor(session, "BANKPSOR", "desc", psor_type, psor_connection, addsor_config).json()
    except ESCWAException as exc:
        print('Unable to create PSOR.')
        print(exc)
        sys.exit(1)
        
    addpac_config = os.path.join(config_dir, 'addpac.json')
    try:
        pac=add_pac(session, pac_name, pac_description, sor['Uid'], addpac_config).json()
    except ESCWAException as exc:
        print('Unable to add PAC.')
        sys.exit(1)
    print('PAC created successfully')

if __name__ == '__main__':
    short_map = {}
    long_map = {
        '--PacName=': 'pac_name',
        '--PacDescription=': 'pac_description',
        '--PsorType=': 'psor_type',
        '--PsorConnection=': 'psor_connection',
        '--MFDSIPAddress': 'ip_address'
    }

    kwargs = parse_args(sys.argv[1:], short_map, long_map)
    session = EscwaSession("http", ip_address, 10086)
    cwd = os.getcwd()
    config_dir = os.path.join(cwd, 'config')
    create_pac(session, config_dir, pac_name, psor_connection, pac_description, psor_type)