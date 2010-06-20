function [classifierstruct, featurestruct]=createArtistExperiment( data, j, name )

    backupdirectory=['Backup_Output', filesep, 'Experiment_', int2str(j)];
    crossfolds=2;
    
    % Create Backup Folder
    if(exist(backupdirectory,'dir')==0)
        mkdir(backupdirectory);
    end
    
    % Do a feature selection algorithm here!
    %Fv=featself(data,'in-in',0);
    %data=data*Fv;
    
    % Prepare Cross Validation
    R=crossval(data,[],crossfolds,0);
    
    % Create the Featurecombination Struct
    allfeatures=getfeatlab(data);
    [numfeatures,~]=size(allfeatures);
    featurestruct=struct('Features',[]);
    for i=1:numfeatures
       featurename=allfeatures(i,:);
       cleanedname=strrep(featurename,' ','');
       featurestruct.('Features').(cleanedname)=[];
    end
    save([backupdirectory, filesep, 'Features_', name], 'featurestruct');
    
    classifierstruct=struct('Classifiers', []);
    
    % Retrieve KNN Struct and add it to the Classifier struct
    knnstruct=ExKNN(data,R,crossfolds);  
    classifierstruct.('Classifiers').('KNN_Classifier')=knnstruct.('KNN_Classifier');
    save([backupdirectory, filesep, 'Classifiers_', name], 'classifierstruct');

    % Retrieve Naive Bayes Struct and add it to the Classifier struct
    nbstruct=ExNaiveBayes(data,R,crossfolds);
    classifierstruct.('Classifiers').('NaiveBayes_Classifier')=nbstruct.('NaiveBayes_Classifier');
    save([backupdirectory, filesep, 'Classifiers_', name], 'classifierstruct');
    
    % Retrieve Neares Mean Struct and add it to the Classifier struct
    nmstruct=ExNearestMean(data,R,crossfolds);
    classifierstruct.('Classifiers').('NearestMean_Classifier')=nmstruct.('NearestMean_Classifier');
    save([backupdirectory, filesep, 'Classifiers_', name], 'classifierstruct');
    
%     options = sprintf('-t 0 -w1 100 -w2 1 -c 1');
%     class = 1;
%     gt_train = (data.nlab==1);
%     gt_train = gt_train(:,2);
%     gt_train = double(gt_train);
%     
%     temp_data = data.data;
%     t1=1;
%     t2=1;
%     for i=1:size(gt_train)
%         if mod(i,5)~=0
%             train_data(t1,:)=temp_data(i,:);
%             train_labels(t1,:)=gt_train(i,:);
%             t1=t1+1;
%         else
%             test_data(t2,:)=temp_data(i,:);
%             test_labels(t2,:)=gt_train(i,:);
%             t2=t2+1;
%         end
%     end
%     
%     model=svmtrain(train_labels, train_data, options);
%     
%     [predict_labels, accuracy, scores] = svmpredict(test_labels, test_data, model);
%     
%     f=1;
    %classifierstruct='';
%     []=svmpredict(gt_test, )
    % libsvm
    
    
%     %Naive Bayes Classifier
%     naivebinsmin=4;
%     naivebinsmax=20;
%     naivebinstep=2;
% 
%     for j=naivebinsmin:naivebinstep:naivebinsmax
%        
%        errorvector=zeros(1,crossfolds);
%        fnvector=zeros(1,crossfolds);
%        fpvector=zeros(1,crossfolds);
%        tpvector=zeros(1,crossfolds);
%        tnvector=zeros(1,crossfolds);
%        fvector=zeros(1,crossfolds);
%        precisionvector=zeros(1,crossfolds);
%        recallvector=zeros(1,crossfolds);
%        
%        for p=1:crossfolds
%             currentvalidationset=data(R==p,:);
%             currenttrainset=data(R~=p,:);
%             W=naivebc(currenttrainset,j);
%             errorvector(p)=testc(currentvalidationset,W);
%             [fnvector(p),tpvector(p)]=testc(currentvalidationset,W,'FN','Positive');
%        end
%        errorrate=mean(errorvector);
%     end
end

