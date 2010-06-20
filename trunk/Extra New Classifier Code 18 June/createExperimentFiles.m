function createExperimentFiles(datastruct)

        Datasetpath=['ArtistDataset' filesep];
        splitpercentage=0.7;
        
        %datastruct=readallXML('Features');
        
        [fulldata, ...
         artistvector, ...
         categorymatrix, ...
         featurevector, ...
         featurenames, ...
         lengthoffeature]=createArtistDataset(datastruct);
                                                   
        % Normalize the Data
        maxvector=max(fulldata);
        minvector=min(fulldata);
        [~, featuresdata]=size(fulldata);
        for j=1:featuresdata
            fulldata(:,j)=fulldata(:,j)-minvector(j);
            fulldata(:,j)=(fulldata(:,j)/maxvector(j))-0.5;
        end
                                                   
        fulldataset=dataset(fulldata);
        fulldataset=addlabels(fulldataset, categorymatrix(:,1), 'category1');
        fulldataset=addlabels(fulldataset, categorymatrix(:,2), 'category2');
        fulldataset=addlabels(fulldataset, categorymatrix(:,3), 'category3');
        fulldataset=addlabels(fulldataset, artistvector, 'artist');
        fulldataset=setfeatlab(fulldataset, featurevector);
        
        [train, test]=gendat(fulldataset,splitpercentage);
        
        save([Datasetpath 'Artist_train'], 'train');
        save([Datasetpath 'Artist_test'], 'test');
        save([Datasetpath 'featurelengths'], 'lengthoffeature');
        save([Datasetpath 'featurenames'], 'featurenames');
end

