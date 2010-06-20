function [ ClassStruct ] = ExNearestMean( data, R, crossfolds )
    %Nearest Mean Classifier
    Classifiername='NearestMean_Classifier';
    
    nearestmeanstruct=struct(Classifiername,[]);
    
    disp('Nearest Mean');
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
        W=nmc(currenttrainset);
        errorvector(p)=testc(currentvalidationset,W);
        [fnvector(p),fpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
        [tpvector(p),tnvector(p)]=testc(currentvalidationset,W,'TP','Positive');
        fvector(p)=testc(currentvalidationset,W,'F');
        [precisionvector(p), recallvector(p)]=testc(currentvalidationset,W,'precision','Positive');
    end

    parametername='NearestMean';

    nearestmeanstruct.(Classifiername).(parametername).('errorrate')=mean(errorvector);
    nearestmeanstruct.(Classifiername).(parametername).('fn')=mean(fnvector);
    nearestmeanstruct.(Classifiername).(parametername).('fp')=mean(fpvector);
    nearestmeanstruct.(Classifiername).(parametername).('tp')=mean(tpvector);
    nearestmeanstruct.(Classifiername).(parametername).('tn')=mean(tnvector);
    nearestmeanstruct.(Classifiername).(parametername).('precision')=mean(precisionvector);
    nearestmeanstruct.(Classifiername).(parametername).('recall')=mean(recallvector);

    ClassStruct=nearestmeanstruct;

end

