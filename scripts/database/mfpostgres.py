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

Description:  PostGres utility functions. 
"""
import psycopg2

def Connect_to_PG_server(database_host, database_port, database_name, database_user, database_password):

    connection_details = 'host={} port={} dbname={} user={} password={}'.format(database_host, database_port, database_name, database_user, database_password)
    PGconn = psycopg2.connect (connection_details)

    PGconn.autocommit = True

    return PGconn

def Execute_PG_Command(PGconn, sql_command):

    PGcursor = PGconn.cursor()

    PGcursor.execute(sql_command)

def Disconnect_from_PG_server(PGconn):

    PGconn.close