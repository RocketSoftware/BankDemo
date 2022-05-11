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

Description:  A script to create a Micro Focus server region. 
"""

import os
import sys

#updates a value in JSON file
#MF_Configure_Json.py <key> <value>
#MF_Configure_Json.py <key> <subkey> <value>

#converts string 'True' 'False' to bool type
def toValue(s):
  d = {'True': True, 'False': False, 'true': True, 'false': False}
  return d.get(s, s)

from utilities.input import read_json, write_json
cfgfile = sys.argv[1]
json = read_json(cfgfile)
if len(sys.argv) == 4:
  json[sys.argv[2]] = toValue(sys.argv[3])
if len(sys.argv) == 5:
  json[sys.argv[2]][sys.argv[3]] = toValue(sys.argv[4])
write_json(cfgfile, json)

