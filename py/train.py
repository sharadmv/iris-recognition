class Classifier:
    def __init__(self, params):
        self.params = params

    def train(self, data):
        raise NotImplementedError

    def predict(self, vector):
        raise NotImplementedError

    def benchmark(self, mat):
        predictions = []
        correct = []
        for i in range(len(mat.x)):
            prediction = self.predict(mat.x[i])
            correct.append(prediction == mat.y[i])
            predictions.append(prediction)
        return (1 - (sum(correct) + 0.0)/len(correct))[0], map(lambda x : x[0], correct), predictions
