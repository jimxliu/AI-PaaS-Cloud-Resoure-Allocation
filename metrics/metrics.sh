#!/bin/bash

top -u $USER -b -n 1 | sed -n '8,$p' > top.log

python metrics.py 

