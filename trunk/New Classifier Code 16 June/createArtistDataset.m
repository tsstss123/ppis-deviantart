function [ dataset, classvector, featurevector ] = createArtistDataset( datastruct, target, varargin )

        featurenames={'numFaces'; ...
                      'cornerRatio'; ...
                      'edgeRatio'; ...
                      'gridEdgeRatio'; ...
                      'medianHue'; ...
                      'avgSat'; ...
                      'avgInt'; ...
                      'medHueCells'; ...
                      'avgSatCells'; ...
                      'avgIntCells'; ...
                      'cornerRatioGrid'; ...
                      };

        artistsnames=fieldnames(datastruct.artists);
        
        % Check which features to use
        logusefeatures=zeros(length(featurenames),1);
        for i=1:length(varargin)
           logcmp=strcmp(varargin(i),featurenames);
           logusefeatures=logusefeatures+logcmp;
        end
        usefeatures=featurenames(logusefeatures>0);
        
        % Count the sizes of the rows, columns and targetrows to
        % pre-allocate the output matrix
        datasetrows=0;
        datasetcolumns=0;
        
        foundfeaturevalues=zeros(length(usefeatures),1);
        foundallfeaturelengths=false;
        for i=1:length(artistsnames)
            artistimages=fieldnames(datastruct.artists.(artistsnames{i}));
            datasetrows=datasetrows+length(artistimages);
                for j=1:length(artistimages)
                    if foundallfeaturelengths == false
                        loadedfeatures=fieldnames(datastruct.artists. ...
                                                          (artistsnames{i}). ...
                                                          (artistimages{j}). ...
                                                          ('features'));
                        for k=1:length(loadedfeatures)
                            logvec=strcmp(loadedfeatures(k), usefeatures);
                            if ~isempty(logvec(logvec>0))
                                data=datastruct.artists. ...
                                                          (artistsnames{i}). ...
                                                          (artistimages{j}). ...
                                                          ('features'). ...
                                                          (loadedfeatures{k}). ...
                                                          ('data');
                                datasetcolumns = datasetcolumns + length(data);
                                foundfeaturevalues = foundfeaturevalues + logvec;
                                if length(foundfeaturevalues(foundfeaturevalues>0)) ...
                                   == length(foundfeaturevalues)
                                    foundallfeaturelengths = true;
                                    break;
                                end
                            end
                        end
                    else
                        break;
                    end
                end    
         end
        
        % Count number of feature values for the preallocated matrix
        dataset=zeros(datasetrows,datasetcolumns);
        classvector=cell(datasetrows,1);        
        datasetindex=1;
        
        for i=1:length(artistsnames)
            artistimages=fieldnames(datastruct.artists.(artistsnames{i}));
                for j=1:length(artistimages)
                        skipimage=false;
                        loadedfeatures=fieldnames(datastruct.artists. ...
                                                            (artistsnames{i}). ...
                                                            (artistimages{j}). ...
                                                            ('features'));
                        for k=1:length(usefeatures)
                            logvec=strcmp(usefeatures(k),loadedfeatures);
                            if isempty(logvec(logvec>0))
                                skipimage=true;
                                break;
                            end
                        end
                        
                        if skipimage==false
                            createrow=[];
                            for k=1:length(usefeatures)
                                loadeddat=datastruct.artists. ...
                                                    (artistsnames{i}). ...
                                                    (artistimages{j}). ...
                                                    ('features'). ...
                                                    (usefeatures{k}). ...
                                                    ('data');
                                createrow = cat(2, createrow, loadeddat);
                            end
                        else
                            createrow=zeros(1,datasetcolumns);
                            createrow(:,:)=NaN;
                        end
                        
                        dataset(datasetindex,:)=createrow;
                        if skipimage == false
                            if strcmp({target},artistsnames{i})
                                classvector(datasetindex)={'Positive'};
                            else
                                classvector(datasetindex)={'Negative'};
                            end
                        else
                            classvector(datasetindex,:)={'NaN'};
                        end
                        datasetindex=datasetindex+1;
                end
        end
end
