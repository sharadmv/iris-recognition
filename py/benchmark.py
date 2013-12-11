from features import *
from svm import *
from scipy.io import loadmat

if __name__ == "__main__":
    data = loadmat('../MMU/data.mat')
    collection = DataExtractor(FeatureExtractor({})).extract(data['left'])
    test, train = collection.split_index(np.arange(0, len(collection), 3))
    model = SVM()
    if not model._trained:
        print "Training"
        model.train(train)
    print "Training error: ",
    train_results = model.benchmark(train)
    print train_results[0]
    print "Testing error: ",
    test_results = model.benchmark(test)
    print test_results[0]
