#!/usr/bin/env python

import os
import pwd
import sys
import time
from Pegasus.DAX3 import *

# The name of the DAX file is the first argument
if len(sys.argv) != 3:
        sys.stderr.write("Usage: %s DAXFILE LOCAL_PATH \n" % (sys.argv[0]))
        sys.exit(1)
daxfile = sys.argv[1]
wd = sys.argv[2]

USER = pwd.getpwuid(os.getuid())[0]

dax = ADAG("pipeline")

# Add input files and iyt
imgIn = File("image.png")
imgIn.addPFN(PFN("file://{}/input/image.png".format(wd),"local"))
dax.addFile(imgIn)
script = File("rgb2grey.py")
script.addPFN(PFN("file://{}/code/rgb2grey.py".format(wd),"local"))
dax.addFile(script)

# Add executables to the DAX-level replica catalog
img_process = Executable(namespace="dax", name="pipeline.sh", installed=False, version="4.0", os="linux", arch="x86_64")
img_process.metadata("size", "2048")
img_process.addPFN(PFN("file://{}/code/pipeline.sh".format(wd),"local"))
dax.addExecutable(img_process)

# Add image processing job
imgOut = File("output.png")
process = Job(img_process)
process.addArguments(script, imgIn, imgOut)
process.uses(imgIn, link=Link.INPUT)
process.uses(script, link=Link.INPUT)
process.uses(imgOut, link=Link.OUTPUT, transfer=True)
dax.addJob(process)

# Write the DAX to a file
f = open(daxfile, "w")
dax.writeXML(f)
f.close()

