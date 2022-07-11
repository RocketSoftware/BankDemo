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

Description:  A series of utility functions for reading input. 
"""

import json
from utilities.exceptions import InputException


def read_json(file_path):
    try:
        with open(file_path, 'r') as file:
            input_json = json.load(file)
    except IOError as exc:
        raise InputException from exc

    return input_json

def write_json(file_path, content):
    try:
        with open(file_path, 'w') as file:
            json.dump(content, file)
    except IOError as exc:
        raise InputException from exc

def read_txt(file_path):
    try:
        with open(file_path, 'r') as file:
            input_txt = file.read()
    except IOError as exc:
        raise InputException from exc

    return input_txt
