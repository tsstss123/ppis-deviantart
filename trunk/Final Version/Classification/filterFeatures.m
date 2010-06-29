function [ filtereddata ] = filterFeatures( data, featurecombo )
%
% This function selects the columns that are specified with featurecombo
% That way it filters out all of the other columns
%
% Input: PRTools format dataset, Combination of features that you want
% Output: The filtered dataset.
%

    % Uses the ismember function to find the indices of the features you
    % want
    allnames=getfeatlab(data);
    [~,indices]=ismember(featurecombo,allnames);
    filtereddata=data(:,indices);
end

