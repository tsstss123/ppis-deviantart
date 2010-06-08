% Load/Compute feature vectors
class1 = IntensityFeature('trainclass1');
class2 = IntensityFeature('trainclass2');

% Label feature vectors and split them in train and test data
[trainingclass1, testclass1] = splitData(class1, 0, 0.7);
[trainingclass2, testclass2] = splitData(class2, 1, 0.7);

% Combine training set for the SVM
trainingmatrix = vertcat(trainingclass1, trainingclass2);
trainingobsmatrix = trainingmatrix(:,1:end-1);
traininggroundtruthvector = trainingmatrix(:,end);

% Combine test set for the SVM
testmatrix = vertcat(testclass1, testclass2);
testobsmatrix = testmatrix(:,1:end-1);
testgroundtruthvector = testmatrix(:,end);

% Create classperf data classifiers performance
cp = classperf(testgroundtruthvector);

% Train the SVM and test it on the testdata
svmStruct = svmtrain(trainingobsmatrix, traininggroundtruthvector);
classes = svmclassify(svmStruct, testobsmatrix);

% Update the Classifiers performance object
classperf(cp,classes);