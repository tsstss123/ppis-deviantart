function [ Fscore ] = computeFmeasure( tpvector, fpvector, fnvector )
%   Computes the F-measure score 
%   Input:  tpvector, vector/single value containing the tp
%           fpvector, vector/single value containing the fp
%           fnvector, vector/single value containing the fn
%
%   Output: Computed F-score
%
    beta=1;
    beta2=beta^2;
    Nominator=(1+beta2)*sum(tpvector);
    Denominator=((1+beta2)*sum(tpvector) + beta2*sum(fnvector) + sum(fpvector));

    Fscore=Nominator/Denominator;
end