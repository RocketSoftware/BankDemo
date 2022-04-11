#! /bin/sh
SCRIPTDIR="$(dirname "$(readlink -f "$0")")"
if [ $# = 0 ]; then
    FILEPATH="$SCRIPTDIR"
else
    FILEPATH=$1
fi

if [ ! -d "$FILEPATH" ]; then
    echo "WARNING: Path does not exist."
fi
WRITEBAK="y"
if [ -f "$SCRIPTDIR/BANKDEMO.xml.bak" ]; then
    echo "$SCRIPTDIR/BANKDEMO.xml.bak already exists. Do you want to override? (y/n) "
    read WRITEBAK
fi
if [ "$WRITEBAK" = "y" -o "$WRITEBAK" = "Y" ]; then
    cp "$SCRIPTDIR/BANKDEMO.xml" "$SCRIPTDIR/BANKDEMO.xml.bak"
fi
sed -i -e "s!__IMPORT_FILE_DIR__!$FILEPATH!" "$SCRIPTDIR/BANKDEMO.xml" 
sed -i -e "s!PS=;!PS=:!" "$SCRIPTDIR/BANKDEMO.xml"
sed -i -e "s!OS=windows!OS=amzn2_linux!" "$SCRIPTDIR/BANKDEMO.xml"