function [ bestf, bestc ] = optimizeSVM( dataset, R, minC, maxC, stepC )
% This function optimizes the SVM classifier
%
%   Input:          - dataset, PRTools styled Dataset with positive and
%                              negative labels to define the classes
%                   - R, The rotation matrix for cross-validation
%                   - minC, The minimum Cost
%                   - maxC, The maximum Cost
%                   - stepC, The stepsize for C
%
%   Output:         - bestf, highest f-measure
%                   - bestc, C corresponding to the highest f-measure
%

bestf=0;
bestc=0;

for c=minC:stepC:maxC
    fmeasure=tadasvm( dataset, R, c );
    if fmeasure > bestf
       bestf=fmeasure;
       bestc=c;
    end
end

end

