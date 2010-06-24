function [ bestf,bestc ] = newSVM( data, R, crossfolds )
%   c = [0.01, 0.1, 1, 10, 100, 1000];
  c = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5];

  fmeasurevector=zeros(11,1);
  pvector=zeros(11,1);  
  findex=1;
  
beta=1;

beta2=beta^2;  
  
  for i=1:length(c)
    options = sprintf('-t 0 -w1 1 -w2 1 -c %f', c(i));
    %options=sprintf('-t 0 -w1 1 -w2 1 -c 0.9');
    
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
    
    Nominator=(1+beta2)*sum(tpvector);
    Denominator=((1+beta2)*sum(tpvector) + beta2*sum(fnvector) + sum(fpvector));

    fmeasurevector(findex)=Nominator/Denominator;
    pvector(findex)=i;    
    findex=findex+1;
  end
    [bestf,I]=max(fmeasurevector);
    bestc=pvector(I);  
end

