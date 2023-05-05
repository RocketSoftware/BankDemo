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

Description:  A script configure json options files. 
"""

import os
import sys
import json

#updates a specified field value in a JSON file
#This is used to programatically configure the options file such as vsam_postgres_pac.json before MF_Provision_Region.py is called
#MF_Configure_Json.py <json_file> <key> <value_type> <value>
#MF_Configure_Json.py <json_file> <key> <subkey> <value_type> <value>

#when value_type is 'json' the value is interpreted as a json object instead of a string
#so for example "['a', 'b']" will be stored as this:
#field = ['a', 'b']
#instead of this:
#field = "['a', 'b']"

#converts given value to the correct type
def convert_value(value, value_type):
  if value_type == "json":
    return json.loads(value)
  #if input is a bool string such as 'True' or 'False' it is converted to an actual bool type
  d = {'True': True, 'False': False, 'true': True, 'false': False}
  return d.get(value, value) 

from utilities.input import read_json, write_json
cfgfile = sys.argv[1]
key = sys.argv[2]
cfg_json = read_json(cfgfile)
if len(sys.argv) == 5:
  value_type = sys.argv[3]
  value = sys.argv[4]
  value = convert_value(value, value_type)
  cfg_json[key] = value
if len(sys.argv) == 6:
  subkey = sys.argv[3]
  value_type = sys.argv[4]
  value = sys.argv[5]
  value = convert_value(value, value_type)
  cfg_json[key][subkey] = value
write_json(cfgfile, cfg_json)

