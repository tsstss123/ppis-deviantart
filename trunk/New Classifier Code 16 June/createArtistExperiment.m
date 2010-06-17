function A=createArtistExperiment( datastruct, target, splitpercentage, varargin )

    crossfolds=5;
    
    if(strcmp(target, 'all'))
        artistnames=fieldnames(datastruct.artists);
        numberofartists=length(artistnames);
    else
        numberofartists=1;
        artistnames={target};
    end
    
    for i=1:numberofartists
        
        % Create class with artist as Positive Example
        [data,classes]=createArtistDataset(datastruct, artistnames{i}, 'numFaces','medianHue', 'avgSat');
        size(data)
        % Normalize the Data
        maxvector=max(data);
        minvector=min(data);
        [~, featuresdata]=size(data);
        for j=1:featuresdata
            data(:,j)=data(:,j)-minvector(j);
            data(:,j)=(data(:,j)/maxvector(j))-0.5;
        end

        % Create PRTools format dataset
        prdata=dataset(data,classes);
        [trainset, testset]=gendat(prdata, splitpercentage);
        
        % Prepare Cross Validation
        R=crossval(trainset,[],crossfolds,0);

        % Create output file
        outputfilename = strcat('Result\Dataset_',artistnames{i},'.txt');
        outputfile = fopen(outputfilename,'w');

        %KNN Classifier
        Kmax=9;
        fprintf(outputfile, 'K-NN Classifier\n\n');
        fprintf(outputfile, 'K\t1\t3\t5\t7\t9\n');
        fprintf(outputfile, 'Err\t');

        for j=1:2:Kmax
           %errorvector = zeros(1,crossfolds);
           %for p=1:crossfolds
           %     currentvalidationset=trainset(R==p,:);
           %     currenttrainset=trainset(R~=p,:);
           %     W=knnc(currenttrainset,j);
           %     errorvector(p)=testc(currentvalidationset,W);
           %end
           %errorrate=mean(errorvector);
           %fprintf(outputfile, '%f\\', errorrate);
           realW=knnc(trainset,j);
           testerror=testc(testset,realW);
           fprintf(outputfile, '%f\t', testerror);
        end
        
        %Naive Bayes Classifier
        naivebinsmin=5;
        naivebinsmax=20;
        
        for j=naivebinsmin:1:naivebinsmax
           naivebc(trainset,j);
           
        end

        fprintf(outputfile, '\n');
        fclose(outputfile);

        A=data;
    end
end

