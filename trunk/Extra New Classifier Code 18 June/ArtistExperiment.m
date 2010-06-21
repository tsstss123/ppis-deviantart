function A=ArtistExperiment(categorytype, names, experiments, autoselect, optimalselect) 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    Datasetpath=['ArtistDataset' filesep];
    
    prwarning(0);
    
    if(exist([Datasetpath 'Artist_train.mat'], 'file') == 0)
        createExperimentFiles();
    end

    temp=load([Datasetpath 'Artist_train']);
    traindata=temp.train;
    
    % Decide which category artist to choose from
    if strcmp(categorytype, 'category1')
        traindata=changelablist(traindata, 'category1');
    elseif strcmp(categorytype, 'category2')
        traindata=changelablist(traindata, 'category2');       
    elseif strcmp(categorytype, 'category3')
        traindata=changelablist(traindata, 'category3');
    else
        traindata=changelablist(traindata, 'artist');
    end
    
    % Filter on Artists/Categories and take care of NaN labels
    if(sum(strcmp(names, 'all'))==0)
        traindata=filterArtists(traindata,names);
    end
    
    % Filter out all the small classes which are lower or equal to 10
    traindata=remclass(traindata,6);
    
    lablist=getlablist(traindata);
    [artistnumbers,~]=size(lablist);
    
    resultsstruct=struct('results',[]);
    
    [numberofexperiments,~]=size(experiments);
    
    for j=1:numberofexperiments
        
        featurecombo=experiments{j};
        if strcmp(featurecombo,'all')==0
            trainset=filterFeatures(traindata, featurecombo);
        else
            trainset=traindata;
        end
        
            disp(lablist(1,:));
            imagelabels=getnlab(trainset);
            positiveimages=imagelabels==1;

            pos=trainset(positiveimages,:);
            neg=trainset(positiveimages==0,:);

            dpos=pos.data;
            dneg=neg.data;
            f=getfeatlab(pos);
            
            newdpos=dataset(dpos,'Positive');
            newdneg=dataset(dneg,'Negative'); 
            
            artistdataset=[newdpos;newdneg];
            artistdataset=setfeatlab(artistdataset,f);
            
            [classifierstruct,featurestruct]=createArtistExperiment(artistdataset,j,lablist{1}, autoselect, optimalselect);

            name=lablist(1,:);
            cleanedname=strrep(name, ' ', '');
            exst=['Experiment_' int2str(j)];
            
            resultsstruct.('results').(cleanedname{1}).(exst).('Classifiers')=classifierstruct.('Classifiers');
            resultsstruct.('results').(cleanedname{1}).(exst).('Features')=featurestruct.('Features');
    end
    A=resultsstruct;
end

