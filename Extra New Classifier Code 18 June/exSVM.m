function [ ClassStruct ] = exSVM( data, R, crossfolds )
%   c = [0.01, 0.1, 1, 10, 100, 1000];
%    c = [0, 1, 2, 3];

  %for i=1:length(c)
    %options = sprintf('-t 0 -w1 1 -w2 1 -c 0.9', c(i));
    options=sprintf('-t 0 -w1 1 -w2 1 -c 0.9');
    optionsparameter='-t 0 -w1 1 -w2 1 -c 0.9' ;
    
    Classifiername='SVM_Classifier';
    svmstruct=struct(Classifiername,[]);
    
    fnvector=zeros(1,crossfolds);
    fpvector=zeros(1,crossfolds);
    tpvector=zeros(1,crossfolds);
    tnvector=zeros(1,crossfolds);
    precisionvector=zeros(1,crossfolds);
    recallvector=zeros(1,crossfolds);
    
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
        precisionvector(p)=tpvector(p)/sum(predict_labels==1);
        recallvector(p)=tpvector(p)/sum(validation_labels>0);
    end    
    
    parametername='SVM';

    svmstruct.(Classifiername).(parametername).('Parameters')=optionsparameter;
    svmstruct.(Classifiername).(parametername).('fn')=mean(fnvector);
    svmstruct.(Classifiername).(parametername).('fp')=mean(fpvector);
    svmstruct.(Classifiername).(parametername).('tp')=mean(tpvector);
    svmstruct.(Classifiername).(parametername).('tn')=mean(tnvector);
    svmstruct.(Classifiername).(parametername).('precision')=mean(precisionvector);
    svmstruct.(Classifiername).(parametername).('recall')=mean(recallvector);
    
    fmeasure = 2*mean(precisionvector)*mean(recallvector)/(mean(precisionvector)+mean(recallvector));
    
    fprintf('c: %f,  fmeasure: %f, precision: %f, recall: %f \n', c(i), fmeasure, mean(precisionvector), mean(recallvector));

    ClassStruct=svmstruct;
  %end
end

