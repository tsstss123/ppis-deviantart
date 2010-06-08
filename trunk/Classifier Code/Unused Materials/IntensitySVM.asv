% Create observation matrix of the first class
obsmatrix1 = IntensityFeature('trainclass1');
[matrixrows1, matrixcolumns1] = size(obsmatrix1);

% Create Group Vector 1
groupvector1 = zeros(matrixrows1 ,1);

% Create observation matrix of the second class
obsmatrix2 = IntensityFeature('trainclass2');
[matrixrows2, matrixcolumns2] = size(obsmatrix2);

% Create Group Vector 2
groupvector2 = ones(matrixrows2, 1);

% Combine the Groups
obsmatrixgroups = vertcat(obsmatrix1, obsmatrix2);
groups = vertcat(groupvector1,groupvector2);

% Create a testset
testset = IntensityFeature('testset');

% Train the SVM
svmStruct = svmtrain(obsmatrixgroups, groups, 'Showplot', true);

% Test the SVM
svmclassify(svmStruct, testset, 'Showplot', true);