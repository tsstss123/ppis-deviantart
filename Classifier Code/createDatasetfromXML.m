function [ Dataset, featurenames, numberofpositive ] = createDatasetfromXML( artistname )
    % Find Imagenames from the Positive Artist
    
    % Assemble Dataset
    % Find names of the positive example
    files=dir('Dataset\artist_knuxtiger4');
    fileIndex = find(~[files.isdir]);
    
    % Create cellvector containing names of the positive example
    cell(1, length(fileIndex));
    for i=1:length(cell)
        
    end
    
    % Loop through all images
    datasetfiles=dir('Features');
    datasetfileIndex = find(~[datasetfiles.isdir]);
    
    for i=1:length(datasetfileIndex)
           fileName = datasetfiles(datasetfileIndex(i)).name;
           path = strcat('Features\', fileName)
    end
    
    
    
    % Give back dataset with given artist on top and number of examples
    % from the artist
    
end