function [ datasetfeaturestruct ] = readallXML( datasetdirectory, featuredirectoryname )
    
    directories=dir(datasetdirectory);
    directoryIndex = find([directories.isdir]);
    
    datasetfeaturestruct=struct('artists',[]);
    % Starts at i=3 in order to ignore the /.. and /. directories
    for i=3:length(directoryIndex)
        directoryName=directories(directoryIndex(i)).name;
        directorypath=strcat(datasetdirectory, filesep, directoryName);
        datasetfeaturestruct.artists.(directoryName)=[];
        
        files=dir(directorypath);
        filesIndex=find(~[files.isdir]);
        
        for j=1:length(filesIndex)
           fileName=files(filesIndex(j)).name;
           fieldName=strcat('image_', int2str(j));
           datasetfeaturestruct.artists. ...
                                (directoryName). ...
                                (fieldName). ...
                                ('filename')=fileName;
        end
    end
    
    featurefiles=dir(featuredirectoryname);
    featurefilesIndex=find(~[featurefiles.isdir]);
    
    artistsnames=fieldnames(datasetfeaturestruct.artists);
    
    for i=1:length(featurefilesIndex)
        featurefileName=featurefiles(featurefilesIndex(i)).name;
        disp(featurefileName);
        featurefilePath=strcat(featuredirectoryname, filesep, featurefileName);
        loadedxml=xml_load(featurefilePath);
        imagename=loadedxml.filename;
        for j=1:length(artistsnames)
            artistimages=fieldnames(datasetfeaturestruct.artists.(artistsnames{j}));
            for k=1:length(artistimages)
               artistimagename=datasetfeaturestruct.artists.(artistsnames{j}).(artistimages{k}).filename;
               if strcmp(imagename, artistimagename);
                    loadedfeatures=loadedxml.features;
                    datasetfeaturestruct.artists.(artistsnames{j}).(artistimages{k}).('features')=loadedfeatures;
               end
            end
        end
    end
end

