function [ bestf, bestK ] = newKNN( data, R, crossfolds )
    Kmax=15;
    
    beta=1;

    beta2=beta^2;
    
    fmeasurevector=zeros(8,1);
    pvector=zeros(8,1);
    findex=1;
    
    disp(['KNN']);    
    
    for j=1:2:Kmax
       
       %disp(['Parameter K: ' int2str(j)]);
       
       fnvector=zeros(1,crossfolds);
       fpvector=zeros(1,crossfolds);
       tpvector=zeros(1,crossfolds);
       tnvector=zeros(1,crossfolds);
       
       for p=1:crossfolds
            currentvalidationset=data(R==p,:);
            currenttrainset=data(R~=p,:);
            W=knnc(currenttrainset,j);
            
            [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
            [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
       end
       
       Nominator=(1+beta2)*sum(tpvector);
       Denominator=((1+beta2)*sum(tpvector) + beta2*sum(fnvector) + sum(fpvector));

       fmeasurevector(findex)=Nominator/Denominator;
       pvector(findex)=j;
       findex=findex+1;
    end
    [bestf,I]=max(fmeasurevector);
    bestK=pvector(I);
end

