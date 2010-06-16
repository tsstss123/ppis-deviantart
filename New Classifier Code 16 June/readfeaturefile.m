% Currently only for three feature values: hsv
% Reads the featurevalues from a file but needs to know how many
% features there are in it.
%  - Might require a workaround or the featurevalues can be called another
%    way
function [ imagenames, classnames, features ] = readfeaturefile( path )

% Read in the feature file of the artist
fid=fopen(path);
contents = textscan(fid, '%s %s %f %f %f', 'Delimiter','\t');
fclose(fid);

% Output a name vector, class vector and featurematrix
imagenames = contents{1};
classnames = contents{2};
features = cat(2, contents{3}, contents{4}, contents{5});

end

