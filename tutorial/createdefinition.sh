#! /bin/sh

###############################################################
# Copyright (C) 2022 Micro Focus.  All Rights Reserved
# This software may be used, modified, and distributed
# (provided this notice is included without modification)
# solely for internal demonstration purposes with other
# Micro Focus software, and is otherwise subject to the EULA at
# https://www.microfocus.com/en-us/legal/software-licensing.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ALL IMPLIED
# WARRANTIES, INCLUDING THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE,
# SHALL NOT APPLY.
# #TO THE EXTENT PERMITTED BY LAW, IN NO EVENT WILL
# MICRO FOCUS HAVE ANY LIABILITY WHATSOEVER IN CONNECTION
# WITH THIS SOFTWARE.
###############################################################

SCRIPTDIR="$(dirname "$(readlink -f "$0")")"
if [ $# = 0 ]; then
    FILEPATH="$SCRIPTDIR"
else
    FILEPATH=$1
fi

if [ ! -d "$FILEPATH" ]; then
    echo "WARNING: Path does not exist."
fi
WRITEXML="y"
if [ -f "$SCRIPTDIR/BANKDEMO.xml" ]; then
    if [ -f "$SCRIPTDIR/BANKDEMO.xml.bak" ]; then
        echo "$SCRIPTDIR/BANKDEMO.xml.bak already exists. Do you want to override? (y/n) "
        read WRITEXML
        if [ "$WRITEXML" = "y" -o "$WRITEXML" = "Y" ]; then
            cp "$SCRIPTDIR/BANKDEMO.xml" "$SCRIPTDIR/BANKDEMO.xml.bak"
        fi
    fi

fi
if [ "$WRITEXML" = "y" -o "$WRITEXML" = "Y" ]; then
    cp "$SCRIPTDIR/BANKDEMO.template" "$SCRIPTDIR/BANKDEMO.xml"
    sed -i -e "s!__IMPORT_FILE_DIR__!$FILEPATH!" "$SCRIPTDIR/BANKDEMO.xml" 
    sed -i -e "s!PS=;!PS=:!" "$SCRIPTDIR/BANKDEMO.xml"
    sed -i -e "s!OS=Windows!OS=Linux!" "$SCRIPTDIR/BANKDEMO.xml"
else
    echo "Error: Enterprise Server definition was not created."
fi