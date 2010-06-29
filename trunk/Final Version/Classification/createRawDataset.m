function [ dataset, artistvector, ... 
           categorymatrix, ...
           featurevector, featurenames, lengthoffeature ...
         ] = createRawDataset(datastruct)
    % This function converts the datastruct that is created with
    % readfeatureXML.m into a raw dataset.
    % This dataset is raw because no PRTools format is yet 
    % assigned to this dataset
    % 
    %  Input: datastruct, which is the output of readfeatureXML.m
    %  Output: n x m dataset, where n are the number of images and m is the
    %                         number of feature dimensions.
    %          n x 1 artistvector, artist class labels for the n images
    %          n x 3 categorymatrix, 3 different category labels for n
    %                                images
    %          1 x n featurevector, feature labels for every column in the 
    %                               dataset
    %          n x 1 featurenamevector, all kinds of featurenames(n) in a
    %                                   vector where n is a feature
    %          n x 1 featurelengthvector, contains the length for each
    %                                     feature(n) where n is a feature
    %
    datasetrows=0;
    datasetcolumns=0;

    artistsnames=fieldnames(datastruct.artists);
    foundallfeaturelengths=false;
    length(artistsnames)

    % Goes through the struct to count all rows and columns that the
    % dataset is going to have.
    % Also tracks all the featurenames that exists in the datastruct
    for i=1:length(artistsnames)
        artistimages=fieldnames(datastruct.artists.(artistsnames{i}));
        datasetrows=datasetrows+length(artistimages);
        if foundallfeaturelengths == false
            loadedfeatures=fieldnames(datastruct.artists. ...
                                                        (artistsnames{i}). ...
                                                        (artistimages{1}). ...
                                                        ('features'));
            featurenames=cell(length(loadedfeatures),1);
            lengthoffeature=zeros(length(loadedfeatures),1);
            for k=1:length(loadedfeatures)
                data=datastruct.artists. ...
                                       (artistsnames{i}). ...
                                       (artistimages{1}). ...
                                       ('features'). ...
                                       (loadedfeatures{k}). ...
                                       ('data');                           
                datasetcolumns = datasetcolumns + length(data);
                featurenames{k}=loadedfeatures{k};
                lengthoffeature(k)=length(data);
                foundallfeaturelengths = true;
            end
        end  
    end

    % Creates the labels for each feature column
    % Puts all the labels into a vector
    featurevector=cell(sum(lengthoffeature),1);
    indexi=1;
    for i=1:length(lengthoffeature)
        for j=1:lengthoffeature(i)
            if (lengthoffeature(i) ~= 1)
                featurevector{indexi}=[featurenames{i} '_' int2str(j)];
                indexi=indexi+1;                    
            else
                featurevector{indexi}=featurenames{i};
                indexi=indexi+1;
                break;
            end
        end
    end

    dataset=zeros(datasetrows,datasetcolumns);
    datasetindex=1;

    artistvector=cell(datasetrows,1);
    categorymatrix=cell(datasetrows,3);

    % Extracts all the feature values of every feature and turns it
    % into a row where the columns of that row represents a feature
    % value.
    %
    % Also retrieves the labels for each row, these labels are the
    % cateogory1, category2, category3 and the artist
    % These labels are used to assign each row to a class.
    for i=1:length(artistsnames)
        artistimages=fieldnames(datastruct.artists.(artistsnames{i}));
            for j=1:length(artistimages)
                    loadedfeatures=fieldnames(datastruct.artists. ...
                                                        (artistsnames{i}). ...
                                                        (artistimages{j}). ...
                                                        ('features'));
                    createrow=[];
                    for k=1:length(loadedfeatures)
                        loadeddat=datastruct.artists. ...
                                            (artistsnames{i}). ...
                                            (artistimages{j}). ...
                                            ('features'). ...
                                            (loadedfeatures{k}). ...
                                            ('data');
                        createrow=cat(2, createrow, loadeddat);
                    end
                    dataset(datasetindex,:)=createrow;
                    artistvector{datasetindex}=artistsnames{i};

                    category=datastruct.artists. ...
                                               (artistsnames{i}). ...
                                               (artistimages{j}). ...
                                               ('category');

                    parts=regexp(category,'/','split');
                    categoryrow={'NaN', 'NaN', 'NaN'};
                    if length(parts)>3
                       categories=3; 
                    else
                       categories=length(parts);
                    end

                    for l=1:categories
                        categoryrow{l}=parts{l};
                    end
                    categorymatrix(datasetindex,:)=categoryrow;                 
                    datasetindex=datasetindex+1;
            end
    end
end

