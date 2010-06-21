function [ filtereddata ] = filterFeatures( traindata, featurecombo )

    Datasetpath=['ArtistDataset' filesep];
    featurelength=load([Datasetpath 'featurelengths']);
    featurenames=load([Datasetpath 'featurenames']);

    featureswitch=zeros(length(featurenames),1);
    allnames=featurenames.featurenames;
    for p=1:length(featurecombo)
        logvec=strcmp(allnames,featurecombo{p});
        featureswitch=featureswitch+logvec;
    end

    all_lengths=featurelength.lengthoffeature;
    trainset=dataset([]);
    for p=1:length(all_lengths)
        if(featureswitch(p)== 1);
            startindex=sum(all_lengths(1:p-1))+1;
            endindex=startindex+all_lengths(p)-1;
            extractedfeature=traindata(:,startindex:endindex);
            trainset=[trainset extractedfeature];
        end
    end
    filtereddata=trainset;
    
end

