function [ bestf ] = newNearestMean( data, R, crossfolds )
    
    disp('Nearest Mean');
    
beta=1;

beta2=beta^2;   
    
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
        Nominator=(1+beta2)*sum(tpvector);
        Denominator=((1+beta2)*sum(tpvector) + beta2*sum(fnvector) + sum(fpvector));

        bestf=Nominator/Denominator;
end

