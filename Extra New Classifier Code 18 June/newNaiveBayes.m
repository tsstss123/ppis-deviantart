function [ bestf, bestbin ] = newNaiveBayes( data, R, crossfolds )
    Binmax=24;
    Binmin=2;
    Binstep=2;
    
beta=1;

beta2=beta^2;    
    
    fmeasurevector=zeros(12,1);
    pvector=zeros(12,1);
    
    findex=1;
    
    disp(['Naive Bayes']);
    
    for j=Binmin:Binstep:Binmax
       
       fnvector=zeros(1,crossfolds);
       fpvector=zeros(1,crossfolds);
       tpvector=zeros(1,crossfolds);
       tnvector=zeros(1,crossfolds);
       
       
       for p=1:crossfolds
            currentvalidationset=data(R==p,:);
            currenttrainset=data(R~=p,:);
            W=naivebc(currenttrainset,j);
            
            [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
            [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
       end
       
       Nominator=(1+beta2)*sum(tpvector);
       Denominator=((1+beta2)*sum(tpvector) + beta2*sum(fnvector) + sum(fpvector));

       fmeasurevector(findex)=Nominator/Denominator
       pvector(findex)=j;       
       findex=findex+1;

    end
    [bestf,I]=max(fmeasurevector);
    bestbin=pvector(I);    
end

