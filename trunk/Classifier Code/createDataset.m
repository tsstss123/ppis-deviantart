% Find the Feature Vectors:
% !!Inspect each featurefile to find the specified format!!
% Returns dataset, imagenames and featurenames that correspond to the
% columns.
function [ featuredataset, imagenamecell, featurenames ] = createDataset( varargin )

directoryname=['Features', filesep];

featurenames={'Hue'; 'Saturation'; 'Intensity'};
featurefiles={'hsvFeature.txt'; 'hsvFeature.txt'; 'hsvFeature.txt'};

featureinputvector = zeros(length(featurenames), 1);
for k=1:length(varargin)
    compare = strcmp(featurenames, varargin(k));
    featureinputvector = featureinputvector+compare;
end

featurenames = featurenames(featureinputvector==1);
featurefiles = featurefiles(featureinputvector==1);

% Create imagename cell with filenames (for the filenames you want)
% For now all images in hsvFeature.txt but in the end must be based
% on 'gallery', 'user', 'just one image' or something else
    path = [directoryname,featurefiles{1}];  
    fid=fopen(path);
    imagenamecell = textscan(fid, '%s %*s %*f %*f %*f', 'Delimiter','\t');
    fclose(fid);
    
% Calculate dataset feature length for speed increase
datasetlength = 0;
for k=1:length(featurenames)
    switch featurenames{k} % Switch to find Feature length value
        case {'Hue', 'Saturation', 'Intensity'} 
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
        otherwise
            fprintf('Feature %s is not implemented in this function yet(textread)', featurenames{k});
    end
    fclose(fid);
    featuredataset(:,k) = contents{1};    
end

end

