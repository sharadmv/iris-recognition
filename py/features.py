import numpy as np

from scipy.io import loadmat
from skimage.feature import hog, local_binary_pattern, daisy
from progressbar import ProgressBar

class FeatureExtractor():
    def __init__(self, features):
        self.features = features
        self.centers = np.loadtxt('../centers.txt')

    def extract(self, image):
        features = np.array([])
        vec = []
        if 'raw' in self.features:
            vec = image.flatten()
        features = np.append(features, vec)
        vec = []
        if 'textons' in self.features:
            import gen_histogram as tx
            vec = np.array(tx.histogram(image, self.centers))
        features = np.append(features, vec)
        vec = []
        if 'hog' in self.features:
            vec = hog(image, cells_per_block=(3, 3))
            vec = np.append(vec, hog(image, cells_per_block=(4, 4)))
            vec = np.append(vec, hog(image, cells_per_block=(1, 1)))
            vec = np.append(vec, hog(image, cells_per_block=(2, 2)))
        features = np.append(features, vec)
        vec = []
        if 'lbp' in self.features:
            vec = local_binary_pattern(image, 24, 3).flatten()
        features = np.append(features, vec)
        vec = []
        if 'daisy' in self.features:
            vec = daisy(image).flatten()
        features = np.append(features, vec)

        return features

class Collection:
    def __init__(self, x, y):
        idx = np.argsort(y)
        self.x = x[idx]
        self.y = y[idx]

    def partition(self, index):
        return Collection(self.x[0:index], self.y[0:index]), Collection(self.x[index:], self.y[index:])

    def split_index(self, range):
        right_idx = np.setdiff1d(np.arange(0, len(self.x)), range)
        return Collection(self.x[range], self.y[range]), Collection(self.x[right_idx], self.y[right_idx])

    def __len__(self):
        return len(self.x)

class DataExtractor():
    def __init__(self, fe):
        self.fe = fe
    def extract(self, data):
        x = None
        y = None
        a = None
        print "Extracting features..."
        count = 0
        pbar = ProgressBar(maxval=len(data['x'][0,0])).start()
        for img, label in zip(data['x'][0,0], data['y'][0,0]):
            if x == None:
                x = self.fe.extract(img)
                a = [img]
            else:
                x = np.vstack([x, self.fe.extract(img)])
                a = np.vstack([a, [img]])
            if y == None:
                y = label
            else:
                y = np.hstack([y, label])
            count += 1
            pbar.update(count)
            #print "%d of %d" % (count, len(data['x'][0,0]))
        pbar.finish()
        return Collection(x, y)

if __name__ == "__main__":
    data = loadmat('../MMU/data.mat')
    fe = FeatureExtractor({})
    de = DataExtractor(fe)
    mat = de.extract(data['left'])
    from svm import *
    s = SVM('sample.model')
    results = s.benchmark(mat)
