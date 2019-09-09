#!/bin/bash
set -e
virtualenv env2.7
source env2.7/bin/activate
python -m pip install --upgrade pip
pip install Pillow

python "$@" # rgb2grey.py imgIn imgOut 	

deactivate
rm -rf env2.7
