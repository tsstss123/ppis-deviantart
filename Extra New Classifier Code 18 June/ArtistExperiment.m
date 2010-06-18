function A=ArtistExperiment( varargin )
    addpath(genpath('../externalpackages/prtools_ac/prtools'));
    
    % Auto Feature select aanzetten kan je als een featurenaam implementeren
    % moet je het dan wel herkennen als ie de featurecombo maakt en daar
    % meot je de featureselect AAN feature eruit knallen
    experiments={{'numFaces'; ...
                                                       'cornerRatio'; ...
                                                       'edgeRatio'; ...
                                                       'gridEdgeRatio'; ...
                                                       'medianHue'; ...
                                                       'avgSat'; ...
                                                       'avgInt'; ...
                                                       'medHueCells'; ...
                                                       'avgSatCells'; ...
                                                       'avgIntCells'; ...
                                                       'cornerRatioGrid' ...
                                                       }};
%                 {'cornerRatio'};
%                 {'avgSat'; 'avgSatCells'}
%                     };

    Datasetpath=['ArtistDataset' filesep]
    splitpercentage=0.7;

    if(exist([Datasetpath 'Artist_train.mat'], 'file') == 0)
        datastruct=readallXML('Dataset', 'Features');
        [fulldata, ~, featurevector, artistvector, featurenames, lengthoffeature]=createArtistDataset( ... 
                                                       datastruct, 'x', ...
                                                       'numFaces', ...
                                                       'cornerRatio', ...
                                                       'edgeRatio', ...
                                                       'gridEdgeRatio', ...
                                                       'medianHue', ...
                                                       'avgSat', ...
                                                       'avgInt', ...
                                                       'medHueCells', ...
                                                       'avgSatCells', ...
                                                       'avgIntCells', ...
                                                       'cornerRatioGrid' ...
                                                       );
                                                   
        % Normalize the Data
        maxvector=max(fulldata);
        minvector=min(fulldata);
        [~, featuresdata]=size(fulldata);
        for j=1:featuresdata
            fulldata(:,j)=fulldata(:,j)-minvector(j);
            fulldata(:,j)=(fulldata(:,j)/maxvector(j))-0.5;
        end
                                                   
        fulldataset=dataset(fulldata, artistvector);
        fulldataset=setfeatlab(fulldataset, featurevector);
        [train, test]=gendat(fulldataset,splitpercentage);
        save([Datasetpath 'Artist_train'], 'train');
        save([Datasetpath 'Artist_test'], 'test');
        save([Datasetpath,'featurelengths'], 'lengthoffeature');
        save([Datasetpath,'featurenames'], 'featurenames');
    end

    temp=load([Datasetpath 'Artist_train'])
    traindata=temp.train;
    
    lablist=getlablist(traindata);
    [artistnumbers,~]=size(lablist);
    
    featurelength=load([Datasetpath 'featurelengths']);
    featurenames=load([Datasetpath 'featurenames']);
    
    resultsstruct=struct('results',[]);
    
    [numberofexperiments,~]=size(experiments);
    for j=1:numberofexperiments
        featurecombo=experiments{j};
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
        getfeatlab(trainset)
        for i=1:artistnumbers
            disp(lablist(i,:));
            imagelabels=getnlab(trainset);
            positiveimages=imagelabels==i;

            pos=trainset(positiveimages,:);
            neg=trainset(positiveimages==0,:);
            pos=addlabels(pos, char('Positive'), 'classification');
            neg=addlabels(neg, char('Negative'), 'classification');

            artistdataset=[pos;neg];
            artistdataset=setprior(artistdataset,[]);
            [classifierstruct,featurestruct]=createArtistExperiment(artistdataset);

            name=lablist(i,:);
            cleanedname=strrep(name, ' ', '');
            resultsstruct.('results').(cleanedname)=[];
            resultsstruct.('results').(cleanedname).('Classifiers')=classifierstruct.('Classifiers');
            resultsstruct.('results').(cleanedname).('Features')=featurestruct.('Features');
        end
    end
    
    A=resultsstruct;
end

