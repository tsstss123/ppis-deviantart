function [ fmeasure ] = TADASVM( data, R, C )
%   The TADA Linear SVM Classifier
%   
%   Input: data:            PRTools Format Dataset;
%          R:               Crossvalidation Rotation Matrix;
%          C:               Cost value;
%              
%   Output: fmeasure:       Average of the F-measure of the crossfolds

    crossfolds = max(R);
    options = sprintf('-t 0 -w1 1 -w2 1 -c %f', C);
    
    fnvector=zeros(1,crossfolds);
    fpvector=zeros(1,crossfolds);
    tpvector=zeros(1,crossfolds);
    tnvector=zeros(1,crossfolds);
    
    for p=1:crossfolds
        currentvalidationset=data(R==p,:);
        currenttrainset=data(R~=p,:);
        
        train_data=currenttrainset.data;
        temp_labels=getnlab(currenttrainset);
        train_labels=-(temp_labels-2);
        model=svmtrain(train_labels, train_data, options);
        
        validation_data=currentvalidationset.data;
        temp2_labels=getnlab(currentvalidationset);
        validation_labels=-(temp2_labels-2);
        
        [predict_labels, ~, ~]=svmpredict(validation_labels, validation_data, model);
        
        tpvector(p)=sum(predict_labels(validation_labels==1)==1);
        fnvector(p)=sum(predict_labels(validation_labels==1)==0);
        fpvector(p)=sum(predict_labels(validation_labels==0)==1);
        tnvector(p)=sum(predict_labels(validation_labels==0)==0);
    end
    
    fmeasure=computeFmeasure(tpvector, fpvector, fnvector);
end

