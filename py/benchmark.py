from features import *
from svm import *
from randomforest import *
from nb import *
from scipy.io import loadmat

def benchmark(model, train, test):
    if not model._trained:
        print "Training"
        model.train(train)
    print "Training error: ",
    train_results = model.benchmark(train)
    print train_results[0]
    print "Testing error: ",
    test_results = model.benchmark(test)
    print test_results[0]

if __name__ == "__main__":
    data = loadmat('../MMU/data.mat')
    features = set(['daisy'])
    collection = DataExtractor(FeatureExtractor(features)).extract(data['left'])
    test, train = collection.split_index(np.arange(0, len(collection), 3))
    models = { "SVM" : SVM(), "Random Forest" : RandomForest(n_estimators=100), "Naive Bayes" : NaiveBayes()}
    models = { "Random Forest" : RandomForest(n_estimators=500,criterion='entropy'), "Naive Bayes" : NaiveBayes()}
    models = { "SVM" : SVM(), "Random Forest" : RandomForest(n_estimators=100), "Naive Bayes" : NaiveBayes()}
    print "Left"
    for name, model in models.items():
        print "Model:", name
        benchmark(model, train, test)

    collection = DataExtractor(FeatureExtractor(features)).extract(data['right'])
    test, train = collection.split_index(np.arange(0, len(collection), 3))
    models = { "SVM" : SVM(), "Random Forest" : RandomForest(n_estimators=100), "Naive Bayes" : NaiveBayes()}
    models = { "Random Forest" : RandomForest(n_estimators=500, criterion='entropy'), "Naive Bayes" : NaiveBayes()}
    models = { "SVM" : SVM(), "Random Forest" : RandomForest(n_estimators=100), "Naive Bayes" : NaiveBayes()}
    print "Right"
    for name, model in models.items():
        print "Model:", name
        benchmark(model, train, test)
