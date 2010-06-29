function [ bestf, bestk ] = optimizekNN( dataset, R, kmax )
% This function optimizes the kNN classifier
%
%   Input:          - dataset, PRTools styled Dataset with positive and
%                              negative labels to define the classes
%                   - R, The rotation matrix for cross-validation
%                   - kmax, The maximum k for NN
%
%   Output:         - bestf, highest f-measure
%                   - bestk, k corresponding to the highest f-measure
%

bestf=0;
bestk=0;

for k=1:2:kmax
    fmeasure=tadaknn( dataset, R, k );
    if fmeasure > bestf
       bestf=fmeasure;
       bestk=k;
    end
end

end

