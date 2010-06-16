function [ trainingdataclass1, testdataclass1] = splitData( obsmatrix1, trainingpercent )

% Create observation matrix of the first class
sizeclass1 = size(obsmatrix1);

% Randomly shuffle the rows inside the obsmatrix
randomobsmatrix1 = obsmatrix1(randperm(sizeclass1(1)),:);
% randomobsmatrix1 = cat(2,randomobsmatrix1, groupvector1);

% Calculate training set and test set
trainingnumber = round(trainingpercent*sizeclass1(1));

% Create the training set
trainingdataclass1 = randomobsmatrix1(1:trainingnumber,:);

% Create the test set
testdataclass1 = randomobsmatrix1(trainingnumber+1:end,:);

end

