% Need to add a function to choose features or replace everything with a
% precomputed matrix with the right features coming from somewhere else
%
% - Also other similarity measures can be used

function [ numberranking, nameranking ] = computeSimilarity( givenartist )

% Read in the given artist name
givenpath = strcat('Feature Dataset\', givenartist, '.txt');
[~, ~, givenvalues] = readfeaturefile(givenpath);

% Choose your features(currently only hsv)
files = dir('Feature Dataset');
fileIndex = find(~[files.isdir]);

% Gallery Level Comparement: Compute the average images feature vector(Gallery Level)
givenmatrixsize = size(givenvalues);
averagefeaturevector = sum(givenvalues) / givenmatrixsize(1);

% Pre compute vectors for output
similarityvector = zeros(length(fileIndex),1) - 1;
classvector = cell(length(fileIndex),1);

for k=1:length(fileIndex)
   fileName = files(fileIndex(k)).name;
   path = strcat('Feature Dataset', '\', fileName);
   [~, class, values] = readfeaturefile(path);
   
   % Compute average images feature vector(Gallery Level)
   sizeofvalues = size(values);
   averagevalues = sum(values) / sizeofvalues(1);

   % Add username to the classvector
   classvector{k} = class{1};

   % Compute the Euclidian distance
   similarityvector(k) = euclidianDistance(averagevalues, averagefeaturevector);
end

% Create the Ranking
[numberranking, indeces] = sortrows(similarityvector);
nameranking = classvector(indeces);
filter = numberranking > 0;
numberranking = numberranking(filter);
nameranking = nameranking(filter);
