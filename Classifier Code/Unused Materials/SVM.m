function [ cp ] = SVM( trainpercentage )

class1name = 'trainclass1';
class2name = 'trainclass2';

% Load/Compute feature vectors * Future replacement with dataset calls!
fprintf('Creating Feature Vector Matrices\n');
class1 = pseudotrainClassifier(class1name);
class2 = pseudotrainClassifier(class2name);

% Split dataset in train and test data
fprintf('Splitting Dataset\n');
[trainingclass1, testclass1] = splitData(class1, trainpercentage);
[trainingclass2, testclass2] = splitData(class2, trainpercentage);

% Combine training set for the SVM
fprintf('Creating and Labeling the Training set\n');
trainingmatrix = vertcat(trainingclass1, trainingclass2);
sizetraining = size(trainingmatrix);
sizetrainingclass1 = size(trainingclass1);
trainingobsmatrix = trainingmatrix(:,1:end);S

% Labeling the training set
traininggroundtruthvector = cell(sizetraining(1), 1);
for k=1:sizetrainingclass1(1)
    traininggroundtruthvector{k} = class1name;
end
for k=sizetrainingclass1(1)+1:sizetraining(1)
    traininggroundtruthvector{k} = class2name;
end

% Combine test set for the SVM
fprintf('Creating and Labeling the Test set\n');
testmatrix = vertcat(testclass1, testclass2);
sizetest = size(testmatrix);
sizeclass1 = size(testclass1);
testobsmatrix = testmatrix(:,1:end);
testgroundtruthvector = cell(sizetest(1), 1);

% Labeling the test set
for k=1:sizeclass1(1)
    testgroundtruthvector{k} = class1name;
end
for k=sizeclass1(1)+1:sizetest(1)-sizeclass1(1)
    testgroundtruthvector{k} = class2name;
end

% Train the SVM and test it on the testdata
fprintf('Training SVM Classifier\n');
svmStruct = svmtrain(trainingobsmatrix, traininggroundtruthvector);

if trainpercentage ~= 1.0
    fprintf('Classifying on the test set\n');
    classes = svmclassify(svmStruct, testobsmatrix);

    fprintf('Done. Output are the results\n');
    % Create classperf data classifiers performance
    cp = classperf(testgroundtruthvector);
    classperf(cp,classes);
else % Else if return the trained classifier
    fprintf('Done. Output is the trained SVM classifier');
    cp = svmStruct;
end

