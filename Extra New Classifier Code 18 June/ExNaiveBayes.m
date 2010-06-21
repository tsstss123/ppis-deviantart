function [ ClassStruct ] = ExNaiveBayes( data, R, crossfolds )
    %Naive Bayes Classifier
    Classifiername='NaiveBayes_Classifier';
    Binmax=24;
    Binmin=6;
    Binstep=2;
    
    naivebcstruct=struct(Classifiername,[]);
    
    for j=Binmin:Binstep:Binmax
       disp(['Parameter Bin: ' int2str(j)]);
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
            W=naivebc(currenttrainset,j);
            errorvector(p)=testc(currentvalidationset,W);
            [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
            [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
            fvector(p)=testc(currentvalidationset,W,'F');
            [precisionvector(p), recallvector(p)]=testc(currentvalidationset,W,'precision','Positive');
       end
       
       parametername=['Bin_' int2str(j)];

       naivebcstruct.(Classifiername).(parametername).('Parameter_Bin')=j;
       naivebcstruct.(Classifiername).(parametername).('errorrate')=mean(errorvector);
       naivebcstruct.(Classifiername).(parametername).('fn')=mean(fnvector);
       naivebcstruct.(Classifiername).(parametername).('fp')=mean(fpvector);
       naivebcstruct.(Classifiername).(parametername).('tp')=mean(tpvector);
       naivebcstruct.(Classifiername).(parametername).('tn')=mean(tnvector);
       naivebcstruct.(Classifiername).(parametername).('precision')=mean(precisionvector);
       naivebcstruct.(Classifiername).(parametername).('recall')=mean(recallvector);

    end
    ClassStruct=naivebcstruct;
end

