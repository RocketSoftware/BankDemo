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

Description:  A script to add/update the CICS resource definitions. 
"""

import os
import sys
import glob

from pathlib import Path
from utilities.input import read_json, read_txt
from utilities.misc import parse_args 
from database.mfpostgres import  Connect_to_PG_server, Execute_PG_Command, Disconnect_from_PG_server, Create_ODBC_Data_Source
def load_database():

    cwd = os.getcwd()

    main_configfile = os.path.join(cwd, 'config', 'demo.json')
    main_config = read_json(main_configfile)

    database_type= main_config["database"]

    sql_folder= os.path.join(cwd, 'config', 'database', database_type)
    
    
    if  database_type == 'PostGres':
        odbc_out = Create_ODBC_Data_Source('localhost','5432','postgres','postgres','J@sp3rTh0m@s')
        conn = Connect_to_PG_server('localhost','5432','postgres','postgres','J@sp3rTh0m@s')
        sql_file = os.path.join(sql_folder, 'create.sql')
        sql_command = read_txt(sql_file)
        execute_res = Execute_PG_Command(conn, sql_command)
        dconn_res = Disconnect_from_PG_server(conn)
        conn = Connect_to_PG_server('localhost','5432','bank','postgres','J@sp3rTh0m@s')
        sql_file = os.path.join(sql_folder, 'tables.sql')
        sql_command = read_txt(sql_file)
        execute_res = Execute_PG_Command(conn, sql_command)
        dconn_res = Disconnect_from_PG_server(conn)
   
if __name__ == '__main__':
    load_database()