import numpy as np

from scipy.io import loadmat

class FeatureExtractor():
    def __init__(self, features):
        self.features = features

    def extract(self, image):
        return image.flatten()

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
        for img, label in zip(data['x'][0,0], data['y'][0,0]):
            if x == None:
                x = self.fe.extract(img)
            else:
                x = np.vstack([x, self.fe.extract(img)])
            if y == None:
                y = label
            else:
                y = np.hstack([y, label])
        return Collection(x, y)

if __name__ == "__main__":
    data = loadmat('../MMU/data.mat')
    fe = FeatureExtractor({})
    de = DataExtractor(fe)
    mat = de.extract(data['left'])
    from svm import *
    s = SVM('sample.model')
    results = s.benchmark(mat)
