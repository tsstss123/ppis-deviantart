% Find the Feature Vectors:
% !!Inspect each featurefile to find the specified format!!
% Returns dataset, imagenames and featurenames that correspond to the
% columns.
% Should also output the class name associated with the data
function [ featuredataset, imagenamecell, featurenames ] = createDataset( categoryname, varargin )

directoryname=['Features', filesep];
datasetdirectory=['Dataset', filesep];

featurenames= { 'Hue'; ...
                'Saturation'; ...
                'Intensity'; ...
                'Corner'; ...
                'Edgeratio'};
            
featurefiles= { 'hsv_feature.txt'; ...
                'hsv_feature.txt'; ...
                'hsv_feature.txt'; ...
                'corner_feature.txt'; ...
                'edgeratio_feature.txt'}

featureinputvector = zeros(length(featurenames), 1);
for k=1:length(varargin)
    compare = strcmp(featurenames, varargin(k));
    featureinputvector = featureinputvector+compare;
end

featurenames = featurenames(featureinputvector==1);
featurefiles = featurefiles(featureinputvector==1);

% What are the positive images
    path = [datasetdirectory,categoryname,filesep];  
    files=dir(path);
    fileIndex = find(~[files.isdir]);
    
% Calculate dataset feature length for speed increase
datasetlength = 0;
for k=1:length(featurenames)
    switch featurenames{k} % Switch to find Feature length value
        case {'Hue', 'Saturation', 'Intensity', 'Corner', 'Edgeratio'} 
            datasetlength = datasetlength + 1;
        otherwise
            fprintf('Feature %s is not implemented in this function yet(length)', featurenames{k});
    end
end

% Create dataset feature matrix
featuredataset = zeros(length(imagenamecell{1}), datasetlength);

% Create the dataset
for k=1:length(featurenames)
    path = [directoryname,featurefiles{k}];
    fid=fopen(path);
    switch featurenames{k} %Search for extraction method
        case {'Hue'} %Extract only 2nd column
            contents = textscan(fid, '%*s %*s %f %*f %*f', 'Delimiter','\t');
        case {'Saturation'} %Extract only 3rd column
            contents = textscan(fid, '%*s %*s %*f %f %*f', 'Delimiter','\t');         
        case {'Intensity'} %Extract only 4th column
            contents = textscan(fid, '%*s %*s %*f %*f %f', 'Delimiter','\t');
        case {'Corner'}
            contents = textscan(fid, '%*s %f', 'Delimiter',',');              
        case {'Edgeratio'}
            contents = textscan(fid, '%*s %f', 'Delimiter',',');             
        otherwise
            fprintf('Feature %s is not implemented in this function yet(textread)', featurenames{k});
    end
    fclose(fid);
    featuredataset(:,k) = contents{1};    
end

end

