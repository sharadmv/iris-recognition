import os
import re
import numpy as np
from scipy.misc import imread
from scipy.io import savemat

mat = {'left' : {'x':[], 'y':[]}, 'right': {'x':[],'y':[]}}
def gather(folder, name):
    temp = None
    left = [(folder+"/right/"+x) for x in os.listdir(folder+"/right/") if re.match('[0-9].bmp', x)]
    right = [(folder+"/left/"+x) for x in os.listdir(folder+"/left/") if re.match('[0-9].bmp', x)]
    for image in left:
        print image
        mat['left']['x'].append(imread(image, flatten=True))
        mat['left']['y'].append(int(image.split('/')[1]))
    for image in right:
        print image
        mat['right']['x'].append(imread(image, flatten=True))
        mat['right']['y'].append(int(image.split('/')[1]))
    return temp

if __name__ == "__main__":
    for f in os.listdir("MMU"):
        if os.path.isdir("MMU/"+f):
            gather("MMU/"+f, f)
    mat['left']['x'] = np.array(mat['left']['x'])
    mat['right']['x'] = np.array(mat['right']['x'])
    savemat('MMU/data.mat', mat)
