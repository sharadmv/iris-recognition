from skimage.data import imread
from skimage.util import img_as_ubyte
import glob

class Dataset:
    def __init__(self, dir, suffix='.bmp'):
        self.dir = dir
        self.suffix = suffix
        self.images = []
        for name in glob.glob("%s/*%s" % (dir, suffix)):
            self.images.append(name)

    def read(self, name, flatten=True):
        return img_as_ubyte(imread(name, flatten))
