function [ ClassStruct ] = ExKNN( data, R, crossfolds )
    %KNN Classifier
    Classifiername='KNN_Classifier';
    Kmax=9;

    knnstruct=struct(Classifiername,[]);
    
    for j=1:2:Kmax
       disp(['Parameter K: ' int2str(j)]);
       errorvector=zeros(1,crossfolds);
       fnvector=zeros(1,crossfolds);
       fpvector=zeros(1,crossfolds);
       tpvector=zeros(1,crossfolds);
       tnvector=zeros(1,crossfolds);
       fvector=zeros(1,crossfolds);
       precisionvector=zeros(1,crossfolds);
       recallvector=zeros(1,crossfolds);
       
       for p=1:crossfolds
            currentvalidationset=data(R==p,:);
            currenttrainset=data(R~=p,:);
            W=knnc(currenttrainset,j);
            errorvector(p)=testc(currentvalidationset,W);
            [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
            [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
            fvector(p)=testc(currentvalidationset,W,'F');
            [precisionvector(p), recallvector(p)]=testc(currentvalidationset,W,'precision','Positive');
       end
       
       parametername=['K_' int2str(j)];

       knnstruct.(Classifiername).(parametername).('Parameter_K')=j;
       knnstruct.(Classifiername).(parametername).('errorrate')=mean(errorvector);
       knnstruct.(Classifiername).(parametername).('fn')=mean(fnvector);
       knnstruct.(Classifiername).(parametername).('fp')=mean(fpvector);
       knnstruct.(Classifiername).(parametername).('tp')=mean(tpvector);
       knnstruct.(Classifiername).(parametername).('tn')=mean(tnvector);
       knnstruct.(Classifiername).(parametername).('precision')=mean(precisionvector);
       knnstruct.(Classifiername).(parametername).('recall')=mean(recallvector);

    end
    ClassStruct=knnstruct;
end

