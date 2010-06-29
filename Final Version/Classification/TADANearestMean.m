function [ fmeasure ] = TADANearestMean( data, R, crossfolds )
%   The TADA Nearest Mean Classifier
%   
%   Input: data:            PRTools Format Dataset;
%          R:               Crossvalidation Rotation Matrix;
%          crossfolds:      number of crossfolds;
%              
%   Output: fmeasure:       Average of the F-measure of the crossfolds
%
    disp('Nearest Mean');  
    
    fnvector=zeros(1,crossfolds);
    fpvector=zeros(1,crossfolds);
    tpvector=zeros(1,crossfolds);
    tnvector=zeros(1,crossfolds);
    
    for p=1:crossfolds
        currentvalidationset=data(R==p,:);
        currenttrainset=data(R~=p,:);
        W=nmc(currenttrainset);
        [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
        [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
    end
    
    fmeasure=computeFmeasure(tpvector, fpvector, fnvector);
end

