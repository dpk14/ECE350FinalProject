from util.util import *
from Compressor import Compressor
from PIL import Image
from mif import Mif
from rgb import RGB
from MifEntry import MifEntry
import argparse as ap
from os.path import basename, dirname
import os
import numpy as np

args = ap.ArgumentParser()
args.add_argument('files', nargs="+")
inputs = args.parse_args()


for f in inputs.files: 
    im=Image.open(f)
    im=im.convert("RGB")
    im=np.array(im)
    im= Image.fromarray(im)
    im.save(f)
