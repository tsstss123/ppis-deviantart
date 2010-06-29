function [ bestf, bestbin ] = optimizeNaiveBayes( dataset, R, minbin, maxbin )
% This function optimizes the Naive Bayes classifier
%
%   Input:          - dataset, PRTools styled Dataset with positive and
%                              negative labels to define the classes
%                   - R, The rotation matrix for cross-validation
%                   - minbin, The minimum bins for NB
%                   - maxbin, The maximum bins for NB
%
%   Output:         - bestf, highest f-measure
%                   - bestbin, bin corresponding to the highest f-measure
%

bestf=0;
bestbin=0;

for bin=minbin:2:maxbin
    fmeasure=tadanaivebayes( dataset, R, bin );
    if fmeasure > bestf
       bestf=fmeasure;
       bestbin=bin;
    end
end

end

