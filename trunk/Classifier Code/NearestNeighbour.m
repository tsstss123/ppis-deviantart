function [ Result ] = NearestNeighbour( trainpercentage, K )

class1name = 'trainclass1';
class2name = 'trainclass2';

% Load/Compute feature vectors *Future replacement with dataset calls! or
% import from another function
class1 = pseudotrainClassifier(class1name);
class2 = pseudotrainClassifier(class2name);

sizeclass1 = size(class1);
sizeclass2 = size(class2);

A = dataset([class1;class2], genlab([sizeclass1(1) sizeclass2(1)], {class1name;class2name}));
A = setprior(A,[0.5,0.5]);

if trainpercentage < 1.0
    [train, test] = gendat(A, trainpercentage);
    W1 = knnc(train,K);
    Result=testc(test*W1);
else
    [Result, ~, ~] = knnc(A, K);
end