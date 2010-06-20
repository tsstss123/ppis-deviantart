function [ dataset, artistvector, ... 
           categorymatrix, ...
           featurevector, featurenames, lengthoffeature ...
         ] = createArtistDataset( datastruct)
     
        % Count the sizes of the rows, columns and targetrows to
        % pre-allocate the output matrix
        datasetrows=0;
        datasetcolumns=0;
        
        artistsnames=fieldnames(datastruct.artists);
        foundallfeaturelengths=false;
        
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
                    if strcmp(loadedfeatures{k}, 'salPoints')
                       data=reshape(data,1,6); 
                    end                                       
                    datasetcolumns = datasetcolumns + length(data);
                    featurenames{k}=loadedfeatures{k};
                    lengthoffeature(k)=length(data);
                    foundallfeaturelengths = true;
                end
            else
                break;
            end  
        end
        
        % Create feature labels
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
        
        % Count number of feature values for the preallocated matrix
        dataset=zeros(datasetrows,datasetcolumns);
        datasetindex=1;
        
        artistvector=cell(datasetrows,1);
        
        categorymatrix=cell(datasetrows,3);
        
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
                            if strcmp(loadedfeatures{k}, 'salPoints')
                               loadeddat=reshape(loadeddat,1,6); 
                            end
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

