function [classifierstruct, featurestruct]=createArtistExperiment( data, j, name, autoselect, optimalselect )

    backupdirectory=['Backup_Output', filesep, 'Experiment_', int2str(j)];
    crossfolds=5;
    
    % Create Backup Folder
    if(exist(backupdirectory,'dir')==0)
        mkdir(backupdirectory);
    end
    
    % Do a feature selection algorithm here!
    if (autoselect==1)
        [Fv,~]=featself(data,'in-in',optimalselect);
        data=data*Fv;
    end
    
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
    
%     % Retrieve KNN Struct and add it to the Classifier struct
%     knnstruct=ExKNN(data,R,crossfolds);  
%     classifierstruct.('Classifiers').('KNN_Classifier')=knnstruct.('KNN_Classifier');
%     save([backupdirectory, filesep, 'Classifiers_', name], 'classifierstruct');
% 
%     % Retrieve Naive Bayes Struct and add it to the Classifier struct
%     nbstruct=ExNaiveBayes(data,R,crossfolds);
%     classifierstruct.('Classifiers').('NaiveBayes_Classifier')=nbstruct.('NaiveBayes_Classifier');
%     save([backupdirectory, filesep, 'Classifiers_', name], 'classifierstruct');
%     
%   % Retrieve Nearest Mean Struct and add it to the Classifier struct
%     nmstruct=ExNearestMean(data,R,crossfolds);
%     classifierstruct.('Classifiers').('NearestMean_Classifier')=nmstruct.('NearestMean_Classifier');
%     save([backupdirectory, filesep, 'Classifiers_', name], 'classifierstruct');
    
    % Retrieve SVM Struct and add it to the Classifier struct
    svmstruct=ExSVM(data,R,crossfolds);
    classifierstruct.('Classifiers').('SVM_Classifier')=svmstruct.('SVM_Classifier');
    save([backupdirectory, filesep, 'Classifiers_', name], 'classifierstruct');
end

