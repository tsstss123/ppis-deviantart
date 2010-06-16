function [ Dataset, featurenames, numberofpositive ] = createDatasetfromXML( artistname )
    % Find imagenames of the positive example
    DataDirectory='Dataset';
    positivepath=strcat(DataDirectory, filesep, artistname);
    files=dir(positivepath);
    fileIndex = find(~[files.isdir]);
    
    % Create cellvector containing names of the positive example
    positivefilenames=cell(1, length(fileIndex));
    for i=1:length(positivefilenames)
        positivefilenames{i}=files(fileIndex(i)).name;
    end
    
    % Loop through all images
    datasetfiles=dir('Features');
    datasetfileIndex = find(~[datasetfiles.isdir]);

    % Create a featurevector
    for i=1:length(datasetfileIndex)
           fileName = datasetfiles(datasetfileIndex(i)).name;
           featurepath = strcat('Features', filesep, fileName);
           
           loadedxml=xml_load(featurepath);
           %loadedfeatures=loadedxml.features;
    end

    
    
    % Give back dataset with given artist on top and number of examples
    % from the artist
    
end