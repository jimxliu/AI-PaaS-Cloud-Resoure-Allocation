import sys
from PIL import Image

# The name of the DAX file is the first argument
if len(sys.argv) != 3:
        sys.stderr.write("Usage: %s rgb2grey, need 1 image file and 1 output file\n" % (sys.argv[0]))
        sys.exit(1)
imgIn = sys.argv[1]
imgOut = sys.argv[2]

img = Image.open(imgIn).convert('LA')
img.save(imgOut)

