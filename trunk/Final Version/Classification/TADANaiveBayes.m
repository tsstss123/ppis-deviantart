function [ fmeasure ] = TADANaiveBayes( data, R, Bin )
%   The TADA Naive Bayes Classifier
%   
%   Input: data:            PRTools Format Dataset;
%          R:               Crossvalidation Rotation Matrix;
%          Bin:             number of Bins
%              
%   Output: fmeasure:       Average of the F-measure of the crossfolds

    fprintf('Naive Bayes with Bins: %f\n', Bin);
       
    crossfolds = max(R);
    
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

