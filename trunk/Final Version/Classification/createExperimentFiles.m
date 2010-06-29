function [train, test, featurenames, lengthoffeature]=createExperimentFiles(datastruct, splitpercentage)
        % Converts the read in XML format datastruct to the PRTools datastruct
        %
        % Input: XML Datastruct and the Train/Test Splitpercentage
        % Output: Train and test set;
        %         Featurenames(n) and Featurelength(n) where n is the index 
        %         of the feature column
        %

        Datasetpath=['Dataset' filesep];
        
        if(exist('Dataset', 'dir')==0)
            mkdir('Dataset');
        end
        
        [fulldata, ...
         artistvector, ...
         categorymatrix, ...
         featurevector, ...
         featurenames, ...
         lengthoffeature]=createRawDataset(datastruct);
        
        % Normalization
        fulldata=minmaxnormalization(fulldata);
                               
        % Converts the dataset to the PRTools format and fills it with
        % labels, and gives the columns their appropriate featurename
        fulldataset=dataset(fulldata);
        fulldataset=addlabels(fulldataset, categorymatrix(:,1), 'category1');
        fulldataset=addlabels(fulldataset, categorymatrix(:,2), 'category2');
        fulldataset=addlabels(fulldataset, categorymatrix(:,3), 'category3');
        
        fulldataset=addlabels(fulldataset, artistvector, 'artist');
        fulldataset=setfeatlab(fulldataset, featurevector);
        
        [train, test]=gendat(fulldataset,splitpercentage);
        
        % Creates backupfiles
        save([Datasetpath 'Trainset'], 'train');
        save([Datasetpath 'Testset'], 'test');
        save([Datasetpath 'Featurelengths'], 'lengthoffeature');
        save([Datasetpath 'Featurenames'], 'featurenames');
end

