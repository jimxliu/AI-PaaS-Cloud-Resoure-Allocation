#!/bin/bash

DIR=$(cd $(dirname $0) && pwd)

if [ $# -ne 2 ]; then
    echo "Usage: $0 DAXFILE SITES"
    exit 1
fi

DAXFILE=$1
SITES=$2
if [ -z $SITES ]
then
    exit 2
fi

# This command tells Pegasus to plan the workflow contained in 
# dax file passed as an argument. The planned workflow will be stored
# in the "submit" directory. The execution # site is "".
# --input-dir tells Pegasus where to find workflow input files.
# --output-dir tells Pegasus where to place workflow output files.
pegasus-plan --conf pegasus.properties \
    --dax $DAXFILE \
    --dir $DIR/submit \
    --input-dir $DIR/input \
    --output-dir $DIR/output \
    --cleanup leaf \
    --force \
    --sites $SITES \
    --submit
