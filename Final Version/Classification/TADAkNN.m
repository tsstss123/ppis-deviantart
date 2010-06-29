function [ fmeasure ] = TADAkNN( data, R, crossfolds, K )
%   The TADA kNN Classifier
%   
%   Input: data:            PRTools Format Dataset;
%          R:               Crossvalidation Rotation Matrix;
%          crossfolds:      number of crossfolds;
%          K:               number of neighbours
%              
%   Output: fmeasure:       Average of the F-measure of the crossfolds
%

    disp('KNN');    
       
    fnvector=zeros(1,crossfolds);
    fpvector=zeros(1,crossfolds);
    tpvector=zeros(1,crossfolds);
    tnvector=zeros(1,crossfolds);
       
    for p=1:crossfolds
        currentvalidationset=data(R==p,:);
        currenttrainset=data(R~=p,:);
        W=knnc(currenttrainset,K);

        [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
        [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
    end
    fmeasure=computeFmeasure(tpvector, fpvector, fnvector);
end

