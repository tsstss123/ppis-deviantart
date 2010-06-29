function [ fmeasure ] = TADANaiveBayes( data, R, crossfolds, Bin )
%   The TADA Naive Bayes Classifier
%   
%   Input: data:            PRTools Format Dataset;
%          R:               Crossvalidation Rotation Matrix;
%          crossfolds:      number of crossfolds;
%          Bin:             number of Bins
%              
%   Output: fmeasure:       Average of the F-measure of the crossfolds
%
    disp('Naive Bayes');
       
    fnvector=zeros(1,crossfolds);
    fpvector=zeros(1,crossfolds);
    tpvector=zeros(1,crossfolds);
    tnvector=zeros(1,crossfolds);
    
    for p=1:crossfolds
        currentvalidationset=data(R==p,:);
        currenttrainset=data(R~=p,:);
        W=naivebc(currenttrainset,Bin);

        [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
        [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
    end
    
    fmeasure=computeFmeasure(tpvector, fpvector, fnvector);
end

