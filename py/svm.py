from train import Classifier
#import liblinearutil as svm
from sklearn import svm
import numpy as np

#class SVM(Classifier):
    #def __init__(self, model=None):
        #if model:
            #self.model = svm.load_model(model)
            #self._trained = True
        #else:
            #self.model = None
            #self._trained = False

    #def train(self, data):
        #self.model = svm.train(data.y.tolist(), data.x.tolist(), '-s 4')
        #self._trained = True

    #def predict(self, vector):
        #return svm.predict([-1], [vector.tolist()], self.model)[0][0]

    #def benchmark(self, data):
        #predictions, accuracy, weights = svm.predict(data.y.tolist(), data.x.tolist(), self.model)
        #return (1 - accuracy/100, np.array(predictions)==data.y, predictions)
class SVM(Classifier):
    def __init__(self, model=None):
        self.model = None
        self._trained = False

    def train(self, data):
        self.model = svm.LinearSVC()
        self.model.fit(data.x, data.y)
        self._trained = True

    def predict(self, vector):
        return self.model.predict(vector)
